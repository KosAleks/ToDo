//
//  ToDoRouter.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 06.08.2025.
//

import Foundation
import UIKit

protocol ToDoRouterProtocol: AnyObject {
    func showNewScreen(from viewController: UIViewController)
}

class ToDoRouter: ToDoRouterProtocol {
    weak var viewController: UIViewController?
    
    func showNewScreen(from viewController: UIViewController) {
        let createNewTaskVC = CreateNewTaskViewController()
        viewController.navigationController?.pushViewController(createNewTaskVC, animated: true)
    }
}
