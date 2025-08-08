//
//  TodayDate.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 07.08.2025.
//

import Foundation

func getTodayDateString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yy"
    let today = Date()
    return dateFormatter.string(from: today)
}
