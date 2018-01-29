//
//  IssueImage.swift
//  com.msi.IMSApp
//
//  Created by 俞兆 on 2016/7/31.
//  Copyright © 2016年 Mark. All rights reserved.
//

import UIKit

@IBDesignable
class IssueImage: UIView {
    
    @IBOutlet weak var IssueImageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var Img_Issue: UIImageView!
    
    @IBOutlet weak var Img_Cancel: UIImageView!
    
    var ImagePath:String!
    
    var MyCustview:UIView!

    
    
    func Hide_CancelBtn()
    {
        Img_Cancel.isHidden = true
        
    }
    
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
        Img_Issue.bringSubview(toFront: MyCustview)
        MyCustview.frame = bounds
        MyCustview.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        IssueImageHeight.constant = MyCustview.frame.height
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(IssueImage.GoToZoome(_:)))
        
        
        MyCustview?.addGestureRecognizer(tapGestureRecognizer)
        
        addSubview(MyCustview)
    }
    
    func GoToZoome(_ sender:UITapGestureRecognizer)
    {
       
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        _ = screenSize.width
        _ = screenSize.height
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZoomImageView") as! ZoomViewController
        
        popOverVC.ZoomImage = Img_Issue.image
        
        let nav = UINavigationController(rootViewController: popOverVC)
        
        let currentController = AppClass.getCurrentViewController()
        
        currentController?.present(nav, animated: false)
     
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for:type(of: self))
        let nib = UINib(nibName: "IssueImage", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
