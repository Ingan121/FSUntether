#!/bin/zsh
printf "\n"
printf "    ___________ __  __      __       __  __             \n"
printf "   / ____/ ___// / / /___  / /____  / /_/ /_  ___  _____\n"
printf "  / /_   \\__ \\/ / / / __ \\/ __/ _ \\/ __/ __ \\/ _ \\/ ___/\n"
printf " / __/  ___/ / /_/ / / / / /_/  __/ /_/ / / /  __/ /    \n"
printf "/_/    /____/\\____/_/ /_/\\__/\\___/\\__/_/ /_/\\___/_/     \n"
printf "                      by Ingan121\n"
printf "\n\n"
echo "Fucking Simple Untethered code execution PoC for iOS 15, 16, and 17"
echo "Untether is fully supported on iOS 15, 16, and 17 with BFU code execution."
echo "  (AFU code execution is supported on iOS 14)"
echo "Unsandboxing method varies per version; please see the options below.\n"

if [[ ! $(uname) = "Darwin" ]]; then
    echo "Sorry, building is only supported on macOS."
    exit -1
fi

if [[ ! -a ~/theos/sdks/iPhoneOS14.5.sdk ]]; then
    echo "Required theos SDK is not installed, installing..."
    mkdir ~/theos
    cd ~/theos
    git clone https://github.com/Ingan121/sdks --depth 1
    cd -
fi

echo Preparing...
rm -rf "${0:A:h}/build"
mkdir "${0:A:h}/build"
cd "${0:A:h}/build"

if [[ ! -a ../TestFlight.ipa ]]; then
    echo "Please place a DECRYPTED TestFlight IPA in the root of this project (the same folder as this script.)"
    echo "The file must be named 'TestFlight.ipa' (without quotes)"
    cd -
    exit -1
fi

unzip ../TestFlight.ipa > /dev/null

TFS=Payload/TestFlight.app/Frameworks/TestFlightServices.framework/TestFlightServices
TFSE=Payload/TestFlight.app/PlugIns/TestFlightServiceExtension.appex/TestFlightServiceExtension
INFOPLIST=Payload/TestFlight.app/Info.plist
TFSE_INFOPLIST=Payload/TestFlight.app/PlugIns/TestFlightServiceExtension.appex/Info.plist

if type otool > /dev/null; then
    if [[ $(otool -l $TFSE | grep cryptid) = *"cryptid 1"* ]]; then
        echo Your TestFlight IPA has encrypted binaries, which FSUntether cannot work with.
        echo Please get a decrypted IPA then try again.
        cd -
        exit -1
    fi
else
    echo Otool is not installed, skipping binary validation.
    echo Please make sure that your TestFlight IPA has decrypted binaries.
fi

echo "\nPlease select an unsandboxing method.\n"
echo "1) Fully unsandboxed code execution with CVE-2022-26766 (permasigning) and FSUntetherGUI"
echo "  * Supported versions: 15.0-15.4.1, 15.5b1-b4, 15.6b1-b5 (AFU supported on 14)\n"
echo "2) Semi-unsandboxed code execution (filesystem access only) with CVE-2022-26766 (permasigning)"
echo "  * Supported versions: same as 1)\n"
echo "3) Semi-unsandboxed code execution (filesystem access only) with CVE-2022-46689 (MacDirtyCow)"
echo "  * Supported versions: 15.0-15.7.1, 16.0-16.1.2 (14 and below are NOT supported)\n"
echo "4) Sandboxed code execution (no filesystem access; untether only)"
echo "  * Supported versions: 15.0-17.0DB1 (AFU supported on 14)\n"

if [[ ! -n $1 ]]; then
    vared -p "Selection: " -c CHOICE
    echo
else
    CHOICE=$1
    echo "Selection: $CHOICE\n"
fi

if [[ $CHOICE == 1 ]]; then
    if [[ ! $(xcode-select -p) = *"Xcode.app"* ]]; then
        echo Xcode is not installed or active developer directory is a command line tools instance!
        echo Please install or xcode-select Xcode!
        cd -
        exit -1
    fi
else
    if ! type clang > /dev/null; then
        echo Clang is not installed!
        echo Please either install Xcode, Xcode Command Line Tools, or just Clang.
        cd -
        exit -1
    fi
fi

if [[ $CHOICE == 1 || $CHOICE == 2 ]]; then
    if [[ ! -n $(ldid 2>&1 1>/dev/null | grep procursus) ]]; then
        echo Procursus ldid is not installed!
        echo Please install it from https://github.com/ProcursusTeam/ldid
        cd -
        exit -1
    fi
