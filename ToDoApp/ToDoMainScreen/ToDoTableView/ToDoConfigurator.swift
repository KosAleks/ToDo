//
//  Configurator.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 29.07.2025.
//

import Foundation

protocol ToDoConfiguratorProtocol: AnyObject {
    func configue(whith viewController: ToDoViewController)
}

class ToDoConfigurator: ToDoConfiguratorProtocol {
    func configue(whith viewController: ToDoViewController) {
        let interactor = ToDoInteractor()
        let presenter = ToDoPresenter(view: viewController, interactor: interactor)
        viewController.toDoPresenter = presenter
        interactor.toDoPresenter = presenter
    }
}
