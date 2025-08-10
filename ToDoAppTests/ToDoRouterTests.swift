//
//  ToDoRouterTests.swift
//  ToDoAppTests
//
//  Created by Александра Коснырева on 10.08.2025.
//

import XCTest
@testable import ToDoApp

class MockNavigationController: UINavigationController {
    var pushedViewController: UIViewController?
    var pushAnimated: Bool?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        pushAnimated = animated
    }
}

class MockViewController: UIViewController {
    var mockNavigationController = MockNavigationController()
    override var navigationController: UINavigationController? {
        return mockNavigationController
    }
}

final class ToDoRouterTests: XCTestCase {
    var router: ToDoRouter!
    var mockViewController: MockViewController!
    
    override func setUp() {
        super.setUp()
        router = ToDoRouter()
        mockViewController = MockViewController()
    }
    
    func testShowCreateNewTaskScreenPushesCreateTaskViewController() {
        router.showCreateNewTaskScreen(from: mockViewController)
        let pushedVC = mockViewController.mockNavigationController.pushedViewController
        XCTAssertNotNil(pushedVC)
        XCTAssertTrue(pushedVC is CreateTaskViewController)
        XCTAssertEqual(mockViewController.mockNavigationController.pushAnimated, false)
    }
    
    func testShowEditTaskScreenPushesEditTaskViewControllerWithCorrectData() {
        let testTask = Task(id: 1, description: "Test", isDone: false, createdAt: Date(), title: "Test Task")
        var didCallOnTaskUpdated = false
        let onTaskUpdatedClosure = {
            didCallOnTaskUpdated = true
        }
        router.showEditTaskScreen(from: mockViewController, task: testTask, onTaskUpdated: onTaskUpdatedClosure)
        guard let pushedVC = mockViewController.mockNavigationController.pushedViewController as? EditTaskViewController else {
            XCTFail("Expected EditTaskViewController to be pushed")
            return
        }
        XCTAssertEqual(pushedVC.task?.id, testTask.id)
        XCTAssertEqual(pushedVC.task?.title, testTask.title)
        XCTAssertNotNil(pushedVC.onTaskUpdated)
        pushedVC.onTaskUpdated?()
        XCTAssertTrue(didCallOnTaskUpdated)
        XCTAssertEqual(mockViewController.mockNavigationController.pushAnimated, false)
        XCTAssertEqual(pushedVC.modalPresentationStyle, .fullScreen)
    }
}
