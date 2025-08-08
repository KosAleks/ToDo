//
//  ToDoAppTests.swift
//  ToDoAppTests
//
//  Created by Александра Коснырева on 29.07.2025.
//
import XCTest
@testable import ToDoApp
import CoreData

class MockTodoService: TodoServiceProtocol {
    var fetchTodosCalled = false
    var resultToReturn: Result<[TodoDTO], Error>?
    
    func fetchTodos(completion: @escaping (Result<[TodoDTO], Error>) -> Void) {
        fetchTodosCalled = true
        if let result = resultToReturn {
            completion(result)
        }
    }
}

class MockPresenter: TodoInteractorOutPutProtocol {
    var didFetchTasksCalled = false
    var receivedTasks: [Task] = []
    
    func didFetchTasks(_ tasks: [Task]) {
        didFetchTasksCalled = true
        receivedTasks = tasks
    }
}

final class ToDoInteractorTests: XCTestCase {
    
    var interactor: ToDoInteractor!
    var mockService: MockTodoService!
    var mockPresenter: MockPresenter!
    var persistentContainer: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()
        
        persistentContainer = {
            let container = NSPersistentContainer(name: "ToDoApp")
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { (desc, error) in
                if let error = error {
                    fatalError("Ошибка загрузки Core Data: \(error)")
                }
            }
            return container
        }()
        
        mockService = MockTodoService()
        mockPresenter = MockPresenter()
        interactor = ToDoInteractor(toDoService: mockService, persistentContainer: persistentContainer)
        interactor.toDoPresenter = mockPresenter
    }
    
    override func tearDown() {
        interactor = nil
        mockService = nil
        mockPresenter = nil
        persistentContainer = nil
        super.tearDown()
    }
    
    func testFetchTodos_whenCoreDataEmpty_callsNetworkAndUpdatesPresenter() {
        
        let todoDTO = TodoDTO(id: 1, todo: "Test task", completed: false)
        mockService.resultToReturn = .success([todoDTO])
        
        interactor.fetchTodos()
        
        let expectation = expectation(description: "Wait for fetchTodos completion")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockService.fetchTodosCalled)
            XCTAssertTrue(self.mockPresenter.didFetchTasksCalled)
            XCTAssertEqual(self.mockPresenter.receivedTasks.count, 1)
            XCTAssertEqual(self.mockPresenter.receivedTasks.first?.description, "Test task")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testUpdateTask_updatesTaskAndCallsPresenter() {
        let context = persistentContainer.viewContext
        let entity = TaskEntity(context: context)
        entity.id = 1
        entity.todo = "Old task"
        entity.completed = false
        entity.createdAt = Date()
        entity.title = "Old title"
        try? context.save()
        
        interactor.fetchTodos()
        
        let updatedTask = Task(id: 1, description: "Updated task", isDone: true, createdAt: Date(), title: "Updated title")
        interactor.updateTask(updatedTask, at: 0)
        
        XCTAssertTrue(mockPresenter.didFetchTasksCalled)
        XCTAssertEqual(interactor.filteredTasks.first?.description, "Updated task")
        XCTAssertEqual(interactor.filteredTasks.first?.isDone, true)
    }
    
    func testDeleteTask_removesTaskAndCallsPresenter() throws {
        let context = persistentContainer.viewContext
        let entity = TaskEntity(context: context)
        entity.id = 1
        entity.todo = "Task to delete"
        entity.completed = false
        entity.createdAt = Date()
        entity.title = "Title to delete"
        try context.save()
        interactor.fetchTodos()
        
        XCTAssertEqual(interactor.filteredTasks.count, 1)
        
        let taskToDelete = Task(id: 1, description: "Task to delete", isDone: false, createdAt: Date(), title: "title to delete")
        
        interactor.deleteTask(task: taskToDelete)
        
        XCTAssertFalse(interactor.filteredTasks.contains { $0.id == 1 })
        XCTAssertFalse(interactor.filteredTasks.isEmpty == false)
        XCTAssertTrue(mockPresenter.didFetchTasksCalled)
        
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", 1)
        let results = try context.fetch(fetchRequest)
        XCTAssertTrue(results.isEmpty)
    }
    
    func testFilterTasks_filtersTasksAndCallsPresenter() {
        let task1 = Task(id: 1, description: "Buy milk", isDone: false, createdAt: Date(), title: "Milk")
        let task2 = Task(id: 2, description: "Call mom", isDone: false, createdAt: Date(), title: "Mom")
        let task3 = Task(id: 3, description: "Buy bread", isDone: true, createdAt: Date(), title: "Bread")
        
        interactor.filteredTasks = [task1, task2, task3]
        interactor.tasks = [task1, task2, task3]
        
        interactor.filterTasks(with: "")
        XCTAssertEqual(mockPresenter.receivedTasks.count, 3)
        
        interactor.filterTasks(with: "buy")
        XCTAssertEqual(mockPresenter.receivedTasks.count, 3)
        XCTAssertEqual(interactor.filteredTasks.count, 2)
        XCTAssertTrue(interactor.filteredTasks.contains(where: { $0.description == "Buy milk" }))
        XCTAssertTrue(interactor.filteredTasks.contains(where: { $0.description == "Buy bread" }))
        
        interactor.filterTasks(with: "call")
        XCTAssertEqual(interactor.filteredTasks.count, 1)
        XCTAssertEqual(interactor.filteredTasks.first?.description, "Call mom")
    }
}


