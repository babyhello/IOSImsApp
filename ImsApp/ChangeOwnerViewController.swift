//
//  ChangeOwnerViewController.swift
//  IMS
//
//  Created by 俞兆 on 2017/6/22.
//  Copyright © 2017年 Mark. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ChangeOwnerViewController: UITableViewController,UISearchResultsUpdating, UISearchBarDelegate  {

    var searchController: UISearchController!
    var shouldShowSearchResults = true

    var ModelMemberArray = [ModelMember]()
    
    var ModelHeaderArray =  [String]()
    
    var PM_Title:String?
    
    var ModelID:String?
    
    var SelectIndex:Int?

    var SelectSection:Int?
    
    var AuthorNameCN:String?
    
    var AuthorNameEN:String?
    
    var IssueNo:String?
    
    @IBOutlet weak var MemberSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(ModelID! + "Owner")
        
        Model_Member(ModelID!)

        title = "Change Owner"
        
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(Finish_Issue))
        
        navigationItem.rightBarButtonItem = done
        
        self.tableView.dataSource = self
        
//        AuthorNameCN = "陳俞兆"
//        
//        AuthorNameEN = "Markycchen"
//        
//        IssueNo = "504207"
    }

    func Finish_Issue()
    {

        
        let MemberArray =  ModelMemberArray.filter{$0.Header! == ModelHeaderArray[SelectSection!]}
        
        let NewOwner = MemberArray[SelectIndex!].MemberName
        
        let NewOwnerWorkID = MemberArray[SelectIndex!].F_ID

        
        var CommentText = "◎Issue Owner Change： 『" + AuthorNameCN!
        
        CommentText += " " + AuthorNameEN! + "』change to 『"
        
        CommentText +=  NewOwner! + "』";
        
        if (!(AppUser.WorkID?.isEmpty)! && !NewOwner!.isEmpty)
        {
            Change_Issue_Owner(NewOwnerWorkID!, IssueID: IssueNo!)
            
            Comment_Insert(AppUser.WorkID!, IssueID: IssueNo!, Comment: CommentText)
            
            
        }

        
    }
    
    
    func Change_Issue_Owner(_ WorkID:String,IssueID:String)
    {
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Change_Issue_Owner", parameters: ["IssueID": IssueID,"WorkID":WorkID])
            .responseJSON { response in
                
        }
        
    }
    func Comment_Insert(_ WorkID:String,IssueID:String,Comment:String)
    {
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/C_Comment_Insert", parameters: ["F_Keyin": WorkID,"F_Master_Table":"C_Issue","F_Master_ID":IssueID,"F_Comment":Comment])
            .responseJSON { response in
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        let IssueInfo = ObjectString!
                        
                        
                        if IssueInfo.count > 0
                        {
                            if(IssueInfo[0]["CommentNo"] as? String != nil)
                            {
                                let CommentNo =  IssueInfo[0]["CommentNo"] as? String
                                
                                _ = self.navigationController?.popViewController(animated: true)
                                
                            }
                            
                            
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

    
    func Model_Member(_ ModelID:String)
    {
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Find_Model_Member", parameters: ["PM_ID": ModelID])
            .responseJSON { response in
                
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        for IssueInfomation in (ObjectString )! {
                            
                            let _ModelMember = ModelMember()
                            
                            if (IssueInfomation["FullName"] as? String) != nil {
                                
                                _ModelMember.MemberName = IssueInfomation["FullName"] as? String
                                
                            }
                            else
                            {
                                _ModelMember.MemberName = ""
                            }
                            
                            if (IssueInfomation["F_Title"] as? String) != nil {
                                
                                _ModelMember.Header = IssueInfomation["F_Title"] as? String
                                
                            }
                            else
                            {
                                _ModelMember.Header = "Normal"
                            }
                            
                            if (IssueInfomation["F_Tel"] as? String) != nil {
                                
                                _ModelMember.F_Tel = IssueInfomation["F_Tel"] as? String
                                
                            }
                            else
                            {
                                _ModelMember.F_Tel = ""
                            }
                            
                            if (IssueInfomation["F_ID"] as? String) != nil {
                                
                                _ModelMember.F_ID = IssueInfomation["F_ID"] as? String
                                
                            }
                            else
                            {
                                _ModelMember.F_ID = ""
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
        return 22.0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeOwnerMemberCell", for: indexPath)
        
        let MemberArray =  ModelMemberArray.filter{$0.Header == ModelHeaderArray[(indexPath as NSIndexPath).section]}
        
        cell.detailTextLabel!.text = MemberArray[(indexPath as NSIndexPath).row].F_Tel
        
        cell.detailTextLabel!.font.withSize(13)
        
        cell.detailTextLabel!.textColor = UIColor(hexString: "#a1a4b0")
        
        cell.textLabel!.font.withSize(16)
        
        cell.textLabel!.textColor = UIColor(hexString: "#212121")
        
        cell.textLabel!.text = MemberArray[(indexPath as NSIndexPath).row].MemberName
       
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
            }
            else{
                cell.accessoryType = .checkmark
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            cell.accessoryType = .checkmark
            
            SelectIndex = indexPath.row
            
            SelectSection = indexPath.section
        
        }
    }
    
 
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ModelHeaderArray[section]
    }
    
    
    
    func configureSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        guard let searchString = searchController.searchBar.text else {
            return
        }
        //Search_ProjectList(searchString)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        guard let searchString = searchController.searchBar.text else {
            return
        }
        //Search_ProjectList(searchString)
        //Search_Project_Table.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            guard let searchString = searchController.searchBar.text else {
                return
            }
            
            shouldShowSearchResults = true
            //Search_ProjectList(searchString)
            //Search_Project_Table.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        //Search_ProjectList(searchString)
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
