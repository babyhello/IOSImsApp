//
//  IssueVideo.swift
//  IMS
//
//  Created by 俞兆 on 2017/6/7.
//  Copyright © 2017年 Mark. All rights reserved.
//

import UIKit

class IssueVideo: UIView {


    @IBOutlet weak var IssueVideoHeight: NSLayoutConstraint!
    
    @IBOutlet weak var Issue_Video_VW: UIView!
    
    @IBOutlet weak var Img_Cancel: UIImageView!
    
    var MyCustview:UIView!
    
    //    var height:Int?
    //
    //    var width:Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    func setup() {
        
        MyCustview = loadViewFromNib()
        Issue_Video_VW.bringSubview(toFront: MyCustview)
        MyCustview.frame = bounds
        MyCustview.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        IssueVideoHeight.constant = MyCustview.frame.height
        addSubview(MyCustview)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for:type(of: self))
        let nib = UINib(nibName: "IssueVideo", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
