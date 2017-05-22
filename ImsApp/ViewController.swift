//
//  ViewController.swift
//  ImsApp
//
//  Created by 俞兆 on 2016/6/28.
//  Copyright © 2016年 Mark. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var Txt_Account: UITextField!
    @IBOutlet weak var Btn_Next: UIButton!
    
    @IBAction func Btn_Next_Click(_ sender: AnyObject) {
        
        
        
        let Account = Txt_Account.text
        
        if Account == "A"
        {
           performSegue(withIdentifier: "RegisterConfirmPassword", sender: self)
        }
        else
        {
            if Account != "" {
                performSegue(withIdentifier: "RegisterConfirmPassword", sender: self)
            }
            else
            {
                
                AppClass.Alert("Please Keyin Outlook ID", SelfControl: self)
            }
        }
       
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func Alert(_ Message:String)
    {
        let alertController = UIAlertController(title: "alert", message:
            Message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "RegisterConfirmPassword"){
            
            let bVc:RegisterPasswordViewController = segue.destination as! RegisterPasswordViewController
            
            bVc.OutloockAccount = Txt_Account.text
            //bVc.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.presentedViewController!
        
        //self.view.window?.rootViewController?.presentedViewController!
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Txt_Account.becomeFirstResponder()
        
        self.hideKeyboardWhenTappedAround()
        
        Btn_Next.layer.borderColor = UIColor(hexString: "#2198F2").cgColor
        
        Btn_Next.layer.cornerRadius = 5
        
    
        
        if AppUser.WorkID != nil && AppUser.WorkID != "" {
            
               performSegue(withIdentifier: "RegisterConfirmPassword", sender: self)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //
    //    }
    
}


