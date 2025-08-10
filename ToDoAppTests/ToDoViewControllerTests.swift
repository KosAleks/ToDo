//
//  ToDoViewControllerTests.swift
//  ToDoAppTests
//
//  Created by Александра Коснырева on 10.08.2025.
//

import XCTest
@testable import ToDoApp

class MockToDoPresenter: ToDoPresenterProtocol {
    var toDoInteractor: ToDoInteractorProtocol = MockToDoInteractor()
    var toDoRouter: ToDoRouterProtocol = MockToDoRouter()
    var configueViewCalled = false
    var numberOfTasksCalled = false
    var numberOfTasksReturn = 0
    var taskAtIndexCalledWith: Int?
    var taskAtIndexReturn: Task?
    var toggleTaskDoneCalledWithIndex: Int?
    var didSelectTaskForEditingCalledWith: Task?
    var deleteTaskCalledWith: Task?

    func didUpdateSearchText(_ text: String) {
    }
    
    func configueView() {
        configueViewCalled = true
    }
    
    func numberOfTasks() -> Int {
        numberOfTasksCalled = true
        return numberOfTasksReturn
    }
    
    func task(at index: Int) -> Task {
        taskAtIndexCalledWith = index
        return taskAtIndexReturn ?? Task(id: 1, description: "Task 1", isDone: false, createdAt: Date(), title: "Task1")
    }
    
    func toggleTaskDone(at index: Int) {
        toggleTaskDoneCalledWithIndex = index
    }
    
    func didSelectTaskForEditing(_ task: Task) {
        didSelectTaskForEditingCalledWith = task
    }
    
    func deleteTask(_ task: Task) {
        deleteTaskCalledWith = task
    }
}


final class ToDoViewControllerTests: XCTestCase {
    var sut: ToDoViewController!
    var mockPresenter: MockToDoPresenter!
    
    override func setUp() {
        super.setUp()
        sut = ToDoViewController()
        mockPresenter = MockToDoPresenter()
        sut.toDoPresenter = mockPresenter
        _ = sut.view
    }
    
    func testViewDidLoad_CallsConfigueView() {
        XCTAssertTrue(mockPresenter.configueViewCalled)
    }
    
    func testTableViewNumberOfRows_CallsPresenter() {
        mockPresenter.numberOfTasksReturn = 5
        let rows = sut.tableView(sut.toDoTableView, numberOfRowsInSection: 0)
        XCTAssertTrue(mockPresenter.numberOfTasksCalled)
        XCTAssertEqual(rows, 5)
    }
    
    func testTableViewCellForRow_ConfiguresCellAndSetsToggleClosure() {
        let task = Task(id: 1, description: "Description", isDone: false, createdAt: Date(), title: "Title")
        mockPresenter.taskAtIndexReturn = task
        let indexPath = IndexPath(row: 0, section: 0)
        sut.toDoTableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.reuseIdentifier)
        let cell = sut.tableView(sut.toDoTableView, cellForRowAt: indexPath) as? ToDoTableViewCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.titleLabel.text, task.title)
        XCTAssertEqual(cell?.descriptionLabel.text, task.description)
        XCTAssertNotNil(cell?.dateLabel.text)
        XCTAssertFalse(cell!.dateLabel.text!.isEmpty)
        cell?.toggleCompletion?()
        XCTAssertEqual(mockPresenter.toggleTaskDoneCalledWithIndex, 0)
    }

    func testUpdateTaskCount_UpdatesLabel() {
        mockPresenter.numberOfTasksReturn = 3
        sut.updateTaskCount()
        XCTAssertEqual(sut.taskCountLabel.text, getTaskWord(for: 3))
    }
    
    func testDisplayTasks_ReloadsTableView() {
        let expectation = expectation(description: "Reload data called")
        let dummyTasks = [
            Task(id: 1, description: "Task 1", isDone: false, createdAt: Date(), title: "Task1"),
            Task(id: 2, description: "Task 2", isDone: true, createdAt: Date(), title: "Task2"),
            Task(id: 3, description: "Task 3", isDone: false, createdAt: Date(), title: "Task3")
        ]
        mockPresenter.numberOfTasksReturn = dummyTasks.count
        sut.toDoTableView.dataSource = sut
        sut.displayTasks(dummyTasks)
        DispatchQueue.main.async {
            XCTAssertEqual(self.sut.toDoTableView.numberOfRows(inSection: 0), dummyTasks.count)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testSearchControllerCallsInteractorSearchTasks() {
        sut.searchController.searchBar.text = "search text"
        sut.updateSearchResults(for: sut.searchController)
        guard let mockInteractor = mockPresenter.toDoInteractor as? MockToDoInteractor else {
            XCTFail("toDoInteractor is not MockToDoInteractor")
            return
        }
        XCTAssertEqual(mockInteractor.searchTasksCalledWith, "search text")
    }
}
