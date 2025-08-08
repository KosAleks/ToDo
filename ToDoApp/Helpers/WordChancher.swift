//
//  WordChancher.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 07.08.2025.
//

import Foundation

func getTaskWord(for count: Int) -> String {
    let remainder10 = count % 10
    let remainder100 = count % 100
    
    if remainder100 >= 11 && remainder100 <= 14 {
        return "\(count) Задач"
    }
    
    switch remainder10 {
    case 1:
        return "\(count) Задача"
    case 2...4:
        return "\(count) Задачи"
    default:
        return "\(count) Задач"
    }
}
