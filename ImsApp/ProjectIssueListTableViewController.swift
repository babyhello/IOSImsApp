//
//  ProjectIssueListTableViewController.swift
//  com.msi.IMSApp
//
//  Created by 俞兆 on 2016/7/19.
//  Copyright © 2016年 Mark. All rights reserved.
//

import UIKit

import Alamofire
import AlamofireImage

class IssueListInfo
{
    var Priority: UIImageView?
    var Author: String?
    var Owner:String?
    var Subject:String?
    var IssueDate:String?
    var IssueNo:String?
    var Status:String?
    var CreateDate:String?
    var WorkNoteCount:Int?
    var IssueRead:Int?
}


class ProjectIssueListTableViewController: UITableViewController {
    
    @IBOutlet var ImsTable: UITableView!
    
    var IssueArray = [IssueListInfo]()
    
    var PM_ID:Int64?
    
    var PM_Title:String?
    
    var Issue_ID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let photo2 = UIImage(named: "btn_share_nav_newissue")!
        
        //let add = UIBarButtonItem(image: photo2, landscapeImagePhone: photo2, style: .plain, target: self, action: #selector(New_Issue_Click))
        //let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Back, target: self, action: "someAction")
        let back = UIBarButtonItem(title: "Project", style: .plain, target: self, action: #selector(backevent))
        
        //navigationItem.rightBarButtonItems = [add]
        
        navigationItem.leftBarButtonItem = back
        
        let nib = UINib(nibName: "ImsCellNib", bundle: nil)
        
        ImsTable.register(nib, forCellReuseIdentifier: "IMSIssueCell")
        
        self.tabBarController?.tabBar.isHidden = true
        
        navigationItem.title = PM_Title
        
        Issue_List()
        
        self.refreshControl?.addTarget(self, action: #selector(ProjectIssueListTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
    

        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("buttonPressed"), name: , object: nil)
        //
        
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
         Issue_List()
        refreshControl.endRefreshing()
    }
    