fi

if [[ $CHOICE == 1 ]]; then
    echo "Building iDownload and AutoLauncher..."
    cd ../iDownload
    clang -arch arm64 -isysroot ~/theos/sdks/iPhoneOS14.5.sdk -o TestFlightServices autolauncher.c -framework CoreFoundation -framework SpringBoardServices -F ~/theos/sdks/iPhoneOS14.5.sdk/System/Library/PrivateFrameworks -dynamiclib
    clang -arch arm64 -isysroot ~/theos/sdks/iPhoneOS14.5.sdk -o ncserver server.c -framework CoreFoundation -framework SpringBoardServices -F ~/theos/sdks/iPhoneOS14.5.sdk/System/Library/PrivateFrameworks -w
    cd -
    
    echo "\nBuilding FSUntetherGUI (Fully unsandboxed)..."
    ../FSUntetherGUI/build.sh
    cp ../FSUntetherGUI/FSUntetherGUI.ipa .
    
    echo "\nBuilding FSUntether TestFlight..."
    cp ../iDownload/TestFlightServices $TFS
    ldid -e $TFSE > tfse.ent
    /usr/libexec/PlistBuddy -c 'Add :com.apple.springboard.opensensitiveurl bool true' tfse.ent
    ldid -Stfse.ent -K../misc/dev_certificate.p12 $TFSE
    zip -r FSUntether.ipa Payload > /dev/null
     
    echo "\nDone!"
    echo Please uninstall the original TestFlight first, then install FSUntetherGUI.ipa and FSUntether.ipa with TrollStore.
elif [[ $CHOICE == 2 ]]; then
    echo "Building iDownload..."
    cd ../iDownload
    clang -arch arm64 -isysroot ~/theos/sdks/iPhoneOS14.5.sdk -o TestFlightServices server-dylib.m -framework MobileCoreServices -framework Foundation -dynamiclib
    cd -
    
    echo "\nBuilding FSUntether TestFlight (Semi-unsandboxed)..."
    cp ../iDownload/TestFlightServices $TFS
    /usr/libexec/PlistBuddy -c "Set :NSExtension:ASDTestFlightServiceExtensionServiceTime -1" $TFSE_INFOPLIST
    ldid -e $TFSE > tfse.ent
    /usr/libexec/PlistBuddy -c 'Add :com.apple.security.exception.files.absolute-path.read-write array' tfse.ent
    /usr/libexec/PlistBuddy -c 'Add :com.apple.security.exception.files.absolute-path.read-write: string /' tfse.ent
    ldid -Stfse.ent -K../misc/dev_certificate.p12 $TFSE
    zip -r FSUntether.ipa Payload > /dev/null
    
    echo "\nDone!"
    echo Please uninstall the original TestFlight first, then install FSUntether.ipa with TrollStore.
elif [[ $CHOICE == 3 ]]; then
    echo "Building iDownload..."
    ../iDownload/build_mdc.sh

    echo "\nBuilding FSUntether TestFlight (MacDirtyCow)..."
    cp ../iDownload/TestFlightServices $TFS
    /usr/libexec/PlistBuddy -c "Set :NSExtension:ASDTestFlightServiceExtensionServiceTime -1" $TFSE_INFOPLIST
    /usr/libexec/PlistBuddy -c 'Add :NSAppleMusicUsageDescription string Full disk access before first unlock' $INFOPLIST
    zip -r FSUntether.ipa Payload > /dev/null

    echo "\nDone!"
    echo Please uninstall the original TestFlight first, then sideload FSUntether.ipa.
    echo You must retain the original com.apple.TestFlight bundle ID.
elif [[ $CHOICE == 4 ]]; then
    echo "Building iDownload..."
    cd ../iDownload
    clang -arch arm64 -isysroot ~/theos/sdks/iPhoneOS14.5.sdk -o TestFlightServices server-dylib.m -framework MobileCoreServices -framework Foundation -dynamiclib
    cd -

    echo "\nBuilding FSUntether TestFlight (Sandboxed)..."
    cp ../iDownload/TestFlightServices $TFS
    /usr/libexec/PlistBuddy -c "Set :NSExtension:ASDTestFlightServiceExtensionServiceTime -1" $TFSE_INFOPLIST
    zip -r FSUntether.ipa Payload > /dev/null

    echo "\nDone!"
    echo Please uninstall the original TestFlight first, then sideload FSUntether.ipa.
    echo You must retain the original com.apple.TestFlight bundle ID.
else
    echo Invalid selection!
    echo Exiting...
fi

cd -
