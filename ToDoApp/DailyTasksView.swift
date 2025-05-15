//
//  DailyTasksView.swift
//  ToDoApp
//
//  Created by Mason Jennings on 5/14/25.
//

import SwiftUI

struct DailyTasksView: View {
    @State private var selectedDate: Date = Date()
    @StateObject private var viewModel: ToDoViewModel
    
    init() {
        let today = Date()
        _viewModel = StateObject(wrappedValue: ToDoViewModel(date: today))
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: goToPreviousDay) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(Self.formattedDate(selectedDate))
                    .font(.headline)
                Spacer()
                Button(action: goToNextDay) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            ContentView(viewModel: viewModel)
            Spacer()
        }
    }
    
    private func goToPreviousDay() {
        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
        viewModel.updateDate(to: selectedDate)
    }
    
    private func goToNextDay() {
        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
        viewModel.updateDate(to: selectedDate)
    }
    
    private static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: date)
        
        if Calendar.current.isDateInToday(date) {
            return "Today, \(dateString)"
        } else {
            formatter.dateFormat = "EEEE"
            let dayOfWeek = formatter.string(from: date)
            return "\(dayOfWeek), \(dateString)"
        }
    }
}
