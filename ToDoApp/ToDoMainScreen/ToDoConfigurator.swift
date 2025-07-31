//
//  Configurator.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 29.07.2025.
//

import Foundation

protocol ToDoConfiguratorProtocol: AnyObject {
    func configure(whith viewController: ToDoViewController)
}

class ToDoConfigurator: ToDoConfiguratorProtocol {
    private let toDoViewController = ToDoViewController()
    
    func configure(whith viewController: ToDoViewController) {
       let presenter = ToDoPresenter(view: viewController)
        viewController.toDoPresenter = presenter
    }
    
}
