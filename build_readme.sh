#!/bin/bash

cd /home/m83/chulho/qt/6.9.1/source

git clone --branch 6.9.1 https://code.qt.io/qt/qt5.git qt-everywhere-src-6.9.1
cd qt-everywhere-src-6.9.1
perl init-repository --module-subset=default,-qtwebengine

# 1. rez-env 실행
rez-env gcc cmake-3.26.5 zlib-1.2.13 openssl-3.0.16 python-3.13 ffmpeg-6.1.1 gstreamer-1.22.6 libxml2-2.11.7 libxslt-1.1.39 harfbuzz-8.4.0 libpng-1.6.43 icu-73.2 libre2-20240201 libdrm-2.4.120 libevent-2.1.12 libprotobuf-3.21.12 snappy-1.1.10 libjsoncpp-1.9.5 libjpeg-3.0.2 libtiff-4.6.0 libwebp-1.3.2 lcms2-2.16 openjpeg2-2.5.0 minizip_ng-4.0.10 freetype-2.13.2 nodejs-20.9.0 libxcb-1.17.0 xcb_proto-1.17.0 xproto-7.0.31

# 2. LD_LIBRARY_PATH 설정 (매우 중요)
export LD_LIBRARY_PATH=/home/m83/chulho/qt/6.9.1/source/qt-everywhere-src-6.9.1/build/qtbase/lib:$LD_LIBRARY_PATH


# 3. configure
cd /home/m83/chulho/qt/6.9.1/source/qt-everywhere-src-6.9.1
mkdir -p build && cd build



cmake .. \
  -G Ninja \
  -DQT_NO_FEATURE_AUTO_RESET=ON \
  -DCMAKE_INSTALL_PREFIX="/core/Linux/APPZ/packages/qt/6.9.1" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_RPATH="\$ORIGIN/../lib:\
/core/Linux/APPZ/packages/zlib/1.2.13/lib:\
/core/Linux/APPZ/packages/openssl/3.0.16/lib64:\
/core/Linux/APPZ/packages/freetype/2.13.2/lib64:\
/core/Linux/APPZ/packages/icu/73.2/lib:\
/core/Linux/APPZ/packages/harfbuzz/8.4.0/lib64:\
/core/Linux/APPZ/packages/libpng/1.6.43/lib:\
/core/Linux/APPZ/packages/gstreamer/1.22.6/lib:\
/core/Linux/APPZ/packages/ffmpeg/6.1.1/lib:\
/core/Linux/APPZ/packages/libxml2/2.11.7/lib:\
/core/Linux/APPZ/packages/libxslt/1.1.39/lib:\
/core/Linux/APPZ/packages/libre2/20240201/lib64:\
/core/Linux/APPZ/packages/libdrm/2.4.120/lib:\
/core/Linux/APPZ/packages/libevent/2.1.12/lib:\
/core/Linux/APPZ/packages/libprotobuf/3.21.12/lib:\
/core/Linux/APPZ/packages/snappy/1.1.10/lib64:\
/core/Linux/APPZ/packages/libjsoncpp/1.9.5/lib64:\
/core/Linux/APPZ/packages/libjpeg/3.0.2/lib64:\
/core/Linux/APPZ/packages/libtiff/4.6.0/lib:\
/core/Linux/APPZ/packages/libwebp/1.3.2/lib64:\
/core/Linux/APPZ/packages/lcms2/2.16/lib:\
/core/Linux/APPZ/packages/openjpeg2/2.5.0/lib:\
/core/Linux/APPZ/packages/minizip_ng/4.0.10/lib64:\
/core/Linux/APPZ/packages/libxcb/1.17.0/lib" \
  -DQT_BUILD_EXAMPLES=OFF \
  -DQT_BUILD_TESTS=OFF \
  -DQT_FEATURE_openssl=ON \
  -DQT_FEATURE_openssl_linked=ON \
  -DOPENSSL_ROOT_DIR="/core/Linux/APPZ/packages/openssl/3.0.16" \
  -DQT_FEATURE_system_zlib=ON \
  -DQT_FEATURE_system_png=ON \
  -DQT_FEATURE_system_harfbuzz=ON \
  -DQT_FEATURE_gstreamer=ON \
  -DQT_FEATURE_ffmpeg=ON \
  -DQT_FEATURE_vaapi=OFF \
  -DQT_FEATURE_opengl=ON \
  -DBUILD_qtwebengine=ON \
  -DBUILD_qtwayland=ON \
  -DBUILD_qtwebview=ON \
  -DBUILD_qtsensors=ON \
  -DBUILD_qtdoc=OFF \
  -DBUILD_qttranslations=OFF \
  -DQT_FEATURE_system_sqlite=ON \
  -DQT_FEATURE_getifaddrs=ON \
  -DQT_GENERATE_SBOM=OFF \
  -Wno-dev
  
