starttime=$(date +%s)
myhome="/Users/pcl/Documents/tmp/myish2"
cd $myhome
xcrun simctl uninstall booted app.ish.iSH
rm -rf build mesonbuild
meson setup mesonbuild
ninja -C mesonbuild -v
mkdir -p build/Release-iphonesimulator
ln -s $myhome/mesonbuild $myhome/build/Release-iphonesimulator/meson
cp ish_resources/infoplisticons.h build/Release-iphonesimulator/
bash ish_resources/xcode-meson.sh
#bash ish_resources/xcode-ninja.sh
xcodebuild build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -sdk iphonesimulator15.5 -target libfakefs
#xcodebuild build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -sdk iphonesimulator15.5 -target libish_emu
ln -s $myhome/build/Release-iphonesimulator/meson/libish_emu.a $myhome/build/Release-iphonesimulator/libish_emu.a
ln -s $myhome/build/Release-iphonesimulator/meson/libish.a $myhome/build/Release-iphonesimulator/libish.a
xcodebuild build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -arch x86_64 -sdk iphonesimulator15.5 -target iSH
cp ish_resources/hterm_all.js build/Release-iphonesimulator/iSH.app/
cp ish_resources/root.tar.gz build/Release-iphonesimulator/iSH.app/
xcrun simctl install "iPhone 12 Pro Max" build/Release-iphonesimulator/iSH.app
xcrun simctl launch booted app.ish.iSH
endtime=$(date +%s)
echo run time: $(expr $endtime - $starttime)s
