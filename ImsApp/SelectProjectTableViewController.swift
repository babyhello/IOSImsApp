//
//  SelectProjectTableViewController.swift
//  com.msi.IMSApp
//
//  Created by 俞兆 on 2016/7/25.
//  Copyright © 2016年 Mark. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SearchProject
{
    var ModelID: String?
    var ModelName: String?
    var ModelPic:String?
    //var ModelSelect:Bool?
}

class SearchProject_Cell:UITableViewCell
{

    @IBOutlet weak var Img_Select: UIImageView!
    @IBOutlet weak var Img_Project: UIImageView!
    @IBOutlet weak var lbl_Project: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class SelectProjectTableViewController: UITableViewController,UISearchResultsUpdating, UISearchBarDelegate {
    
    var searchController: UISearchController!
    var shouldShowSearchResults = false
    @IBOutlet weak var Sbr_Project: UISearchBar!
  
    var request: Request?
    @IBOutlet var Search_Project_Table: UITableView!
    var SearchProjectList = [SearchProject]()
    var SelectModel = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
        Search_ProjectList("%")
        
        configureSearchController()
    }

    
    
    func Search_ProjectList(_ ModelName:String)
    {
        self.clearsSelectionOnViewWillAppear = true
        
        SearchProjectList = [SearchProject]()
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Find_Project_List_Search", parameters: ["ModelName": ModelName])
            .responseJSON { response in
                
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        for ModelInfo in (ObjectString )! {
                            
                            var ModelID:String?
                            var ModelName: String?
                            var ModelPic:String?
                            
                            if (ModelInfo["ModelID"]! as? NSNumber) != nil {
                                
                                ModelID = String(describing: ModelInfo["ModelID"]! as? NSNumber)
                                
                            }
                            
                            
                            
                            if (ModelInfo["ModelName"] as? String) != nil {
                                
                                ModelName =  ModelInfo["ModelName"] as? String
                                
                                //print(Image!)
                                
                                //Image = "http:" + (Image)!
                                
                                //print(Image!)
                            }
                            
                            if (ModelInfo["ModelPic"] as? String) != nil {
                                
                                ModelPic =  ModelInfo["ModelPic"] as? String
                                
                                ModelPic = "http:" + ModelPic!
                            }
                            
                         
                            
                            let _SearchProject =  SearchProject()
                            
                            _SearchProject.ModelID = ModelID
                            
                            _SearchProject.ModelName = ModelName
                            
                            _SearchProject.ModelPic = ModelPic
                            
                            //_SearchProject.ModelSelect = false
                            
                            self.SearchProjectList.append(_SearchProject)
                        }
                        
                        self.Search_Project_Table.reloadData()
                        
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

 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        return SearchProjectList.count
    }

//    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! SearchProject_Cell
//        
//        if SearchProjectList[indexPath.row].ModelPic != nil
//        {
//            let ImgPath = SearchProjectList[indexPath.row].ModelPic
//            
//            loadImage(ImgPath!,ImageView: cell.Img_Project)
//        }
//        
//        cell.lbl_Project.text = SearchProjectList[indexPath.row].ModelName
//        
//        //cell.Img_Select.image = UIImage.init(named: "radiobtn_nor")
//        
//        cell.accessoryType = UITableViewCellAccessoryType.None
//        
//        SearchProjectList[indexPath.row].ModelSelect = false
//        
//        self.Search_Project_Table.reloadData()
//    }
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        //let indexPathx = tableView.indexPathForSelectedRow!
        let cell = self.tableView.cellForRow(at: indexPath) as! SearchProject_Cell
        //let cell = self.tableView.cellForRowAtIndexPath(indexPathx) as! SearchProject_Cell
        
        if SearchProjectList[(indexPath as NSIndexPath).row].ModelPic != nil
        {
            let ImgPath = SearchProjectList[(indexPath as NSIndexPath).row].ModelPic
            
            //loadImage(ImgPath!,ImageView: cell.Img_Project)
            
            AppClass.WebImgGet(ImgPath!,ImageView: cell.Img_Project)
        }
        
        cell.lbl_Project.text = SearchProjectList[(indexPath as NSIndexPath).row].ModelName
        
        let ModelID = SearchProjectList[(indexPath as NSIndexPath).row].ModelID
        
        SelectModel = ModelID!
        
//        for SearchProject in SearchProjectList {
//            
//            if SearchProject.ModelSelect == true
//            {
//                SearchProject.ModelSelect = false
//            }
//            
//            
//        }
//        
//        SearchProjectList[indexPath.row].ModelSelect = true
        
        self.Search_Project_Table.reloadData()
        //self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        

    }
    
