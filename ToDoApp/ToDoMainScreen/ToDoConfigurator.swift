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

class ToDoConfigurator: ToDoConfiguratorProtocol {
    private let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func configue(whith viewController: ToDoViewController) {
        let interactor = ToDoInteractor(toDoService: TodoService(), persistentContainer: persistentContainer)
        let presenter = ToDoPresenter(view: viewController, interactor: interactor)
        let router = ToDoRouter()
        viewController.toDoPresenter = presenter
        interactor.toDoPresenter = presenter
        router.viewController = viewController
        let panelCreator = PanelCreator(toDoRouter: router, toDoViewController: viewController)
        viewController.setPanelCreator(panelCreator)
    }
}
