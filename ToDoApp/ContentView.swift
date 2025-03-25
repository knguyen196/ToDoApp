//
//  ContentView.swift
//  ToDoApp
//
//  Created by Kent Nguyen on 3/21/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ToDoViewModel()
    @State private var newTaskTitle = ""
    
    var body: some View{
        NavigationView{
            ZStack {
                Color(red: 0.92, green: 0.98, blue: 0.95)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
            VStack{
                HStack{
                    TextField("New task", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
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
                        HStack{
                            Button(action: {viewModel.toggleTaskComplete(task) }) {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(task.isCompleted ? .green : .gray)
                            }
                            Text(task.title)
                                .strikethrough(task.isCompleted)
                        }
                    }
                        .onDelete(perform: viewModel.deleteTask)
                }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
            }
            
            Spacer()
                
        }
        .navigationTitle("To-Do List")

        .overlay(
            VStack {
                Spacer()
                
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
        viewModel.addTask(title: newTaskTitle)
        newTaskTitle = ""
    }
}

struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
    }
}
