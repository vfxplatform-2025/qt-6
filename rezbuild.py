# -*- coding: utf-8 -*-
import os, sys, shutil, subprocess


def run_cmd(cmd, cwd=None):
    print(f"[RUN] {cmd}")
    subprocess.run(cmd, cwd=cwd, shell=True, check=True)


def clean_build_dir(build_path):
    """Clean rez build metadata directory, preserving .rxt and variant.json."""
    if os.path.exists(build_path):
        for item in os.listdir(build_path):
            if item.endswith(".rxt") or item == "variant.json":
                print(f"Preserving {item}")
                continue
            full = os.path.join(build_path, item)
            if os.path.isdir(full):
                shutil.rmtree(full)
            else:
                os.remove(full)


def clean_install_dir(install_path):
    if os.path.isfile(install_path):
        os.remove(install_path)
    elif os.path.isdir(install_path):
        shutil.rmtree(install_path)


def copy_package_py(source_path, install_path):
    src = os.path.join(source_path, "package.py")
    dst = os.path.join(install_path, "package.py")
    if os.path.exists(src):
        shutil.copy(src, dst)


def get_lib_dir(root):
    """Return lib64 if exists, otherwise lib."""
    if os.path.isdir(os.path.join(root, "lib64")):
        return "lib64"
    return "lib"


