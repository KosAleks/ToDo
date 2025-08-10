//
//  ToDoPresenter.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 31.07.2025.
//

import Foundation
import ProgressHUD
import UIKit

protocol ToDoPresenterProtocol: AnyObject {
    var toDoInteractor: ToDoInteractorProtocol {get}
    var toDoRouter: ToDoRouterProtocol {get}
    func configueView()
    func numberOfTasks() -> Int
    func task(at index: Int) -> Task
    func toggleTaskDone(at index: Int)
    func didUpdateSearchText(_ text: String)
    func deleteTask(_ task: Task)
    func didSelectTaskForEditing(_ task: Task)
}

class ToDoPresenter: ToDoPresenterProtocol {
    weak var view: ToDoViewProtocol?
    var toDoInteractor: ToDoInteractorProtocol
    var filteredTasks: [Task] = []
    var toDoRouter: ToDoRouterProtocol
    
    required init(view: ToDoViewProtocol, interactor: ToDoInteractorProtocol, router: ToDoRouterProtocol) {
        self.view = view
        self.toDoInteractor = interactor
        self.toDoRouter = router
    }
    
    func configueView() {
        UIBlockingProgressHUD.show()
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
        toDoInteractor.updateTask(task, at: index)
    }
    
    func didUpdateSearchText(_ text: String) {
        toDoInteractor.filterTasks(with: text)
    }
    
    func deleteTask(_ task: Task) {
        toDoInteractor.deleteTask(task: task)
    }
    
    func didSelectTaskForEditing(_ task: Task) {
        guard let view = view as? UIViewController else { return }
        toDoRouter.showEditTaskScreen(from: view, task: task) { [weak self] in
            self?.view?.displayTasks(self?.toDoInteractor.filteredTasks ?? [])
            self?.configueView()
            self?.view?.updateTaskCount()
        }
    }
}

extension ToDoPresenter: TodoInteractorOutPutProtocol {
    func didFetchTasks(_ tasks: [Task]) {
        DispatchQueue.main.async { [weak self] in
            UIBlockingProgressHUD.dismiss()
            self?.view?.displayTasks(tasks)
            self?.view?.updateTaskCount()
        }
    }
}






