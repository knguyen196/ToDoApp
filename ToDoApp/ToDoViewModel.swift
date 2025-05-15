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
    private var currentDate: Date
    
    init(date: Date) {
        self.currentDate = date
        self.saveKey = "Tasks_Daily_\(Self.dateFormatter.string(from: date))"
        loadTasks()
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    func updateDate(to newDate: Date) {
        self.currentDate = newDate
        self.saveKey = "Tasks_Daily_\(Self.dateFormatter.string(from: newDate))"
        loadTasks()
    }
    
    var completedTasks: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    var progress: Double {
        tasks.isEmpty ? 0.0 : Double(completedTasks) / Double(tasks.count)
    }
    
    func addTask(title: String, priority: Int, latitude: Double? = nil, longitude: Double? = nil){
        let newTask = ToDoItem(title: title, isCompleted: false, priority: priority, latitude: latitude, longitude: longitude)
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
    
    func toggleTaskComplete(_ task: ToDoItem){
        if let index = tasks.firstIndex(where: {$0.id == task.id}) {
            tasks[index].isCompleted.toggle()
            saveTasks()
        }
    }
    
    func deleteTask(at offsets: IndexSet){
        tasks.remove(atOffsets: offsets)
        saveTasks()
    }
    
    private func saveTasks(){
        if let encodedData = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedData, forKey: saveKey)
        }
    }
    
    private func loadTasks() {
        if let savedData = UserDefaults.standard.data(forKey: saveKey),
           let decodedTasks = try? JSONDecoder().decode([ToDoItem].self, from: savedData) {
            tasks = decodedTasks
        } else {
            tasks = []
        }
    }
}
