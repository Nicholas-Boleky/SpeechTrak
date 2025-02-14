//
//  SpeechExerciseView.swift
//  SpeechTrak
//
//  Created by Nick on 2/12/25.
//

import SwiftUI

struct SpeechExerciseView: View {
    var sound: Sound
    var word: String
    
    @Environment(\.dismiss) private var dismiss //close modal
    @State private var repetitions = 0
    @State private var isRecording = false
    
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
                Text("🎯 Practicing: '\(sound.stringEquivalent)'")
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
                isRecording.toggle()
            }) {
                Text(isRecording ? "🎤 Recording..." : "🎤 Tap to Record")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(isRecording ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .padding(.vertical, 10)
            
            // Repetition Progress Tracker
            Text("Repetitions: \(repetitions) / 10")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            // Parent Feedback Buttons
            HStack(spacing: 40) {
                Button(action: {
                    if repetitions < 10 { repetitions += 1 }
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
                    if repetitions < 10 { repetitions += 1 }
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
                dismiss()
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
}

#Preview {
    let sampleSound = Sound(stringEquivalent: "R")
    SpeechExerciseView(sound: sampleSound, word: "Rabbit")
}
