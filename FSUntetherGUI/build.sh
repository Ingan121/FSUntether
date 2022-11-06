#!/bin/zsh
cd "${0:A:h}"
rm -rf build

if [[ $1 != skipguibuild ]]; then
    xcodebuild -workspace FSUntetherGUI.xcodeproj/project.xcworkspace -scheme FSUntetherGUI -sdk iphoneos -configuration Release CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED="NO" CODE_SIGNING_ALLOWED="NO"
fi

mkdir cached
mkdir build
cd build

if [[ ! -a ../cached/killall ]]; then
    curl https://apt.bingner.com/debs/1443.00/shell-cmds_118-8_iphoneos-arm.deb -o shell-cmds.deb
    ar -x shell-cmds.deb data.tar.lzma
    tar xvf data.tar.lzma
    cp usr/bin/killall ../cached/killall
fi

mkdir Payload
cp -r ~/Library/Developer/Xcode/DerivedData/FSUntetherGUI-*/Build/Products/Release-iphoneos/FSUntetherGUI.app Payload
cp ../../iDownload/ncserver Payload/FSUntetherGUI.app/ncserver
cp ../cached/killall Payload/FSUntetherGUI.app/killall
ldid -S../entitlements.plist -K../../misc/dev_certificate.p12 Payload/FSUntetherGUI.app/FSUntetherGUI
ldid -S../entitlements.plist -K../../misc/dev_certificate.p12 Payload/FSUntetherGUI.app/ncserver
ldid -S../entitlements.plist -K../../misc/dev_certificate.p12 Payload/FSUntetherGUI.app/killall
zip -r ../FSUntetherGUI.ipa Payload
cd -
