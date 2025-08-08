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
    func deleteTask(task: Task)
    var filteredTasks: [Task] { get }
    func filterTasks(with query: String)
}

protocol TodoInteractorOutPutProtocol: AnyObject {
    func didFetchTasks(_ tasks: [Task])
}

class ToDoInteractor: ToDoInteractorProtocol {
    weak var toDoPresenter: TodoInteractorOutPutProtocol?
    var toDoService: TodoServiceProtocol
    let persistentContainer: NSPersistentContainer
    var tasks: [Task] = []
    var filteredTasks: [Task] = []
    
    init(toDoService: TodoServiceProtocol, persistentContainer: NSPersistentContainer) {
        self.toDoService = toDoService
        self.persistentContainer = persistentContainer
    }
    
    func fetchTodos() {
        loadTasksFromCoreData()
        if tasks.isEmpty {
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
            taskEntity.createdAt = Date()
        }
        do {
            try context.save()
            loadTasksFromCoreData()
            toDoPresenter?.didFetchTasks(filteredTasks)
        } catch {
            print("Ошибка при сохранении в Core Data: \(error)")
            toDoPresenter?.didFetchTasks([])
        }
    }
    
    func updateTask(_ task: Task, at index: Int) {
        guard tasks.indices.contains(index) else { return }
        tasks[index] = task
        filteredTasks = tasks
        updateTaskInCoreData(task)
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
    
    func deleteTask(task: Task) {
        filteredTasks.removeAll { $0.id == task.id }
        tasks.removeAll { $0.id == task.id }
        let context = persistentContainer.viewContext
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
        toDoPresenter?.didFetchTasks(filteredTasks)
    }
}

extension ToDoInteractor {
    func addNewTask(_ task: Task) {
        tasks.insert(task, at: 0)
        filteredTasks = tasks
        let context = persistentContainer.viewContext
        let entity = TaskEntity(context: context)
        entity.id = Int32(task.id)
        entity.todo = task.description
        entity.completed = task.isDone
        entity.createdAt = task.createdAt
        do {
            try context.save()
            toDoPresenter?.didFetchTasks(filteredTasks)
        } catch {
            print("Ошибка при добавлении задачи в Core Data: \(error)")
        }
    }

}
