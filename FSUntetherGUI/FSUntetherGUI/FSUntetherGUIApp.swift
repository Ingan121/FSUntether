//
//  FSUntetherGUIApp.swift
//  FSUntetherGUI
//
//  Created by 이준서 on 2022/10/30.
//

import SwiftUI
import AVFoundation
import PersonaSpawn

@main
struct FSUntetherGUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    if (url.absoluteString == "diagnostics://boot") {
                        /*
                          This is somehow required
                          I made this logic to play some system sound on start
                          to know when the app starts, but it always played after
                          the Apple logo. So I just removed this before committing,
                          but it turns out that this was somehow necessary.
                          The whole logic seems to be not running without the audio.
                        */
                        playSound()
                        rootexec(Bundle.main.resourcePath! + "/ncserver boot")
                        //sendNotification()
                        // We can't exit normally when locked
                        // App will simply restart on exit(0)
                        // Bunch of private APIs to return to SB doesn't work either
                        // So just respring it
                        rootexec(Bundle.main.resourcePath! + "/killall -9 backboardd")
                    }
                }
        }
    }
}

var player: AVAudioPlayer?

func playSound() {
    // https://github.com/anars/blank-audio/blob/master/1-minute-of-silence.mp3 lmao
    guard let url = Bundle.main.url(forResource: "silence", withExtension: "mp3") else { return }

    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)

        /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

        /* iOS 10 and earlier require the following line:
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

        guard let player = player else { return }

        player.play()

    } catch let error {
        print(error.localizedDescription)
    }
}

@discardableResult func rootexec(_ cmd: String) -> Int32 {
    var attr: posix_spawnattr_t?
    posix_spawnattr_init(&attr)
    posix_spawnattr_set_persona_np(&attr, 99, 1)
    posix_spawnattr_set_persona_uid_np(&attr, 0)
    posix_spawnattr_set_persona_gid_np(&attr, 0)
    
    var pid: pid_t = 0
    let cmdSplit = cmd.components(separatedBy: " ")
    var argv: [UnsafeMutablePointer<CChar>?] = cmdSplit.map { strdup($0) }
    argv.append(nil)
    let result = posix_spawn(&pid, cmdSplit[0], nil, &attr, &argv, environ)
    let err = errno
    if result != 0 {
        print("Spawn failed")
        print("Error: \(result) Errno: \(err) Cmd: \(cmd)")
    }
    return result
}
