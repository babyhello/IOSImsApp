//
//  ProjectSpecTableViewController.swift
//  ImsApp
//
//  Created by 俞兆 on 2016/7/1.
//  Copyright © 2016年 Mark. All rights reserved.
//

import UIKit
import Alamofire


class ProjectSpecCell:UITableViewCell
{
    @IBOutlet weak var lbl_Spec_Title: UILabel!
    @IBOutlet weak var lbl_Spec_Detail: UILabel!
    @IBOutlet weak var View_Spec: UIView!
}

class SpecData
{
    var Spec_Title:String?
    var Spec_Detail:String?
}

class ProjectSpecTableViewController: UITableViewController {
    
    var SpecDataList = [SpecData]()
    
    var ModelID :String?
    
    var PM_Title:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        title = PM_Title!
        
        Spec_List(ModelID!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return SpecDataList.count
    }
    
    
    func Spec_List(_ PM_ID:String)
    {
        SpecDataList = [SpecData]()
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Find_Model_Spec", parameters: ["PM_ID": PM_ID])
            .responseJSON { response in
                
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        for SpecInformation in (ObjectString )! {
                            
                            let _SpecData = SpecData()
                            
                            if (SpecInformation["F_FieldName"] as? String) != nil {
                                
                                _SpecData.Spec_Title = SpecInformation["F_FieldName"] as? String
                                
                            }
                            else
                            {
                                _SpecData.Spec_Title = ""
                            }
                            
                            if (SpecInformation["F_SpecData"] as? String) != nil {
                                
                                _SpecData.Spec_Detail = SpecInformation["F_SpecData"] as? String
                                
                            }
                            else
                            {
                                _SpecData.Spec_Detail = ""
                            }
                            
                            self.SpecDataList.append(_SpecData)
                        }
                        //print(self.SpecDataList.count)
                        self.tableView.reloadData()
                        
                    }
                    
                }
                
        }
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectSpecCell", for: indexPath) as! ProjectSpecCell
        
        cell.lbl_Spec_Title.text = SpecDataList[(indexPath as NSIndexPath).row].Spec_Title
        
        cell.lbl_Spec_Detail.text = SpecDataList[(indexPath as NSIndexPath).row].Spec_Detail
        
        
        
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