def build(source_path, build_path, install_path, targets):
    version = os.environ.get("REZ_BUILD_PROJECT_VERSION", "6.9.1")

    # 1) 경로 설정
    qt_src = os.path.join(source_path, f"source/qt-everywhere-src-{version}")
    qt_build = os.path.join(source_path, "build")
    build_done_flag = os.path.join(qt_build, ".build_done")

    if "install" in targets:
        install_root = f"/core/Linux/APPZ/packages/qt/{version}"
        clean_install_dir(install_root)
    else:
        install_root = install_path

    print(f"Source:  {qt_src}")
    print(f"Build:   {qt_build}")
    print(f"Install: {install_root}")

    if not os.path.isdir(qt_src):
        raise FileNotFoundError(f"Source directory not found: {qt_src}")

    # 2) install-only: 빌드가 이미 완료된 경우 설치만 수행
    if "install" in targets and os.path.exists(build_done_flag):
        print("Installing Qt (build already completed)...")
        run_cmd(f"cmake --install . --prefix {install_root}", cwd=qt_build)

        server_base = f"/core/Linux/APPZ/packages/qt/{version}"
        os.makedirs(server_base, exist_ok=True)
        copy_package_py(source_path, server_base)

        # rez metadata
        clean_build_dir(build_path)
        marker = os.path.join(build_path, "build.rxt")
        open(marker, "a").close()
        variant_json = os.path.join(build_path, "variant.json")
        with open(variant_json, "w") as f:
            f.write("{}\n")

        print(f"qt-{version} install completed: {install_root}")
        return

    # 3) 빌드 디렉터리 준비 (소스 트리 내 build/ — Qt 빌드 용량이 크므로 유지)
    if os.path.exists(qt_build):
        shutil.rmtree(qt_build)
    os.makedirs(qt_build, exist_ok=True)

    # 4) LD_LIBRARY_PATH (빌드 중 qtbase lib 필요)
    qt_lib_path = os.path.join(qt_build, "qtbase", "lib")
    os.environ["LD_LIBRARY_PATH"] = f"{qt_lib_path}:{os.environ.get('LD_LIBRARY_PATH', '')}"

    # 5) 의존성 경로 수집
    dep_env_map = {
        "zlib":         "REZ_ZLIB_ROOT",
        "openssl":      "REZ_OPENSSL_ROOT",
        "ffmpeg":       "REZ_FFMPEG_ROOT",
        "gstreamer":    "REZ_GSTREAMER_ROOT",
        "libdrm":       "REZ_LIBDRM_ROOT",
        "libevent":     "REZ_LIBEVENT_ROOT",
        "libprotobuf":  "REZ_LIBPROTOBUF_ROOT",
        "snappy":       "REZ_SNAPPY_ROOT",
        "libjsoncpp":   "REZ_LIBJSONCPP_ROOT",
        "libpng":       "REZ_LIBPNG_ROOT",
        "libjpeg":      "REZ_LIBJPEG_ROOT",
        "libtiff":      "REZ_LIBTIFF_ROOT",
        "libwebp":      "REZ_LIBWEBP_ROOT",
        "harfbuzz":     "REZ_HARFBUZZ_ROOT",
        "lcms2":        "REZ_LCMS2_ROOT",
        "openjpeg2":    "REZ_OPENJPEG2_ROOT",
        "minizip_ng":   "REZ_MINIZIP_NG_ROOT",
        "libxml2":      "REZ_LIBXML2_ROOT",
        "libxslt":      "REZ_LIBXSLT_ROOT",
        "icu":          "REZ_ICU_ROOT",
        "libre2":       "REZ_LIBRE2_ROOT",
        "freetype":     "REZ_FREETYPE_ROOT",
        "libxcb":       "REZ_LIBXCB_ROOT",
    }

    deps = {}
    for name, env_var in dep_env_map.items():
        root = os.environ.get(env_var, "")
        if root:
            deps[name] = root
        else:
            print(f"Warning: {env_var} not set")

    # 6) RPATH 생성
    rpath_entries = ["\\$ORIGIN/../lib"]
    for name, root in deps.items():
        lib_dir = get_lib_dir(root)
        rpath_entries.append(f"{root}/{lib_dir}")
    rpath_str = ":".join(rpath_entries)

    # 7) CMake 구성 (build.sh 최종 빌드 기준)
    openssl_root = deps.get("openssl", "")

    cmake_cmd = (
        f"cmake {qt_src} "
        f"-G Ninja "
        f"-DQT_NO_FEATURE_AUTO_RESET=ON "
        f"-DCMAKE_INSTALL_PREFIX={install_root} "
        f"-DCMAKE_BUILD_TYPE=Release "
        f'-DCMAKE_INSTALL_RPATH="{rpath_str}" '
        f"-DQT_BUILD_EXAMPLES=OFF "
        f"-DQT_BUILD_TESTS=OFF "
        f"-DQT_FEATURE_openssl=ON "
        f"-DQT_FEATURE_openssl_linked=ON "
        f"-DOPENSSL_ROOT_DIR={openssl_root} "
        f"-DQT_FEATURE_system_zlib=ON "
        f"-DQT_FEATURE_system_png=ON "
        f"-DQT_FEATURE_system_harfbuzz=ON "
        f"-DQT_FEATURE_gstreamer=ON "
        f"-DQT_FEATURE_ffmpeg=ON "
        f"-DQT_FEATURE_vaapi=OFF "
        f"-DQT_FEATURE_opengl=ON "
        f"-DBUILD_qtwebengine=ON "
        f"-DBUILD_qtwayland=ON "
        f"-DBUILD_qtwebview=ON "
        f"-DBUILD_qtsensors=ON "
        f"-DBUILD_qtdoc=OFF "
        f"-DBUILD_qttranslations=OFF "
        f"-DQT_FEATURE_system_sqlite=ON "
        f"-DQT_FEATURE_getifaddrs=ON "
        f"-DQT_GENERATE_SBOM=OFF "
        f"-DPKG_CONFIG_USE_CMAKE_PREFIX_PATH=ON "
        f"-Wno-dev"
    )

    run_cmd(cmake_cmd, cwd=qt_build)

    # 8) 빌드
    run_cmd("cmake --build . --parallel", cwd=qt_build)

    # 9) 빌드 완료 마커
    with open(build_done_flag, "w") as f:
        f.write("done")

    print(f"qt-{version} build completed.")

    # 10) 설치
    if "install" in targets:
        run_cmd("cmake --install .", cwd=qt_build)

        server_base = f"/core/Linux/APPZ/packages/qt/{version}"
        os.makedirs(server_base, exist_ok=True)
        copy_package_py(source_path, server_base)

        marker = os.path.join(build_path, "build.rxt")
        open(marker, "a").close()

    # rez metadata
    clean_build_dir(build_path)
    variant_json = os.path.join(build_path, "variant.json")
    with open(variant_json, "w") as f:
        f.write("{}\n")

    print(f"qt-{version} build & install completed: {install_root}")


if __name__ == "__main__":
    build(
        source_path=os.environ["REZ_BUILD_SOURCE_PATH"],
        build_path=os.environ["REZ_BUILD_PATH"],
        install_path=os.environ["REZ_BUILD_INSTALL_PATH"],
        targets=sys.argv[1:],
    )
