//
//  ViewController.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 29.07.2025.
//

import UIKit

protocol ToDoViewProtocol: AnyObject {
    var toDoPresenter: ToDoPresenterProtocol? {get set}
    func displayTasks(_ tasks: [Task])
    func updateTaskCount() 
}

class ToDoViewController: UIViewController, ToDoViewProtocol, UITableViewDelegate, UISearchResultsUpdating {
    var toDoPresenter: ToDoPresenterProtocol?
    private let tableViewCreator = ToDoTableViewCreator()
    private var searchController = UISearchController()
    private var tasks: [Task] = []
    private var panelCreator: PanelCreator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        toDoPresenter?.configueView()
        tableViewCreator.createToDoTableView(in: self)
        tableViewCreator.toDoTableView.delegate = self
        tableViewCreator.toDoTableView.dataSource = self
        tableViewCreator.toDoTableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.reuseIdentifier)
        setupNavigation()
        setupSearchController()
    }
    
    private func setupNavigation() {
        self.navigationItem.title = "Задачи"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchTextField.backgroundColor = UIColor(named: "darkGrayColor")
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 17)
            ])
    }
    
    func setPanelCreator(_ creator: PanelCreator) {
        self.panelCreator = creator
        panelCreator?.setupBottomPanel(with: self)
    }
    
    func displayTasks(_ tasks: [Task]) { 
        self.tasks = tasks
        tableViewCreator.toDoTableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        toDoPresenter?.didUpdateSearchText(text)
    }
    
    var isFiltering: Bool {
        searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
}

extension ToDoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toDoPresenter?.numberOfTasks() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.reuseIdentifier, for: indexPath) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        let task = toDoPresenter?.task(at: indexPath.row)
        cell.configure(title: task?.description ?? "no title", description: task?.description ?? "no description", done: task?.isDone ?? false)
        
        cell.toggleCompletion = { [weak self] in
            guard let self = self else { return }
            toDoPresenter?.toggleTaskDone(at: indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = .zero
        }
    }
}

extension ToDoViewController {
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        
        let task = tasks[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let edit = UIAction(title: "Редактировать", image: UIImage(named: "editIcon")) { _ in
                self.editTask(task: task)
            }
            
            let lock = UIAction(title: "Поделиться", image: UIImage(named: "shareIcon")) { _ in
                self.shareTask(task: task)
            }
            
            let delete = UIAction(title: "Удалить", image: UIImage(named: "trashIcon"), attributes: .destructive) { _ in
                self.deleteTask(task: task)
            }
            
            return UIMenu(title: "", children: [edit, lock, delete])
        }
    }
    
    func editTask(task: Task) {
        print("edit")
    }
    
    func shareTask(task: Task) {
        print("share")
    }
    
    func deleteTask(task: Task) {
        toDoPresenter?.deleteTask(task)
    }
}

extension ToDoViewController {
    func updateTaskCount() {
        let count = toDoPresenter?.numberOfTasks() ?? 0
        panelCreator?.todoCountLabel.text = "\(count) задач" 
    }
}
