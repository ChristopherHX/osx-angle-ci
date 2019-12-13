git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=$PATH:$PWD/depot_tools
git clone https://chromium.googlesource.com/angle/angle
cd angle
python scripts/bootstrap.py
gclient sync
gn gen out/Release --args='target_cpu="x86" is_debug=false mac_sdk_min="10.10" angle_enable_metal=false angle_enable_swiftshader=false angle_enable_vulkan=false'
autoninja -C out/Release libEGL libGLESv2
cd ..
mkdir ./artifacts
cp angle/out/Release/*.dylib ./artifacts/ > /dev/null || :
cp angle/out/Release/*.a ./artifacts/ > /dev/null || :