    //override func tableview
//    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
//        let selectedIndexPaths = indexPathsForSelectedRowsInSection(indexPath.section)
//        
//        if selectedIndexPaths?.count == 1 {
//            tableView.deselectRowAtIndexPath(selectedIndexPaths!.first!, animated: true)
//        }
//        
//        return indexPath
//    }
//    
//    func indexPathsForSelectedRowsInSection(section: Int) -> [NSIndexPath]? {
//        return (tableView.indexPathsForSelectedRows! as? [NSIndexPath])?.filter({ (indexPath) -> Bool in
//            indexPath.section == section
//        })
//    }
//    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Search_Project_Cell", for: indexPath) as! SearchProject_Cell
        
        //let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! SearchProject_Cell
        
        if SearchProjectList.count > (indexPath as NSIndexPath).row {
            
            if SearchProjectList[(indexPath as NSIndexPath).row].ModelPic != nil
            {
                if SearchProjectList[(indexPath as NSIndexPath).row].ModelPic != nil
                {
                    
                    let ImgPath = SearchProjectList[(indexPath as NSIndexPath).row].ModelPic
                    
                    //loadImage(ImgPath!,ImageView: cell.Img_Project)
                    AppClass.WebImgGet(ImgPath!,ImageView: cell.Img_Project)
                }
                else
                {
                    cell.Img_Project.image = UIImage.init(named: "msi")
                }
                
            }
            else
            {
                cell.Img_Project.image = UIImage.init(named: "msi")
            }
            
            cell.lbl_Project.text = SearchProjectList[(indexPath as NSIndexPath).row].ModelName
            
//            if (SearchProjectList[indexPath.row].ModelSelect != nil) {
//                if SearchProjectList[indexPath.row].ModelSelect == true {
//                    
//                    cell.Img_Select.image = UIImage.init(named: "radiobtn_sel")
//
//                }
//                else
//                {
//                   cell.Img_Select.image = UIImage.init(named: "radiobtn_nor")
//                }
//            }
//            else
//            {
//            cell.Img_Select.image = UIImage.init(named: "radiobtn_nor")
//            }
            if SelectModel != "" {
                if (SelectModel == SearchProjectList[(indexPath as NSIndexPath).row].ModelID)
                {
                    cell.Img_Select.image = UIImage.init(named: "radiobtn_sel")
                }
                else
                {
                    cell.Img_Select.image = UIImage.init(named: "radiobtn_nor")
                    
                }

            } else
            {
                cell.Img_Select.image = UIImage.init(named: "radiobtn_nor")
            }
            
            
        }
       
        
       

        return cell
    }
 
  
    func populateCell(_ image: UIImage,ImageView:UIImageView) {
        
        ImageView.image = image
        
    }
    
    
    
    func configureSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
    
        Search_Project_Table.tableHeaderView = searchController.searchBar
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        guard let searchString = searchController.searchBar.text else {
            return
        }
        Search_ProjectList(searchString)    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        guard let searchString = searchController.searchBar.text else {
            return
        }
Search_ProjectList(searchString)
        //Search_Project_Table.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            guard let searchString = searchController.searchBar.text else {
                return
            }
            
            shouldShowSearchResults = true
            Search_ProjectList(searchString)
            //Search_Project_Table.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        Search_ProjectList(searchString)
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