#  -DQT_FEATURE_graphicsframecapture=ON \
#  -DBUILD_qtrenderdoc=OFF \  



cmake --build . --parallel $(nproc)
cmake --install .

 최종 위에 걸로 빌드.

ninja -j$(nproc) -v > ninja.log 2>&1
grep -i "failed\|undefined\|error\|fatal" ninja.log


cmake .. \
  -G Ninja \
  -DCMAKE_MODULE_PATH="/home/m83/chulho/qt/6.9.1/source/qt-everywhere-src-6.9.1/qtmultimedia/cmake;/home/m83/chulho/qt/6.9.1/source/qt-everywhere-src-6.9.1/qtbase/cmake/Modules" \
  -DCMAKE_INSTALL_PREFIX="/core/Linux/APPZ/packages/qt/6.9.1" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_PREFIX_PATH="/core/Linux/APPZ/packages/libxml2/2.11.7;/core/Linux/APPZ/packages/libxslt/1.1.39;/core/Linux/APPZ/packages/pcre2/10.40;/core/Linux/APPZ/packages/re2/20240201;/core/Linux/APPZ/packages/harfbuzz/8.4.0;/core/Linux/APPZ/packages/ffmpeg/6.1.1" \
  -DPKG_CONFIG_USE_CMAKE_PREFIX_PATH=ON \
  -DCMAKE_SKIP_BUILD_RPATH=TRUE \
  -DCMAKE_INSTALL_RPATH="\$ORIGIN/../lib:/core/Linux/APPZ/packages/freetype/2.13.2/lib64:/core/Linux/APPZ/packages/icu/73.2/lib" \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=FALSE \
  -DQT_BUILD_EXAMPLES=OFF \
  -DQT_BUILD_TESTS=OFF \
  -DQT_FEATURE_openssl=ON \
  -DQT_FEATURE_openssl_linked=ON \
  -DOPENSSL_ROOT_DIR="/core/Linux/APPZ/packages/openssl/3.0.16" \
  -DQT_FEATURE_system_zlib=ON \
  -DQT_FEATURE_system_png=ON \
  -DQT_FEATURE_system_harfbuzz=ON \
  -DQT_FEATURE_gstreamer=OFF \
  -DQT_FEATURE_vaapi=OFF \
  -DBUILD_qtwayland=OFF \
  -DBUILD_qtwebview=OFF \
  -DBUILD_qtsensors=OFF \
  -DBUILD_qt3d=OFF \
  -DBUILD_qtdoc=OFF \
  -DBUILD_qttranslations=OFF \
  -DQT_FEATURE_dbus=OFF \
  -Wno-dev
  

  

