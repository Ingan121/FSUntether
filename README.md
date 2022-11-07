```
    ___________ __  __      __       __  __             
   / ____/ ___// / / /___  / /____  / /_/ /_  ___  _____
  / /_   \__ \/ / / / __ \/ __/ _ \/ __/ __ \/ _ \/ ___/
 / __/  ___/ / /_/ / / / / /_/  __/ /_/ / / /  __/ /    
/_/    /____/\____/_/ /_/\__/\___/\__/_/ /_/\___/_/        
                    by Ingan121
```
*__Fucking Simple Untethered + Unsandboxed code execution PoC for iOS 15__*
# Compatibility is not guaranteed, USE AT YOUR OWN RISK!
# Readme update is pending
## Building
1. Get decrypted TestFlight ipa
2. Extract it
3. Build FSUntether with
```
cd iDownload
clang -arch arm64 -isysroot ~/theos/sdks/iPhoneOS14.5.sdk -o TestFlightServices autolauncher.c -framework CoreFoundation -framework SpringBoardServices -F ~/theos/sdks/iPhoneOS14.5.sdk/System/Library/PrivateFrameworks -dynamiclib
clang -arch arm64 -isysroot ~/theos/sdks/iPhoneOS14.5.sdk -o ncserver server.c -framework CoreFoundation -framework SpringBoardServices -F ~/theos/sdks/iPhoneOS14.5.sdk/System/Library/PrivateFrameworks
../FSUntetherGUI/build.sh
```
* Xcode SDKs should work, too.
* You must use [Procursus ldid](https://github.com/permasigner/ldid), not brew ldid.
4. Replace `Payload/TestFlight.app/Frameworks/TestFlightServices.framework/TestFlightServices` with the built library
5. Compress the Payload folder then change the extension to .ipa
6. Install it with TrollStore
7. Disable USB restricted mode, connect your phone to Mac, then reboot the device 
8. Run `iproxy 1338 1338` and `nc localhost 1338` in separate terminals
* TestFlight app will crash on launch, but the untether will work fine.
* Tested on iPhone XS running iOS 15.4.1.
* The untether part also works when installed as a dev-signed user app. (So test it on 16?)
## How does this work
* `TestFlightServiceExtension` of `TestFlight.app` automatically starts on boot, even before first unlock. That's all `¯\_(ツ)_/¯`
* How did I find this? Just ran sysdiagnose BFU and found this was the only process in `/var` that is started before first unlock.
* Getting arbitrary code execution was a bit hard though. Directly replacing `TestFlightServiceExtension` with permasigned binaries didn't seem to work, so I had to modify the library it loads.

## Todo
* Get the original TestFlight functionality working
* Or get FSU working after changing the bundle ID (it doesn't currently)
* Find out how to build an executable that can directly replace `TestFlightServiceExtension`
* Find out how to show the GUI app content when locked

## Credits
[@LinusHenze](https://github.com/LinusHenze) for iDownload from Fugu14 and the CoreTrust exploit<br>
[@opa334](https://github.com/opa334) for TrollStore
