//
//  ProjectHeaderCellTableViewCell.swift
//  IMS
//
//  Created by 俞兆 on 2017/5/25.
//  Copyright © 2017年 Mark. All rights reserved.
//

import UIKit

class ProjectHeaderCellTableViewCell: UITableViewCell {

    @IBOutlet weak var Lbl_Title: UILabel!
    
    @IBOutlet weak var Lbl_Toggle_Title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
