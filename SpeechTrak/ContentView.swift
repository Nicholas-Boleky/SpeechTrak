//
//  ContentView.swift
//  SpeechTrak
//
//  Created by Nick on 2/8/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing: 20) {
                    ChildDetailView(child: Child(name: "Henry Hickensburgh", pictureName: "person.crop.circle", speechSounds: ["Th, th, th"]))
                    
                    
                }
                .padding()
                .navigationTitle("Dashboard")
                //            .navigationDestination(for: HealthMetricContext.self) { metric in
                //                HealthDataListView(isShowingPermissionPriming: $isShowingPermissionPrimingSheet, metric: metric)
                //            }
                //            .fullScreenCover(isPresented: $isShowingPermissionPrimingSheet, onDismiss: {
                //                fetchHealthData()
                //            }, content: {
                //                HealthKitPermissionPrimingView()
                //                    .environment(HealthKitManager())
                //            })
                //            .alert(isPresented: $isShowingAlert, error: fetchError) { fetchError in
                //                //Action buttons, default is OK button
                //            } message: { fetchError in
                //                Text(fetchError.failureReason)
                //            }
                
            }
            .tint(.pink)
        }
    }
}

#Preview {
    ContentView()
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
                    ForEach(child.speechSounds, id: \.self) { sound in
                        Text(sound)
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

struct Child {
    var name: String
    var pictureName: String
    var speechSounds: [String]
}
