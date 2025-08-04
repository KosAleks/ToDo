//
//  ViewController.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 29.07.2025.
//

import UIKit

protocol ToDoViewProtocol: AnyObject {
    var toDoPresenter: ToDoPresenterProtocol? {get set}
    var configurator: ToDoConfiguratorProtocol? {get set}
    func showTask()
}

class ToDoViewController: UIViewController, ToDoViewProtocol, UITableViewDelegate, UISearchResultsUpdating {
    var toDoPresenter: ToDoPresenterProtocol?
    var configurator: ToDoConfiguratorProtocol? = ToDoConfigurator()
    private let tableViewCreator = ToDoTableViewCreator()
    private var searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configurator?.configue(whith: self)
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
        searchController.searchBar.tintColor = .gray
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.searchTextField.backgroundColor = UIColor(named: "darkGrayColor")
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                .foregroundColor: UIColor.darkGray,
                .font: UIFont.systemFont(ofSize: 17)
            ])
    }
    
    func showTask() {
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
        cell.configure(title: task?.title ?? "no title", description: task?.description ?? "no description", done: task?.isDone ?? false)
        
        cell.toggleCompletion = { [weak self] in
            guard let self = self else { return }
            toDoPresenter?.toggleTaskDone(at: indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }
}

