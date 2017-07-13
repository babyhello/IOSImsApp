//
//  DB_Member.swift
//  
//
//  Created by 俞兆 on 2016/8/21.
//
//

import Foundation
import CoreData
import UIKit
//import UIApplicationMain

class DB_Member: NSManagedObject {

    
     class func addMember(_ moc:NSManagedObjectContext,WorkID:String,outlook_Account:String, outlook_Password:String,MemberName:String) {
        
        
        let _DB_Member = NSEntityDescription.insertNewObject(forEntityName: "DB_Member", into: moc) as! DB_Member
        
        _DB_Member.outlook_account = outlook_Account
        
        _DB_Member.outlook_password = outlook_Password
        
        _DB_Member.name = MemberName
        
        _DB_Member.workid = WorkID
        
        do {
            try moc.save()
        }catch{
            fatalError("Failure to save context: \(error)")
        }
    }
    

    class func Get_Member(_ moc:NSManagedObjectContext)-> [DB_Member] {
        
        var request: NSFetchRequest<DB_Member>
        
        if #available(iOS 10.0, *) {
           request = DB_Member.fetchRequest() as! NSFetchRequest<DB_Member>

        } else {
            //request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person") as! NSFetchRequest<DB_Member>
            request = NSFetchRequest(entityName: "DB_Member")
        }
        
        
        do {
            
            return try moc.fetch(request)

        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
   
    }
    
    class func Delete_Member(_ moc:NSManagedObjectContext) {
        
    
        let request = NSFetchRequest<DB_Member>() 
        do {
            let results = try moc.fetch(request) 
            for result in results {
                moc.delete(result)
            }
            do {
                try moc.save()
            }catch{
                fatalError("Failure to save context: \(error)")
            }
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
    }

}
