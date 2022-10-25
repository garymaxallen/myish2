starttime=$(date +%s)
xcrun simctl uninstall booted app.ish.iSH
rm -rf build
mkdir -p build/Release-iphonesimulator
cp myresource/lib* build/Release-iphonesimulator/
#cp myresource/infoplisticons.h build/Release-iphonesimulator/
xcodebuild build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -arch x86_64 -sdk iphonesimulator16.0 -target iSH
cp myresource/repositories.txt build/Release-iphonesimulator/iSH.app/
cp myresource/hterm_all.js build/Release-iphonesimulator/iSH.app/
cp myresource/root.tar.gz build/Release-iphonesimulator/iSH.app/
cp myresource/term.* build/Release-iphonesimulator/iSH.app/
xcrun simctl install "iPhone 12 Pro Max" build/Release-iphonesimulator/iSH.app
xcrun simctl launch booted app.ish.iSH
endtime=$(date +%s)
echo run time: $(expr $endtime - $starttime)s
