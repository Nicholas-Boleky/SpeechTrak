//
//  Word.swift
//  SpeechTrak
//
//  Created by Nick on 2/20/25.
//

import Foundation

// Represents a sound/position mapping for a word
struct SoundPositionMapping: Codable, Hashable {
    let sound: SpeechSound
    let position: SoundPosition
}

// Main Word model
struct Word: Identifiable, Codable, Hashable {
    let id = UUID()
    let text: String
    let soundPositions: [SoundPositionMapping]

    // Helper to check if a word matches a specific sound and position
    func matches(sound: SpeechSound, position: SoundPosition) -> Bool {
        return soundPositions.contains { $0.sound == sound && $0.position == position }
    }
}
