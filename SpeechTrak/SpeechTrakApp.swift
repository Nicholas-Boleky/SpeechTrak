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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Child.self, SpeechProfile.self, Sound.self, PracticeSession.self]) //SwiftData Models
    }
}
