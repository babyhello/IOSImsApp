//
//  FontSettingTableViewController.swift
//  com.msi.IMSApp
//
//  Created by 俞兆 on 2016/8/21.
//  Copyright © 2016年 Mark. All rights reserved.
//

import UIKit

class FontSettingTableViewController: UITableViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Font Size"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        
        if AppUser.NewFontSize != nil {
            AppUser.OldFontSize = AppUser.NewFontSize
        }
        
        
        
        for cell in tableView.visibleCells
        {
            cell.accessoryType = .none
            
        }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            //cell.contentView.backgroundColor = UIColor.whiteColor()
            
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                
            } else {
                cell.accessoryType = .checkmark
                
            }
        }
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            AppUser.NewFontSize = 0.8
        case 1:
            AppUser.NewFontSize = 1.0
        case 2:
            AppUser.NewFontSize = 1.2
        default: break
            
        }
        
        let UilabelAppearace = UILabel.appearance()
        
        UilabelAppearace.SetLabelDefaultSize(AppUser.NewFontSize!)
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FontCell", for: indexPath)
        
        cell.selectionStyle = .none
        
        
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            cell.textLabel!.text = "Small"
            cell.textLabel!.font = UIFont(name: cell.textLabel!.font.fontName, size: 10)
            
        case 1:
            cell.textLabel!.text = "Medium"
            cell.textLabel!.font = UIFont(name: cell.textLabel!.font.fontName, size: 20)
        case 2:
            cell.textLabel!.text = "Large"
            cell.textLabel!.font = UIFont(name: cell.textLabel!.font.fontName, size: 30)
        default: break
            
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
