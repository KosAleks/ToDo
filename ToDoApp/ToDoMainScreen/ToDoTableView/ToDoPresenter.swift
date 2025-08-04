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
    func didFilterTasks()
}

class ToDoPresenter: ToDoPresenterProtocol {
    weak var view: ToDoViewProtocol?
    var toDoInteractor: ToDoInteractorProtocol
    private var tasks: [Task] = []
    
    required init(view: ToDoViewProtocol, interactor: ToDoInteractorProtocol) {
        self.view = view
        self.toDoInteractor = interactor
    }
    
    func configueView() {
        toDoInteractor.fetchTasks()
    }
    
    func numberOfTasks() -> Int {
        return toDoInteractor.filteredTasks.count
    }
    
    func task(at index: Int) -> Task {
        return toDoInteractor.filteredTasks[index]
    }
    
    func toggleTaskDone(at index: Int) {
        guard tasks.indices.contains(index) else {return}
        var task = tasks[index]
        task.isDone.toggle()
        toDoInteractor.updateTask(task, at: index)
    }
    
    func didUpdateSearchText(_ text: String) {
        toDoInteractor.filterTasks(with: text)
    }
    
    func didFilterTasks() {
        view?.showTask()
    }
}

extension ToDoPresenter: TodoInteractorOutPutProtocol {
    func didFetchTasks(_ tasks: [Task]) {
        self.tasks = tasks
        view?.showTask()
    }
}
