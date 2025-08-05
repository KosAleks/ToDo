//
//  ToDoPresenter.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 31.07.2025.
//

import Foundation

protocol ToDoPresenterProtocol: AnyObject {
    func configueView()
    func numberOfTasks() -> Int
    func task(at index: Int) -> Task
    func toggleTaskDone(at index: Int)
    func didUpdateSearchText(_ text: String)
}

class ToDoPresenter: ToDoPresenterProtocol {
    weak var view: ToDoViewProtocol?
    var toDoInteractor: ToDoInteractorProtocol
    private var filteredTasks: [Task] = []
    
    required init(view: ToDoViewProtocol, interactor: ToDoInteractorProtocol) {
        self.view = view
        self.toDoInteractor = interactor
    }
    
    func configueView() {
        toDoInteractor.fetchTodos()
    }
    
    func numberOfTasks() -> Int {
        return toDoInteractor.filteredTasks.count
    }
    
    func task(at index: Int) -> Task {
        return toDoInteractor.filteredTasks[index]
    }
    
    func toggleTaskDone(at index: Int) {
        guard index < toDoInteractor.filteredTasks.count else { return }
        var task = toDoInteractor.filteredTasks[index]
        task.isDone.toggle()
        // Обновляем задачу в интеракторе (Core Data + локальный массив)
        toDoInteractor.updateTask(task, at: index)
    }
    
    func didUpdateSearchText(_ text: String) {
        toDoInteractor.filterTasks(with: text)
    }
}

extension ToDoPresenter: TodoInteractorOutPutProtocol {
    func didFetchTasks(_ tasks: [Task]) {
        // При обновлении данных из интерактора — обновляем вью
        DispatchQueue.main.async { [weak self] in
            self?.view?.displayTasks(tasks)
        }
    }
}

