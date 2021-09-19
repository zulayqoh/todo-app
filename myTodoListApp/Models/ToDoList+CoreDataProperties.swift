//
//  ToDoList+CoreDataProperties.swift
//  myTodoListApp
//
//  Created by Decagon on 09/09/2021.
//
//

import Foundation
import CoreData


extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var id: Int32
    @NSManaged public var desc: String?
    @NSManaged public var title: String?
    @NSManaged public var deletedDate: Date?
    @NSManaged public var important: String?

}

extension ToDoList : Identifiable {

}
