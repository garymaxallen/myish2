starttime=$(date +%s)
xcrun simctl uninstall booted app.ish.iSH
rm -rf build
mkdir -p build/Release-iphonesimulator
cp ish_resources/lib* build/Release-iphonesimulator/
#cp ish_resources/infoplisticons.h build/Release-iphonesimulator/
xcodebuild build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -arch x86_64 -sdk iphonesimulator15.5 -target iSH
cp ish_resources/repositories.txt build/Release-iphonesimulator/iSH.app/
cp ish_resources/hterm_all.js build/Release-iphonesimulator/iSH.app/
cp ish_resources/root.tar.gz build/Release-iphonesimulator/iSH.app/
cp ish_resources/term.* build/Release-iphonesimulator/iSH.app/
xcrun simctl install "iPhone 12 Pro Max" build/Release-iphonesimulator/iSH.app
xcrun simctl launch booted app.ish.iSH
endtime=$(date +%s)
echo run time: $(expr $endtime - $starttime)s
