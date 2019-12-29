#!/bin/bash
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=$PATH:$PWD/depot_tools
git clone https://github.com/minecraft-linux/angle.git
pushd angle
python2 scripts/bootstrap.py
python2 ../depot_tools/gclient.py sync
find build -name '*.gn' | xargs -n 1 sed -i '' 's/-Werror//g'
python2 ../depot_tools/gn.py gen out/Release --args='target_cpu="x86" is_debug=false mac_sdk_min="10.12" angle_enable_metal=false angle_enable_swiftshader=false angle_enable_vulkan=false'
python2 ../depot_tools/autoninja.py -C out/Release libEGL libGLESv2
popd
mkdir ./artifacts
cp angle/out/Release/*.dylib ./artifacts/
