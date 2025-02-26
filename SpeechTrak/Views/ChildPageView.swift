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
        TabView {
            //MARK: 🏠 Overview Tab
            OverviewTab(child: child, isExercisePresented: $isExercisePresented)
                .tabItem {
                    Label("Overview", systemImage: "house")
                }

            //MARK: 📊 Progress Tab
            ProgressTab(child: child)
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.xaxis")
                }

            //MARK: 📝 Practice History Tab
            PracticeHistoryTab(child: child)
                .tabItem {
                    Label("History", systemImage: "list.bullet.rectangle")
                }

            //MARK: 🏆 Achievements Tab
            AchievementsTab(child: child)
                .tabItem {
                    Label("Achievements", systemImage: "star.fill")
                }
        }
    }
}

struct OverviewTab: View {
    var child: Child
    @Binding var isExercisePresented: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // User Info
                    VStack {
                        Image(systemName: child.pictureName)
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
                        Text("🎯 Last Sound Practiced: '\(child.speechProfile.lastPracticedSound?.soundType.rawValue ?? "-")'")
                            .font(.headline)
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)

                        HStack {
                            Text("🔥 Streak: 5 Days") // Placeholder
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
                        NavigationStack {
                            SoundPositionSelectionView(child: child, isPresented: $isExercisePresented)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Overview")
        }
    }
}

struct ProgressTab: View {
    var child: Child

    var body: some View {
        NavigationStack {
            VStack {
                Text("📊 Progress Breakdown")
                    .font(.title)
                    .padding()

                Text("Sound and position breakdowns will go here.")
                    .foregroundColor(.gray)
                    .italic()

                Spacer()
            }
            .navigationTitle("Progress")
        }
    }
}


//struct PracticeHistoryTab: View {
//    var child: Child
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Text("📝 Practice History")
//                    .font(.title)
//                    .padding()
//
//                Text("List of completed sessions will be displayed here.")
//                    .foregroundColor(.gray)
//                    .italic()
//
//                Spacer()
//            }
//            .navigationTitle("Practice History")
//        }
//    }
//}

struct AchievementsTab: View {
    var child: Child

    var body: some View {
        NavigationStack {
            VStack {
                Text("🏆 Achievements")
                    .font(.title)
                    .padding()

                Text("Completed goals, badges, and sounds mastered will appear here.")
                    .foregroundColor(.gray)
                    .italic()

                Spacer()
            }
            .navigationTitle("Achievements")
        }
    }
}

struct ChildPageView_Previews: PreviewProvider {
    static var previews: some View {
        ChildPageView(child: Child.mockChild)
    }
}

struct PracticeHistoryTab: View {
    var child: Child

    @State private var selectedFilter: SpeechSound? = nil // Optional filter by sound
    @State private var showSessionDetails = false
    @State private var selectedSession: PracticeSession? = nil

    var filteredSessions: [PracticeSession] {
        let allSessions = child.speechProfile.soundsInProgress.flatMap { $0.sessionHistory }
        if let soundFilter = selectedFilter {
            return allSessions.filter { session in
                child.speechProfile.soundsInProgress.contains {
                    $0.sessionHistory.contains(session) && $0.soundType == soundFilter
                }
            }
        }
        return allSessions
    }

    var body: some View {
        NavigationStack {
            VStack {
                // Filter Dropdown
                Picker("Filter by Sound", selection: $selectedFilter) {
                    Text("All Sounds").tag(nil as SpeechSound?)
                    ForEach(SpeechSound.allCases, id: \.self) { sound in
                        Text(sound.rawValue.uppercased()).tag(sound as SpeechSound?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                // List of Practice Sessions
                List(filteredSessions.sorted(by: { $0.date > $1.date })) { session in
                    Button(action: {
                        selectedSession = session
                        showSessionDetails = true
                    }) {
                        SessionRowView(session: session)
                    }
                }
            }
            .navigationTitle("Practice History")
            .sheet(isPresented: $showSessionDetails) {
                if let session = selectedSession {
                    PracticeSessionDetailView(session: session)
                }
            }
        }
    }
}
struct SessionRowView: View {
    var session: PracticeSession

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(session.date, style: .date)
                    .font(.headline)
                Text("Accuracy: \(String(format: "%.0f", session.accuracy))%")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}
struct PracticeSessionDetailView: View {
    var session: PracticeSession

    var body: some View {
        VStack(spacing: 16) {
            Text("Practice Session Details")
                .font(.title2)
                .fontWeight(.bold)

            Text("📅 Date: \(session.date, style: .date)")
                .font(.headline)

            Text("✅ Correct: \(session.repititionsCorrect)")
                .foregroundColor(.green)
                .font(.title2)

            Text("❌ Incorrect: \(session.repititionsIncorrect)")
                .foregroundColor(.red)
                .font(.title2)

            Text("🎯 Accuracy: \(String(format: "%.0f", session.accuracy))%")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(session.accuracy >= 85 ? .green : .orange)

            Spacer()
        }
        .padding()
        .presentationDetents([.medium, .large])
    }
}
