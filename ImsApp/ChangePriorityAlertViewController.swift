//
//  ChangePriorityAlertViewController.swift
//  IMS
//
//  Created by 俞兆 on 2017/7/6.
//  Copyright © 2017年 Mark. All rights reserved.
//

import UIKit

protocol ChangePriorityDelegate: class {         // make this class protocol so you can create `weak` reference
    func PriorityChange()
}

class ChangePriorityAlertViewController: UIView {

    weak var delegate: ChangePriorityDelegate?
    
    @IBOutlet weak var Btn_Priority_One: UIButton!
    
    @IBOutlet weak var Btn_Priority_Two: UIButton!
    
    @IBOutlet weak var Btn_Priority_Three: UIButton!
    
    @IBOutlet weak var lbl_Title: UILabel!
    
    @IBAction func Btn_PriorityOne_Click(_ sender: Any) {
         Set_Priority(1)
        delegate?.PriorityChange()
    }
    
    @IBAction func Btn_PriorityTwo_Click(_ sender: Any) {
         Set_Priority(2)
        delegate?.PriorityChange()
    }
    
    @IBAction func Btn_PriorityThree_Click(_ sender: Any) {
         Set_Priority(3)
        delegate?.PriorityChange()
    }
    
    var SelectedPriority = 1
    
    var MyCustview:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    func Set_Priority(_ Priority:Int)
    {
        Btn_Priority_One.setBackgroundImage(UIImage(named: "btn_change_prioP1_nor"), for: .normal)
        Btn_Priority_Two.setBackgroundImage(UIImage(named: "btn_change_prioP2_nor"), for: .normal)
        Btn_Priority_Three.setBackgroundImage(UIImage(named: "btn_change_prioP3_nor"), for: .normal)
        
        SelectedPriority = Priority
        
        switch Priority {
            
        case 1:
            Btn_Priority_One.setBackgroundImage(UIImage(named: "btn_change_prioP1_sel"), for: .normal)
            
            Btn_Priority_Two.setBackgroundImage(UIImage(named: "btn_change_prioP2_nor"), for: .normal)
            Btn_Priority_Three.setBackgroundImage(UIImage(named: "btn_change_prioP3_nor"), for: .normal)
            
            break;
        case  2:
            Btn_Priority_Two.setBackgroundImage(UIImage(named: "btn_change_prioP2_sel"), for: .normal)
            
            Btn_Priority_One.setBackgroundImage(UIImage(named: "btn_change_prioP1_nor"), for: .normal)
            
            Btn_Priority_Three.setBackgroundImage(UIImage(named: "btn_change_prioP3_nor"), for: .normal)
            
            
            
            break;
        case  3:
            Btn_Priority_Three.setBackgroundImage(UIImage(named: "btn_change_prioP3_sel"), for: .normal)
            
            Btn_Priority_One.setBackgroundImage(UIImage(named: "btn_change_prioP1_nor"), for: .normal)
            Btn_Priority_Two.setBackgroundImage(UIImage(named: "btn_change_prioP2_nor"), for: .normal)
            
            break;
            
        default:
            break;
            
            
        }
        
        
    }
    
  
    
    func setup() {
        
     
        
        MyCustview = loadViewFromNib()
        MyCustview.frame = bounds
        MyCustview.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
       
        addSubview(MyCustview)
        
        //Set_Priority(SelectedPriority)
        
        
    }

    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for:type(of: self))
        let nib = UINib(nibName: "ChangePriorityAlertViewController", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
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