------------------
cmake .. \
  -G Ninja \
  -DCMAKE_MODULE_PATH="$PWD/qtmultimedia/cmake;${OTHER_MODULE_PATHS}" \
  -DCMAKE_INSTALL_PREFIX="/core/Linux/APPZ/packages/qt/6.9.1" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_PREFIX_PATH="\
/core/Linux/APPZ/packages/libxml2/2.11.7;\
/core/Linux/APPZ/packages/libxslt/1.1.39;\
/core/Linux/APPZ/packages/pcre2/10.40;\
/core/Linux/APPZ/packages/re2/20240201;\
/core/Linux/APPZ/packages/harfbuzz/8.4.0;\
/core/Linux/APPZ/packages/ffmpeg/6.1.1" \
  -DPKG_CONFIG_USE_CMAKE_PREFIX_PATH=ON \
  -DCMAKE_BUILD_RPATH_USE_ORIGIN=ON \
  -DCMAKE_SKIP_BUILD_RPATH=TRUE \
  -DCMAKE_BUILD_RPATH="\$ORIGIN/../lib;/core/Linux/APPZ/packages/freetype/2.13.2/lib64;/core/Linux/APPZ/packages/icu/73.2/lib;/core/Linux/APPZ/packages/libpng/1.6.43/lib;/core/Linux/APPZ/packages/harfbuzz/8.4.0/lib64" \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=FALSE \
  -DQT_BUILD_EXAMPLES=OFF \
  -DQT_BUILD_TESTS=OFF \
  -DQT_FEATURE_openssl=ON \
  -DQT_FEATURE_openssl_linked=ON \
  -DOPENSSL_ROOT_DIR="/core/Linux/APPZ/packages/openssl/3.0.16" \
  -DOPENSSL_INCLUDE_DIR="/core/Linux/APPZ/packages/openssl/3.0.16/include" \
  -DOPENSSL_SSL_LIBRARY="/core/Linux/APPZ/packages/openssl/3.0.16/lib64/libssl.so" \
  -DOPENSSL_CRYPTO_LIBRARY="/core/Linux/APPZ/packages/openssl/3.0.16/lib64/libcrypto.so" \
  -DHARFBUZZ_INCLUDE_DIRS="/core/Linux/APPZ/packages/harfbuzz/8.4.0/include" \
  -DHARFBUZZ_LIBRARIES="/core/Linux/APPZ/packages/harfbuzz/8.4.0/lib64/libharfbuzz.so" \
  -DZLIB_LIBRARY=/core/Linux/APPZ/packages/zlib/1.2.13/lib/libz.so \
  -DZLIB_INCLUDE_DIR=/core/Linux/APPZ/packages/zlib/1.2.13/include \
  -DQT_FEATURE_gstreamer=OFF \
  -DQT_FEATURE_vaapi=OFF \
  -DBUILD_qtwayland=OFF \
  -DBUILD_qtwebview=OFF \
  -DBUILD_qtsensors=OFF \
  -DBUILD_qt3d=OFF \
  -DBUILD_qtdoc=OFF \
  -DBUILD_qttranslations=OFF \
  -DQT_FEATURE_system_zlib=ON \
  -DQT_FEATURE_system_png=ON \
  -DQT_FEATURE_system_harfbuzz=ON \
  -Wno-dev
  
cmake --build . --parallel $(nproc)
cmake --install .

#  -DCMAKE_INSTALL_RPATH="/core/Linux/APPZ/packages/qt/6.9.1/lib" \
#  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON \
#  -DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE \
#  -DCMAKE_SKIP_BUILD_RPATH=FALSE \
#  -DQT_FEATURE_gstreamer=ON \
#  -DGSTREAMER_INCLUDE_DIR="/core/Linux/APPZ/packages/gstreamer/1.22.6/include/gstreamer-1.0" \
#  -DGStreamer_LIBRARIES="gstreamer-1.0;gstbase-1.0;gobject-2.0;glib-2.0" \
  
  



rez-env gcc cmake-3.26.5 zlib openssl-3.0.16 python-3.13 ffmpeg-6 gstreamer-1.22.6 libxml2-2.11.7 libxslt-1.1.39 zlib-1.2.13 harfbuzz-8.4.0 libpng-1.6.43 icu-73.2

cd /home/m83/chulho/qt/6.9.1/source/qt-everywhere-src-6.9.1/build/qtmultimedia/build_qtmultimedia/

export LD_LIBRARY_PATH=/home/m83/chulho/qt/6.9.1/source/qt-everywhere-src-6.9.1/build/qtbase/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=/core/Linux/APPZ/packages/gstreamer/1.22.6/lib/pkgconfig:/core/Linux/APPZ/packages/ffmpeg/6.1.1/lib/pkgconfig:$PKG_CONFIG_PATH
export CMAKE_PREFIX_PATH=/core/Linux/APPZ/packages/qt/6.9.1




