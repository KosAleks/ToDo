//
//  ToDoInteractor.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 03.08.2025.
//

import Foundation

protocol ToDoInteractorProtocol: AnyObject {
    func fetchTasks()
    func updateTask(_ task: Task, at index: Int)
    var filteredTasks: [Task] {get}
    func filterTasks(with query: String)
}

protocol TodoInteractorOutPutProtocol: AnyObject {
    func didFetchTasks(_ tasks: [Task])
}

class ToDoInteractor: ToDoInteractorProtocol {
    weak var toDoPresenter: TodoInteractorOutPutProtocol?
    var tasks: [Task] = [
        Task(title: "Купить молоко", description: "Обезжиренное, 1 литр", isDone: false),
        Task(title: "Позвонить маме", description: "Уточнить насчёт выходных", isDone: true),
        Task(title: "Сделать зарядку", description: "10 минут йоги", isDone: false),
        Task(title: "Купить молоко", description: "Обезжиренное, 1 литр", isDone: false),
        Task(title: "Позвонить маме", description: "Уточнить насчёт выходных", isDone: true),
        Task(title: "Сделать зарядку", description: "10 минут йоги", isDone: false),
        Task(title: "Купить молоко", description: "Обезжиренное, 1 литр", isDone: false),
        Task(title: "Позвонить маме", description: "Уточнить насчёт выходных", isDone: true),
        Task(title: "Сделать зарядку", description: "10 минут йоги", isDone: false),
        Task(title: "Купить молоко", description: "Обезжиренное, 1 литр", isDone: false),
        Task(title: "Позвонить маме", description: "Уточнить насчёт выходных", isDone: true),
        Task(title: "Сделать зарядку", description: "10 минут йоги", isDone: false)
    ]
    var filteredTasks: [Task] = []
    
    func filterTasks(with query: String) {
        if query.isEmpty {
            filteredTasks = tasks
        } else {
            filteredTasks = tasks.filter {
                $0.title.lowercased().contains(query.lowercased()) ||
                $0.description.lowercased().contains(query.lowercased())
            }
        }
        toDoPresenter?.didFetchTasks(tasks)
    }
    
    func fetchTasks() {
        filteredTasks = tasks
        toDoPresenter?.didFetchTasks(tasks)
    }
    
    func updateTask(_ task: Task, at index: Int) {
        guard tasks.indices.contains(index) else { return }
        tasks[index] = task
        filteredTasks = tasks 
        toDoPresenter?.didFetchTasks(filteredTasks)
    }
}

