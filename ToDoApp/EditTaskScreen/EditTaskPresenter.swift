//
//  EditTaskPresenter.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 07.08.2025.
//

import Foundation
import UIKit

protocol EditTaskPresenterProtocol: AnyObject {
    func saveTaskChanges(title: String?, id: Int32, todo: String?, date: Date?, completion: @escaping () -> Void)
}

final class EditTaskPresenter: EditTaskPresenterProtocol {
    private weak var view: EditTaskViewProtocol?
    private let interactor: EditTaskInteractorProtocol
    
    init(view: EditTaskViewProtocol, interactor: EditTaskInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
    
    func saveTaskChanges(
        title: String?,
        id: Int32,
        todo: String?,
        date: Date?,
        completion: @escaping () -> Void
    ) {
        guard let title = title, !title.isEmpty else {
            view?.showError("Заголовок не может быть пустым")
            return
        }
        guard let todo = todo, !todo.isEmpty else {
            view?.showError("Описание не может быть пустым")
            return
        }
        interactor.saveTask(
            title: title,
            id: id,
            todo: todo,
            date: date,
            completion: completion
        )
    }
}

