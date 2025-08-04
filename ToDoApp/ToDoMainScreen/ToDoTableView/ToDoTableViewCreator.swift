//
//  ToDoTableViewCreator.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 01.08.2025.
//

import Foundation
import UIKit

protocol ToDoTableViewCreatorProtocol: AnyObject {
    func createToDoTableView(in viewController: UIViewController)
}

final class ToDoTableViewCreator: ToDoTableViewCreatorProtocol {
    weak var viewController: UIViewController?
    let toDoTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    func createToDoTableView(in viewController: UIViewController) {
        self.viewController = viewController
        guard let view = viewController.view else { return }
        toDoTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toDoTableView)
        
        NSLayoutConstraint.activate([
            toDoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toDoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toDoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //пока не создан футер на экране, низ привязан к safeArea
            toDoTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
