#!/bin/bash
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=$PATH:$PWD/depot_tools
git clone https://github.com/minecraft-linux/angle.git
pushd angle
python scripts/bootstrap.py
gclient sync
find build -name '*.gn' | xargs -n 1 sed -i '' 's/-fatal_warnings//g'
gn gen out/Release --args='target_cpu="x86" is_debug=false mac_sdk_path="'"${SDKROOT}"'" mac_sdk_min="10.12.0" mac_min_system_version="10.12.0" mac_deployment_target="10.12.0" angle_enable_metal=false angle_enable_swiftshader=false angle_enable_vulkan=false'
gn gen out/Release64 --args='is_debug=false mac_sdk_path="'"${SDKROOT}"'" mac_sdk_min="10.12.0" mac_min_system_version="10.12.0" mac_deployment_target="10.12.0"'
autoninja -C out/Release libEGL libGLESv2
autoninja -C out/Release64 libEGL libGLESv2
popd
mkdir ./artifacts
lipo -create angle/out/Release/libEGL.dylib angle/out/Release64/libEGL.dylib -output ./artifacts/libEGL.dylib
lipo -create angle/out/Release/libGLESv2.dylib angle/out/Release64/libGLESv2.dylib -output ./artifacts/libGLESv2.dylib
