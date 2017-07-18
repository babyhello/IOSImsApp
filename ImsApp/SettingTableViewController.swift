//
//  SettingTableViewController.swift
//  com.msi.IMSApp
//
//  Created by 俞兆 on 2016/8/20.
//  Copyright © 2016年 Mark. All rights reserved.
//

import UIKit
import Alamofire

class SettingTableViewController: UITableViewController {
    
    var MemberData = [DB_Member]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let moc = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        MemberData = DB_Member.Get_Member(moc)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).row {
        case 0:
            self.performSegue(withIdentifier: "SettingToAccount", sender: self)
        case 1:
            //self.performSegueWithIdentifier("SettingToFont", sender: self)
            break
        case 2:
            //self.performSegueWithIdentifier("SettingToNotification", sender: self)
            break
        case 3:
            GetServerVersion()
            break
            
        default:
            break
        }
    }
    
    func GetServerVersion()
    {
        
        var PlistPath = ""
        
        var PathPath = ""
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Get_IOS_Version")
            .responseJSON { response in
                
                
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        let IssueInfo = ObjectString!
                        
                        
                        if IssueInfo.count > 0
                        {
                            
                            if (IssueInfo[0]["Path"] as? String) != nil {
                                
                                PlistPath = (IssueInfo[0]["Path"] as? String)!
                                
                            }
                            if (IssueInfo[0]["PagePath"] as? String) != nil {
                                
                                PathPath = (IssueInfo[0]["PagePath"] as? String)!
                                
                            }
                        }
                        
                        if(!PlistPath.isEmpty && !PathPath.isEmpty)
                        {
                            self.checkForUpdates(PlistPath: PlistPath, HtmlPath: PathPath)
                        }
                        
                    }
                    else
                    {
                    }
                    
                }
                else
                {
                    //AppClass.Alert("Outlook ID or Password Not Verify !!", SelfControl: self)
                }
        }
        
        
    }
    
    
    func checkForUpdates(PlistPath:String,HtmlPath:String) {
        
        DispatchQueue.global().async {
            
            DispatchQueue.main.async(execute: {
                
                
                let categoriesURL =  URL(string: PlistPath)
                //let dict = NSDictionary(contentsOfURL: categoriesURL!)
                
                let updateDictionary = NSDictionary(contentsOf: categoriesURL!)
                
                let items = updateDictionary?["items"]
                let itemDict = (items as AnyObject).lastObject as! NSDictionary
                let metaData = itemDict["metadata"] as! NSDictionary
                let serverVersion = metaData["bundle-version"] as! String
                let localVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
                let updateAvailable = serverVersion.compare(localVersion, options: .numeric) == .orderedDescending;
                
                if updateAvailable {
                    self.showUpdateDialog(serverVersion: serverVersion,PagePath:HtmlPath)
                }
                else
                {
                    let alertController = UIAlertController(title: "Is New Version", message:
                        "", preferredStyle: UIAlertControllerStyle.alert)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
        
    }
    
    func showUpdateDialog(serverVersion: String,PagePath:String) {
        DispatchQueue.main.async(execute: { () -> Void in
            
            
            
            let alertController = UIAlertController(title: "New version available!", message:
                "New Version \(serverVersion) has been released. Would you like to download it now?", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Not now", style: .cancel,handler: nil))
            alertController.addAction(UIAlertAction(title: "Update", style: .default, handler: { (UIAlertAction) in
                UIApplication.shared.openURL(NSURL(string: PagePath)! as URL)
            }))
            
            
            self.present(alertController, animated: true, completion: nil)
            
            
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        
        if MemberData.count > 0 {
            
            switch (indexPath as NSIndexPath).row {
            case 0:
                cell.imageView?.image = UIImage(named: "ic_set_account")
                
                cell.textLabel!.text = "Account"
                
                cell.detailTextLabel!.text = MemberData[0].outlook_account
            case 1:
                cell.imageView?.image = UIImage(named: "ic_set_fontsize")
                
                cell.textLabel!.text = "Font Size"
                
                cell.detailTextLabel!.text = "Medium"
            case 2:
                cell.imageView?.image = UIImage(named: "ic_set_loudvolume")
                
                cell.textLabel!.text = "Notification"
                
                cell.detailTextLabel!.text = ""
                
                cell.accessoryView = UISwitch()
            case 3:
                //cell.imageView?.image = UIImage(named: "ic_set_account")
                
                cell.textLabel!.text = "Check Version"
                
                cell.detailTextLabel!.text = ""
            default:
                break
            }
            
        }
        
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
