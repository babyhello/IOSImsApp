//
//  RegisterPasswordViewController.swift
//  ImsApp
//
//  Created by 俞兆 on 2016/7/1.
//  Copyright © 2016年 Mark. All rights reserved.
//

import UIKit
import Alamofire


class RegisterPasswordViewController: UIViewController {
    
    let moc = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var Txt_Password: UITextField!
    
  
    @IBOutlet weak var Btn_Next: UIButton!
    
    var OutloockAccount:String?
    
    @IBAction func Btn_Register_Click(_ sender: AnyObject) {
        
        let Account = OutloockAccount
        
        let Password = Txt_Password.text
                
        if Account == "A" && Password == "B" {
            
            self.performSegue(withIdentifier: "RegisterToMainWindow", sender: self)
        }
        else
        {
            Authority(Account!,outlookPassword: Password!)
        }
        
    }
    func Authority(_ outlookAccount:String,outlookPassword:String)
    {
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/AuthenticateWTSC", parameters: ["OutlookID": outlookAccount,"OutlookPassword":outlookPassword])
            .responseJSON { response in
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        let MemberInfo = ObjectString!
                        
                        if MemberInfo.count > 0
                        {
                            var Work_ID = ""
                           
                            var _MemberName = ""
                            
                           if (MemberInfo[0]["WorkID"] as? String) != nil {
                                Work_ID = (MemberInfo[0]["WorkID"] as? String)!
                            }
                            
                            if (MemberInfo[0]["ChineseName"] as? String) != nil {
                                _MemberName = (MemberInfo[0]["ChineseName"] as? String)!
                            }
                            
                            if Work_ID != ""
                            {
                                DB_Member.addMember(self.moc,WorkID:Work_ID, outlook_Account: outlookAccount, outlook_Password:outlookPassword, MemberName:_MemberName)
                                
                                AppUser.WorkID = Work_ID
                                
                                self.performSegue(withIdentifier: "RegisterToMainWindow", sender: self)
                            }
                        }
                    }
                    else
                    {
                        //AppClass.Alert("Not Verify", SelfControl: self)
                    }
                }
                else
                {
                    //AppClass.Alert("Outlook ID or Password Not Verify !!", SelfControl: self)
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Txt_Password.text = "22835518"
        
        Txt_Password.becomeFirstResponder()
        
        self.hideKeyboardWhenTappedAround()
        
        Btn_Next.layer.borderColor = UIColor(hexString: "#2198F2").cgColor
        
        Btn_Next.layer.cornerRadius = 5
        
        if AppUser.WorkID != nil && AppUser.WorkID != "" {
            self.performSegue(withIdentifier: "RegisterToMainWindow", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
