//
//  Child.swift
//  SpeechTrak
//
//  Created by Nick on 2/14/25.
//
import SwiftData
import Foundation

// Represents a child in the system
@Model
class Child {
    var name: String
    var pictureName: String  // Can reference an asset image
    @Relationship(deleteRule: .cascade) var speechProfile: SpeechProfile
    
    init(name: String, pictureName: String, speechProfile: SpeechProfile) {
        self.name = name
        self.pictureName = pictureName
        self.speechProfile = speechProfile
    }
    
    // Mock child instance
    static let mockChild = Child(
        name: "Charlie",
        pictureName: "person.circle.fill",
        speechProfile: SpeechProfile(
            lastPracticedSound: Sound(soundType: .b, position: .beginning),  // Most recently practiced sound
            soundsInProgress: [Sound(soundType: .p, position: .beginning),
                               Sound(soundType: .b, position: .beginning),
                               Sound(soundType: .g, position: .beginning) // Active sounds being worked on
                              ]
        )
    )
    
    static let mockChildren = [mockChild]
}

// Represents the speech progress for a child
@Model
class SpeechProfile {
    var lastPracticedSound: Sound?
    @Relationship(deleteRule: .cascade) var soundsInProgress: [Sound] = []  // Multiple sounds + positions
    
    init(lastPracticedSound: Sound? = nil, soundsInProgress: [Sound] = []) {
        self.lastPracticedSound = lastPracticedSound
        self.soundsInProgress = soundsInProgress
    }
    
//    func addSound(_ sound: Sound) {
//        soundsInProgress.insert(sound)
//    }
}

// Represents a single sound, tracking its practice history
@Model
class Sound {
    var soundType: SpeechSound  // Uses our Enum
    var position: SoundPosition // Beginning, middle, or end of the word
    @Relationship(deleteRule: .cascade) var sessionHistory: [PracticeSession] = []
    
    init(soundType: SpeechSound, position: SoundPosition, sessionHistory: [PracticeSession] = []) {
        self.soundType = soundType
        self.position = position
        self.sessionHistory = sessionHistory
    }
    
    func addPracticeSession(repititionsCorrect: Int, repititionsIncorrect: Int, accuracy: Double) {
        let newSession = PracticeSession(repititionsCorrect: repititionsCorrect, repititionsIncorrect: repititionsIncorrect, accuracy: accuracy)
        sessionHistory.append(newSession)
    }
}

@Model
class PracticeSession {
    var date: Date
    var repititionsCorrect: Int
    var repititionsIncorrect: Int
    var accuracy: Double
    
    init(date: Date = Date(), repititionsCorrect: Int, repititionsIncorrect: Int, accuracy: Double) {
        self.date = date
        self.repititionsCorrect = repititionsCorrect
        self.repititionsIncorrect = repititionsIncorrect
        self.accuracy = accuracy
    }
}

//Reasons for using class over structs - SwiftData, built on CoreData, requires reference types because it relies on *object identity* for relationships. Classes will track modifications instead of making new instances. Also many of these data structures use one-to-many relationship tracking which also requires reference types. Functions like object creation, updates, and deletions also require classes to allow mutation in place. Structs simply make copies.

enum SpeechSound: String, Codable, CaseIterable {
    case p, b, t, d, k, g  // Plosives
    case m, n, ng          // Nasals
    case f, v, thVoiced = "th Voiced", thUnvoiced = "th unvoiced"  // Fricatives
    case s, z, sh, zh
    case ch, j             // Affricates
    case l, r, w, y, h     // Liquids & Glides
}
enum SoundPosition: String, Codable, CaseIterable {
    case beginning, middle, end
}
