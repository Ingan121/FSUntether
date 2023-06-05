#!/bin/zsh
cd "${0:A:h}"

if [[ ! -n $(ldid 2>&1 1>/dev/null | grep procursus) ]] then
    echo Procursus ldid is not installed!
    echo Please install it from https://github.com/permasigner/ldid/releases!
    exit -1
fi

if [[ ! $(xcode-select -p) = *"Xcode.app"* ]] then
    echo Xcode is not installed or active developer directory is a command line tools instance!
    echo Please install or xcode-select Xcode!
    exit -1
fi

if [[ ! -a ~/theos/sdks/iPhoneOS14.5.sdk ]]; then
    echo "Required theos SDK is not installed, installing..."
    mkdir ~/theos
    cd ~/theos
    git clone https://github.com/Ingan121/sdks --depth 1
    cd -
fi

cd -
