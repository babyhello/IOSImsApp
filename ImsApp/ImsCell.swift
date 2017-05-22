//
//  ImsCell.swift
//  com.msi.IMSApp
//
//  Created by 俞兆 on 2016/7/15.
//  Copyright © 2016年 Mark. All rights reserved.
//

import UIKit

class ImsCell: UITableViewCell {

    @IBOutlet weak var lbl_Issue_Subject: UILabel!
    
    @IBOutlet weak var lbl_Project_Name: UILabel!
    @IBOutlet weak var lbl_WorkNoteCount: UILabel!
    @IBOutlet weak var ImgPriority: UIImageView!
    @IBOutlet weak var lbl_Issue_No: UILabel!
    @IBOutlet weak var lbl_Issue_Date: UILabel!
//    
//    @IBOutlet weak var lbl_Issue_Subject: UILabel!
//    @IBOutlet weak var lbl_Issue_Date: UILabel!
//    @IBOutlet weak var lbl_Issue_No: UILabel!
//    @IBOutlet weak var ImgPriority: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
