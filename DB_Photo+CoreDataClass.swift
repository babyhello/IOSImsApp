//
//  DB_Photo+CoreDataClass.swift
//  IMS
//
//  Created by 俞兆 on 2017/8/24.
//  Copyright © 2017年 Mark. All rights reserved.
//

import Foundation
import CoreData

//@NSManaged public var photo_background: String?
//@NSManaged public var photo_date: String?
//@NSManaged public var photo_path: String?

public class DB_Photo: NSManagedObject {
    
    class func add_Photo(_ moc:NSManagedObjectContext,photo_background:String,photo_sdate:String,photo_edate:String, photo_path:String) {
        
        
        let _DB_Photo = NSEntityDescription.insertNewObject(forEntityName: "DB_Photo", into: moc) as! DB_Photo
        
        _DB_Photo.photo_background = photo_background
        
        _DB_Photo.photo_sdate = photo_sdate
        
        _DB_Photo.photo_path = photo_path
        
        _DB_Photo.photo_edate = photo_edate
    
        do {
            try moc.save()
        }catch{
            fatalError("Failure to save context: \(error)")
        }
    }
    
    
    class func Get_DB_Photo(_ moc:NSManagedObjectContext)-> [DB_Photo] {
        
        var request: NSFetchRequest<DB_Photo>
       
        if #available(iOS 10.0, *) {
            request = DB_Photo.fetchRequest() as! NSFetchRequest<DB_Photo>
            
        } else {
            //request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person") as! NSFetchRequest<DB_Member>
            request = NSFetchRequest(entityName: "DB_Photo")
        }
        
        
        do {
            
            return try moc.fetch(request)
            
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
        
    }
    
    class func Delete_Member(_ moc:NSManagedObjectContext) {
        
        
        let request = NSFetchRequest<DB_Photo>()
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
