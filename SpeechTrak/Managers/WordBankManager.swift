//
//  WordBankManager.swift
//  SpeechTrak
//
//  Created by Nick on 2/20/25.
//

import Foundation

class WordBankManager: ObservableObject {
    @Published var words: [Word] = [] // Holds loaded words
    private var wordIndex: [SoundPositionKey: [Word]] = [:] // Precomputed index

    // 🚀 Load the WordBank on app launch
    func loadWordBank() {
        self.words = WordBank.words // Load raw words from static WordBank
        buildIndex() // Build the precomputed index
        print("✅ WordBank preloaded with \(words.count) words.")
    }

    // 🔥 Build the precomputed index for O(1) lookups
    private func buildIndex() {
        var index = [SoundPositionKey: [Word]]()
        for word in words {
            for mapping in word.soundPositions {
                let key = SoundPositionKey(sound: mapping.sound, position: mapping.position)
                index[key, default: []].append(word)
            }
        }
        self.wordIndex = index
    }

    // 🔍 Fast lookup method using the precomputed index
    func getWords(for sound: SpeechSound, at position: SoundPosition) -> [Word] {
        let key = SoundPositionKey(sound: sound, position: position)
        return wordIndex[key] ?? []
    }
}
