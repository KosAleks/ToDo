//
//  ToDoInteractor.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 03.08.2025.
//

import Foundation
import CoreData

protocol ToDoInteractorProtocol: AnyObject {
    var filteredTasks: [Task] {get}
    var tasks: [Task] {get}
    func fetchTodos()
    func updateTask(_ task: Task, at index: Int)
    func deleteTask(task: Task)
    func filterTasks(with query: String)
    func searchTasks(query: String)
}

protocol TodoInteractorOutPutProtocol: AnyObject {
    func didFetchTasks(_ tasks: [Task])
}

final class ToDoInteractor: ToDoInteractorProtocol {
    weak var toDoPresenter: TodoInteractorOutPutProtocol?
    let persistentContainer: NSPersistentContainer
    var toDoService: TodoServiceProtocol
    var tasks: [Task] = []
    var filteredTasks: [Task] = []
    
    init(toDoService: TodoServiceProtocol, persistentContainer: NSPersistentContainer) {
        self.toDoService = toDoService
        self.persistentContainer = persistentContainer
    }
    
    func fetchTodos() {
        loadTasksFromCoreData { [weak self] in
            guard let self = self else { return }
            if self.tasks.isEmpty {
                self.loadTodosFromNetwork()
            } else {
                self.filteredTasks = self.tasks
                DispatchQueue.main.async {
                    self.toDoPresenter?.didFetchTasks(self.filteredTasks)
                }
            }
        }
    }
    
    func filterTasks(with query: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let filtered: [Task]
            if query.isEmpty {
                filtered = self.tasks
            } else {
                filtered = self.tasks.filter {
                    $0.description?.lowercased().contains(query.lowercased()) ?? false
                }
            }
            DispatchQueue.main.async {
                self.filteredTasks = filtered
                self.toDoPresenter?.didFetchTasks(filtered)
            }
        }
    }
    
    private func loadTasksFromCoreData(completion: @escaping () -> Void) {
        persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            do {
                let entities = try context.fetch(fetchRequest)
                let loadedTasks = entities.map { Task(from: $0) }
                DispatchQueue.main.async {
                    self.tasks = loadedTasks
                    self.filteredTasks = loadedTasks
                    completion()
                }
            } catch {
                print("Ошибка при загрузке из Core Data: \(error)")
                DispatchQueue.main.async {
                    self.tasks = []
                    self.filteredTasks = []
                    completion()
                }
            }
        }
    }
    
    private func loadTodosFromNetwork() {
        toDoService.fetchTodos { [weak self] result in
            switch result {
            case .success(let todoDTOs):
                self?.saveTodosToCoreData(todoDTOs)
            case .failure(let error):
                print("Ошибка при загрузке из сети: \(error)")
                DispatchQueue.main.async {
                    self?.toDoPresenter?.didFetchTasks([])
                }
            }
        }
    }
    
    private func saveTodosToCoreData(_ todoDTOs: [TodoDTO]) {
        persistentContainer.performBackgroundTask { context in
            for todo in todoDTOs {
                let taskEntity = TaskEntity(context: context)
                taskEntity.id = Int32(todo.id)
                taskEntity.todo = todo.todo
                taskEntity.completed = todo.completed
                taskEntity.createdAt = Date()
            }
            do {
                try context.save()
                DispatchQueue.main.async {
                    self.loadTasksFromCoreData {
                        self.toDoPresenter?.didFetchTasks(self.filteredTasks)
                    }
                }
            } catch {
                print("Ошибка при сохранении в Core Data: \(error)")
                DispatchQueue.main.async {
                    self.toDoPresenter?.didFetchTasks([])
                }
            }
        }
    }
    
    func updateTask(_ task: Task, at index: Int) {
        guard tasks.indices.contains(index) else { return }
        tasks[index] = task
        filteredTasks = tasks
        persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
            do {
                if let entityToUpdate = try context.fetch(fetchRequest).first {
                    entityToUpdate.completed = task.isDone
                    entityToUpdate.todo = task.description
                    entityToUpdate.createdAt = task.createdAt
                    try context.save()
                }
            } catch {
                print("Ошибка обновления задачи в Core Data: \(error)")
            }
            DispatchQueue.main.async {
                self.toDoPresenter?.didFetchTasks(self.filteredTasks)
            }
        }
    }
    
    func deleteTask(task: Task) {
        filteredTasks.removeAll { $0.id == task.id }
        tasks.removeAll { $0.id == task.id }
        persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
            do {
                if let entityToDelete = try context.fetch(fetchRequest).first {
                    context.delete(entityToDelete)
                    try context.save()
                }
            } catch {
                print("Ошибка при удалении задачи из Core Data: \(error)")
            }
            DispatchQueue.main.async {
                self.toDoPresenter?.didFetchTasks(self.filteredTasks)
            }
        }
    }
    
    func addNewTask(_ task: Task) {
        tasks.insert(task, at: 0)
        filteredTasks = tasks
        persistentContainer.performBackgroundTask { context in
            let entity = TaskEntity(context: context)
            entity.id = Int32(task.id)
            entity.todo = task.description
            entity.completed = task.isDone
            entity.createdAt = task.createdAt
            do {
                try context.save()
            } catch {
                print("Ошибка при добавлении задачи в Core Data: \(error)")
            }
            DispatchQueue.main.async {
                self.toDoPresenter?.didFetchTasks(self.filteredTasks)
            }
        }
    }
    
    func searchTasks(query: String) {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()

        if !query.isEmpty {
            request.predicate = NSPredicate(format: "todo CONTAINS[cd] %@ OR title CONTAINS[cd] %@", query, query)
        }
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        do {
            let taskEntities = try persistentContainer.viewContext.fetch(request)
            let tasks = taskEntities.map { Task(from: $0) }
            filteredTasks = tasks
            DispatchQueue.main.async {
                self.toDoPresenter?.didFetchTasks(tasks)
            }
        } catch {
            print("Ошибка поиска задач:", error)
            DispatchQueue.main.async {
                self.filteredTasks = []
                self.toDoPresenter?.didFetchTasks([])
            }
        }
    }
}
