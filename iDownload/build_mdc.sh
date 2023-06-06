#!/bin/zsh
cd "${0:A:h}"

mkdir build
clang -arch arm64 -isysroot ~/theos/sdks/iPhoneOS14.5.sdk -o build/libexploit.a Exploit/vm_unaligned_copy_switch_race.c -c
clang -arch arm64 -isysroot ~/theos/sdks/iPhoneOS14.5.sdk -o build/libhelpers.a Exploit/helpers.m -framework CoreFoundation -c -fmodules
clang -arch arm64 -isysroot ~/theos/sdks/iPhoneOS14.5.sdk -o build/libgfda.a Exploit/grant_full_disk_access.m -framework CoreFoundation -c -fmodules
clang -arch arm64 -isysroot ~/theos/sdks/iPhoneOS14.5.sdk -o TestFlightServices server-dylib-mdc.c -framework CoreFoundation -framework SpringBoardServices -F ~/theos/sdks/iPhoneOS14.5.sdk/System/Library/PrivateFrameworks -Lbuild -lhelpers -lexploit -lgfda -dynamiclib

cd -