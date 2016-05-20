//
//  Task+CoreDataProperties.swift
//  Task2
//
//  Created by Nicholas Laughter on 5/19/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task {

    @NSManaged var name: String
    @NSManaged var due: NSDate?
    @NSManaged var isIncomplete: NSNumber
    @NSManaged var notes: String?

}
