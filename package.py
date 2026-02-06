# -*- coding: utf-8 -*-
name = "qt"

version = "6.9.1"

authors = ["M83"]

description = "Qt 6.9.1 built with FFmpeg 6.1.1 and system media support"


#rez-env gcc cmake-3.26.5 zlib-1.2.13 openssl-3.0.16 python-3.13 ffmpeg-6.1.1 gstreamer-1.22.6 libxml2-2.11.7 libxslt-1.1.39 harfbuzz-8.4.0 libpng-1.6.43 icu-73.2 libre2-20240201 libdrm-2.4.120 libevent-2.1.12 libprotobuf-3.21.12 snappy-1.1.10 libjsoncpp-1.9.5 libjpeg-3.0.2 libtiff-4.6.0 libwebp-1.3.2 lcms2-2.16 openjpeg2-2.5.0 minizip_ng-4.0.10 freetype-2.13.2 nodejs-20.9.0 libxcb-1.17.0 xcb_proto-1.17.0 xproto-7.0.31

requires = [
    "openssl-3.0.16",
    "ffmpeg-6.1.1",
    "gstreamer-1.22.6",
    "libdrm-2.4.120",
    "libevent-2.1.12",
    "libprotobuf-3.21.12",
    "snappy-1.1.10",
    "libjsoncpp-1.9.5",
    "libpng-1.6.43",
    "libjpeg-3.0.2",
    "libtiff-4.6.0",
    "libwebp-1.3.2",
    "harfbuzz-8.4.0",
    "lcms2-2.16",
    "openjpeg2-2.5.0",
    "zlib-1.2.13",
    "minizip_ng-4.0.10",
    "libxml2-2.11.7",
    "libxslt-1.1.39",
    "icu-73.2",
    "libre2-20240201",
    "freetype-2.13.2",
    "libxcb-1.17.0",
    "xcb_proto-1.17.0",
    "xproto-7.0.31"
]

variants = []

build_requires = [
    "gcc-11.5.0",
    "cmake-3.26.5",
    #"python-3.13.2",
    "nodejs-20.9.0",
]

build_command='python {root}/rezbuild.py {install}'

def commands():
    env.QT_ROOT = "{root}"
    env.PATH.prepend("{root}/bin")
    env.LD_LIBRARY_PATH.prepend("{root}/lib")
    env.PKG_CONFIG_PATH.prepend("{root}/lib/pkgconfig")
    env.CMAKE_PREFIX_PATH.prepend("{root}")
    env.QT_PLUGIN_PATH.prepend("{root}/plugins")
    env.QML2_IMPORT_PATH.prepend("{root}/qml")
    # env.CXXFLAGS="-DQT_NO_STATX_MNT_ID"
