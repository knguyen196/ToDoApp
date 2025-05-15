//
//  ToDoViewModel.swift
//  ToDoApp
//
//  Created by Kent Nguyen on 3/21/25.
//

import Foundation

class ToDoViewModel: ObservableObject {
    enum Mode {
        case daily
        case weekly
    }
    
    @Published var tasks: [ToDoItem] = []
    
    private var saveKey: String
    private var currentDate: Date
    private let mode: Mode
    
    init(date: Date, mode: Mode = .daily) {
        self.currentDate = date
        self.mode = mode
        self.saveKey = ToDoViewModel.makeSaveKey(for: date, mode: mode)
        loadTasks()
    }
    
    static func makeSaveKey(for date: Date, mode: Mode) -> String {
        switch mode {
        case .daily:
            return "Tasks_Daily_\(dateFormatter.string(from: date))"
        case .weekly:
            let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            return "Tasks_Weekly_\(dateFormatter.string(from: startOfWeek))"
        }
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    func updateDate(to newDate: Date) {
        self.currentDate = newDate
        self.saveKey = Self.makeSaveKey(for: newDate, mode: mode)
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
