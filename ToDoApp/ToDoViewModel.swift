//
//  ToDoViewModel.swift
//  ToDoApp
//
//  Created by Kent Nguyen on 3/21/25.
//

import Foundation

class ToDoViewModel: ObservableObject {
    @Published var tasks: [ToDoItem] = [] {
        didSet{
            saveTasks()
        }
    }
    
    private let saveKey = "Tasks"
    
    init() {
        loadTasks()
    }
    
    //Function to add tasks.
    func addTask(title: String){
        let newTask = ToDoItem(title: title)
        tasks.append(newTask)
    }
    
    //Function to toggle completed task
    func toggleTaskComplete(_ task: ToDoItem){
        if let index = tasks.firstIndex(where: {$0.id == task.id}) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    //Function to delete task
    func deleteTask(at offsets: IndexSet){
        tasks.remove(atOffsets: offsets)
    }
    
    //Function that saves tasks to UserDefaults
    private func saveTasks(){
        if let encodedData = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedData, forKey: saveKey)
        }
    }
    //Function that loads tasks from UserDefaults
    private func loadTasks(){
        if let savedData = UserDefaults.standard.data(forKey: saveKey),
           let decodedTasks = try? JSONDecoder().decode([ToDoItem].self, from: savedData){
            tasks = decodedTasks
        }
    }
}
