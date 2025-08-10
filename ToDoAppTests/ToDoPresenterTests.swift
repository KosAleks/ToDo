//
//  ToDoPresenterTests.swift
//  ToDoAppTests
//
//  Created by Александра Коснырева on 08.08.2025.
//

import XCTest
@testable import ToDoApp

class MockToDoView: UIViewController, ToDoViewProtocol {
    var toDoPresenter: ToDoPresenterProtocol?
    var displayedTasks: [Task] = []
    var updateTaskCountCalled = false
    
    func displayTasks(_ tasks: [Task]) {
        displayedTasks = tasks
    }
    
    func updateTaskCount() {
        updateTaskCountCalled = true
    }
}

class MockToDoInteractor: ToDoInteractorProtocol {
    weak var toDoPresenter: TodoInteractorOutPutProtocol?
    
    var tasks: [Task] = []
    var filteredTasks: [Task] = []
    
    var fetchTodosCalled = false
    var updateTaskCalledWith: (task: Task, index: Int)?
    var searchTasksCalledWith: String?
    var deleteTaskCalledWith: Task?
    
    func fetchTodos() {
        fetchTodosCalled = true
    }
    
    func updateTask(_ task: Task, at index: Int) {
        updateTaskCalledWith = (task, index)
        filteredTasks[index] = task
    }
    
    func searchTasks(query: String) {
        searchTasksCalledWith = query
        
        if query.isEmpty {
            filteredTasks = tasks
        } else {
            filteredTasks = tasks.filter { task in
                ((task.title?.lowercased().contains(query.lowercased())) != nil) ||
                (task.description?.lowercased().contains(query.lowercased()) ?? false)
            }
        }
        
        DispatchQueue.main.async {
            self.toDoPresenter?.didFetchTasks(self.filteredTasks)
        }
    }
    
    func filterTasks(with query: String) {
    }
    
    func deleteTask(task: Task) {
        deleteTaskCalledWith = task
        filteredTasks.removeAll { $0.id == task.id }
        tasks.removeAll { $0.id == task.id }
    }
}

class MockToDoRouter: ToDoRouterProtocol {
    var showCreateNewTaskScreenCalled = false
    var showEditTaskScreenCalled = false
    var editedTask: Task?
    var onTaskUpdatedClosure: (() -> Void)?

    func showCreateNewTaskScreen(from viewController: UIViewController) {
        showCreateNewTaskScreenCalled = true
    }

    func showEditTaskScreen(from viewController: UIViewController, task: Task, onTaskUpdated: @escaping () -> Void) {
        showEditTaskScreenCalled = true
        editedTask = task
        onTaskUpdatedClosure = onTaskUpdated
    }
}

final class ToDoPresenterTests: XCTestCase {
    
    var presenter: ToDoPresenter!
    var mockView: MockToDoView!
    var mockInteractor: MockToDoInteractor!
    var mockRouter: MockToDoRouter!
    
    override func setUp() {
        super.setUp()
        
        mockView = MockToDoView()
        mockInteractor = MockToDoInteractor()
        mockRouter = MockToDoRouter()
        
        mockInteractor.filteredTasks = [
            Task(id: 1, description: "Task 1", isDone: false, createdAt: Date(), title: "Task1"),
            Task(id: 2, description: "Task 2", isDone: true, createdAt: Date(), title: "Task2"),
            Task(id: 3, description: "Task 3", isDone: false, createdAt: Date(), title: "Task3")
        ]
        presenter = ToDoPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
    }
    
    func testConfigueViewCallsFetchTodos() {
        presenter.configueView()
        XCTAssertTrue(mockInteractor.fetchTodosCalled)
    }
    
    func testToggleTaskDoneTogglesIsDoneAndCallsUpdateTask() {
        presenter.toggleTaskDone(at: 0)
        
        XCTAssertNotNil(mockInteractor.updateTaskCalledWith)
        XCTAssertEqual(mockInteractor.updateTaskCalledWith?.index, 0)
        XCTAssertEqual(mockInteractor.updateTaskCalledWith?.task.id, 1)
        XCTAssertTrue(mockInteractor.updateTaskCalledWith!.task.isDone)
    }
    
    func testDidSelectTaskForEditingCallsRouterAndUpdatesView() {
        let taskToEdit = mockInteractor.filteredTasks[0]
        
        presenter.didSelectTaskForEditing(taskToEdit)
        
        XCTAssertTrue(mockRouter.showEditTaskScreenCalled)
        XCTAssertEqual(mockRouter.editedTask?.id, taskToEdit.id)
        
        mockRouter.onTaskUpdatedClosure?()
        
        XCTAssertEqual(mockView.displayedTasks.count, mockInteractor.filteredTasks.count)
        XCTAssertTrue(mockView.updateTaskCountCalled)
    }

}
