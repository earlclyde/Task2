//
//  TaskController.swift
//  Task2
//
//  Created by Nicholas Laughter on 5/19/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import Foundation
import CoreData

class TaskController {
    
    static var sharedInstance = TaskController()
    let fetchedResultsController: NSFetchedResultsController
    
    init() {
        let moc = Stack.sharedStack.managedObjectContext
        let request = NSFetchRequest(entityName: "Task")
        let sortDescriptor1 = NSSortDescriptor(key: "isIncomplete", ascending: false)
        let sortDescriptor2 = NSSortDescriptor(key: "due", ascending: true)
        request.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: "isIncomplete", cacheName: nil)
        _ = try? fetchedResultsController.performFetch()
    }
    
    func addTask(name: String, notes: String?, due: NSDate?) {
        _ = Task(name: name, notes: notes, due: due)
        saveToPersistentStorage()
    }
    
    func removeTask(task: Task) {
        task.managedObjectContext?.deleteObject(task)
        saveToPersistentStorage()
    }
    
    func isIncompleteValueToggle(task: Task) {
        task.isIncomplete = !task.isIncomplete.boolValue
        saveToPersistentStorage()
    }
    
    func updateTask(task: Task, name: String, notes: String?, due: NSDate?, isIncomplete: Bool) {
        task.name = name
        task.notes = notes
        task.due = due
        task.isIncomplete = isIncomplete
        saveToPersistentStorage()
    }
    
    func saveToPersistentStorage() {
        let _ = try? Stack.sharedStack.managedObjectContext.save()
    }
}