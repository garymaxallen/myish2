starttime=$(date +%s)
myhome="/Users/pcl/Documents/tmp/myish2"
cd $myhome
xcrun simctl uninstall booted app.ish.iSH
rm -rf build mesonbuild
meson setup mesonbuild
cd mesonbuild
ninja -v
cd ..
mkdir -p build/Release-iphonesimulator
cd build/Release-iphonesimulator
rm -rf meson
ln -s $myhome/mesonbuild meson
cd ../..
cp ish_resources/infoplisticons.h build/Release-iphonesimulator/
bash ish_resources/xcode-meson.sh
#bash ish_resources/xcode-ninja.sh
xcodebuild build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -sdk iphonesimulator16.0 -target libfakefs
xcodebuild build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -sdk iphonesimulator16.0 -target libish_emu
xcodebuild build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -arch x86_64 -sdk iphonesimulator16.0 -target iSH
cp ish_resources/hterm_all.js build/Release-iphonesimulator/iSH.app/
cp ish_resources/root.tar.gz build/Release-iphonesimulator/iSH.app/
xcrun simctl install "iPhone 12 Pro Max" build/Release-iphonesimulator/iSH.app
xcrun simctl launch booted app.ish.iSH
endtime=$(date +%s)
echo run time: $(expr $endtime - $starttime)s
