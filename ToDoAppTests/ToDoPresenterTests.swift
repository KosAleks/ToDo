//
//  ToDoPresenterTests.swift
//  ToDoAppTests
//
//  Created by Александра Коснырева on 08.08.2025.
//

import XCTest
@testable import ToDoApp

class MockToDoInteractor: ToDoInteractorProtocol {
    var fetchTodosCalled = false
    var filteredTasks: [Task] = []
    var updateTaskCalled = false
    var updatedTask: Task?
    var updatedIndex: Int?
    var filterTasksCalled = false
    var filterQuery: String?
    var deleteTaskCalled = false
    var deletedTask: Task?
    
    func fetchTodos() {
        fetchTodosCalled = true
    }
    
    func updateTask(_ task: Task, at index: Int) {
        updateTaskCalled = true
        updatedTask = task
        updatedIndex = index
    }
    
    func filterTasks(with query: String) {
        filterTasksCalled = true
        filterQuery = query
    }
    
    func deleteTask(task: Task) {
        deleteTaskCalled = true
        deletedTask = task
    }
}

class MockToDoView: ToDoViewProtocol {
    var toDoPresenter: ToDoApp.ToDoPresenterProtocol?
    
    func updateTaskCount() {
        <#code#>
    }
    
    var displayTasksCalled = false
    var displayedTasks: [Task] = []
    
    func displayTasks(_ tasks: [Task]) {
        displayTasksCalled = true
        displayedTasks = tasks
    }
}

final class ToDoPresenterTests: XCTestCase {
    var presenter: ToDoPresenter!
    var mockInteractor: MockToDoInteractor!
    var mockView: MockToDoView!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockToDoInteractor()
        mockView = MockToDoView()
        // Для роутера можно подставить заглушку, если надо
        let mockRouter = MockToDoRouter()
        
        presenter = ToDoPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
    }
    
    override func tearDown() {
        presenter = nil
        mockInteractor = nil
        mockView = nil
        super.tearDown()
    }
    
    func testConfigueView_callsFetchTodos() {
        presenter.configueView()
        XCTAssertTrue(mockInteractor.fetchTodosCalled)
    }
    
    func testNumberOfTasks_returnsFilteredTasksCount() {
        mockInteractor.filteredTasks = [
            Task(id: 1, description: "Test 1", isDone: false, createdAt: Date(), title: "Test1"),
            Task(id: 2, description: "Test 2", isDone: false, createdAt: Date(), title: "Test2")
        ]
        XCTAssertEqual(presenter.numberOfTasks(), 2)
    }
    
    func testTaskAtIndex_returnsCorrectTask() {
        let task = Task(id: 1, description: "Test", isDone: false, createdAt: Date(), title: "Test")
        mockInteractor.filteredTasks = [task]
        let returnedTask = presenter.task(at: 0)
        XCTAssertEqual(returnedTask.id, task.id)
    }
    
    func testToggleTaskDone_updatesTask() {
        let task = Task(id: 1, description: "Test", isDone: false, createdAt: Date(), title: "Test")
        mockInteractor.filteredTasks = [task]
        
        presenter.toggleTaskDone(at: 0)
        
        XCTAssertTrue(mockInteractor.updateTaskCalled)
        XCTAssertEqual(mockInteractor.updatedTask?.id, task.id)
        XCTAssertEqual(mockInteractor.updatedTask?.isDone, true)
    }
    
    func testDidUpdateSearchText_callsFilterTasks() {
        presenter.didUpdateSearchText("query")
        XCTAssertTrue(mockInteractor.filterTasksCalled)
        XCTAssertEqual(mockInteractor.filterQuery, "query")
    }
    
    func testDeleteTask_callsDeleteTask() {
        let task = Task(id: 1, description: "Test", isDone: false, createdAt: Date(), title: "Test")
        presenter.deleteTask(task)
        XCTAssertTrue(mockInteractor.deleteTaskCalled)
        XCTAssertEqual(mockInteractor.deletedTask?.id, task.id)
    }
    
    func testDidFetchTasks_callsViewDisplayTasks() {
        let tasks = [Task(id: 1, description: "Test", isDone: false, createdAt: Date(), title: "Test")]
        presenter.didFetchTasks(tasks)
        XCTAssertTrue(mockView.displayTasksCalled)
        XCTAssertEqual(mockView.displayedTasks.count, 1)
    }
}

// Заглушка роутера для компиляции (можешь расширить)
class MockToDoRouter: ToDoRouterProtocol {
    func showCreateNewTaskScreen(from viewController: UIViewController) {
        <#code#>
    }
    
    func showEditTaskScreen(from viewController: UIViewController, task: ToDoApp.Task, onTaskUpdated: @escaping () -> Void) {
        <#code#>
    }
    
    // Реализуй методы роутера по необходимости
}