cmake -G Ninja \
  -S ../../../qtmultimedia \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=${QT_INSTALL} \
  -DCMAKE_PREFIX_PATH="${QT_INSTALL};${GST_ROOT}" \
  -DQt6_DIR="${QT_INSTALL}/lib/cmake/Qt6" \
  -DPKG_CONFIG_USE_CMAKE_PREFIX_PATH=ON \
  -DGSTREAMER_1_0_ROOT=${GST_ROOT}
  
  

cd /home/m83/chulho/qt/6.9.1/source/qt-everywhere-src-6.9.1/build/qtmultimedia/build_qtmultimedia
export QT_INSTALL=/core/Linux/APPZ/packages/qt/6.9.1
export GST_ROOT=/core/Linux/APPZ/packages/gstreamer/1.22.6
export PKG_CONFIG_PATH="$GST_ROOT/lib/pkgconfig:$PKG_CONFIG_PATH"

  
cmake -G Ninja \
  -S ../../../qtmultimedia \
  -B . \
  -DCMAKE_MODULE_PATH="../../../qtmultimedia/cmake" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=${QT_INSTALL} \
  -DCMAKE_PREFIX_PATH="${QT_INSTALL};${GST_ROOT}" \
  -DQt6_DIR="${QT_INSTALL}/lib/cmake/Qt6" \
  -DPKG_CONFIG_USE_CMAKE_PREFIX_PATH=ON
  
  
  
  
  
  > [m83@chulho build_qtmultimedia]$ cmake --find-package \
  -DNAME=GStreamer \
  -DVERSION=1.0 \
  -DCOMPILER_ID=GNU \
  -DLANGUAGE=C \
  -DREQUIRED=TRUE \
  -DMODE=FIND_PACKAGE \
  -DPKG_CONFIG_USE_CMAKE_PREFIX_PATH=ON \
  -DCMAKE_PREFIX_PATH=/core/Linux/APPZ/packages/gstreamer/1.22.6
GStreamer not found.

==========================================================================================================
  
  
  
cmake .. \
  -G Ninja \
  -DCMAKE_MODULE_PATH="$PWD/qtmultimedia/cmake;${OTHER_MODULE_PATHS}" \
  -DCMAKE_INSTALL_PREFIX="/core/Linux/APPZ/packages/qt/6.9.1" \
  -DPKG_CONFIG_EXECUTABLE=$(which pkg-config) \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_IGNORE_PATH="/usr/lib64" \
  -DQT_BUILD_EXAMPLES=OFF \
  -DQT_BUILD_TESTS=OFF \
  -DQT_BUILD_TOOLS_BY_DEFAULT=ON \
  -DQT_FEATURE_openssl=ON \
  -DQT_FEATURE_openssl_linked=ON \
  -DOPENSSL_ROOT_DIR="/core/Linux/APPZ/packages/openssl/3.0.16" \
  -DOPENSSL_INCLUDE_DIR="/core/Linux/APPZ/packages/openssl/3.0.16/include" \
  -DOPENSSL_SSL_LIBRARY="/core/Linux/APPZ/packages/openssl/3.0.16/lib64/libssl.so" \
  -DOPENSSL_CRYPTO_LIBRARY="/core/Linux/APPZ/packages/openssl/3.0.16/lib64/libcrypto.so" \
  -DCMAKE_PREFIX_PATH="/core/Linux/APPZ/packages/libxml2/2.11.7;/core/Linux/APPZ/packages/libxslt/1.1.39;/core/Linux/APPZ/packages/pcre2/10.40;/core/Linux/APPZ/packages/re2/20240201;/core/Linux/APPZ/packages/ffmpeg/6.1.1" \
  -DPKG_CONFIG_USE_CMAKE_PREFIX_PATH=ON \
  -DQT_EXTRA_DEFINES="QT_NO_STATX_MNT_ID" \
  -DCMAKE_VERBOSE_MAKEFILE=ON \
  -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON \
  -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=OFF \
  -DCMAKE_SKIP_RPATH=FALSE \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE \
  -DCMAKE_INSTALL_RPATH="/core/Linux/APPZ/packages/qt/6.9.1/lib" \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE \
  -DQT_FEATURE_vaapi=OFF \
  -DQT_FEATURE_opengl=ON \
  -DQT_FEATURE_gstreamer=OFF \
  -DBUILD_qtwayland=OFF \
  -DBUILD_qtwebview=OFF \
  -DBUILD_qtsensors=OFF \
  -DQT_FEATURE_system_zlib=ON \
  -DQT_FEATURE_system_png=ON \
  -DQT_FEATURE_system_harfbuzz=ON \
  -DBUILD_qt3d=OFF \
  -DBUILD_qtdoc=OFF \
  -DBUILD_qttranslations=OFF \
  -Wno-dev
  
  
