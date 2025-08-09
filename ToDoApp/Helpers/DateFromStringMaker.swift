//
//  DateFromStringMaker.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 09.08.2025.
//

import Foundation

func makeDateFromString(from dateString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter.date(from: dateString)
}
