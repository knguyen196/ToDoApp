//
//  ContentView.swift
//  ToDoApp
//
//  Created by Kent Nguyen on 3/21/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ToDoViewModel
    @State private var newTaskTitle = ""
    @State private var newTaskPriority = 1

    init(viewModel: ToDoViewModel = ToDoViewModel(category: "Daily")) {
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
                                
                                VStack(alignment: .leading) {
                                    Text(task.title)
                                        .foregroundColor(Color.black)
                                        .strikethrough(task.isCompleted)
                                    
                                    StarView(currentRating: task.priority) { newRating in
                                        viewModel.updatePriority(for: task, to: newRating)
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
            .navigationTitle("To-Do")
            
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
    }
    private func addTask(){
        viewModel.addTask(title: newTaskTitle, priority: newTaskPriority)
        newTaskTitle = ""
        newTaskPriority = 1
    }
}

struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
    }
}