# 테스트  했으나 gstreamer 외 여러가지 라이브러리 인식 안됨.
cmake .. \
  -G Ninja \
  -DCMAKE_MODULE_PATH="/home/m83/chulho/qt/6.9.1/source/qt-everywhere-src-6.9.1/qtmultimedia/cmake/;/home/m83/chulho/qt/6.9.1/source/qt-everywhere-src-6.9.1/qtbase/cmake/Modules" \
  -DCMAKE_INSTALL_PREFIX="/core/Linux/APPZ/packages/qt/6.9.1" \
  -DPKG_CONFIG_EXECUTABLE=$(which pkg-config) \
  -DCMAKE_PROGRAM_PATH="/usr/bin" \
  -DCMAKE_PREFIX_PATH="/core/Linux/APPZ/packages/openssl/3.0.16;/core/Linux/APPZ/packages/gstreamer/1.22.6;/core/Linux/APPZ/packages/libxml2/2.11.7;/core/Linux/APPZ/packages/libxslt/1.1.39;/core/Linux/APPZ/packages/pcre2/10.40;/core/Linux/APPZ/packages/libre2/20240201;/core/Linux/APPZ/packages/ffmpeg/6.1.1;/usr"\
  -DPKG_CONFIG_USE_CMAKE_PREFIX_PATH=ON \
  -DCMAKE_BUILD_TYPE=Release \
  -DQT_BUILD_EXAMPLES=OFF \
  -DQT_BUILD_TESTS=OFF \
  -DQT_FEATURE_openssl=ON \
  -DQT_FEATURE_openssl_linked=ON \
  -DOPENSSL_ROOT_DIR="/core/Linux/APPZ/packages/openssl/3.0.16" \
  -DOPENSSL_INCLUDE_DIR="/core/Linux/APPZ/packages/openssl/3.0.16/include" \
  -DOPENSSL_SSL_LIBRARY="/core/Linux/APPZ/packages/openssl/3.0.16/lib64/libssl.so" \
  -DOPENSSL_CRYPTO_LIBRARY="/core/Linux/APPZ/packages/openssl/3.0.16/lib64/libcrypto.so" \
  -DZLIB_LIBRARY="/core/Linux/APPZ/packages/zlib/1.2.13/lib/libz.so" \
  -DZLIB_INCLUDE_DIR="/core/Linux/APPZ/packages/zlib/1.2.13/include" \
  -DQT_FEATURE_gstreamer=ON \
  -DGSTREAMER_INCLUDE_DIRS="/core/Linux/APPZ/packages/gstreamer/1.22.6/include/gstreamer-1.0" \
  -DGSTREAMER_LIBRARIES="gstreamer-1.0;gstbase-1.0;gobject-2.0;glib-2.0" \
  -DQT_FEATURE_vaapi=OFF \
  -DBUILD_qtwebengine=OFF \
  -DBUILD_qtsensors=OFF \
  -DBUILD_qt3d=OFF \
  -DBUILD_qtwayland=OFF \
  -DBUILD_qtdoc=OFF \
  -DBUILD_qttranslations=OFF \
  -DCMAKE_FIND_DEBUG_MODE=ON \
  -DQT_FEATURE_slog2=OFF \
  -DQT_FEATURE_brotli=OFF \
  -DQT_FEATURE_networkproxy=OFF \
  -DQT_FEATURE_gssapi=OFF \
  -DQT_FEATURE_opengl=ON \
  -DQT_FEATURE_dnslookup=OFF \
  -DBus1_DIR="/usr/lib64/cmake/DBus1" \
  -DBus1_INCLUDE_DIR="/usr/lib64/dbus-1.0/include" \
  -DBus1_LIBRARY="/usr/lib64/libdbus-1.so" \
  -DCMAKE_DISABLE_FIND_PACKAGE_PCRE2=TRUE \
  -DCMAKE_DISABLE_FIND_PACKAGE_harfbuzz=TRUE \
  -DCMAKE_DISABLE_FIND_PACKAGE_md4c=TRUE \
  -DCMAKE_DISABLE_FIND_PACKAGE_Qt6LinguistTools=TRUE \
  -DCMAKE_DISABLE_FIND_PACKAGE_Mimer=TRUE \
  -DCMAKE_DISABLE_FIND_PACKAGE_Jasper=TRUE \
  -DCMAKE_DISABLE_FIND_PACKAGE_PipeWire=TRUE \
  -DCMAKE_DISABLE_FIND_PACKAGE_MMRendererCore=TRUE \
  -DCMAKE_DISABLE_FIND_PACKAGE_MMRenderer=TRUE \
  -DCMAKE_DISABLE_FIND_PACKAGE_LTTngUST=TRUE \
  -DCMAKE_DISABLE_FIND_PACKAGE_OpenXR=TRUE \
  -DCMAKE_DISABLE_FIND_PACKAGE_Slog2=TRUE \
  -DCMAKE_DISABLE_FIND_PACKAGE_PulseAudio=TRUE \
  -DCMAKE_DISABLE_FIND_PACKAGE_Xpm=TRUE \
  -DCMAKE_POLICY_DEFAULT_CMP0004=NEW \
  -Wno-dev

