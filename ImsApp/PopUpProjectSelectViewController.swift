//
//  PopUpProjectSelectViewController.swift
//  ImsApp
//
//  Created by 俞兆 on 2016/6/30.
//  Copyright © 2016年 Mark. All rights reserved.
//

import UIKit

protocol PopUpProjectSelectViewDelegate: class {         // make this class protocol so you can create `weak` reference
    func Img_Issue_Click()
    
    func Img_Spec_Click()
    
    func Img_Member_Click()
    
    func Exit_Click()
}

class PopUpProjectSelectViewController: UIViewController {
    
    weak var delegate: PopUpProjectSelectViewDelegate?
    
    @IBOutlet weak var Img_Member: UIImageView!
    @IBOutlet weak var Img_Spec: UIImageView!
    @IBOutlet weak var Img_Issue: UIImageView!
    @IBOutlet weak var ClosePopView: UIImageView!
    
    
  
    @IBOutlet weak var Img_Project: UIImageView!
    @IBOutlet weak var lbl_ProjectName: UILabel!
    @IBOutlet weak var lbl_CloseRate: UILabel!
    
    @IBOutlet weak var BottomConstanct: NSLayoutConstraint!
    
    var ProjectInfo : ProjectInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationController?.isNavigationBarHidden = true
        
        lbl_ProjectName.text = ProjectInfo?.ProjectName
        
        lbl_CloseRate.text = (ProjectInfo?.CloseRate)! + "%"
        
        AppClass.WebImgGet((ProjectInfo?.Image)!,ImageView: Img_Project)
        
        Img_Project.clipsToBounds = true
        
        let ClosePopup = ClosePopView
        let ClosePopupLink = UITapGestureRecognizer(target:self, action:#selector(PopUpProjectSelectViewController.ClosePopView_Click(_:)))
        ClosePopup?.isUserInteractionEnabled = true
        ClosePopup?.addGestureRecognizer(ClosePopupLink)
        
        let ImgIssue = Img_Issue
        let ImgIssueLink = UITapGestureRecognizer(target:self, action:#selector(PopUpProjectSelectViewController.Img_Issue_Click(_:)))
        ImgIssue?.isUserInteractionEnabled = true
        ImgIssue?.addGestureRecognizer(ImgIssueLink)
        
        let ImgSpec = Img_Spec
        let ImgSpecLink = UITapGestureRecognizer(target:self, action:#selector(PopUpProjectSelectViewController.Img_Spec_Click(_:)))
        ImgSpec?.isUserInteractionEnabled = true
        ImgSpec?.addGestureRecognizer(ImgSpecLink)
        
        let ImgMember = Img_Member
        let ImgMemberLink = UITapGestureRecognizer(target:self, action:#selector(PopUpProjectSelectViewController.Img_Member_Click(_:)))
        ImgMember?.isUserInteractionEnabled = true
        ImgMember?.addGestureRecognizer(ImgMemberLink)
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        
        //self.showAnimate()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func Img_Issue_Click(_ img: AnyObject)
    {
        self.HideBar()
        
        delegate?.Img_Issue_Click()
    }
    
    func Img_Spec_Click(_ img: AnyObject)
    {
        self.HideBar()
        
        delegate?.Img_Spec_Click()
    }
    
    func Img_Member_Click(_ img: AnyObject)
    {
        self.HideBar()
        
        delegate?.Img_Member_Click()
    }
    
   
    

    func ClosePopView_Click(_ img: AnyObject)
    {
        self.HideBar()
        
        delegate?.Exit_Click()
    }
    
    func HideBar()
    {
        //        self.removeAnimate()
        //
        
        //navigationController?.popViewController(animated: true)
        removeAnimate()
        dismiss(animated: true, completion: nil)
        
        //        super.tabBarController?.tabBar.isHidden = false
        //
        //        super.navigationController?.isNavigationBarHidden = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
