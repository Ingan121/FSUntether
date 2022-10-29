# Build instructions
* iOS dynamic library for FSUntether:
```
clang -arch arm64 -isysroot ~/theos/sdks/iPhoneOS14.5.sdk -o TestFlightServices server-dylib.c -framework CoreFoundation -framework SpringBoardServices -F ~/theos/sdks/iPhoneOS14.5.sdk/System/Library/PrivateFrameworks -dynamiclib
ldid -K../misc/dev_certificate.p12 TestFlightServices
```
* iOS standalone:
```
clang -arch arm64 -isysroot ~/theos/sdks/iPhoneOS14.5.sdk -o ncserver2 server.c -framework CoreFoundation -framework SpringBoardServices -F ~/theos/sdks/iPhoneOS14.5.sdk/System/Library/PrivateFrameworks
ldid -Sentitlements.plist -K../misc/dev_certificate.p12 TestFlightServices
```
## macOS is currently not supported
* macOS dynamic library for testing:
```
clang -dynamiclib -o ncserver.dylib server-dylib.c
DYLD_INSERT_LIBRARIES=ncserver.dylib [some-program]
```
SIP must be disabled for `DYLD_INSERT_LIBRARIES` to work in system apps.
* macOS standalone:
```
clang -o ncserver-mac server.c
```
