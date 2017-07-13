//
//  CloseIssueAlertViewController.swift
//  IMS
//
//  Created by 俞兆 on 2017/7/6.
//  Copyright © 2017年 Mark. All rights reserved.
//

import UIKit

protocol CloseIssueDelegate: class {         // make this class protocol so you can create `weak` reference
    func CloseIssueStatusChange()
}

class CloseIssueAlertViewController: UIView {

    weak var delegate: CloseIssueDelegate?
    
    @IBOutlet weak var Btn_Limitation: UIButton!
    
    @IBOutlet weak var Btn_Fixed: UIButton!
    
    @IBOutlet weak var Btn_Waive: UIButton!
  
    @IBOutlet weak var Btn_Limitation_Click: UIButton!
    
    @IBAction func Btn_Limitation_Click(_ sender: Any) {
        Set_Close_Status(1)
        
        delegate?.CloseIssueStatusChange()
    }
    
    @IBAction func Btn_Fixed_Click(_ sender: Any) {
        Set_Close_Status(2)
        
        delegate?.CloseIssueStatusChange()
    }
    @IBAction func Btn_Waive_Click(_ sender: Any) {
        Set_Close_Status(5)
        
        delegate?.CloseIssueStatusChange()
    }
    
    var IssueStatus:Int?
    
    var MyCustview:UIView!
    
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
        MyCustview.frame = bounds
        MyCustview.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        addSubview(MyCustview)
    }
    
    func clearStatus()
    {
        Btn_Limitation.setBackgroundImage(UIImage(named: "btn_closeissue_limit_nor"), for: .normal)
        Btn_Fixed.setBackgroundImage(UIImage(named: "btn_closeissue_fixe_nor"), for: .normal)
        Btn_Waive.setBackgroundImage(UIImage(named: "btn_closeissue_waive_nor"), for: .normal)
        
        IssueStatus = nil
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for:type(of: self))
        let nib = UINib(nibName: "CloseIssueAlertViewController", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    func Set_Close_Status(_ _IssueStatus:Int)
    {
        Btn_Limitation.setBackgroundImage(UIImage(named: "btn_closeissue_limit_nor"), for: .normal)
        Btn_Fixed.setBackgroundImage(UIImage(named: "btn_closeissue_fixe_nor"), for: .normal)
        Btn_Waive.setBackgroundImage(UIImage(named: "btn_closeissue_waive_nor"), for: .normal)
        
         IssueStatus = _IssueStatus
        
        switch _IssueStatus {
            
        case 1:
            Btn_Limitation.setBackgroundImage(UIImage(named: "btn_closeissue_limit_sel"), for: .normal)
            
            Btn_Fixed.setBackgroundImage(UIImage(named: "btn_closeissue_fixe_nor"), for: .normal)
            Btn_Waive.setBackgroundImage(UIImage(named: "btn_closeissue_waive_nor"), for: .normal)
            
            break;
        case  2:
            Btn_Fixed.setBackgroundImage(UIImage(named: "btn_closeissue_fixe_sel"), for: .normal)
            
            Btn_Limitation.setBackgroundImage(UIImage(named: "btn_closeissue_limit_nor"), for: .normal)
            
            Btn_Waive.setBackgroundImage(UIImage(named: "btn_closeissue_waive_nor"), for: .normal)
            
            
            
            break;
        case  5:
            Btn_Waive.setBackgroundImage(UIImage(named: "btn_closeissue_waive_sel"), for: .normal)
            
            Btn_Limitation.setBackgroundImage(UIImage(named: "btn_closeissue_limit_nor"), for: .normal)
            Btn_Fixed.setBackgroundImage(UIImage(named: "btn_closeissue_fixe_nor"), for: .normal)
            
            break;
            
        default:
            break;
            
            
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
