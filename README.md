# FSUntether<sub><sup><sub> - *Fucking Simple Untether for iOS 15*</sub></sup></sub>

```
    ___________ __  __      __       __  __             
   / ____/ ___// / / /___  / /____  / /_/ /_  ___  _____
  / /_   \__ \/ / / / __ \/ __/ _ \/ __/ __ \/ _ \/ ___/
 / __/  ___/ / /_/ / / / / /_/  __/ /_/ / / /  __/ /    
/_/    /____/\____/_/ /_/\__/\___/\__/_/ /_/\___/_/        
                    Fucking Simple Untether by Ingan121
```

## Building
1. Get decrypted TestFlight ipa
2. Extract it
3. Build iDownload with
```
cd iDownload
clang -arch arm64 -isysroot ~/theos/sdks/iPhoneOS14.5.sdk -dynamiclib -o TestFlightServices server-dylib.c
ldid -K../misc/dev_certificate.p12 TestFlightServices
```
4. Replace `Payload/TestFlight.app/Frameworks/TestFlightServices.framework/TestFlightServices` with the built library
5. Compress the Payload folder then change the extension to .ipa
6. Install it with TrollStore
7. Disable USB restricted mode, connect your phone to Mac, then reboot the device 
8. Run `iproxy 1337 1337` and `nc localhost 1337` in separate terminals
* TestFlight app will crash on launch, but the untether will work fine.
* FSUntetherGUI is WIP
