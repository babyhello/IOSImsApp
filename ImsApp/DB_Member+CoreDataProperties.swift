//
//  DB_Member+CoreDataProperties.swift
//  
//
//  Created by 俞兆 on 2016/8/21.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DB_Member {

    @NSManaged var fontsize: NSNumber?
    @NSManaged var workid: String?
    @NSManaged var name: String?
    @NSManaged var outlook_account: String?
    @NSManaged var outlook_password: String?
    @NSManaged var phone: String?
    @NSManaged var notification: NSNumber?

}
