//
//  ViewController.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 29.07.2025.
//

import UIKit

protocol ToDoViewProtocol: AnyObject {
    var toDoPresenter: ToDoPresenterProtocol? {get}
    var configurator: ToDoConfiguratorProtocol? {get}
}

class ToDoViewController: UIViewController, ToDoViewProtocol {
    var toDoPresenter: ToDoPresenterProtocol?
    var configurator: ToDoConfiguratorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configurator?.configure(whith: self)
        toDoPresenter?.configueView()
        self.navigationItem.title = "Задачи"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

