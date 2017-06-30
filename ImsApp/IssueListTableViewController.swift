//
//  IssueListTableViewController.swift
//  ImsApp
//
//  Created by 俞兆 on 2016/7/1.
//  Copyright © 2016年 Mark. All rights reserved.
//

import UIKit

import Alamofire
import AlamofireImage
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class IssueInfo
{
    var Priority: UIImageView?
    var Author: String?
    var Owner:String?
    var Subject:String?
    var IssueDate:String?
    var IssueNo:String?
    var Status:String?
    var CreateDate:String?
    var WorkNoteCount:String?
    var ProjectName:String?
    var IssueRead:Int?
    var WorkNoteRead:Int?
    var PrioritySort:Int?
    var Work_ID:String?
}

class IssueListTableViewController: UITableViewController,QRCode_Scan_Delegate,NewIssueViewViewDelegate {
    
    var PM_ID:String?
    
    var Issue_ID:String?
    
    var IssueArray = [IssueInfo]()
    
    var QR_Code_Scan_Text:String?
    
    //var IssueListRefresh: UIRefreshControl!
    
    var DateRangeNum = 12
    
    @IBOutlet var ImsTable: UITableView!
    @IBAction func Btn_IssueList_Click(_ sender: AnyObject) {
        
        
        
        
    }
    
