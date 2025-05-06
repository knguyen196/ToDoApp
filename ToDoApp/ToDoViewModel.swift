//
//  ToDoViewModel.swift
//  ToDoApp
//
//  Created by Kent Nguyen on 3/21/25.
//

import Foundation

class ToDoViewModel: ObservableObject {
    @Published var tasks: [ToDoItem] = []
    
    private var saveKey: String
    
    init(category: String) {
        self.saveKey = "Tasks_\(category)"
        loadTasks()
    }
    
    //Number of completed tasks
    var completedTasks: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    //Progress on completed tasks as a percentage
    var progress: Double {
        tasks.isEmpty ? 0.0 : Double(completedTasks) / Double(tasks.count)
    }
    
    //Function to add tasks.
    func addTask(title: String, priority: Int){
        let newTask = ToDoItem(title: title, isCompleted: false, priority: priority)
        tasks.append(newTask)
        tasks.sort {$0.priority > $1.priority}
        saveTasks()
    }
    
    func updatePriority(for task: ToDoItem, to newPriority: Int){
        if let index = tasks.firstIndex(where: { $0.id == task.id}){
            tasks[index].priority = newPriority
            tasks.sort {$0.priority > $1.priority}
            saveTasks()
        }
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
