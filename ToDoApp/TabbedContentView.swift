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
            ContentView(viewModel: ToDoViewModel(category: "Daily"))
                .tabItem {
                    Label("Daily", systemImage: "calendar.badge.exclamationmark")
                }
            
            ContentView(viewModel: ToDoViewModel(category: "Weekly"))
                .tabItem {
                    Label("Weekly", systemImage: "calendar.badge.clock")
                }
            
            ContentView(viewModel: ToDoViewModel(category: "Someday"))
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
