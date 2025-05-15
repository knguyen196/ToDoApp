//
//  ToDoItem.swift
//  ToDoApp
//
//  Created by Kent Nguyen on 3/21/25.
//

import Foundation
import CoreLocation

struct ToDoItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var priority: Int = 1
    
    var latitude: Double?
    var longitude: Double?
    
    var location: CLLocation? {
        if let lat = latitude, let lon = longitude {
            return CLLocation(latitude: lat, longitude: lon)
        }
        return nil
    }
}
