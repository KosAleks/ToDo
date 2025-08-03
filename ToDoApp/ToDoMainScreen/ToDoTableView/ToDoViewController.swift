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

struct Task {
    var title: String
    var description: String
    var isDone: Bool
}

class ToDoViewController: UIViewController, ToDoViewProtocol, UITableViewDelegate {
    //моковый список
    var tasks: [Task] = [
        Task(title: "Купить молоко", description: "Обезжиренное, 1 литр", isDone: false),
        Task(title: "Позвонить маме", description: "Уточнить насчёт выходных", isDone: true),
        Task(title: "Сделать зарядку", description: "10 минут йоги", isDone: false),
        Task(title: "Купить молоко", description: "Обезжиренное, 1 литр", isDone: false),
        Task(title: "Позвонить маме", description: "Уточнить насчёт выходных", isDone: true),
        Task(title: "Сделать зарядку", description: "10 минут йоги", isDone: false),
        Task(title: "Купить молоко", description: "Обезжиренное, 1 литр", isDone: false),
        Task(title: "Позвонить маме", description: "Уточнить насчёт выходных", isDone: true),
        Task(title: "Сделать зарядку", description: "10 минут йоги", isDone: false),
        Task(title: "Купить молоко", description: "Обезжиренное, 1 литр", isDone: false),
        Task(title: "Позвонить маме", description: "Уточнить насчёт выходных", isDone: true),
        Task(title: "Сделать зарядку", description: "10 минут йоги", isDone: false)
    ]
    
    var toDoPresenter: ToDoPresenterProtocol?
    var configurator: ToDoConfiguratorProtocol?
    private let tableViewCreator = ToDoTableViewCreator()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        //  configurator?.configure(whith: self)
        // toDoPresenter?.configueView()
        
        tableViewCreator.createToDoTableView(in: self)
        tableViewCreator.toDoTableView.delegate = self
        tableViewCreator.toDoTableView.dataSource = self
        tableViewCreator.toDoTableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.reuseIdentifier)
        setupNavigation()
    }
    
    private func setupNavigation() {
        self.navigationItem.title = "Задачи"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension ToDoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.reuseIdentifier, for: indexPath) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        let task = tasks[indexPath.row]
        cell.configure(title: task.title  , description: task.description, done: task.isDone)
        
        cell.toggleCompletion = { [weak self] in
            guard let self = self else { return }
            self.tasks[indexPath.row].isDone.toggle()
        }
        return cell
    }
}


