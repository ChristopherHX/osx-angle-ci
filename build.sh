#!/bin/bash
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=$PATH:$PWD/depot_tools
git clone https://github.com/minecraft-linux/angle.git
pushd angle
python scripts/bootstrap.py
gclient sync
find build -name '*.gn' | xargs -n 1 sed -i '' 's/-Werror//g'
gn gen out/Release --args='target_cpu="x86" is_debug=false mac_sdk_path="'"${SDKROOT}"'" mac_sdk_min="10.12.0" mac_min_system_version="10.12.0" mac_deployment_target="10.12.0" angle_enable_metal=false angle_enable_swiftshader=false angle_enable_vulkan=false'
autoninja -C out/Release libEGL libGLESv2
popd
mkdir ./artifacts
cp angle/out/Release/*.dylib ./artifacts/
