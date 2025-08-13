//
//  Configurator.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 29.07.2025.
//

import Foundation
import CoreData

protocol ToDoConfiguratorProtocol: AnyObject {
    func configue(whith viewController: ToDoViewController)
}

final class ToDoConfigurator: ToDoConfiguratorProtocol {
    private let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func configue(whith viewController: ToDoViewController) {
        let interactor = ToDoInteractor(toDoService: TodoService(), persistentContainer: persistentContainer)
        let router = ToDoRouter()
        let presenter = ToDoPresenter(view: viewController, interactor: interactor, router: router)
        viewController.toDoPresenter = presenter
        interactor.toDoPresenter = presenter
        router.viewController = viewController
    }
}
