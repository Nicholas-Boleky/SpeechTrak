//
//  ContentView.swift
//  SpeechTrak
//
//  Created by Nick on 2/8/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    
    @Environment(\.modelContext) private var modelContext
    @Query private var children: [Child] //fetch stored children from swiftdata
    @State private var isAddingChild: Bool = false //sheet presentation for adding chld

    var body: some View {
        NavigationStack {
            VStack {
                if children.isEmpty { // Show a placeholder when no children exist
                    VStack {
                        Text("No children added yet!")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .padding()
                        
                        Button(action: { isAddingChild = true }) {
                            Label("Add Your First Child", systemImage: "plus.circle.fill")
                                .font(.title2)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                } else {
                    List {
                        ForEach(children) { child in
                            NavigationLink(destination: ChildPageView(child: child)) {
                                ChildDetailView(child: child)
                            }
                        }
                        .onDelete(perform: deleteChild) // swipe-to-delete
                    }
                }
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { isAddingChild = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingChild) {
                AddChildView(isPresented: $isAddingChild)
            }
        }
    }
    
    // Function to delete a child
    private func deleteChild(at offsets: IndexSet) {
        for index in offsets {
            let childToDelete = children[index]
            modelContext.delete(childToDelete)
        }
    }
}

#Preview {
    do {
        let container = try ModelContainer(for: Child.self, configurations: .init(isStoredInMemoryOnly: true))
        
        let sampleChild = Child(
            name: "Child",
            pictureName: "person.circle.fill",
            speechProfile: SpeechProfile(
                lastPracticedSound: nil, soundsInProgress: []))
        container.mainContext.insert(sampleChild)
        return ContentView().modelContainer(container)
    } catch {
        return Text("Failed to load Preview: \(error.localizedDescription)")
    }
}


struct ChildDetailView: View {
    let child: Child
    
    var body: some View {
        HStack{
            Image(systemName: child.pictureName)
                .resizable()
                .scaledToFit()
                .frame(height: 125)
                .clipShape(Circle())
                .padding()
            VStack {
                Text(child.name)
                    .font(.largeTitle)
                    .padding(.bottom, 8)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                
                Text("Speech Sounds:")
                    .font(.headline)
                
                // List out the speech sounds
                HStack {
                    ForEach(child.speechProfile.soundsInProgress, id: \.self) { sound in
                        Text(sound.stringEquivalent)
                            .padding(6)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(6)
                    }
                }
                .padding()
                
                Spacer()
            }
            .padding()
            
        }
        .background(Color(.systemFill))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

