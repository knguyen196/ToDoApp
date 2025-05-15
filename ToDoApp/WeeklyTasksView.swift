//
//  DailyTasksView.swift
//  ToDoApp
//
//  Created by Mason Jennings on 5/14/25.
//

import SwiftUI

struct WeeklyTasksView: View {
    @State private var selectedWeek: Date = Date().startOfWeek
    @StateObject private var viewModel: ToDoViewModel
    
    init() {
        let weekStart = Date().startOfWeek
        _viewModel = StateObject(wrappedValue: ToDoViewModel(date: weekStart, mode: .weekly))
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: goToPreviousWeek) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(Self.formattedWeekRange(from: selectedWeek))
                    .font(.headline)
                Spacer()
                Button(action: goToNextWeek) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            
            ContentView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.updateDate(to: selectedWeek)
        }
    }
    
    private func goToPreviousWeek() {
        selectedWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedWeek)!
        viewModel.updateDate(to: selectedWeek)
    }
    
    private func goToNextWeek() {
        selectedWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: selectedWeek)!
        viewModel.updateDate(to: selectedWeek)
    }
    
    private static func formattedWeekRange(from startDate: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        
        let today = Date()
        let currentWeekStart = today.startOfWeek
        let weekEnd = calendar.date(byAdding: .day, value: 6, to: startDate)!
        
        if calendar.isDate(startDate, inSameDayAs: currentWeekStart) {
            return "Today - \(formatter.string(from: weekEnd))"
        } else {
            return "\(formatter.string(from: startDate)) - \(formatter.string(from: weekEnd))"
        }
    }
}

extension Date {
    var startOfWeek: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }
}
