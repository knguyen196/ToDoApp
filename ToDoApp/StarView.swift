//
//  StarView.swift
//  ToDoApp
//
//  Created by Kent Nguyen on 4/18/25.
//

import Foundation
import SwiftUI

struct StarView: View {
    var currentRating: Int
    var onSelect: (Int) -> Void
    var maxStars: Int = 5
    
    var body: some View{
        HStack(spacing: 2){
            ForEach(1...maxStars, id: \.self) {index in
                Image(systemName: index <= currentRating ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        onSelect(index)
                    }
            }
        }
    }
}
