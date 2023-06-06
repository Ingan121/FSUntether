#!/bin/zsh
cd "${0:A:h}"

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
echo "Unsandboxing method varies per version; please see the options below.\n\n"

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

echo "Please select an unsandboxing method.\n"
echo "1) Fully unsandboxed code execution with CVE-2022-26766 (permasigning) and FSUntetherGUI"
echo "  * Supported versions: 15.0-15.4.1, 15.5b1-b4, 15.6b1-b5 (AFU supported on 14)\n"
echo "2) Semi-unsandboxed code execution (filesystem access only) with CVE-2022-26766 (permasigning)"
echo "  * Supported versions: same as 1)\n"
echo "3) Semi-unsandboxed code execution (filesystem access only) with CVE-2022-46689 (MacDirtyCow)"
echo "  * Supported versions: 15.0-16.1.2 (14 and below is NOT supported)\n"
echo "4) Sandboxed code execution (no filesystem access; untether only)"
echo "  * Supported versions: 15.0-17.0DB1 (AFU supported on 14)\n"
vared -p "Selection: " -c CHOICE

cd -
