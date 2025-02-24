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
                Text("🎯 Last Sound Practiced: '\(child.speechProfile.lastPracticedSound?.soundType.rawValue)'")
                    .font(.headline)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                HStack {
                    Text("🔥 Streak: 5 Days") // Placeholder for now
                    Spacer()
                    Text("✅ Avg Accuracy: \(String(format: "%.0f", child.speechProfile.lastPracticedSound?.sessionHistory.first?.accuracy ?? 0.0))%")
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
            
            VStack {
                Text("\(child.name)'s Progress")
                    .font(.title2)
                    .padding()
                List(child.speechProfile.soundsInProgress.sorted(by: { $0.soundType.rawValue < $1.soundType.rawValue }), id: \.self) { sound in
                    HStack {
                        Text(sound.soundType.rawValue) // Show the sound name
                        Spacer()
                        Text("\(String(format: "%.0f", sound.sessionHistory.map { $0.accuracy }.average()))%") // Show avg accuracy
                    }
                }

            }
            // Graph Placeholder
            VStack {
                Text("📈 Progress Graph (\(child.speechProfile.lastPracticedSound?.soundType.rawValue))")
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
                NavigationStack{
                    SoundPositionSelectionView(child: child, isPresented: $isExercisePresented)
                }
//                SpeechExerciseView(child: child, sound: Sound(soundType: .r, position: .beginning), word: "Rabbit")
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
