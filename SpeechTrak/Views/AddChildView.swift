//
//  AddChildView.swift
//  SpeechTrak
//
//  Created by Nick on 2/15/25.
//

import SwiftUI
import SwiftData

struct AddChildView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var selectedPicture = "person.circle.fill"
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Child Info")) {
                    TextField("Enter Name", text: $name)
                        .submitLabel(.done)
                    
                    Picker("Profile Icon", selection: $selectedPicture) {
                        Image(systemName: "person.circle.fill").tag("person.circle.fill")
                        Image(systemName: "person.crop.circle").tag("person.crop.circle")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("New Child")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        addChild()
                        isPresented = false
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    private func addChild() {
        let newChild = Child(
            name: name,
            pictureName: selectedPicture,
            speechProfile: SpeechProfile(lastPracticedSound: nil, soundsInProgress: [])
        )
        modelContext.insert(newChild)
        
        do {
            try modelContext.save()
        } catch {
            print(" FAILED TO SAVE NEW CHILD \(error.localizedDescription)")
        }
    }
}

#Preview {
    var isPresented = false
    AddChildView(isPresented: .constant(false))
}