    func Cancel_NewIssue()
    {
        self.tabBarController?.tabBar.isHidden = false
        
        self.navigationController?.isNavigationBarHidden = false
    }
    func Finish_Issue()
    {
    
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        if AppUser.WorkID! != "" {
            
            Issue_List(AppUser.WorkID!,DateRange: DateRangeNum)
        }
        refreshControl.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = UserDefaults.standard
        let hasViewedWalkthrough = defaults.bool(forKey: "hasViewedWalkthrough")
        
        if hasViewedWalkthrough {
            return
        }
        
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? WalkthroughPageViewController {
            
            present(pageViewController, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let nib = UINib(nibName: "ImsCellNib", bundle: nil)
        
        ImsTable.register(nib, forCellReuseIdentifier: "IMSIssueCell")
        
        self.refreshControl?.addTarget(self, action: #selector(IssueListTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)

        if AppUser.WorkID! != "" {
            
            Issue_List(AppUser.WorkID!,DateRange: DateRangeNum)
        }
        else
        {
            
            
        }
        //let photo2 = UIImage(named: "btn_share_nav_newissue")!
        
        //let add = UIBarButtonItem(image: photo2, landscapeImagePhone: photo2, style: .plain, target: self, action: #selector(QR_CodeScan))
        //navigationItem.rightBarButtonItems = [add]
        
        initNavigationItemTitleView("Issue"  + "\n" + "▼")
    }
    
    fileprivate func initNavigationItemTitleView(_ TitleText:String) {
        let titleView = UILabel()
        titleView.text = TitleText
        titleView.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        titleView.textColor = UIColor.white
        titleView.tintColor = UIColor.white
        let width = titleView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
        titleView.frame = CGRect(origin:CGPoint.zero, size:CGSize(width: width, height: 500))
        self.navigationItem.titleView = titleView
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(IssueListTableViewController.titleWasTapped))
        titleView.isUserInteractionEnabled = true
        titleView.addGestureRecognizer(recognizer)
    }
    
    func titleWasTapped()
    {
        let optionMenu = UIAlertController(title: nil,message: "Issue Sort",preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title:"Cancel",style:.cancel,handler:nil)
        
        let updateTimeAction = UIAlertAction(title:"UpdateTime",style:.default,handler: {
            (ACTION:UIAlertAction!) -> Void in self.UpdateTimeTap()})
        
        let priorityAction = UIAlertAction(title:"Priority",style:.default,handler: {
            (ACTION:UIAlertAction!) -> Void in self.PriorityTap()})
        
        
        optionMenu.addAction(updateTimeAction)
        
        optionMenu.addAction(priorityAction)
        
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func PriorityTap()
    {
        
        IssueArray.sort(by: { $0.PrioritySort < $1.PrioritySort })
        
        self.ImsTable.reloadData()
        
        
    }
    
    func UpdateTimeTap()
    {
         IssueArray.sort(by: { $0.CreateDate > $1.CreateDate })
        
        self.ImsTable.reloadData()
    }
    
    func Issue_List(_ WorkID:String,DateRange:Int)
    {
        
        
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Find_My_Issue_List", parameters: ["F_Keyin": WorkID,"DateRange":DateRange])
            .responseJSON { response in
                self.IssueArray = [IssueInfo]()
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        //print(Jstring)
                        
                        for IssueInfomation in (ObjectString )! {
                            
                            let IssueDetail = IssueInfo()
                            
                            if (IssueInfomation["F_Owner"] as? String) != nil {
                                
                                IssueDetail.Owner = IssueInfomation["F_Owner"] as? String
                                
                            }
                            else
                            {
                                IssueDetail.Owner = ""
                            }
                            
                            if (IssueInfomation["Issue_Author"] as? String) != nil {
                                
                                IssueDetail.Author =  IssueInfomation["Issue_Author"] as? String
                                
                            }
                            else
                            {
                                IssueDetail.Author =  ""
                            }
                            
                            if (IssueInfomation["F_SeqNo"] as? NSNumber) != nil {
                                
                                IssueDetail.IssueNo = String(describing: (IssueInfomation["F_SeqNo"] as! NSNumber))
                            }
                            else
                            {
                                IssueDetail.IssueNo = ""
                            }
                            
                            if (IssueInfomation["F_Priority"] as? String) != nil {
                                
                                IssueDetail.Priority =  AppClass.PriorityImage((IssueInfomation["F_Priority"] as? String)!)
                                
                                IssueDetail.PrioritySort = Int(IssueInfomation["F_Priority"] as! String)
                                
                            }
                            
                            if (IssueInfomation["F_Subject"] as? String) != nil {
                                
                                IssueDetail.Subject =  IssueInfomation["F_Subject"] as? String
                                
                            }
                            else
                            {
                                IssueDetail.Subject = ""
                            }
                            
                            if (IssueInfomation["F_CreateDate"] as? String) != nil {
                                
                                IssueDetail.CreateDate =  IssueInfomation["F_CreateDate"] as? String
                                
                            }
                            else
                            {
                                IssueDetail.CreateDate = ""
                            }
                            
                            if (IssueInfomation["F_Status"] as? String) != nil {
                                
                                IssueDetail.Status =  IssueInfomation["F_Status"] as? String
                                
                            }
                            else
                            {
                                IssueDetail.Status = ""
                            }
                            if (IssueInfomation["WorkNotesCount"] as? Int64) != nil {
                                
                                IssueDetail.WorkNoteCount =  String(describing: IssueInfomation["WorkNotesCount"] as? Int64)
                                
                            }
                            else
                            {
                                IssueDetail.WorkNoteCount = ""
                            }
                            
                            if (IssueInfomation["Model"] as? String) != nil {
                                
                                IssueDetail.ProjectName =  IssueInfomation["Model"] as? String
                                
                            }
                            else
                            {
                                IssueDetail.ProjectName = ""
                            }
                            if (IssueInfomation["Read"] as? NSNumber) != nil {
                                
                                IssueDetail.IssueRead =  Int((IssueInfomation["Read"] as? NSNumber)!)
                                
                            }
                            
                            
                            if (IssueInfomation["CommentRead"] as? NSNumber) != nil {
                                
                                IssueDetail.WorkNoteRead =  Int((IssueInfomation["CommentRead"] as? NSNumber)!)
                                
                            }
                            
                            self.IssueArray.append(IssueDetail)
                        }
                        
                        self.ImsTable.reloadData()
                        
                    }
                    
                    
                }
                
        }
        
    }
    
    func QKCode_Scan_Finish()
    {
        self.tabBarController?.tabBar.isHidden = false
        
        self.navigationController?.isNavigationBarHidden = false
        
        performSegue(withIdentifier: "IssueListToWrite", sender: self)
    }
    
    func QR_CodeScan()
    {
        let QRCode_Scan = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QRCodeScanSelected") as! QRCodeScan
        
        QRCode_Scan.delegate = self
        
        self.addChildViewController(QRCode_Scan)
        
        QRCode_Scan.view.frame = self.view.frame
        
        self.view.addSubview(QRCode_Scan.view)
        
        QRCode_Scan.didMove(toParentViewController: self)
        
        //self.tabBarController?.tabBar.hidden = true
        
        //self.navigationController?.navigationBarHidden = true
        
        
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
        
       // cell.lbl_Issue_No.text = "#"  + IssueArray[(indexPath as NSIndexPath).row].IssueNo!
        
        cell.lbl_Issue_No.text = IssueArray[(indexPath as NSIndexPath).row].Owner
        
        cell.lbl_Issue_Subject.text = IssueArray[(indexPath as NSIndexPath).row].Subject
        
        cell.ImgPriority.image = IssueArray[(indexPath as NSIndexPath).row].Priority!.image
        
        cell.lbl_Project_Name.text = "MS-" + IssueArray[(indexPath as NSIndexPath).row].ProjectName!
        
        if IssueArray[(indexPath as NSIndexPath).row].IssueRead == 0 {
            
            cell.lbl_WorkNoteCount.text = "N"
            
            cell.lbl_WorkNoteCount.backgroundColor = UIColor(hexString: "#ff5c72")
        }
        else
        {
            if IssueArray[(indexPath as NSIndexPath).row].WorkNoteRead == 0 {
                
                //cell.lbl_WorkNoteCount.isHidden = true
                
            }
            else
            {
                cell.lbl_WorkNoteCount.text = String(IssueArray[(indexPath as NSIndexPath).row].WorkNoteRead!)
            }
        }
        
        if IssueArray[(indexPath as NSIndexPath).row].IssueNo! == "493693"
        {
            print(IssueArray[(indexPath as NSIndexPath).row].IssueRead!)
            print(IssueArray[(indexPath as NSIndexPath).row].WorkNoteRead!)
        }
        
        if IssueArray[(indexPath as NSIndexPath).row].Status! == "5" {
            cell.backgroundColor = UIColor(hexString: "#e4e7e9")
        }else
        {
            cell.backgroundColor = UIColor.clear
            
        }
                
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //performSegueWithIdentifier("IssueListToMessage", sender: self) //氣泡對話視窗
        
        Issue_ID = IssueArray[(indexPath as NSIndexPath).row].IssueNo
        
        self.tabBarController?.tabBar.isHidden = true
        
        performSegue(withIdentifier: "IssueListToEdit", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "IssueListToEdit" {
            
            let ViewController = segue.destination as! EditIssueViewController
            
            ViewController.Issue_ID = Issue_ID
            
        }
        else if(segue.identifier == "IssueListToWrite")
        {
            let ViewController = segue.destination as! NewIssueViewController
            
            ViewController.FromScanText = QR_Code_Scan_Text!
            
            self.tabBarController?.tabBar.isHidden = true
        }
        
        
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
