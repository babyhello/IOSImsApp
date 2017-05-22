//
//  TestTeableViewAutoHeightViewController.swift
//  IMS
//
//  Created by 俞兆 on 2017/3/20.
//  Copyright © 2017年 Mark. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class Issue_Command_Test
{
    var Command_Author: String?
    var Command_Time: String?
    var Command_Content: String?
    var Command_Author_WorkID:String?
    //var FileType: String?
}

class TestTeableViewAutoHeightViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var TB_Content: UITableView!
    var Issue_Command_List = [Issue_Command_Test]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        TB_Content.delegate = self
        TB_Content.dataSource = self
        TB_Content.reloadData()
        
                TB_Content.estimatedRowHeight = 60
                TB_Content.rowHeight = UITableViewAutomaticDimension
       
        Get_Issue_Command("498701")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func Get_Issue_Command(_ Issue_ID:String)
    {
        Issue_Command_List = [Issue_Command_Test]()
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Find_Issue_Comment", parameters: ["Issue_ID": Issue_ID])
            .responseJSON { response in
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        
                        for IssueInfo in (ObjectString )! {
                            
                            let _Issue_Command = Issue_Command_Test()
                            
                            let Issue_Command_Author = IssueInfo["F_Owner"] as! String
                            let Issue_Command_Date = IssueInfo["F_CreateDate"] as! String
                            
                            let Issue_Command_Content = IssueInfo["F_Comment"] as! String
                            let Issue_Command_WorkID = IssueInfo["F_Keyin"] as! String
                            _Issue_Command.Command_Author_WorkID = Issue_Command_WorkID
                            _Issue_Command.Command_Author = Issue_Command_Author
                            _Issue_Command.Command_Content = Issue_Command_Content
                            _Issue_Command.Command_Time = Issue_Command_Date
                            
                            self.Issue_Command_List.append(_Issue_Command)
                        }
                        
                        self.TB_Content.reloadData()
                        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Issue_Command_List.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:EditIssueTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WorkNoteCell") as! EditIssueTableViewCell
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        let attrString = NSMutableAttributedString(string: Issue_Command_List[(indexPath as NSIndexPath).row].Command_Content!)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        
        cell.Img_Command_Author.image = UIImage(named: "default man avatar")
        
        AppClass.WebImgGet(AppClass.ImagePath + Issue_Command_List[(indexPath as NSIndexPath).row].Command_Author_WorkID! + ".jpg",ImageView: cell.Img_Command_Author)
        cell.Img_Command_Author.layer.cornerRadius = cell.Img_Command_Author.frame.width/2.0
        
        cell.Img_Command_Author.clipsToBounds = true
        
        cell.lbl_Command_Time.text = AppClass.DateStringtoShortDate(Issue_Command_List[(indexPath as NSIndexPath).row].Command_Time!)
        cell.lbl_Command_Author.text = Issue_Command_List[(indexPath as NSIndexPath).row].Command_Author
        cell.lbl_Command_Content.attributedText = attrString
        
        return cell
    }


}
