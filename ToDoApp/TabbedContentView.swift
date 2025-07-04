//
//  TabbedContentView.swift
//  ToDoApp
//
//  Created by Mason Jennings on 5/5/25.
//

import SwiftUI

struct TabbedContentView: View {
    var body: some View {
        TabView {
            DailyTasksView()
                .tabItem {
                    Label("Daily", systemImage: "calendar")
                }
            
            WeeklyTasksView()
                .tabItem {
                    Label("Weekly", systemImage: "calendar.badge.clock")
                }
            
            ContentView(viewModel: ToDoViewModel(date: Date()))
                .tabItem {
                    Label("Someday", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                }
        }
    }
}

struct TabbedContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabbedContentView()
    }
}
