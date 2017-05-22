//
//  ProjectCell.swift
//  com.msi.IMSApp
//
//  Created by 俞兆 on 2016/7/8.
//  Copyright © 2016年 Mark. All rights reserved.
//

import UIKit

class ProjectCell: UITableViewCell {
    
    @IBOutlet weak var ProjectImage: UIImageView!
    
    @IBOutlet weak var ProjectName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    
        
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
