//
//  ExpandTableProjectListViewController.swift
//  IMS
//
//  Created by 俞兆 on 2017/5/23.
//  Copyright © 2017年 Mark. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ExpandTableProjectInfo
{
    var ProjectName: String?
    var Image: String?
    var CloseRate:String?
    var PM_ID:String?
    init(text: String?,image: String?,CloseRate:String?,PM_ID:String?) {
        // Default type is Mine
        self.ProjectName = text
        self.Image = image
        self.CloseRate = CloseRate
        self.PM_ID = PM_ID
    }
    
}

class ExpandTableProjectListViewController: UITableViewController,PopUpProjectSelectViewDelegate,NewIssueViewViewDelegate,UISearchResultsUpdating, UISearchBarDelegate,UIPopoverPresentationControllerDelegate {

    
    
    
    var request: Request?
    
    //@IBOutlet var ImsProjectTable: UITableView!
    
    var ProjectInfroList = [ExpandTableProjectInfo]()
    
    var SelectPM_ID:String?
    
    var SelectPM_Name:String?
    
    var searchController: UISearchController!
    
    var shouldShowSearchResults = false
    
    // var refreshControl: UIRefreshControl!
    
    @IBAction func Btn_Project_Click(_ sender: AnyObject) {
        
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ProjectCellNib", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "ImsProjectCell")
        
        self.clearsSelectionOnViewWillAppear = true
        
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "")
        refreshControl?.addTarget(self, action: #selector(ProjectListTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        tableView.addSubview(refreshControl!) // not required when using UITableViewController
        
        //        self.refreshControl?.addTarget(self, action: #selector(ProjectIssueListTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        //self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        
        if AppUser.WorkID! != "" {
            
            ProjectList(AppUser.WorkID!,SearchString: "")
        }
        
        
        
        //configureSearchController()
        
        
        
    }
    
    
    
//    func configureSearchController() {
//        
//        searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search here..."
//        searchController.searchBar.delegate = self
//        searchController.searchBar.sizeToFit()
//        
//        self.tableHeaderView = searchController.searchBar
//    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        if AppUser.WorkID! != "" {
            
            
            