#  -DGStreamer_INCLUDE_DIRS="/core/Linux/APPZ/packages/gstreamer/1.22.6/include/gstreamer-1.0" \
#  -DGStreamer_LIBRARIES="gstbase-1.0;gstreamer-1.0;gobject-2.0;glib-2.0" \
#  -DQT_POLICY_QTP0004=NEW \
#  -DQT_FEATURE_system_zlib=ON \
#  -DQT_FEATURE_gstreamer=OFF \
#  -DGSTREAMER_INCLUDE_DIR="/core/Linux/APPZ/packages/gstreamer/1.22.6/include/gstreamer-1.0" \
#  -DGSTREAMER_LIBRARY="/core/Linux/APPZ/packages/gstreamer/1.22.6/lib/libgstreamer-1.0.so" \
#  -DCMAKE_DISABLE_FIND_PACKAGE_DBus1=TRUE \  
#    -DQT_FEATURE_harfbuzz=OFF \
  
  
  
  
  
  
  
  
  
  

 
  
#  -DQT_FEATURE_system_libxml2=ON \qtw
#  -DQT_FEATURE_system_libxslt=ON \
#  -DQT_FEATURE_system_pcre2=ON \
#  -DQT_FEATURE_system_re2=ON \
#  -DQT_FEATURE_system_gstreamer=ON \
#  -DQT_SKIP_MODULES="qtwebengine;qtsensors;qt3d;qtwayland;qtdoc;qttranslations"

#  -DQT_NO_STATX_MNT_ID=ON \
#  -DQT_FEATURE_statx=OFF \
#  -DQT_BUILD_QTSHADERTOOLS=ON \
#  -DCMAKE_DEBUG_FIND_MODE_FILE=ON \
#  -DQT_FEATURE_qstorageinfo_mnt_id=OFF \

cmake --build . --parallel $(nproc)
cmake --install .
cp /home/m83/chulho/qt/6.9.1/package.py  /core/Linux/APPZ/packages/qt/6.9.1

# 4. ninja 빌드
ninja -j$(nproc) -v

# 5. 설치
ninja install














# 참고사항
=============

cd /home/m83/chulho/qt/6.9.1/source/qt-everywhere-src-6.9.1
mkdir -p build && cd build
# /home/m83/chulho/packages
# /core/Linux/APPZ/packages