    func backevent()
    {
        _ = navigationController?.popViewController(animated: true)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //    override func didMoveToParentViewController(parent: UIViewController?) {
    //
    ////        if parent == self.parentViewController {
    ////            self.tabBarController?.tabBar.hidden = false
    ////            //self.clearsSelectionOnViewWillAppear = true
    ////        }
    //
    //        if (parent == nil) {
    //
    //        }
    //        else
    //        {
    //
    //        }
    //
    //
    //    }
    
    
    
    func New_Issue_Click(_ img: AnyObject)
    {
        
        performSegue(withIdentifier: "ProjectIssueToNewissue", sender: self)
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //
        //        let vc = storyboard.instantiateViewControllerWithIdentifier("NewIssueView") as! NewIssueViewController
        //
        //        vc.ModelID = String(PM_ID)
        //
        //        vc.ModelName = PM_Titleㄑㄋㄋㄋ
        //
        //        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func Issue_List()
    {
        IssueArray = [IssueListInfo]()
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Find_Issue_List", parameters: ["PM_ID": String(PM_ID!)])
            .responseJSON { response in
                
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        for IssueInfomation in (ObjectString )! {
                            
                            let IssueDetail = IssueListInfo()
                            
                            
                            if (IssueInfomation["F_Owner"] as? String) != nil {
                                
                                IssueDetail.Owner = IssueInfomation["F_Owner"] as? String
                                
                            }
                            
                            if (IssueInfomation["Issue_Author"] as? String) != nil {
                                
                                IssueDetail.Author =  IssueInfomation["Issue_Author"] as? String
                                
                            }
                            
                            if (IssueInfomation["F_SeqNo"] as? NSNumber) != nil {
                                
                                IssueDetail.IssueNo = String(describing: (IssueInfomation["F_SeqNo"] as! NSNumber))
                                //print(IssueDetail.IssueNo!)
                            }
                            
                            if (IssueInfomation["F_Priority"] as? String) != nil {
                                
                                IssueDetail.Priority =  AppClass.PriorityImage((IssueInfomation["F_Priority"] as? String)!)
                                
                            }
                            
                            if (IssueInfomation["F_Subject"] as? String) != nil {
                                
                                IssueDetail.Subject =  IssueInfomation["F_Subject"] as? String
                                
                            }
                            
                            //print(IssueInfomation["F_CreateDate"])
                            
                            if (IssueInfomation["F_CreateDate"] as? String) != nil {
                                
                                IssueDetail.CreateDate =  IssueInfomation["F_CreateDate"] as? String
                                
                            }
                            
                            if (IssueInfomation["F_Status"] as? String) != nil {
                                
                                IssueDetail.Status =  IssueInfomation["F_Status"] as? String
                                
                            }
                            
                            if (IssueInfomation["CommentRead"] as? NSNumber) != nil {
                                
                                IssueDetail.WorkNoteCount =  Int((IssueInfomation["CommentRead"] as? NSNumber)!)
                                
                            }
                            if (IssueInfomation["Read"] as? NSNumber) != nil {
                                
                                IssueDetail.IssueRead =  Int((IssueInfomation["Read"] as? NSNumber)!)
                                
                            }
                            
                            
                            self.IssueArray.append(IssueDetail)
                        }
                        
                        self.ImsTable.reloadData()
                        
                    }
                    else
                    {
                        
                        
                        AppClass.Alert("Not Verify", SelfControl: self)
                    }
                    
                }
                else
                {
                    AppClass.Alert("Outlook ID or Password Not Verify !!", SelfControl: self)                }
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return IssueArray.count
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return IssueArray.count
        
        //ㄥreturn 50
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ImsCell = tableView.dequeueReusableCell(withIdentifier: "IMSIssueCell") as! ImsCell
        
        let str = IssueArray[(indexPath as NSIndexPath).row].CreateDate
        
        let dateFor: DateFormatter = DateFormatter()
        
        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let yourDate: Date? = dateFor.date(from: str!)
        
        cell.lbl_WorkNoteCount.text = "1"
        
        cell.lbl_Issue_Date.text = AppClass.DateStringtoShortDate(String(describing: yourDate!))
        
        cell.lbl_Issue_No.text = "#" + IssueArray[(indexPath as NSIndexPath).row].IssueNo!
        
        cell.lbl_Issue_Subject.text = IssueArray[(indexPath as NSIndexPath).row].Subject
        
        cell.ImgPriority.image = IssueArray[(indexPath as NSIndexPath).row].Priority!.image
        
        cell.lbl_Project_Name.isHidden = true
        
        if IssueArray[(indexPath as NSIndexPath).row].IssueRead! == 0 {
            cell.lbl_WorkNoteCount.text = "N"
            cell.lbl_WorkNoteCount.backgroundColor = UIColor(hexString: "#ff5c72")
        }
        else
        {
            if IssueArray[(indexPath as NSIndexPath).row].WorkNoteCount! == 0 {
                cell.lbl_WorkNoteCount.isHidden = true
            }
            else
            {
                cell.lbl_WorkNoteCount.text = String(IssueArray[(indexPath as NSIndexPath).row].WorkNoteCount!)
                
            }
        }
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //performSegueWithIdentifier("ProjectIssueListToMessage", sender: self)
        
        Issue_ID = IssueArray[(indexPath as NSIndexPath).row].IssueNo
        
        performSegue(withIdentifier: "ProjectIssueToEdit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProjectIssueToNewissue"
        {
            let ViewController = segue.destination as! NewIssueViewController
            
            //print(SelectPM_ID)
            
            ViewController.ModelID = String(PM_ID!)
            print(String(PM_ID!))
            ViewController.ModelName = PM_Title
        }else if segue.identifier == "ProjectIssueToEdit"
        {
            
            let ViewController = segue.destination as! EditIssueViewController
            
            ViewController.Issue_ID = Issue_ID
            
        }
        
        
    }
    
    
    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
}