            ProjectList(AppUser.WorkID!,SearchString: "" )
        }
        
        refreshControl.endRefreshing()
    }
    
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "New Issue"
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let NewIssue = UITableViewRowAction(style: .default, title: "New\n Issue") { (action, indexPath) in
            
            let ProjectName = self.ProjectInfroList[(indexPath as NSIndexPath).row].ProjectName
            
            self.SelectPM_ID = self.ProjectInfroList[(indexPath as NSIndexPath).row].PM_ID
            
            self.SelectPM_Name = ProjectName
            
            self.tabBarController?.tabBar.isHidden = true
            
            self.performSegue(withIdentifier: "ProjectToNewIssue", sender: self)
            
        }
        
        
        NewIssue.backgroundColor = UIColor(hexString: "#52ADF6")
        
        return [NewIssue]
    }
    //
    //    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    //        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
    //            // delete item at indexPath
    //        }
    //
    //        let share = UITableViewRowAction(style: .normal, title: "Disable") { (action, indexPath) in
    //            // share item at indexPath
    //        }
    //
    //        share.backgroundColor = UIColor.blue
    //
    //        return [delete, share]
    //    }
    
    //    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    //        super.tableView(tableView, editActionsForRowAt: indexPath)
    //    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            
            //let PicPath = ProjectInfroList[indexPath.row].Image
            
            //let CloseRate = ProjectInfroList[indexPath.row].CloseRate
            
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    func Finish_Issue()
    {
        
    }
    func ProjectList(_ WorkID:String,SearchString:String)
    {
        ProjectInfroList = [ExpandTableProjectInfo]()
        
        var Path = AppClass.ServerPath + "/IMS_App_Service.asmx/Find_Project_List"
        
        var _parameters = ["WorkID": WorkID]
        
        if SearchString != "" {
            _parameters = ["ModelName": SearchString]
            
            Path = AppClass.ServerPath + "/IMS_App_Service.asmx/Find_Project_List_Search"
            
        }
        
        
        Alamofire.request( Path, parameters: _parameters)
            .responseJSON { response in
                
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        for ModelInfo in (ObjectString )! {
                            
                            var Name:String?
                            
                            var Image:String?
                            
                            var CloseRate:String?
                            
                            var Service_PM_ID:String?
                            
                            if (ModelInfo["ModelName"] as? String) != nil {
                                
                                Name = ModelInfo["ModelName"] as? String
                                
                            }
                            
                            if (ModelInfo["ModelPic"] as? String) != nil {
                                
                                //print(ModelInfo)
                                Image =  ModelInfo["ModelPic"] as? String
                                
                                
                                Image = "http:" + (Image)!
                                
                                
                                
                                
                                //print(Image!)
                            }
                            
                            if (ModelInfo["CloseRate"]) != nil {
                                
                                
                                let TempCloseRate = ModelInfo["CloseRate"]!
                                
                                CloseRate =  String(describing: TempCloseRate)
                                
                                
                                
                            }
                            
                            CloseRate = "0"
                            
                            if (ModelInfo["ModelID"]) != nil {
                                
                                let TempPM_ID = ModelInfo["ModelID"]!
                                
                                Service_PM_ID = String(describing: TempPM_ID)
                                
                                
                            }
                            
                            let ProjectDetail =  ExpandTableProjectInfo(text: Name!, image: Image!,CloseRate: CloseRate,PM_ID: Service_PM_ID)
                            
                            self.ProjectInfroList.append(ProjectDetail)
                        }
                        
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
    
    
    //    override func tableview
    
    func Cancel_NewIssue()
    {
        self.tabBarController?.tabBar.isHidden = false
        
        
        
        
        
        if AppUser.WorkID! != "" {
            
            ProjectList(AppUser.WorkID!,SearchString: "")
        }
        else
        {
            
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
            
            
                   }
        
    }
    
    func  Exit_Click()
    {
        
        super.tabBarController?.tabBar.isHidden = false
        
        super.navigationController?.isNavigationBarHidden = false
        
        
        
    }
    
    func Img_Member_Click() {
        
        super.tabBarController?.tabBar.isHidden = false
        
        super.navigationController?.isNavigationBarHidden = false
        
        
        performSegue(withIdentifier: "ProjectListToMemberList", sender: self)
    }
    
    func Img_Spec_Click() {
        super.tabBarController?.tabBar.isHidden = false
        
        super.navigationController?.isNavigationBarHidden = false
        
        
        performSegue(withIdentifier: "ProjectToSpecList", sender: self)
    }
    
    func Img_Issue_Click() {
        super.tabBarController?.tabBar.isHidden = false
        
        super.navigationController?.isNavigationBarHidden = false
        performSegue(withIdentifier: "ProjectToIssueList", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ProjectInfroList.count
        
    }
    
    func populateCell(_ image: UIImage,ImageView:UIImageView) {
        
        ImageView.image = image
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ProjectCell = tableView.dequeueReusableCell(withIdentifier: "ImsProjectCell") as! ProjectCell
        
        if  (ProjectInfroList.count >= (indexPath as NSIndexPath).row)
        {
            
            let ProjectName = ProjectInfroList[(indexPath as NSIndexPath).row].ProjectName
            
            let PicPath = ProjectInfroList[(indexPath as NSIndexPath).row].Image
            
            cell.ProjectName.text = ProjectName
            
            AppClass.WebImgGet(PicPath!,ImageView: cell.ProjectImage)
            
            //loadImage(PicPath!,ImageView: cell.ProjectImage)
            
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpProjectSelect") as! PopUpProjectSelectViewController
        
        let nav = UINavigationController(rootViewController: popOverVC)
        
        nav.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        let popover = nav.popoverPresentationController
        popOverVC.preferredContentSize = CGSize(width: screenWidth * 0.8, height: screenHeight * 0.6)
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 100, y: 100, width: 0, height: 0)
        
        
        
        
        
        self.tabBarController?.tabBar.isHidden = true
        //
        //        self.navigationController?.isNavigationBarHidden = true
        
        //UITabBar.appearance().backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        
        //self.tabBarController?.tabBar.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        popOverVC.delegate = self
        
        //        self.addChildViewController(popOverVC)
        //        popOverVC.view.frame = self.view.frame
        //
        //        self.view.addSubview(popOverVC.view)
        //
        //        popOverVC.didMove(toParentViewController: self)
        
        //popOverVC.ProjectInfo = ProjectInfroList[(indexPath as NSIndexPath).row]
        
        
        self.clearsSelectionOnViewWillAppear = true
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let ProjectName = ProjectInfroList[(indexPath as NSIndexPath).row].ProjectName
        
        //                let PicPath = ProjectInfroList[(indexPath as NSIndexPath).row].Image
        //
        //                let CloseRate =  ProjectInfroList[(indexPath as NSIndexPath).row].CloseRate
        //
        SelectPM_ID = ProjectInfroList[(indexPath as NSIndexPath).row].PM_ID
        
        SelectPM_Name = ProjectName
        
        self.present(nav, animated: true, completion: nil)
        //self.performSegue(withIdentifier: "ProjectToPopupPresent", sender: self)
        
        
        //
        
        //
        //        popOverVC.lbl_ProjectName.text = ProjectName
        //
        //        popOverVC.lbl_CloseRate.text = CloseRate! + "%"
        //
        //        AppClass.WebImgGet(PicPath!,ImageView: popOverVC.Img_Project)
        //
        //        popOverVC.Img_Project.clipsToBounds = true
        //
    }
    
    func addCategory() {
        
        
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        
        
        if segue.identifier == "ProjectToIssueList" {
            
            let ViewController = segue.destination as! ProjectIssueListTableViewController
            
            ViewController.PM_ID = Int64(SelectPM_ID!)
            
            ViewController.PM_Title = SelectPM_Name
            
        }
        else if segue.identifier == "ProjectToNewIssue"
        {
            print(segue.destination)
            
            let ViewController = segue.destination as! NewIssueViewController
            
            //print(SelectPM_ID)
            
            ViewController.ModelID = SelectPM_ID!
            
            ViewController.ModelName = SelectPM_Name
            
            //ViewController.delegate = self
            
        }
        else if segue.identifier == "ProjectListToMemberList"
        {
            
            let ViewController = segue.destination as! ProjectMemberTableViewController
            
            //print(SelectPM_ID)
            
            ViewController.ModelID = SelectPM_ID!
            
            ViewController.PM_Title = SelectPM_Name
            
            //ViewController.delegate = self
            
        }
        else if segue.identifier == "ProjectToSpecList"
        {
            
            let ViewController = segue.destination as! ProjectSpecTableViewController
            
            //print(SelectPM_ID)
            
            ViewController.ModelID = SelectPM_ID!
            
            ViewController.PM_Title = SelectPM_Name
            
            //ViewController.delegate = self
            
        }
        
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        if searchString != "" {
            ProjectList("",SearchString: searchString)
        }
        
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        guard let searchString = searchController.searchBar.text else {
            return
        }
        ProjectList("",SearchString: searchString)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            guard let searchString = searchController.searchBar.text else {
                return
            }
            
            shouldShowSearchResults = true
            ProjectList("",SearchString: searchString)
            
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        ProjectList("",SearchString: searchString)
    }
    
    //    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return dataArray[section]
    //    }
    //
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
    
    
    
    
}
