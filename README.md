```
    ___________ __  __      __       __  __             
   / ____/ ___// / / /___  / /____  / /_/ /_  ___  _____
  / /_   \__ \/ / / / __ \/ __/ _ \/ __/ __ \/ _ \/ ___/
 / __/  ___/ / /_/ / / / / /_/  __/ /_/ / / /  __/ /    
/_/    /____/\____/_/ /_/\__/\___/\__/_/ /_/\___/_/        
                    by Ingan121
```
*__Fucking Simple Untethered code execution PoC for iOS 15, 16, and 17__*
# Compatibility is not guaranteed, USE AT YOUR OWN RISK!
## Building
1. Get decrypted TestFlight ipa
2. Rename it to TestFlight.ipa and place it in the same directory as `build.sh`
3. Build FSUntether with `build.sh` in the root of the repository.
4. Install the built IPAs as instructed by `build.sh`
  * You'll need a paid certificate to retain the original `com.apple.TestFlight` bundle ID, if you're not using TrollStore.
  * FSUntether currently doesn't work if the bundle ID is changed.
5. Disable USB restricted mode, connect your phone to your Mac or PC, then reboot the device 
6. Run `iproxy 1338 1338` and `nc localhost 1338` in separate terminals
* TestFlight app will crash on launch, but the untether will work fine.
* Tested versions and devices:
  * iPhone Xs: 15.1, 15.4.1
  * iPad Pro 12.9 6th gen: 16.1.1, 16.3.1, 16.4, 16.4.1, 16.5, 17.0DB1
  * iPhone 14 Pro Max: 16.1.2
  * On 14.3 (Xs), `TestFlightServiceExtension` starts a few seconds after the first unlock, so there's no BFU code execution. (But there are [Fugu14](https://github.com/LinusHenze/Fugu14) and [permasigning haxx](https://github.com/asdfugil/haxx) that work BFU on 14, you know.)
## How does this work
* `TestFlightServiceExtension` of `TestFlight.app` automatically starts on boot, even before first unlock. That's all `¯\_(ツ)_/¯`
* How did I find this? Just ran sysdiagnose BFU and found this was the only process in `/var` that is started before first unlock.
* Getting arbitrary code execution was a bit hard though. Directly replacing `TestFlightServiceExtension` with permasigned binaries didn't seem to work, so I had to modify the library it loads.

## Some notes about the untether's lifecycle
* `TesfFlightServiceExtension` and the injected code start right after the app is installed.
  * If the app is signed with an enterprise cert and the cert has not been trusted yet, it doesn't start at all. It can be started after trusting the cert, and it will start when the app is reinstalled or the device is rebooted.
* Untether is not that fast. It usually starts 1-3 seconds before or after the Apple logo disappears.
* If you're in Setup.app because of an update, it will not start before first unlock. It starts after unlocking and tapping the first button in Setup.app.
* The injected code will become dormant a few minutes after starting. The port is still open and you can connect to it but iDownload won't respond. Nothing gets printed.
* The code will completely stop more minutes later. The port is also closed and the connection will fail. (But `TestFlightServiceExtension` itself still runs.)
* The process also randomly gets started in the background. I don't know the condition and timing.
* Note: if iproxy prints `No connected device found` when the connection is failing, it means your device is not being properly detected. Please check if your device is not USB restricted (Settings → Passcode → Accessories must be ON), the cable is OK, or if some software like VMware is interfering with your connection.

## Todo
* Get the original TestFlight functionality working
* Or get FSU working after changing the bundle ID (it doesn't currently)
* Find out how to build an executable that can directly replace `TestFlightServiceExtension`
* Find out how to show the GUI app content when locked
* **FSUntetherGUI is currently abandoned as I downgraded my Xs to iOS 14.3**

## Credits
[@LinusHenze](https://github.com/LinusHenze) for iDownload from Fugu14 and the CoreTrust exploit<br>
[@opa334](https://github.com/opa334) for TrollStore<br>
[@comex](https://github.com/comex) for sbsutils<br>
[@zhuowei](https://github.com/zhuowei) for MacDirtyCow codes
