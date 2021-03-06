//
//  Friend+CoreDataProperties.swift
//  FacebookMessenger
//
//  Created by Ellen Mey on 10/12/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Friend {

    @NSManaged var profileImageName: String?
    @NSManaged var name: String?
    @NSManaged var messages: NSSet?

}
