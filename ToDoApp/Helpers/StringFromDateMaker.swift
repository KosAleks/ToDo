//
//  StringFromDateMaker.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 09.08.2025.
//

import Foundation


func makeStringFromDate(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    formatter.string(from: date)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter.string(from: date)
}
