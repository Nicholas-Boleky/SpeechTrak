//
//  SoundSelectionView.swift
//  SpeechTrak
//
//  Created by Nick on 2/20/25.
//
import SwiftUI

struct SoundPositionSelectionView: View {
    var child: Child
    @Binding var isPresented: Bool
    @EnvironmentObject var wordBankManager: WordBankManager

    @State private var selectedSound: SpeechSound? = nil
    @State private var selectedPosition: SoundPosition? = nil
    @State private var selectedWord: Word? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("🎯 Select a Sound")
                        .font(.title)

                    // Scrollable Sound Grid
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 16) {
                        ForEach(SpeechSound.allCases, id: \.self) { sound in
                            Button(action: { selectedSound = sound }) {
                                Text(sound.rawValue.uppercased())
                                    .padding()
                                    .background(selectedSound == sound ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding()

                    Divider()

                    Text("🧩 Select Position")
                        .font(.title2)

                    // Position Selection Buttons
                    HStack {
                        ForEach(SoundPosition.allCases, id: \.self) { position in
                            Button(action: { selectedPosition = position }) {
                                Text(position.rawValue.capitalized)
                                    .padding()
                                    .background(selectedPosition == position ? Color.green : Color.gray.opacity(0.2))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }

                    Divider()

                    // Dynamically Display Words
                    if let sound = selectedSound, let position = selectedPosition {
                        let filteredWords = wordBankManager.getWords(for: sound, at: position)

                        if filteredWords.isEmpty {
                            Text("No words found for \(sound.rawValue.uppercased()) in the \(position.rawValue) position.")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            Text("📚 Select a Word")
                                .font(.headline)
                                .padding(.top)

                            ForEach(filteredWords) { word in
                                NavigationLink(destination: SpeechExerciseView(child: child, word: word, isPresented: $isPresented)) {
                                    Text(word.text.capitalized)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    } else {
                        Text("⬆️ Select both a sound and position to see words.")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("Select Sound & Word")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { isPresented = false }
                }
            }
        }
    }
}


// ✅ Preview for Testing
#Preview {
    @State var isPresented = false
    SoundPositionSelectionView(child: Child.mockChild, isPresented: $isPresented)
}
