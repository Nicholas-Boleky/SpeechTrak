//
//  ChildPageView.swift
//  SpeechTrak
//
//  Created by Nick on 2/11/25.
//

import SwiftUI

struct ChildPageView: View {
    var child: Child
    @State private var isExercisePresented = false
    
    var body: some View {
        VStack(spacing: 16) {
            //Child Info

                VStack {
                    Image(systemName: child.pictureName) // Child's Avatar
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    Text(child.name)
                        .font(.title2)
                        .fontWeight(.bold)
                }
            
            .padding()

            // Last Practiced Sound & Stats
            VStack(spacing: 10) {
                Text("🎯 Last Sound Practiced: '\(child.speechProfile.lastPracticedSound.stringEquivalent)'")
                    .font(.headline)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                HStack {
                    Text("🔥 Streak: 5 Days") // Placeholder for now
                    Spacer()
                    Text("✅ Avg Accuracy: \(String(format: "%.0f", child.speechProfile.lastPracticedSound.sessionHistory.average()))%")
                }
                .font(.subheadline)
                .padding(.horizontal)

                HStack {
                    Text("⭐ Total Words Practiced: \(child.speechProfile.soundsInProgress.count * 10)") // Placeholder logic
                    Spacer()
                    Text("📅 Last Practice: Feb 10, 2025") // Placeholder date
                }
                .font(.subheadline)
                .padding(.horizontal)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1)))

            // Graph Placeholder
            VStack {
                Text("📈 Progress Graph (\(child.speechProfile.lastPracticedSound.stringEquivalent))")
                    .font(.headline)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                Text("[Future: Swipe to View Other Sounds]")
                    .font(.footnote)
                    .italic()
                    .foregroundColor(.gray)
            }
            .padding()

            Spacer()

            // Start New Exercise Button
            Button(action: {
                isExercisePresented = true
            }) {
                Text("🎤 Start New Exercise")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
            .sheet(isPresented: $isExercisePresented) {
                SpeechExerciseView(sound: Sound(stringEquivalent: "R", sessionHistory: [0.8]), word: "Mock")
            }
        }
        .padding()
    }
}

// Helper extension to calculate average accuracy
extension Array where Element == Double {
    func average() -> Double {
        guard !self.isEmpty else { return 0 }
        return self.reduce(0, +) / Double(self.count)
    }
}

// Sample Data for Preview
struct ChildPageView_Previews: PreviewProvider {
    static var previews: some View {
        ChildPageView(child: Child.mockChild)
    }
}

// Represents a single sound, tracking its practice history
struct Sound: Hashable {
    var stringEquivalent: String  // e.g., "R", "S", "L"
    var sessionHistory: [Double]  // Stores accuracy percentages for each session
}

// Represents the speech progress for a child
struct SpeechProfile {
    var lastPracticedSound: Sound  // The most recent sound practiced
    var soundsInProgress: [Sound]  // Sounds the child is currently working on
}

// Represents a child in the system
struct Child {
    var name: String
    var pictureName: String  // Can reference an asset image
    var speechProfile: SpeechProfile

    // Mock child instance
    static let mockChild = Child(
        name: "Charlie",
        pictureName: "person.circle.fill", // Make sure this asset exists in your project
        speechProfile: SpeechProfile(
            lastPracticedSound: Sound(stringEquivalent: "R", sessionHistory: [75, 80, 85, 90]),  // Most recently practiced sound
            soundsInProgress: [Sound(stringEquivalent: "R", sessionHistory: [75, 80, 85, 90]), Sound(stringEquivalent: "S", sessionHistory: [60, 65, 70, 75]), Sound(stringEquivalent: "L", sessionHistory: [85, 88, 92, 95])] // Active sounds being worked on
        )
    )
    
    static let mockChildren = [mockChild]
}
