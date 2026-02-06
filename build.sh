#!/bin/bash

cd /home/m83/chulho/qt/6.9.1/source

git clone --branch 6.9.1 https://code.qt.io/qt/qt5.git qt-everywhere-src-6.9.1
cd qt-everywhere-src-6.9.1
perl init-repository --module-subset=default  # 기본적으로 qtwebengine 포함 모든 데이터를 다 받는 것.
#perl init-repository --module-subset=default,-qtwebengine 이건 qtwebengine을 제외하라는 것.

# 1. rez-env 실행
rez-env gcc cmake-3.26.5 zlib-1.2.13 openssl-3.0.16 python-3.13 ffmpeg-6.1.1 gstreamer-1.22.6 libxml2-2.11.7 libxslt-1.1.39 harfbuzz-8.4.0 libpng-1.6.43 icu-73.2 libre2-20240201 libdrm-2.4.120 libevent-2.1.12 libprotobuf-3.21.12 snappy-1.1.10 libjsoncpp-1.9.5 libjpeg-3.0.2 libtiff-4.6.0 libwebp-1.3.2 lcms2-2.16 openjpeg2-2.5.0 minizip_ng-4.0.10 freetype-2.13.2 nodejs-20.9.0 libxcb-1.17.0 xcb_proto-1.17.0 xorgproto-2024.1

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

# 최종 위에 걸로 빌드.

ninja -j$(nproc) -v > ninja.log 2>&1
grep -i "failed\|undefined\|error\|fatal" ninja.log

크라운 30만원 :

휴대폰 




