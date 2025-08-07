//
//  EditTaskPresenter.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 07.08.2025.
//

import Foundation
import UIKit

protocol EditTaskPresenterProtocol: AnyObject {
    func viewDidLoad()
    func saveTask(title: String, description: String, date: Date)
}

final class EditTaskPresenter: EditTaskPresenterProtocol {
//    weak var view: EditTaskViewProtocol?
//    private let task: Task
//    private let interactor: EditTaskInteractorProtocol
    
//    init(view: EditTaskViewProtocol, task: Task, interactor: EditTaskInteractorProtocol) {
//        self.view = view
//        self.task = task
//        self.interactor = interactor
//    }
//    
    func viewDidLoad() {
        //    TODO: func to showData
    }
    
    func saveTask(title: String, description: String, date: Date) {
        
        print("")
        
    }
}
