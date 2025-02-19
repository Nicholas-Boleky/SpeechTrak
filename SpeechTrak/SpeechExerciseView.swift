//
//  SpeechExerciseView.swift
//  SpeechTrak
//
//  Created by Nick on 2/12/25.
//

import SwiftUI

struct SpeechExerciseView: View {
    var child: Child
    var sound: Sound
    var word: String
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss //close modal view
    @State private var repetitionsCorrect = 0
    @State private var repetitionsIncorrect = 0
//    @State private var isRecording = false
//    @State private var accuracy: Double = 0.0
    
    var body: some View {
        VStack(spacing: 16) {
            // Back Button & Title
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                Spacer()
                Text("Speech Exercise")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            
            // Sound & Word Being Practiced
            VStack(spacing: 10) {
                Text("🎯 Practicing: '\(sound.soundType.rawValue)'")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                Text("Word: \(word)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            .padding()
            
            // Microphone Button (Tap to Record)
            Button(action: {
          //      isRecording.toggle()
            }) {
                Text("🎤 Tap to Record") //Text(isRecording ? "🎤 Recording..." : "🎤 Tap to Record")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, minHeight: 50)
           //         .background(isRecording ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .padding(.vertical, 10)
            
            // Repetition Progress Tracker
            Text("Repetitions: \(repetitionsCorrect + repetitionsIncorrect) / 10")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            // Parent Feedback Buttons
            HStack(spacing: 40) {
                Button(action: {
                    if (repetitionsCorrect + repetitionsIncorrect) < 10 { repetitionsCorrect += 1 }
                }) {
                    Text("✅ Correct")
                        .font(.title2)
                        .padding()
                        .frame(width: 140)
                        .background(Color.green.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                Button(action: {
                    if (repetitionsCorrect + repetitionsIncorrect) < 10 { repetitionsIncorrect += 1 }
                }) {
                    Text("❌ Try Again")
                        .font(.title2)
                        .padding()
                        .frame(width: 140)
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
            
            Spacer()
            
            // End Exercise Button
            Button(action: {
                saveSession()
            }) {
                Text("🏁 End Exercise")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
    
    private func saveSession() {
        let totalReps = repetitionsCorrect + repetitionsIncorrect
        let accuracy = totalReps > 0 ? (Double(repetitionsCorrect) / Double(totalReps)) * 100 : 0.0

        //This represents the session completed on screen
        let newSession = PracticeSession(
            repititionsCorrect: repetitionsCorrect,
            repititionsIncorrect: repetitionsIncorrect,
            accuracy: accuracy
        )
        
        //Finds sound in progress matching the sound in this session:
        if let existingSound = child.speechProfile.soundsInProgress.first(where: { $0.soundType == sound.soundType && $0.position == sound.position }) {
            //if found, add this practice session
            existingSound.sessionHistory.append(newSession)
        } else {
            //if not found, create new sound and add it to sounds in progress
            let newSound = Sound(soundType: sound.soundType, position: sound.position, sessionHistory: [newSession])
            child.speechProfile.soundsInProgress.append(newSound)
        }
        
        // Update last practiced sound in speech profile
        child.speechProfile.lastPracticedSound = sound
        
        //save the updates to child
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save session: \(error)")
        }

       //at this point I need to find the sound in progress that matches this practice session and add the new session to the session history of this sound


    }
}

#Preview {
    let sampleSound = Sound(soundType: .r, position: .beginning)
    SpeechExerciseView(child: Child.mockChild, sound: sampleSound, word: "Rabbit")
}
