//
//  ContentView.swift
//  FSUntetherGUI
//
//  Created by 이준서 on 2022/10/30.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAlert = false
    @State private var resultMsg = ""
    
    var body: some View {
        Text("    ___________ __  __      __       __  __             \r\n   / ____/ ___// / / /___  / /____  / /_/ /_  ___  _____\r\n  / /_   \\__ \\/ / / / __ \\/ __/ _ \\/ __/ __ \\/ _ \\/ ___/\r\n / __/  ___/ / /_/ / / / / /_/  __/ /_/ / / /  __/ /    \r\n/_/    /____/\\____/_/ /_/\\__/\\___/\\__/_/ /_/\\___/_/     \r\n                      by Ingan121")
            .padding()
            .font(.system(size: 8).monospaced())
        
        Button(action: {
            grant_full_disk_access() { error in
                resultMsg = error?.localizedDescription ?? "Success"
            }
            self.showingAlert = true
        }) {
            Text("Grant Full Disk Access")
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("FSUntether"), message: Text(resultMsg), dismissButton: .default(Text("OK")))
        }

        Button(action: {
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: "/var/mobile"), includingPropertiesForKeys: nil)
                resultMsg = ""
                for url in fileURLs {
                        resultMsg += url.lastPathComponent + " "
                    }
            } catch {
                resultMsg = "Error while enumerating files /var/mobile: \(error.localizedDescription)"
            }
            self.showingAlert = true
        }) {
            Text("ls /var/mobile")
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("FSUntether"), message: Text(resultMsg), dismissButton: .default(Text("OK")))
        }
        
        Button(action: {
            let textToShare = [ FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("full_disk_access_sandbox_token.txt") ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                    
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
               
            windowScene?.keyWindow?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                    
        }) {
            Text("Share sandbox extension token")
        }
        
        Button(action: {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        }) {
            Text("Minimize")
        }
        
        Button(action: {
            guard let window = UIApplication.shared.windows.first else { return }
            while true {
               window.snapshotView(afterScreenUpdates: false)
            }
        }) {
            Text("Respring")
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
