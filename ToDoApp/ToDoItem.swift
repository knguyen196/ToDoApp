//
//  ToDoItem.swift
//  ToDoApp
//
//  Created by Kent Nguyen on 3/21/25.
//

import Foundation

struct ToDoItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
}
