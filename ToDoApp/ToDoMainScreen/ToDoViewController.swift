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
    private var searchController = UISearchController()
    private var tasks: [Task] = []
    
    let taskCountLabel: UILabel = {
        let taskCountLabel = UILabel()
        taskCountLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        taskCountLabel.textColor = .white
        taskCountLabel.numberOfLines = 1
        taskCountLabel.sizeThatFits(CGSize(width: 44.0, height: 13.0))
        return taskCountLabel
    }()
    
    let toDoTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        tableView.backgroundColor = .black
        return tableView
    }()
    
    let addNewTodoButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.setImage(UIImage(named: "AddToDo"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        toDoPresenter?.configueView()
        setupNavigation()
        createToDoTableView()
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
        toDoTableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.reuseIdentifier)
        setupSearchController()
        setupToolbar()
        addNewTodoButton.addTarget(self, action: #selector(addNewTodo), for: .touchUpInside)
        navigationItem.backButtonTitle = "Назад"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    private func setupToolbar() {
        let centerLabelItem = UIBarButtonItem(customView: taskCountLabel)
        let buttonItem = UIBarButtonItem(customView: addNewTodoButton)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [flexibleSpace, centerLabelItem, flexibleSpace, buttonItem]
        if let toolbar = navigationController?.toolbar {
            toolbar.barTintColor = UIColor(named: "darkGrayColor")
            toolbar.tintColor = .white
            toolbar.isTranslucent = false
        }
        updateTaskCount()
    }
    
    private func setupNavigation() {
        title = "Задачи"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesSearchBarWhenScrolling = false
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.prefersLargeTitles = true
        navBar.isTranslucent = false
        navBar.tintColor = .systemYellow
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
        searchController.searchBar.backgroundColor = .black
    }
    
    func createToDoTableView() {
        toDoTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toDoTableView)
        NSLayoutConstraint.activate([
            toDoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toDoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toDoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toDoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func displayTasks(_ tasks: [Task]) {
        self.tasks = tasks
        toDoTableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        toDoPresenter?.didUpdateSearchText(text)
    }
    
    var isFiltering: Bool {
        searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    @objc private func addNewTodo() {
        toDoPresenter?.toDoRouter.showCreateNewTaskScreen(from: self)
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
        toDoPresenter?.toDoRouter.showEditTaskScreen(from: self, task: task)
    }
    
    func shareTask(task: Task) {
        print("share")
    }
    
    func deleteTask(task: Task) {
        toDoPresenter?.deleteTask(task)
        updateTaskCount()
    }
}

extension ToDoViewController {
    func updateTaskCount() {
        let count = toDoPresenter?.numberOfTasks() ?? 0
        let countString = getTaskWord(for: count)
        taskCountLabel.text = getTaskWord(for: count)
    }
}
