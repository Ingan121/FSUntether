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
                        var attr: posix_spawnattr_t?
                        posix_spawnattr_init(&attr)
                        posix_spawnattr_set_persona_np(&attr, 99, 1)
                        posix_spawnattr_set_persona_uid_np(&attr, 0)
                        posix_spawnattr_set_persona_gid_np(&attr, 0)
                        var pid: pid_t = 0
                        let path = Bundle.main.url(forResource: "ncserver", withExtension: "")?.absoluteString.replacingOccurrences(of: "file://", with: "")
                        var argv: [UnsafeMutablePointer<CChar>?] = [strdup(path), nil]
                        posix_spawn(&pid, path, nil, &attr, &argv, environ)
                        exit(0)
                    }
                }
        }
    }
}
