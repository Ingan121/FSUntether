#!/bin/zsh
cd "${0:A:h}"
rm -rf build
xcodebuild -workspace FSUntetherGUI.xcodeproj/project.xcworkspace -scheme FSUntetherGUI -sdk iphoneos -configuration Release CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED="NO" CODE_SIGNING_ALLOWED="NO"
mkdir build
cd build
mkdir Payload
cp -r ~/Library/Developer/Xcode/DerivedData/FSUntetherGUI-*/Build/Products/Release-iphoneos/FSUntetherGUI.app Payload
cp ../../iDownload/ncserver Payload/FSUntetherGUI.app/ncserver
ldid -S../entitlements.plist -K../../misc/dev_certificate.p12 Payload/FSUntetherGUI.app/FSUntetherGUI
ldid -S../entitlements.plist -K../../misc/dev_certificate.p12 Payload/FSUntetherGUI.app/ncserver
zip -r ../FSUntetherGUI.ipa Payload
cd -
