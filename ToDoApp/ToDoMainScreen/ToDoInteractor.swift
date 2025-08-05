//
//  ToDoInteractor.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 03.08.2025.
//

import Foundation
import CoreData

protocol ToDoInteractorProtocol: AnyObject {
    func fetchTodos()
    func updateTask(_ task: Task, at index: Int)
    var filteredTasks: [Task] {get}
    func filterTasks(with query: String)
}

protocol TodoInteractorOutPutProtocol: AnyObject {
    func didFetchTasks(_ tasks: [Task])
}

class ToDoInteractor: ToDoInteractorProtocol {
    weak var toDoPresenter: TodoInteractorOutPutProtocol?
    var toDoService: TodoServiceProtocol
    let persistentContainer: NSPersistentContainer
    
    // Все задачи из Core Data или сервиса, по ним фильтруем
    private var tasks: [Task] = []
    var filteredTasks: [Task] = []
    
    init(toDoService: TodoServiceProtocol, persistentContainer: NSPersistentContainer) {
        self.toDoService = toDoService
        self.persistentContainer = persistentContainer
    }
    
    func fetchTodos() {
        // Сначала пытаемся загрузить из Core Data
        loadTasksFromCoreData()
        if tasks.isEmpty {
            // Если пусто — загружаем из сети
            loadTodosFromNetwork()
        } else {
            filteredTasks = tasks
            toDoPresenter?.didFetchTasks(filteredTasks)
        }
    }
    
    func filterTasks(with query: String) {
        if query.isEmpty {
            filteredTasks = tasks
        } else {
            filteredTasks = tasks.filter {
                $0.description?.lowercased().contains(query.lowercased()) ?? false
            }
        }
        toDoPresenter?.didFetchTasks(tasks)
    }
    
    private func loadTasksFromCoreData() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(fetchRequest)
            tasks = entities.map { Task(from: $0) }
            filteredTasks = tasks
        } catch {
            print("Ошибка при загрузке из Core Data: \(error)")
            tasks = []
            filteredTasks = []
        }
    }
    
    private func loadTodosFromNetwork() {
        toDoService.fetchTodos { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let todoDTOs):
                    self?.saveTodosToCoreData(todoDTOs)
                case .failure(let error):
                    print("Ошибка при загрузке из сети: \(error)")
                    self?.toDoPresenter?.didFetchTasks([])
                }
            }
        }
    }
    
    private func saveTodosToCoreData(_ todoDTOs: [TodoDTO]) {
        let context = persistentContainer.viewContext
        for todo in todoDTOs {
            let taskEntity = TaskEntity(context: context)
            taskEntity.id = Int32(todo.id)
            taskEntity.todo = todo.todo
            taskEntity.completed = todo.completed
            taskEntity.createdAt = Date() // или можно не задавать, если нет данных
        }
        
        do {
            try context.save()
            // Обновляем локальный массив tasks
            loadTasksFromCoreData()
            toDoPresenter?.didFetchTasks(filteredTasks)
        } catch {
            print("Ошибка при сохранении в Core Data: \(error)")
            toDoPresenter?.didFetchTasks([])
        }
    }
    
    func updateTask(_ task: Task, at index: Int) {
        guard tasks.indices.contains(index) else { return }
        
        // Обновляем локальный массив
        tasks[index] = task
        filteredTasks = tasks
        
        // Обновляем в Core Data
        updateTaskInCoreData(task)
        
        // Уведомляем презентер
        toDoPresenter?.didFetchTasks(filteredTasks)
    }
    
    private func updateTaskInCoreData(_ task: Task) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
        
        do {
            let entities = try context.fetch(fetchRequest)
            if let entityToUpdate = entities.first {
                entityToUpdate.completed = task.isDone
                entityToUpdate.todo = task.description
                entityToUpdate.createdAt = task.createdAt
                try context.save()
            }
        } catch {
            print("Ошибка обновления задачи в Core Data: \(error)")
        }
    }
}

