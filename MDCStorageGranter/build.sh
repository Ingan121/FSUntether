#!/bin/zsh
cd "${0:A:h}"
rm -rf build

if [[ $1 != skipguibuild ]]; then
    xcodebuild -workspace MDCStorageGranter.xcodeproj/project.xcworkspace -scheme MDCStorageGranter -sdk iphoneos -configuration Release CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED="NO" CODE_SIGNING_ALLOWED="NO"
fi

mkdir build
cd build

mkdir Payload
cp -r ~/Library/Developer/Xcode/DerivedData/MDCStorageGranter-*/Build/Products/Release-iphoneos/MDCStorageGranter.app Payload
zip -r ../MDCStorageGranter.ipa Payload
cd -
