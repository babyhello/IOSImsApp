//
//  PopUpProjectSelectViewController.swift
//  ImsApp
//
//  Created by 俞兆 on 2016/6/30.
//  Copyright © 2016年 Mark. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

protocol PopUpProjectSelectViewDelegate: class {         // make this class protocol so you can create `weak` reference
    func Img_Issue_Click()
    
    func Img_Spec_Click()
    
    func Img_Member_Click()
    
    func Img_NewIssue_Click()
    
    func Exit_Click()
}

class PopUpProjectSelectViewController: UIViewController {
    
    weak var delegate: PopUpProjectSelectViewDelegate?
    
    @IBOutlet weak var Img_Favorite: UIImageView!

    @IBOutlet weak var ClosePopView: UIImageView!
    
    @IBOutlet weak var Img_Spec: UIImageView!
    @IBOutlet weak var Img_Issue: UIImageView!
    @IBOutlet weak var lbl_Stage: UILabel!
    
    @IBOutlet weak var Img_Member: UIImageView!
    @IBOutlet weak var Img_Project: UIImageView!
    
    @IBOutlet weak var lbl_ProjectName: UILabel!
    @IBOutlet weak var lbl_CloseRate: UILabel!
    
    @IBOutlet weak var lbl_P1_count: UILabel!
    
    @IBOutlet weak var lbl_Project_MarketName: UILabel!
    
    @IBOutlet weak var Img_NewIssue: UIImageView!
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
        
        lbl_Project_MarketName.textColor = UIColor(hexString: "#878787")
        
        let FavoritView = Img_Favorite
        let FavoritViewLink = UITapGestureRecognizer(target:self, action:#selector(PopUpProjectSelectViewController.Favorite_Click(_:)))
        FavoritView?.isUserInteractionEnabled = true
        FavoritView?.addGestureRecognizer(FavoritViewLink)
        
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
        
        let ImgNew = Img_NewIssue
        let ImgNewLink = UITapGestureRecognizer(target:self, action:#selector(PopUpProjectSelectViewController.Img_NewIssue_Click(_:)))
        ImgNew?.isUserInteractionEnabled = true
        ImgNew?.addGestureRecognizer(ImgNewLink)

        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        if AppUser.WorkID! != "" {
            
            Find_Model_Detail((ProjectInfo?.PM_ID)!,WorkID: AppUser.WorkID!)
        }
        
        
        //self.showAnimate()
        
        
        // Do any additional setup after loading the view.
    }
//    
    
    func Find_Model_Detail(_ ModelID:String,WorkID:String)
    {
       
        
        let Path = AppClass.ServerPath + "/IMS_App_Service.asmx/Find_Model_Detail";
        
        let _parameters = ["WorkID": WorkID,"ModelID":ModelID]
        
        Alamofire.request( Path, parameters: _parameters)
            .responseJSON { response in
                
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        for ModelInfo in (ObjectString )! {
                            
                            
                            var P1:String?
                            
                            var ModelID:Int?
                            
                            var ModelPic:String?
                            
                            var Model_Favorit:Bool?
                            
                            var CloseRate:Double?
                            
                            var CurrentStage:String?
                            
                            var MarketName:String?

                            
                            if (ModelInfo["P1"] as? String) != nil {
                                
                                P1 = ModelInfo["P1"] as? String
                                
                            }
                            
                            if (ModelInfo["ModelID"] as? Int) != nil {
                                
                                ModelID =  ModelInfo["ModelID"] as? Int
                                
                            }
                            
                            if (ModelInfo["ModelPic"]) != nil {
                                
                                
                               ModelPic = ModelInfo["ModelPic"] as? String
                                
                                
                            }
                            
                            
                            if (ModelInfo["Model_Favorit"]) != nil {
                                
                                                                
                                Model_Favorit = ModelInfo["Model_Favorit"] as? Bool
                                
                                
                            }
                            
                            if (ModelInfo["CloseRate"]) != nil {
                                
                                CloseRate = ModelInfo["CloseRate"] as? Double

                            }
                            
                            if (ModelInfo["CurrentStage"]) != nil {
                                
                                CurrentStage = ModelInfo["CurrentStage"] as? String
                                
                            }
                            
                            if (ModelInfo["MarketName"]) != nil {
                                
                                MarketName = ModelInfo["MarketName"] as? String
                                
                            }
                            
                           self.lbl_CloseRate.text = String(describing: Int(CloseRate! * 100)) + "%"
                            
                             self.lbl_P1_count.text = P1
                            
                            self.lbl_Stage.text = CurrentStage

                            
                            self.lbl_Project_MarketName.text = MarketName
                       
                            if  Model_Favorit!
                            {
                                self.Img_Favorite.image = UIImage(named: "btn_star_sel")
                         }
                            else
                            {
                                self.Img_Favorite.image = UIImage(named: "btn_star_nor")

                            }
                            
                        }
                        
                        
                        
                    }
                    else
                    {
                        
                        
                        AppClass.Alert("Not Verify", SelfControl: self)
                    }
                    
                }
                else
                {
                    AppClass.Alert("Outlook ID or Password Not Verify !!", SelfControl: self)
                }
        }
        
    }
    
    func Favorite_Click(_ img: AnyObject)
    {
        
        let Path = AppClass.ServerPath + "/IMS_App_Service.asmx/Insert_Favorit_Model"
        
        let F_Owner = ""
        
        //let _parameters = ["F_Keyin": AppUser.WorkID!,"F_Owner":F_Owner,"ModelID":ProjectInfo?.PM_ID!]
      
        let PM_ID = ProjectInfo?.PM_ID!
        
        Alamofire.request( Path, parameters: ["F_Keyin": AppUser.WorkID!,"F_Owner":F_Owner,"F_PM_ID": PM_ID!])
            .responseJSON { response in
                self.Find_Model_Detail((self.ProjectInfo?.PM_ID)!,WorkID: AppUser.WorkID!)
               
        }
        
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
    
    func Img_NewIssue_Click(_ img: AnyObject)
    {
        self.HideBar()
        
        delegate?.Img_NewIssue_Click()
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
