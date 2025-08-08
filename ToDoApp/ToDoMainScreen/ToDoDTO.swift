//
//  Entity.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 03.08.2025.
//

import Foundation

struct TodoResponse: Codable {
    let todos: [TodoDTO]
}

struct TodoDTO: Codable {
    let id: Int
    let todo: String
    let completed: Bool
}

