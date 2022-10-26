# Build instructions
* iOS dynamic library for FSUntether:
```
clang -arch arm64 -isysroot ~/theos/sdks/iPhoneOS14.5.sdk -dynamiclib -o TestFlightServices server-dylib.c
ldid -K../misc/dev_certificate.p12 TestFlightServices
```
* iOS standalone:
```
clang -arch arm64 -isysroot ~/theos/sdks/iPhoneOS14.5.sdk -o ncserver server.c
ldid -Sentitlements.plist -K../misc/dev_certificate.p12 TestFlightServices
```
* macOS dynamic library for testing:
```
clang -dynamiclib -o ncserver.dylib server-dylib.c
DYLD_INSERT_LIBRARIES=ncserver.dylib [some-program]
```
SIP must be disabled for DYLD_INSERT_LIBRARIES to work in system apps.
* macOS standalone:
```
clang -dynamiclib -o ncserver-mac server.c
```
