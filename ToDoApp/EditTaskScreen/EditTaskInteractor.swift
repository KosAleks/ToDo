//
//  EditTaskInteractor.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 07.08.2025.
//

import Foundation
import CoreData

protocol EditTaskInteractorProtocol: AnyObject {
    func saveTask(title: String?, id: Int32, todo: String?, date: Date?, completion: @escaping () -> Void
    )
}

final class EditTaskInteractor: EditTaskInteractorProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    func saveTask(title: String?, id: Int32, todo: String?, date: Date?, completion: @escaping () -> Void) {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            if let task = try context.fetch(request).first {
                task.title = title
                task.todo = todo
                task.createdAt = date 
                
                try context.save()
                print("Task updated")
            } else {
                print("Task not found")
            }
        } catch {
            print("Failed to update task:", error)
        }
        DispatchQueue.main.async {
            completion()
        }
    }
}





