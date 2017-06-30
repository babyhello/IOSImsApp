//
//  ProjectMemberTableViewController.swift
//  ImsApp
//
//  Created by 俞兆 on 2016/7/1.
//  Copyright © 2016年 Mark. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class ProjectMemberTableViewController: UITableViewController {

    var ModelMemberArray = [ModelMember]()
    
    var ModelHeaderArray =  [String]()
    
    var PM_Title:String?
    
    var ModelID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = PM_Title
        
        Model_Member(ModelID!)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func Model_Member(_ ModelID:String)
    {
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Find_Model_Member_List", parameters: ["PM_ID": ModelID])
            .responseJSON { response in
                
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        for IssueInfomation in (ObjectString )! {
                            
                            let _ModelMember = ModelMember()
                            
                            if (IssueInfomation["MemberName"] as? String) != nil {
                                
                                _ModelMember.MemberName = IssueInfomation["MemberName"] as? String
                                
                            }
                            else
                            {
                                _ModelMember.MemberName = ""
                            }
                            
                            if (IssueInfomation["Header"] as? String) != nil {
                                
                                _ModelMember.Header = IssueInfomation["Header"] as? String
                                
                            }
                            else
                            {
                                _ModelMember.Header = ""
                            }
                            
                            if (IssueInfomation["F_Tel"] as? String) != nil {
                                
                                _ModelMember.F_Tel = IssueInfomation["F_Tel"] as? String
                                
                                
                                
                                
                            }
                            else
                            {
                                _ModelMember.F_Tel = ""
                            }
                            
                            self.ModelMemberArray.append(_ModelMember)
                        }
                        
                        let Group = self.ModelMemberArray.groupBy{ $0.Header!}

                        for GroupKey in Group
                        {
                            if GroupKey.0 != ""
                            {
                            self.ModelHeaderArray.append(GroupKey.0)
                            }
                            
                        
                        }
                        
                        //print(Group)

                        //print(self.ModelHeaderArray)
                        
                        self.tableView.reloadData()
                        
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return ModelHeaderArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        // Usage
        
        let MemberArray =    ModelMemberArray.filter{$0.Header == ModelHeaderArray[section]}
        
        return MemberArray.count
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath)

        let MemberArray =  ModelMemberArray.filter{$0.Header == ModelHeaderArray[(indexPath as NSIndexPath).section]}
        
        cell.detailTextLabel!.text = MemberArray[(indexPath as NSIndexPath).row].F_Tel
        
        cell.detailTextLabel!.font.withSize(13)
        
        cell.detailTextLabel!.textColor = UIColor(hexString: "#a1a4b0")
        
        cell.textLabel!.font.withSize(16)
        
        cell.textLabel!.textColor = UIColor(hexString: "#212121")
        
        cell.textLabel!.text = MemberArray[(indexPath as NSIndexPath).row].MemberName
        
        if MemberArray[(indexPath as NSIndexPath).row].F_Tel != "" {
            
            //let CallImageView = UIImageView
            
            cell.accessoryView = (UIImageView(image: UIImage(named:"ic_callanswer")))
        }
        else
        {
            cell.accessoryView = (UIImageView(image: UIImage(named:"")))

        }
        // Configure the cell...

        return cell
    }
 

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ModelHeaderArray[section]
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

public extension Sequence {
    
    func groupBy<G: Hashable>(_ closure: (Iterator.Element)->G) -> [G: [Iterator.Element]] {
        var results = [G: Array<Iterator.Element>]()
        
        forEach {
            let key = closure($0)
            
            if var array = results[key] {
                array.append($0)
                results[key] = array
            }
            else {
                results[key] = [$0]
            }
        }
        
        return results
    }
    
}

