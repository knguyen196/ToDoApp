//
//  ContentView.swift
//  ToDoApp
//
//  Created by Kent Nguyen on 3/21/25.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var viewModel: ToDoViewModel
    @StateObject private var locationManager = LocationManager()
    @State private var selectedLocation: CLLocation?
    @State private var isShowingMap = false
    @State private var newTaskTitle = ""
    @State private var newTaskPriority = 1

    init(viewModel: ToDoViewModel = ToDoViewModel(date: Date())) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View{
        NavigationView{
            ZStack {
                Color(red: 0.92, green: 0.98, blue: 0.95)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack{
                    HStack{
                        TextField("New task", text: $newTaskTitle)
                            .foregroundColor(Color.black)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius:1)
                        
                        StarView(currentRating: newTaskPriority){ rating in
                            newTaskPriority = rating
                        }
                        
                        Button(action: {
                            isShowingMap = true
                        }) {
                            Image(systemName: selectedLocation == nil ? "mappin.and.ellipse" : "mappin.circle.fill")
                                .font(.title2)
                                .foregroundColor(.red)
                                .padding(.leading, 5)
                        }
                        
                        Button(action: addTask) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                        .disabled(newTaskTitle.isEmpty)
                    }
                    .padding()
                    
                    List {
                        ForEach(viewModel.tasks) { task in
                            HStack {
                                Button(action: { viewModel.toggleTaskComplete(task) }) {
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(task.isCompleted ? .green : .gray)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(task.title)
                                        .foregroundColor(Color.black)
                                        .strikethrough(task.isCompleted)
                                    
                                    StarView(currentRating: task.priority) { newRating in
                                        viewModel.updatePriority(for: task, to: newRating)
                                    }
                                    
                                    if let taskLoc = task.location,
                                       let userLoc = locationManager.currentLocation {
                                        let distanceInMiles = userLoc.distance(from: taskLoc) / 1609.344
                                        Text(String(format: "%.1f miles away", distanceInMiles))
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    } else {
                                        Text("No distance info")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                            .listRowInsets(EdgeInsets()) // removes default List padding
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: viewModel.deleteTask)
                    }
                    
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                }
                
                Spacer()
                
            }
            // .navigationTitle("To-Do")
            
            .overlay(
                VStack {
                    Spacer()
                        .frame(height: 0)
                    
                    VStack {
                        ProgressView(value: viewModel.progress)
                            .progressViewStyle(LinearProgressViewStyle())
                            .tint(.green)
                            .frame(width: 200)
                        
                        Text("\(viewModel.completedTasks) / \(viewModel.tasks.count) Tasks Completed")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.shadow(radius: 1))
                }
                    .edgesIgnoringSafeArea(.bottom),
                alignment: .bottom
            )
        }
        .sheet(isPresented: $isShowingMap) {
            MapPickerView(
                selectedLocation: $selectedLocation,
                userLocation: locationManager.currentLocation?.coordinate
            )
        }
    }
    private func addTask(){
        print("Adding task: \(newTaskTitle), location: \(selectedLocation?.coordinate.latitude ?? 0), \(selectedLocation?.coordinate.longitude ?? 0)")
        viewModel.addTask(title: newTaskTitle, priority: newTaskPriority, latitude: selectedLocation?.coordinate.latitude, longitude: selectedLocation?.coordinate.longitude)
        newTaskTitle = ""
        newTaskPriority = 1
        selectedLocation = nil
    }
}

struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
    }
}
