//
//  ContentView.swift
//  FSUntetherGUI
//
//  Created by 이준서 on 2022/10/30.
//

import SwiftUI
import PersonaSpawn

struct ContentView: View {
    @State private var showingAlert = false
    @State private var resultMsg = "iDownload is now listening on port 1388."
    
    var body: some View {
        Text("    ___________ __  __      __       __  __             \r\n   / ____/ ___// / / /___  / /____  / /_/ /_  ___  _____\r\n  / /_   \\__ \\/ / / / __ \\/ __/ _ \\/ __/ __ \\/ _ \\/ ___/\r\n / __/  ___/ / /_/ / / / / /_/  __/ /_/ / / /  __/ /    \r\n/_/    /____/\\____/_/ /_/\\__/\\___/\\__/_/ /_/\\___/_/     \r\n                      by Ingan121")
            .padding()
            .font(.system(size: 8, design: .monospaced))
        
        Button(action: {
            var attr: posix_spawnattr_t?
            posix_spawnattr_init(&attr)
            posix_spawnattr_set_persona_np(&attr, 99, 1)
            posix_spawnattr_set_persona_uid_np(&attr, 0)
            posix_spawnattr_set_persona_gid_np(&attr, 0)

            var pid: pid_t = 0
            let path = Bundle.main.url(forResource: "ncserver", withExtension: "")?.absoluteString.replacingOccurrences(of: "file://", with: "")
            var argv: [UnsafeMutablePointer<CChar>?] = [strdup(path), nil]
            let result = posix_spawn(&pid, path, nil, &attr, &argv, environ)
            let err = errno
            if result != 0 {
                resultMsg = "Error: \(result) Errno: \(err)\nPath: \(path ?? "error")"
            }
            self.showingAlert = true
        }) {
            Text("Launch iDownload")
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("FSUntether"), message: Text(resultMsg), dismissButton: .default(Text("OK")))
        }
        
        Button(action: {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        }) {
            Text("Minimize")
        }
        
        Button(action: {
            exit(0)
        }) {
            Text("Exit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
