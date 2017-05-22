//
//  EditIssueViewController.swift
//  com.msi.IMSApp
//
//  Created by 俞兆 on 2016/8/3.
//  Copyright © 2016年 Mark. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import AlamofireImage



class EditIssueCollectionCell:UICollectionViewCell
{
      
    @IBOutlet weak var Img_Issue: UIImageView!
    
    
    //    override init(frame: CGRect) {
    //        super.init(frame: frame)
    //        //setup()
    //    }
    //
    //    required init(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder)!
    //        //setup()
    //    }
}


class EditIssueTableViewCell:UITableViewCell
{
    
    @IBOutlet weak var Img_Command_Author: UIImageView!
    
    @IBOutlet weak var lbl_Command_Author: UILabel!
    
    @IBOutlet weak var lbl_Command_Time: UILabel!
    
    @IBOutlet weak var lbl_Command_Content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class Issue_File
{
    var FilePath: String?
    var FileType: String?
}

class Issue_Command
{
    var Command_Author: String?
    var Command_Time: String?
    var Command_Content: String?
    var Command_Author_WorkID:String?
    //var FileType: String?
}

class EditIssueViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var VW_IssueInfo: UIView!
    
    @IBOutlet weak var Img_Camera: UIImageView!
    
    @IBOutlet weak var WorkNoteContent: NSLayoutConstraint!
    
    
    @IBOutlet weak var TB_WorkNote: UITableView!

    @IBOutlet weak var lbl_ProjectName: UILabel!
    
    @IBOutlet weak var Img_Author: UIImageView!
    
    @IBOutlet weak var lbl_Author: UILabel!
    
    @IBOutlet weak var lbl_Issue_Subject: UILabel!
    
    @IBOutlet weak var Img_Priority: UIImageView!
    
    @IBOutlet weak var lbl_IssueDate: UILabel!

    
    @IBOutlet weak var lbl_Owner: UILabel!
    
    @IBOutlet weak var Col_Edit_View: UICollectionView!
    
    @IBOutlet weak var WorkNoteMessage: UITextField!
    
    @IBAction func Btn_WorkNote_Send(_ sender: Any) {
    }
    
    var SelectPhoto:UIImage?
    var Issue_File_List = [Issue_File]()
    var Issue_Command_List = [Issue_Command]()
    //var photoList = [Photo]()
    var request: Request?
    var Issue_ID:String?
    var Issue_Keyin:String?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.translatesAutoresizingMaskIntoConstraints = false
        
        navigationController?.delegate = self
        
