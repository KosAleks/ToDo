//
//  ToDoRouter.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 06.08.2025.
//

import Foundation
import UIKit

protocol ToDoRouterProtocol: AnyObject {
    func showCreateNewTaskScreen(from viewController: UIViewController)
    func showEditTaskScreen(from viewController: UIViewController, task: Task)
}

class ToDoRouter: ToDoRouterProtocol {
    weak var viewController: UIViewController?
    
    func showCreateNewTaskScreen(from viewController: UIViewController) {
        let createNewTaskVC = CreateTaskViewController()
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .moveIn
        transition.subtype = .fromRight
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        viewController.navigationController?.view.layer.add(transition, forKey: kCATransition)
        viewController.navigationController?.pushViewController(createNewTaskVC, animated: false)
    }
    
    func showEditTaskScreen(from viewController: UIViewController, task: Task) {
        let editTaskVC = EditTaskViewController()
        let presenter = EditTaskPresenter()
        editTaskVC.presenter = presenter
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .moveIn
        transition.subtype = .fromTop
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        viewController.navigationController?.view.layer.add(transition, forKey: kCATransition)
        viewController.navigationController?.pushViewController(editTaskVC, animated: false)
    }
    
}
