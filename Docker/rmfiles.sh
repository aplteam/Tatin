#!/bin/bash

if [ "$BUILDTYPE" = "minimal" ]; then
  cd /opt/mdyalog/18.0/64/unicode/

  rm -Rf aplfmt \
    aplkeys/file_siso \
    aplkeys/utf8 \
    aplkeys/xterm \
    aplkeys.sh \
    apltrans/utf8 \
    apltrans/xterm \
    BuildID \
    dyalog.BuildID \
    dyalog.config.example \
    dyalog.desktop \
    dyalog.rt \
    dyalog.svg \
    fonts \
    help \
    libcef.so \
    lib/ademo64.so \
    lib/testcallback.so \
    make_scripts \
    mapl \
    outprods \
    samples \
    DWASamples \
    Samples \
    TestCertificates \
    ws/apl2in.dws \
    ws/apl2pcin.dws \
    ws/ddb.dws \
    ws/display.dws \
    ws/eval.dws \
    ws/fonts.dws \
    ws/ftp.dws \
    ws/groups.dws \
    ws/max.dws \
    ws/min.dws \
    ws/ops.dws \
    ws/quadna.dws \
    ws/smdemo.dws \
    ws/smdesign.dws \
    ws/smtutor.dws \
    ws/tube.dws \
    ws/tutor.dws \
    ws/xfrcode.dws \
    ws/xlate.dws \
    xflib \
    xfsrc \
    cef.pak \
    cef_100_percent.pak \
    cef_200_percent.pak \
    cef_extensions.pak \
    chrome-sandbox \
    devtools_resources.pak \
    icudtl.dat \
    locales \
    snapshot_blob.bin \
    natives_blob.bin \
    lib/libcef.so \
    lib/libAplWrapper.so \
    lib/libHttpInterceptor.so \

fi