//
//  ProjectInfo.swift
//  IMS
//
//  Created by 俞兆 on 2017/5/26.
//  Copyright © 2017年 Mark. All rights reserved.
//

import UIKit

class ProjectInfo
{
    var ProjectName: String?
    var Image: String?
    var CloseRate:String?
    var PM_ID:String?
    var Model_Focus: String?
    init(text: String?,image: String?,CloseRate:String?,PM_ID:String?,Model_Focus:String?) {
        // Default type is Mine
        self.ProjectName = text
        self.Image = image
        self.CloseRate = CloseRate
        self.PM_ID = PM_ID
        self.Model_Focus = Model_Focus
    }
    
}
