//
//  Child.swift
//  SpeechTrak
//
//  Created by Nick on 2/14/25.
//
import SwiftData
import Foundation

@Model
class PracticeSession {
    var date: Date
    var accuracy: Double
    
    init(date: Date = Date(), accuracy: Double) {
        self.date = date
        self.accuracy = accuracy
    }
}
// Represents a single sound, tracking its practice history
@Model
class Sound {
    var stringEquivalent: String  // e.g., "R", "S", "L"
    @Relationship(deleteRule: .cascade) var sessionHistory: [PracticeSession] = [] // Stores accuracy percentages for each session
    init(stringEquivalent: String, sesssionHistory: [PracticeSession] = []) {
        self.stringEquivalent = stringEquivalent
        self.sessionHistory = sesssionHistory
    }
}

// Represents the speech progress for a child
@Model
class SpeechProfile {
    @Relationship(deleteRule: .nullify) var lastPracticedSound: Sound?  // The most recent sound practiced
    @Relationship(deleteRule: .cascade) var soundsInProgress: [Sound]  // Sounds the child is currently working on
    init(lastPracticedSound: Sound? = nil, soundsInProgress: [Sound] = []) {
        self.lastPracticedSound = lastPracticedSound
        self.soundsInProgress = soundsInProgress
    }
}

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
            lastPracticedSound: Sound(stringEquivalent: "R"),  // Most recently practiced sound
            soundsInProgress: [Sound(stringEquivalent: "R"), Sound(stringEquivalent: "S"), Sound(stringEquivalent: "L") // Active sounds being worked on
                              ]
        )
    )
    
    static let mockChildren = [mockChild]
}


//Reasons for using class over structs - SwiftData, built on CoreData, requires reference types because it relies on *object identity* for relationships. Classes will track modifications instead of making new instances. Also many of these data structures use one-to-many relationship tracking which also requires reference types. Functions like object creation, updates, and deletions also require classes to allow mutation in place. Structs simply make copies.
