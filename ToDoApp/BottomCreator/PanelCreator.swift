//
//  PanelCreator.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 06.08.2025.
//

import Foundation
import UIKit

final class PanelCreator {
    weak var toDoViewController: UIViewController?
    var toDoRouter: ToDoRouterProtocol
    
    init(toDoRouter: ToDoRouterProtocol, toDoViewController: UIViewController) {
        self.toDoRouter = toDoRouter
        self.toDoViewController = toDoViewController
    }
    
    let bottomPanel: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "darkGrayColor")
        return view
    }()
    
    let todoCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    let addNewTodoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.imageView?.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        return button
    }()
    
    func setupBottomPanel(with viewController: UIViewController) {
        setupconstraints(with: viewController)
        addNewTodoButton.setImage(UIImage(named: "AddToDo"), for: .normal)
        addNewTodoButton.addTarget(self, action: #selector(addNewTodo), for: .touchUpInside)
        updateTaskCountLabel()
    }
    
    private func setupconstraints(with viewController: UIViewController) {
        [bottomPanel, todoCountLabel, addNewTodoButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        [todoCountLabel, addNewTodoButton].forEach { bottomPanel.addSubview($0) }
        viewController.view.addSubview(bottomPanel)
        
        NSLayoutConstraint.activate([
            todoCountLabel.centerXAnchor.constraint(equalTo: bottomPanel.centerXAnchor),
            todoCountLabel.topAnchor.constraint(equalTo: bottomPanel.topAnchor, constant:  20.5),
            todoCountLabel.heightAnchor.constraint(equalToConstant: 13),
            
            
            addNewTodoButton.trailingAnchor.constraint(equalTo: bottomPanel.trailingAnchor),
            addNewTodoButton.topAnchor.constraint(equalTo: bottomPanel.topAnchor, constant: 5),
            addNewTodoButton.heightAnchor.constraint(equalToConstant: 44),
            addNewTodoButton.widthAnchor.constraint(equalToConstant: 68),
            
            bottomPanel.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            bottomPanel.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            bottomPanel.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            bottomPanel.heightAnchor.constraint(equalToConstant: 83)
        ])
    }
    
    @objc func addNewTodo() {
        guard let toDoViewController = toDoViewController else { return }
        toDoRouter.showNewScreen(from: toDoViewController)
    }
    
    func updateTaskCountLabel() {
        (toDoViewController as? ToDoViewController)?.updateTaskCount()
    }
}
