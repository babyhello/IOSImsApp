//
//  DB_Photo+CoreDataProperties.swift
//  IMS
//
//  Created by 俞兆 on 2017/8/24.
//  Copyright © 2017年 Mark. All rights reserved.
//

import Foundation
import CoreData


extension DB_Photo {

    @NSManaged public var photo_background: String?
    @NSManaged public var photo_sdate: String?
    @NSManaged public var photo_path: String?
    @NSManaged public var photo_edate: String?
}