        let back = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backevent))
        
        navigationItem.leftBarButtonItem = back
        
        let Camera = Img_Camera
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(EditIssueViewController.Camera_Photo_Pic(_:)))
        Camera?.isUserInteractionEnabled = true
        Camera?.addGestureRecognizer(tapGestureRecognizer)
        
                //Col_Edit_View.reloadData()
        
        //TB_WorkNote.translatesAutoresizingMaskIntoConstraints = false
        
        TB_WorkNote.estimatedRowHeight = 80
        TB_WorkNote.rowHeight = UITableViewAutomaticDimension
        
        TB_WorkNote.delegate = self
        TB_WorkNote.dataSource = self
        TB_WorkNote.reloadData()
      
        
        Get_Issue(Issue_ID!)
        Get_Issue_File(Issue_ID!)
        Get_Issue_Command(Issue_ID!)
        Insert_Issue_Read(Issue_ID!)
        WorkNoteMessage.delegate = self
        
        
        
        self.Img_Author.layer.cornerRadius = self.Img_Author.frame.width/2.0
        
        self.Img_Author.clipsToBounds = true
        

        //WorkNoteContent.constant = 50
    }
    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        //print(viewController)
        //viewController.viewDidLoad()
        //        if let controller = viewController as? ProjectIssueListTableViewController {
        //            //controller.viewDidLoad()    // Here you pass the data back to your original view controller
        //        }
        
        if let controller = viewController as? IssueListTableViewController {
            
            if controller.Issue_ID != nil {
                
            }
            
            self.tabBarController?.tabBar.isHidden = false
        }
        
    }
    
    func keyboardWillShow(_ notification:Foundation.Notification)
    {
        var info = (notification as NSNotification).userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.WorkNoteContent.constant = keyboardFrame.size.height
            self.view.setNeedsLayout()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func keyboardWillHide(_ notification:Foundation.Notification)
    {
        WorkNoteContent.constant = 0.0
        view.setNeedsLayout()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        WorkNoteMessage.resignFirstResponder()
        WorkNote_Update()
        
        return true
    }
    
    
    func backevent()
    {
        _ = navigationController?.popViewController(animated: true)
        
        
    }
    
    func Comment_Insert(_ WorkID:String,IssueID:String,Comment:String)
    {
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/C_Comment_Insert", parameters: ["F_Keyin": WorkID,"F_Master_Table":"C_Issue","F_Master_ID":IssueID,"F_Comment":Comment])
            .responseJSON { response in
                self.Get_Issue_Command(self.Issue_ID!)
        }
        
        
    }
    
    func WorkNote_Update()
    {
        let WorkMessage = WorkNoteMessage.text
        
        if WorkMessage != "" {
            
            if AppUser.WorkID! != "" {
                
                Comment_Insert(AppUser.WorkID!,IssueID: Issue_ID!,Comment: WorkMessage!)
                
                WorkNoteMessage.text = ""
            }
        }
        
        // Get_Issue_Command(Issue_ID!)
        
    }
    
    func Get_Issue(_ Issue_ID:String)
    {
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Issue_Get", parameters: ["F_SeqNo": Issue_ID])
            .responseJSON { response in
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        let IssueInfo = ObjectString!
                        
                        
                        if IssueInfo.count > 0
                        {
                            
                            
                            
                            //let Issue_Author = IssueInfo[0]["F_Owner"] as! String
                            //let Issue_Owner = IssueInfo[0]["Issue_Owner"] as! String
                            //let Issue_Date = IssueInfo[0]["F_CreateDate"] as! String
                            //let Issue_Subject = IssueInfo[0]["F_Subject"] as! String
                            //let Issue_Priority = IssueInfo[0]["F_Priority"] as! String
                            //let Issue_ProjectName = IssueInfo[0]["F_ModelName"] as! String
                            
                            if (IssueInfo[0]["F_Owner"] as? String) != nil {
                                
                                self.lbl_Author.text = IssueInfo[0]["F_Owner"] as? String
                                
                            }
                            else
                            {
                                self.lbl_Author.text = ""
                                
                            }
                            
                            
                            if (IssueInfo[0]["Issue_Owner"] as? String) != nil {
                                
                                self.lbl_Owner.text = IssueInfo[0]["Issue_Owner"] as? String
                                
                            }
                            else
                            {
                                self.lbl_Owner.text = ""
                            }
                            
                            if (IssueInfo[0]["F_ModelName"] as? String) != nil {
                                
                                self.lbl_ProjectName.text = "MS-" + (IssueInfo[0]["F_ModelName"] as? String)!
                                
                            }
                            else
                            {
                                self.lbl_ProjectName.text = ""
                            }
                            
                            if (IssueInfo[0]["F_Subject"] as? String) != nil {
                                
                                self.lbl_Issue_Subject.text = IssueInfo[0]["F_Subject"] as? String
                                
                            }
                            else
                            {
                                self.lbl_Issue_Subject.text = ""
                            }
                            
                            if (IssueInfo[0]["F_Priority"] as? String) != nil {
                                
                                self.Img_Priority = AppClass.PriorityImage(IssueInfo[0]["F_Priority"] as! String)
                                
                            }
                            else
                            {
                                //self.Img_Priority = AppClass.PriorityImage(IssueInfo[0]["F_Priority"] as! String)
                            }
                            
                            if (IssueInfo[0]["F_CreateDate"] as? String) != nil {
                                
                                self.lbl_IssueDate.text = AppClass.DateStringtoShortDate( (IssueInfo[0]["F_CreateDate"] as? String)!)
                                
                            }
                            else
                            {
                                self.lbl_IssueDate.text = ""
                            }
                            
                            if (IssueInfo[0]["F_Keyin"] as? String) != nil {
                                
                                self.Issue_Keyin = IssueInfo[0]["F_Keyin"] as? String
                                
                                //self.Img_Author =  self.Get_Issue_Photo(self.Issue_Keyin!)
                                
                                AppClass.WebImgGet(AppClass.ImagePath + self.Issue_Keyin! + ".jpg",ImageView: self.Img_Author)
                                
                                

                                
                            }
                            else
                            {
                                self.Issue_Keyin = ""
                            }

                            
                            
                            self.lbl_Author.adjustsFontSizeToFitWidth = true
                            //                            self.lbl_ProjectName.adjustsFontSizeToFitWidth = true
                        }
                        
                        
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
    
    func Get_Issue_Photo(_ WorkID:String) ->UIImageView
    {
        let Img:UIImageView = UIImageView(image: UIImage(named:"default man avatar"))
        
        AppClass.WebImgGet(AppClass.ImagePath + WorkID + ".jpg",ImageView: Img)
        
//        print(AppClass.ImagePath + WorkID + ".jpg")
//        
//        print(Img)

        //loadImage(AppClass.ImagePath + WorkID + ".jpg",ImageView: Img)
        
        //AppClass.WebImgGet(AppClass.ImagePath + WorkID + ".jpg",ImageView: Img)
      
        return Img
    }
    
    func Get_Issue_File(_ Issue_ID:String)
    {
        Issue_File_List = [Issue_File]()
        
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Issue_File_List", parameters: ["F_SeqNo": Issue_ID])
            .responseJSON { response in
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        for IssueInfo in (ObjectString )! {
                            
                            let _Issue_File = Issue_File()
                            
                            let Issue_File_Path = IssueInfo["F_DownloadFilePath"] as! String
                            
                            _Issue_File.FilePath = "http:" + Issue_File_Path
                          
                            if ((_Issue_File.FilePath?.uppercased().contains("JPG"))! || (_Issue_File.FilePath?.uppercased().contains("PNG"))! || (_Issue_File.FilePath?.uppercased().contains("GIF"))!)
                            {
                            self.Issue_File_List.append(_Issue_File)
                            }
                            
                            
                          
                        }
                        
                        if(self.Issue_File_List.count > 0 )
                        {
                            self.Col_Edit_View.dataSource = self
                            
                            self.Col_Edit_View.delegate = self
                            
                            self.Col_Edit_View.collectionViewLayout.invalidateLayout()
                            
                            self.Col_Edit_View.reloadData()
                        }
                        else
                        {
                            
                             self.VW_IssueInfo.frame = CGRect(x: self.VW_IssueInfo.frame.origin.x, y: self.VW_IssueInfo.frame.origin.y, width: self.VW_IssueInfo.frame.width, height: self.VW_IssueInfo.frame.height - self.Col_Edit_View.frame.height)
                            
                            self.Col_Edit_View.frame = CGRect(x: self.Col_Edit_View.frame.origin.x, y: self.Col_Edit_View.frame.origin.y, width: 0, height: 0)
                                                    }
                        
                        
                        
                        //print(self.Issue_File_List.count)
                        
                    }
                    
                }
        }
        
        

        
    }
    
    func Get_Issue_Command(_ Issue_ID:String)
    {
        Issue_Command_List = [Issue_Command]()
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Find_Issue_Comment", parameters: ["Issue_ID": Issue_ID])
            .responseJSON { response in
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        
                        for IssueInfo in (ObjectString )! {
                            
                            let _Issue_Command = Issue_Command()
                            
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
                        
                        self.TB_WorkNote.reloadData()
                        
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
    func Insert_Issue_Read(_ Issue_ID:String)
    {
        Issue_File_List = [Issue_File]()
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Insert_Issue_Read", parameters: ["F_Master_ID": Issue_ID,"F_Master_Table":"C_Issue","F_Read":"1"])
            .responseJSON { response in
                
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("CollectionViewCount" + String(Issue_File_List.count))
        
        return Issue_File_List.count
    }
    
    func Camera_Photo_Pic(_ sender:AnyObject)
    {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            //imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true,
                                       completion: nil)
            //newMedia = true
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        //let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditCollectionView", for: indexPath) as!  EditIssueCollectionCell
        
        //cell.selected = true
        
        let path = Issue_File_List[(indexPath as NSIndexPath).row].FilePath
        
        //loadImage(path!,ImageView: cell.Img_Issue)
        
        AppClass.WebImgGet(path!,ImageView: cell.Img_Issue)
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //cell.
        cell.backgroundColor = UIColor.white // make cell more visible in our example project
        
        return cell
    }
    
   
    
 
    
    func populateCell(_ image: UIImage,ImageView:UIImageView) {
        
        ImageView.image = image
        
    }
    


    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell : EditIssueCollectionCell = collectionView.cellForItem(at: indexPath) as! EditIssueCollectionCell
        
        SelectPhoto = cell.Img_Issue.image
        
        //performSegueWithIdentifier("EditIssueToViewPhoto", sender: self)
        
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
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("test")
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        //print(UITableViewAutomaticDimension)
//        return 80
//    }
//    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//      
//        
//        return 80
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "EditIssueToViewPhoto"
//        {
//            ///let ViewController = segue.destinationViewController as! SinglePhotoCollectionViewCell
//            
//            
//            
//            //ViewController.imgView.image = SelectPhoto
//            
//            // find selected photo index path
//            let clickedIndexPath : [NSIndexPath] = self.Col_Edit_View!.indexPathsForSelectedItems()!
//            
//            // create destination view controller
//            let destViewCtrl = segue.destinationViewController as! SinglePhotoViewController
//            
//            // set clicked photo index path for new page contoller
//            destViewCtrl.clickedPhotoIndexPath = clickedIndexPath[0]
//            
//            // set current screne photo list to new controller
//            destViewCtrl.photoList = self.photoList
//            
//        }
        
        
    }
    
    
}

extension UILabel {
    func resizeToText() {
        self.numberOfLines = 0
        self.sizeToFit()
    }
}
