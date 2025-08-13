//
//  ToDoRouter.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 06.08.2025.
//

import Foundation
import UIKit
import CoreData

protocol ToDoRouterProtocol: AnyObject {
    func showCreateNewTaskScreen(from viewController: UIViewController)
    func showEditTaskScreen(from viewController: UIViewController, task: Task, onTaskUpdated: @escaping () -> Void)
}

final class ToDoRouter: ToDoRouterProtocol {
    weak var viewController: UIViewController?
    func getContext() -> NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can't get AppDelegate")
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    
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
    
    func showEditTaskScreen(from viewController: UIViewController, task: Task, onTaskUpdated: @escaping () -> Void) {
        let interactor = EditTaskInteractor(context: getContext())
        let editTaskVC = EditTaskViewController()
        editTaskVC.modalPresentationStyle = .fullScreen
        editTaskVC.task = task
        let presenter = EditTaskPresenter(view: editTaskVC as! EditTaskViewProtocol, interactor: interactor)
        editTaskVC.presenter = presenter
        editTaskVC.onTaskUpdated = onTaskUpdated  
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .moveIn
        transition.subtype = .fromTop
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        viewController.navigationController?.view.layer.add(transition, forKey: kCATransition)
        viewController.navigationController?.pushViewController(editTaskVC, animated: false)
    }
}
