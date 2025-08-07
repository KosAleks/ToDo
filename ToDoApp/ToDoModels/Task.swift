//
//  Task.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 05.08.2025.
//

import Foundation

struct Task {
    let id: Int
    var description: String?
    var isDone: Bool
    let createdAt: Date?
    
    init(id: Int, description: String?, isDone: Bool, createdAt: Date?) {
        self.id = id
        self.description = description
        self.isDone = isDone
        self.createdAt = createdAt
    }
    
    init(from dto: TodoDTO) {
        self.id = dto.id
        self.description = dto.todo
        self.isDone = dto.completed
        self.createdAt = nil
    }
    
    init(from entity: TaskEntity) {
        self.id = Int(entity.id)
        self.description = entity.todo
        self.isDone = entity.completed
        self.createdAt = entity.createdAt
    }
}
