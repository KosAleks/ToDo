//
//  TaskEntity+CoreDataProperties.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 05.08.2025.
//
//

import Foundation
import CoreData


extension TaskEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }
    
    @NSManaged public var id: Int32
    @NSManaged public var todo: String?
    @NSManaged public var completed: Bool
    @NSManaged public var createdAt: Date?
    @NSManaged public var title: String?
}

extension TaskEntity : Identifiable {
    
}