../configure \
  -prefix /home/m83/chulho/packages/qt/6.9.1 \
  -opensource \
  -confirm-license \
  -release \
  -nomake examples \
  -nomake tests \
  #-openssl-linked \
  -DQT_FEATURE_openssl=ON \
  -DQT_FEATURE_openssl_linked=ON \
  -DOPENSSL_ROOT_DIR=$REZ_OPENSSL_ROOT \
  -DOPENSSL_INCLUDE_DIR=$REZ_OPENSSL_ROOT/include \
  -DOPENSSL_SSL_LIBRARY=$REZ_OPENSSL_ROOT/lib/libssl.so \
  -DOPENSSL_CRYPTO_LIBRARY=$REZ_OPENSSL_ROOT/lib/libcrypto.so \
  -opengl desktop \
  -skip qtdoc \
  -skip qt3d \
  -skip qtwayland \
  -skip qtsensors \
  -skip qtwebengine \
  -DQT_FEATURE_system_libxml2=ON \
  -DQT_FEATURE_system_libxslt=ON \
  -DQT_FEATURE_system_pcre2=ON \
  -DQT_FEATURE_gstreamer=ON \
  -DQT_FEATURE_gstreamer_playback=ON \
  -DQT_FEATURE_qstorageinfo_mnt_id=OFF \
  -DQT_FEATURE_statx=OFF \
  -DPKG_CONFIG_USE_CMAKE_PREFIX_PATH=ON \
  -DQT_EXTRA_DEFINES="QT_NO_STATX_MNT_ID" \
  -DQT_BUILD_QTSHADERTOOLS=ON \
  -DQT_BUILD_TOOLS_BY_DEFAULT \
  -cmake-generator Ninja

-------------------------------------------------------------------------
#PKG_CONFIG_DEBUG_SPEW=1 cmake  --debug-find \
cmake .. \
  -G Ninja \
  -DCMAKE_MODULE_PATH="$PWD/qtmultimedia/cmake;${OTHER_MODULE_PATHS}" \
  -DCMAKE_INSTALL_PREFIX="/home/m83/chulho/packages/qt/6.9.1" \
  -DPKG_CONFIG_EXECUTABLE=$(which pkg-config) \
  -DCMAKE_BUILD_TYPE=Release \
  -DQT_BUILD_EXAMPLES=OFF \
  -DQT_BUILD_TESTS=OFF \
  -DQT_BUILD_TOOLS_BY_DEFAULT=ON \
  -DQT_BUILD_QTSHADERTOOLS=ON \
  -DQT_FEATURE_openssl=ON \
  -DQT_FEATURE_openssl_linked=ON \
  -DOPENSSL_ROOT_DIR="/core/Linux/APPZ/packages/openssl/1.1.1b" \
  -DOPENSSL_INCLUDE_DIR="/core/Linux/APPZ/packages/openssl/1.1.1b/include" \
  -DOPENSSL_SSL_LIBRARY="/core/Linux/APPZ/packages/openssl/1.1.1b/lib/libssl.so" \
  -DOPENSSL_CRYPTO_LIBRARY="/core/Linux/APPZ/packages/openssl/1.1.1b/lib/libcrypto.so" \
  -DCMAKE_PREFIX_PATH="/core/Linux/APPZ/packages/gstreamer/1.22.1;${CMAKE_PREFIX_PATH}" \
  -DGStreamer_DIR="/core/Linux/APPZ/packages/gstreamer/1.22.1/lib/cmake/gstreamer-1.0" \
  -DGSTREAMER_1_0_ROOT_DIR="/core/Linux/APPZ/packages/gstreamer/1.22.1" \
  -DQT_FEATURE_system_libxml2=ON \
  -DQT_FEATURE_system_libxslt=ON \
  -DQT_FEATURE_system_pcre2=ON \
  -DQT_FEATURE_gstreamer=ON \
  -DQT_FEATURE_gstreamer_playback=ON \
  -DQT_FEATURE_qstorageinfo_mnt_id=OFF \
  -DQT_FEATURE_statx=OFF \
  -DPKG_CONFIG_USE_CMAKE_PREFIX_PATH=ON \
  -DQT_EXTRA_DEFINES="QT_NO_STATX_MNT_ID" \
  -DCMAKE_VERBOSE_MAKEFILE=ON \
  -DCMAKE_DEBUG_FIND_MODE_FILE=ON \
  -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON \
  -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=OFF \
  -DQT_SKIP_MODULES="qtwebengine;qtsensors;qt3d;qtwayland;qtdoc"

-----------------------------------------------------------------

