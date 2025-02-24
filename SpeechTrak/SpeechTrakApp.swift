//
//  SpeechTrakApp.swift
//  SpeechTrak
//
//  Created by Nick on 2/8/25.
//

import SwiftUI
import SwiftData

@main
struct SpeechTrakApp: App {
    @StateObject private var wordBankManager = WordBankManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(wordBankManager) //Injected wordbank manager for reference on later pages./
                .onAppear() {
                    wordBankManager.loadWordBank() //preload on app launch
                }
        }
        .modelContainer(for: [Child.self]) //SwiftData Models
    }
}
