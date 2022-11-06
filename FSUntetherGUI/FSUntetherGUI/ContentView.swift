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
    @State private var resultMsg = ""
    
    var body: some View {
        Text("    ___________ __  __      __       __  __             \r\n   / ____/ ___// / / /___  / /____  / /_/ /_  ___  _____\r\n  / /_   \\__ \\/ / / / __ \\/ __/ _ \\/ __/ __ \\/ _ \\/ ___/\r\n / __/  ___/ / /_/ / / / / /_/  __/ /_/ / / /  __/ /    \r\n/_/    /____/\\____/_/ /_/\\__/\\___/\\__/_/ /_/\\___/_/     \r\n                      by Ingan121")
            .padding()
            .font(.system(size: 8, design: .monospaced))
        
        Button(action: {
            let path = Bundle.main.resourcePath! + "/ncserver"
            let result = rootexec(path)
            if result != 0 {
                resultMsg = "Error: \(result)\nPath: \(path )"
                self.showingAlert = true
            }
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
            rootexec(Bundle.main.resourcePath! + "/killall -9 backboardd")
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
