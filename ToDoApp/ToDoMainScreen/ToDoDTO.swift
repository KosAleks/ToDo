//
//  Entity.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 03.08.2025.
//

import Foundation

//это модель для парсинга {"todos":[{"id":1,"todo":"Do something nice for someone you care about","completed":false,"userId":152}

struct TodoResponse: Codable {
    let todos: [TodoDTO]
}

struct TodoDTO: Codable {
    let id: Int
    let todo: String
    let completed: Bool
}

