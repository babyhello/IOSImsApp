//
//  NotificationTableViewController.swift
//  com.msi.IMSApp
//
//  Created by 俞兆 on 2016/8/29.
//  Copyright © 2016年 Mark. All rights reserved.
//

import UIKit

import Alamofire
import AlamofireImage

class NotificationCell:UITableViewCell
{
    @IBOutlet weak var Img_Author: UIImageView!
    
    @IBOutlet weak var Vw_Cell: UIView!
    @IBOutlet weak var lbl_Author: UILabel!
    @IBOutlet weak var lbl_Notification_Time: UILabel!
    @IBOutlet weak var lbl_Notification_Title: UILabel!
    @IBOutlet weak var lbl_Notification_Detail: UILabel!
}

class Notification
{
    var Author:String?
    var Title:String?
    var Detail:String?
    var Author_WorkID:String?
    var Time:String?
    var Issue_ID:String?
}

class NotificationTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var NotificationList = [Notification]()
    @IBOutlet weak var TB_Notification: UITableView!
    var Issue_ID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //title = "Notification"
        
        self.TB_Notification.dataSource = self
        self.TB_Notification.delegate = self
        self.TB_Notification.reloadData()
        
        self.TB_Notification.estimatedRowHeight = 120
        
        
        self.TB_Notification.rowHeight = UITableViewAutomaticDimension

        if AppUser.WorkID != "" {
            Get_Notification_List(AppUser.WorkID!)
        }
        
        self.TB_Notification.separatorStyle = .none

        
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return NotificationList.count
    }
    
    func Get_Notification_List(_ WorkID:String)
    {
        NotificationList = [Notification]()
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Find_MobileSystemMessage")
            .responseJSON { response in
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        for NotificationInfo in (ObjectString )! {
                            
                            let _NotificationInfo = Notification()
                            
//                            String F_Owner = ModelData.getString("F_Owner");
//                            
//                            String F_MsgType = ModelData.getString("Title");
//                            
//                            String F_Subject = ModelData.getString("F_Content");
//                            
//                            F_Subject = F_Subject.replace("<br />", "\n");
//                            
//                            String F_CreateDate = AppClass.ConvertDateString(ModelData.getString("F_CreateDate"));
//                            
//                            String F_Desc = ModelData.getString("F_Desc");
                            
                            if (NotificationInfo["F_Owner"] as? String) != nil {
                                
                                _NotificationInfo.Author = NotificationInfo["F_Owner"] as? String
                                
                            }
                            else
                            {
                                _NotificationInfo.Author = ""
                            }
                            
                            _NotificationInfo.Author = "IMS Post"
                            
                            if (NotificationInfo["Title"] as? String) != nil {
                                
                                _NotificationInfo.Title = NotificationInfo["Title"] as? String
                                
                            }
                            else
                            {
                                _NotificationInfo.Title = ""
                            }
                            
                            
                            if (NotificationInfo["F_Content"] as? String) != nil {
                                
                                _NotificationInfo.Detail = NotificationInfo["F_Content"] as? String
                                
                            }
                            else
                            {
                                _NotificationInfo.Detail = ""
                            }
                            
                            
                            
                            if (NotificationInfo["F_CreateDate"] as? String) != nil {
                                
                                _NotificationInfo.Time = NotificationInfo["F_CreateDate"] as? String
                                
                            }
                            else
                            {
                                _NotificationInfo.Time = ""
                            }
                            
//                            if (NotificationInfo["F_Keyin"] as? String) != nil {
//                                
//                                _NotificationInfo.Author_WorkID = NotificationInfo["F_Keyin"] as? String
//                                
//                            }
//                            else
//                            {
//                                _NotificationInfo.Author_WorkID = ""
//                            }
//                            
//                            if (NotificationInfo["F_Master_ID"] as? NSNumber) != nil {
//                                
//                                _NotificationInfo.Issue_ID = String(describing: (NotificationInfo["F_Master_ID"] as! NSNumber))
//                                //print(IssueDetail.IssueNo!)
//                            }

                            
                            self.NotificationList.append(_NotificationInfo)
                        }
                        
                        self.TB_Notification.reloadData()
                        
                    }
                    
                }
                
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        
        cell.Img_Author.image = UIImage(named: "default man avatar")

        cell.lbl_Author.text = NotificationList[(indexPath as NSIndexPath).row].Author
        
        cell.lbl_Notification_Time.text = AppClass.DateStringtoShortDate(NotificationList[(indexPath as NSIndexPath).row].Time!)
        
        cell.lbl_Notification_Detail.text = NotificationList[(indexPath as NSIndexPath).row].Detail
        
        cell.lbl_Notification_Title.text = NotificationList[(indexPath as NSIndexPath).row].Title
        
        cell.Vw_Cell.layer.borderColor = UIColor(hexString: "#dfe1e7").cgColor
        
        cell.Vw_Cell.layer.borderWidth = 1
        
//        AppClass.WebImgGet(AppClass.ImagePath + NotificationList[(indexPath as NSIndexPath).row].Author_WorkID! + ".jpg", ImageView: cell.Img_Author)
        
       
        
        cell.Img_Author.layer.cornerRadius = cell.Img_Author.frame.width/2.0
        
        cell.Img_Author.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell

        cell.Vw_Cell.backgroundColor = UIColor.gray
        
        Issue_ID = NotificationList[(indexPath as NSIndexPath).row].Issue_ID
        
        //performSegue(withIdentifier: "NotificationToEditIssue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        cell.Vw_Cell.backgroundColor = UIColor.white
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NotificationToEditIssue"
        {
//            let ViewController = segue.destination as! EditIssueViewController
//            
//           ViewController.Issue_ID = Issue_ID
            
            
        }
    }
    
}
