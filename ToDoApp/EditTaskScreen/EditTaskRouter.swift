//
//  EditTaskRouter.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 07.08.2025.
//

import Foundation
import UIKit
import CoreData

protocol EditTaskRouterProtocol: AnyObject {
    func showEditTaskScreen(from viewController: UIViewController, task: Task)
}

class EditTaskRouter: EditTaskRouterProtocol {
    weak var viewController: UIViewController?
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func showEditTaskScreen(from viewController: UIViewController, task: Task) {
        let interactor = EditTaskInteractor(context: context)
        let editTaskVC = EditTaskViewController()
        let presenter = EditTaskPresenter(view: editTaskVC as! EditTaskViewProtocol, interactor: interactor)
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
