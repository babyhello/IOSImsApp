//
//  SettingTableViewController.swift
//  com.msi.IMSApp
//
//  Created by 俞兆 on 2016/8/20.
//  Copyright © 2016年 Mark. All rights reserved.
//

import UIKit

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
        return 3
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
        default:
            break
        }
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
