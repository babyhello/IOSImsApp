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
import Fusuma
import ImageViewer

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
    
    @IBOutlet weak var Img_Command: UIImageView!
    
    @IBOutlet weak var Col_Img_Height: NSLayoutConstraint!
    
    
    
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
    var Command_File:String?
    //var FileType: String?
}

class EditIssueViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,ChangePriorityDelegate,CloseIssueDelegate,FusumaDelegate {
    
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
    
    @IBOutlet weak var Img_Edit_Issue: UIImageView!
    
    @IBAction func Btn_WorkNote_Send(_ sender: Any) {
        
        WorkNote_Update()
    }
    
    var ChangePriorityView = ChangePriorityAlertViewController()
    var CloseIssueView = CloseIssueAlertViewController()
    var SelectPhoto:UIImage?
    var Issue_File_List = [Issue_File]()
    var Issue_Command_List = [Issue_Command]()
    //var photoList = [Photo]()
    var request: Request?
    var Issue_ID:String?
    var Issue_Keyin:String?
    var Issue_Priority:String?
    var ModelID:String?
    var AuthorNameCN:String?
    var AuthorNameEN:String?
    var Issue_Owner:String?
    var Issue_Status_Display:String?
    var Issue_Status:String?
    
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
        
        
        //        Get_Issue(Issue_ID!)
        //        Get_Issue_File(Issue_ID!)
        //        Get_Issue_Command(Issue_ID!)
        Get_Issue_Info(Issue_ID!)
        
        Insert_Issue_Read(Issue_ID!)
        WorkNoteMessage.delegate = self
        
        
        
        self.Img_Author.layer.cornerRadius = self.Img_Author.frame.width/2.0
        
        self.Img_Author.clipsToBounds = true
        
        lbl_ProjectName.text = "#" + Issue_ID!
        
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
                self.Get_Issue_Info(self.Issue_ID!)
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
                                
                                self.title = "MS-" + (IssueInfo[0]["F_ModelName"] as? String)!
                                
                            }
                            else
                            {
                                self.title = ""
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
                                
                                self.Issue_Priority = IssueInfo[0]["F_Priority"] as? String
                                
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
                                
                                AppClass.WebImgGet(AppClass.ImagePath + self.Issue_Keyin! + ".jpg",ImageView: self.Img_Author)
                                
                            }
                            else
                            {
                                self.Issue_Keyin = ""
                            }
                            
                            if (IssueInfo[0]["F_Keyin"] as? String) != nil {
                                
                                self.Issue_Keyin = IssueInfo[0]["F_Keyin"] as? String
                                
                                AppClass.WebImgGet(AppClass.ImagePath + self.Issue_Keyin! + ".jpg",ImageView: self.Img_Author)
                                
                            }
                            else
                            {
                                self.Issue_Keyin = ""
                            }
                            
                            
                            
                            self.lbl_Author.adjustsFontSizeToFitWidth = true
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
    
    func showActivityIndicatory(uiView: UIView) {
        let container: UIView = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor(hexString: "0xffffff").withAlphaComponent(0.3)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        
        
        
        loadingView.backgroundColor = UIColor(hexString: "0x444444").withAlphaComponent(0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        
        
        
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 2);
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        
        container.tag = 1
        
        actInd.startAnimating()
    }
    
    func Get_Issue_Info(_ Issue_ID:String)
    {
        showActivityIndicatory(uiView: self.view)
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/GetIssue_Info", parameters: ["IssueID": Issue_ID])
            .responseJSON { response in
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [String: AnyObject]
                    
                    if((ObjectString?.count)! > 0)
                    {
                        let IssueInfo = ObjectString?["IssueInfo"]! as? [[String: AnyObject]]
                        
                        self.Get_Issue_InfoData(Data: IssueInfo!)
                        
                        let IssueComment = ObjectString?["IssueComment"] as? [[String: AnyObject]]
                        
                        self.Get_Issue_Command_Data(Data: IssueComment!)
                        
                        let IssueFile = ObjectString?["IssueFile"] as? [[String: AnyObject]]
                        
                        self.Get_Issue_FileData(Data: IssueFile!)
                    }
                    
                }
                else
                {
                    //AppClass.Alert("Outlook ID or Password Not Verify !!", SelfControl: self)
                }
                
                if let viewWithTag = self.view.viewWithTag(1) {
                    
                    viewWithTag.removeFromSuperview()
                }
                
        }
        
    }
    
    
    
    func Get_Issue_Command_Data(Data:[[String: AnyObject]])
    {
        Issue_Command_List = [Issue_Command]()
        
        for IssueInfo in (Data ) {
            
            let _Issue_Command = Issue_Command()
            
            let Issue_Command_Author = IssueInfo["F_Owner"] as! String
            let Issue_Command_Date = IssueInfo["F_CreateDate"] as! String
            
            let Issue_Command_Content = IssueInfo["F_Comment"] as! String
            let Issue_Command_WorkID = IssueInfo["F_Keyin"] as! String
            let Issue_Command_File = IssueInfo["Comment_File"] as! String
            
            _Issue_Command.Command_Author_WorkID = Issue_Command_WorkID
            _Issue_Command.Command_Author = Issue_Command_Author
            _Issue_Command.Command_Content = Issue_Command_Content
            _Issue_Command.Command_Time = Issue_Command_Date
            _Issue_Command.Command_File = Issue_Command_File
            
            
            self.Issue_Command_List.append(_Issue_Command)
        }
        
        self.TB_WorkNote.reloadData()
    }
    
    func Get_Issue_InfoData(Data:[[String: AnyObject]])
    {
        let IssueInfo = Data
        
        if IssueInfo.count > 0
        {
            
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
                
                self.title = "MS-" + (IssueInfo[0]["F_ModelName"] as? String)!
                
            }
            else
            {
                self.title = ""
            }
            
            if (IssueInfo[0]["F_Subject"] as? String) != nil {
                
                self.lbl_Issue_Subject.text = IssueInfo[0]["F_Subject"] as? String
                
            }
            else
            {
                self.lbl_Issue_Subject.text = ""
            }
            
            if (IssueInfo[0]["F_Priority"] as? String) != nil {
                
                Issue_Priority = IssueInfo[0]["F_Priority"] as? String
                
                self.Img_Priority.image = AppClass.PriorityImage(Issue_Priority!).image
                
                
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
                
                AppClass.WebImgGet(AppClass.ImagePath + self.Issue_Keyin! + ".jpg",ImageView: self.Img_Author)
                
            }
            else
            {
                self.Issue_Keyin = ""
            }
            
            if (IssueInfo[0]["F_PM_ID"] as? String) != nil {
                
                ModelID = IssueInfo[0]["F_PM_ID"] as? String
                
            }
            
            if (IssueInfo[0]["F_Owner_en"] as? String) != nil {
                
                AuthorNameEN = IssueInfo[0]["F_Owner_en"] as? String
                
            }
            
            if (IssueInfo[0]["F_Owner_cn"] as? String) != nil {
                
                AuthorNameCN = IssueInfo[0]["F_Owner_cn"] as? String
                
            }
            
            if (IssueInfo[0]["F_RespGroup"] as? String) != nil {
                
                self.Issue_Owner = IssueInfo[0]["F_RespGroup"] as? String
                
                
            }
            
            if (IssueInfo[0]["F_Status_Display"] as? String) != nil {
                
                self.Issue_Status_Display = IssueInfo[0]["F_Status_Display"] as? String
                
                
            }
            
            if (IssueInfo[0]["F_Status"] as? String) != nil {
                
                self.Issue_Status = IssueInfo[0]["F_Status"] as? String
                
                
            }
            
            
            
            
            self.lbl_Author.adjustsFontSizeToFitWidth = true
        }
        
        let _Img_Edit_Issue = Img_Edit_Issue
        let Img_EditGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(EditIssueViewController.Edit_Issue_Fun(_:)))
        _Img_Edit_Issue?.isUserInteractionEnabled = true
        _Img_Edit_Issue?.addGestureRecognizer(Img_EditGestureRecognizer)
    }
    
    func Get_Issue_FileData(Data:[[String: AnyObject]])
    {
        Issue_File_List = [Issue_File]()
        
        for IssueInfo in (Data ) {
            
            let _Issue_File = Issue_File()
            
            let Issue_File_Path = IssueInfo["F_DownloadFilePath"] as! String
            
            _Issue_File.FilePath = Issue_File_Path
            
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
                            
                            _Issue_File.FilePath = Issue_File_Path
                            
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
    
    func Edit_Issue_Fun(_ sender:AnyObject)
    {
        
        let margin:CGFloat = 8
        
        let optionMenu = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n",message: nil,preferredStyle: .actionSheet)
        
        var items = [CustomizableActionSheetItem]()
        
        let rect = CGRect(x: margin, y: margin, width: optionMenu.view.bounds.size.width - margin * 4.0, height: 100.0)
        
        if ((Issue_Status_Display != "3") && Issue_Keyin == AppUser.WorkID)
        {
            //Priority
            ChangePriorityView = ChangePriorityAlertViewController(frame: rect)
            
            ChangePriorityView.SelectedPriority = Int(self.Issue_Priority!)!
            
            ChangePriorityView.delegate = self
            
            ChangePriorityView.Set_Priority(Int(self.Issue_Priority!)!)
            
            items.append(Create_Sheet_Item(SheetType: .view, Label: nil, CustomView: ChangePriorityView, SheetAction: { (actionSheet: CustomizableActionSheet) -> Void in
            }
                , Height: 120))
            
            
            
            if((Issue_Status != "5") && Issue_Owner == Issue_Keyin)
            {
                               
                //Close Issue
                
                CloseIssueView = CloseIssueAlertViewController(frame: rect)
                
                CloseIssueView.delegate = self
                
//                if(!(Issue_Status?.isEmpty)!)
//                {
//                    CloseIssueView.Set_Close_Status(Int(Issue_Status!)!)
//                }
                
                
                items.append(Create_Sheet_Item(SheetType: .view, Label: nil, CustomView: CloseIssueView, SheetAction: { (actionSheet: CustomizableActionSheet) -> Void in
                }
                    , Height: 120))
                
                
            }
            
            //Change Owner
            
            items.append(Create_Sheet_Item(SheetType: .button, Label: "Change Owner", CustomView: nil, SheetAction: { (actionSheet: CustomizableActionSheet) -> Void in
                
                self.Change_Owner()
                
                actionSheet.dismiss()
            }
                , Height: nil))

            
        }
        
        if(Issue_Status_Display == "1" && Issue_Owner == AppUser.WorkID && Issue_Keyin != AppUser.WorkID)
        {
            items.append(Create_Sheet_Item(SheetType: .button, Label: "Solution privided", CustomView: nil, SheetAction: { (actionSheet: CustomizableActionSheet) -> Void in
                
                self.Verify()
                
                actionSheet.dismiss()
            }
                , Height: nil))
        }
        
        if(Issue_Status_Display == "3" && Issue_Keyin == AppUser.WorkID)
        {
            items.append(Create_Sheet_Item(SheetType: .button, Label: "Reject", CustomView: nil, SheetAction: { (actionSheet: CustomizableActionSheet) -> Void in
                
                self.Reject()
                
                actionSheet.dismiss()
            }
                , Height: nil))
            
            //Close Issue
            
            CloseIssueView = CloseIssueAlertViewController(frame: rect)
            
            CloseIssueView.delegate = self
            
//            if(!(Issue_Status?.isEmpty)!)
//            {
//                CloseIssueView.Set_Close_Status(Int(Issue_Status!)!)
//            }
            
            items.append(Create_Sheet_Item(SheetType: .view, Label: nil, CustomView: CloseIssueView, SheetAction: { (actionSheet: CustomizableActionSheet) -> Void in
            }
                , Height: 120))
        
        }
        
        items.append(Create_Sheet_Item(SheetType: .button, Label: "Cancel", CustomView: nil, SheetAction: { (actionSheet: CustomizableActionSheet) -> Void in actionSheet.dismiss()
        }
            , Height: nil))
        
        // Show
        let actionSheet = CustomizableActionSheet()
        actionSheet.showInView(self.view, items: items)
        
    }
    
    func Create_Sheet_Item(SheetType:CustomizableActionSheetItemType,Label:String?,CustomView:UIView?,SheetAction:@escaping (_ actionSheet: CustomizableActionSheet) -> Void,Height:Int?) -> CustomizableActionSheetItem
    {
        let SheetItem = CustomizableActionSheetItem()
        
        SheetItem.type = SheetType
        
        if(SheetType == .button)
        {
            SheetItem.label = Label
            
            SheetItem.selectAction = SheetAction
        }
        else if (SheetType == .view)
        {
            SheetItem.view = CustomView
            
            SheetItem.height = CGFloat(Height!)
            
        }
        
        
        
        
        return SheetItem
    }
    
    func Verify_Issue(_ IssueID:String,WorkID:String)
    {
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Verify_Issue", parameters: ["IssueNo": IssueID,"WorkID":WorkID])
            .responseJSON { response in
                
                self.Get_Issue_Info(self.Issue_ID!)
                
        }
    }
    
    func Reject_Issue(_ IssueID:String,WorkID:String,CloseType:String)
    {
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Reject_Verify_Issue", parameters: ["IssueNo": IssueID,"WorkID":WorkID])
            .responseJSON { response in
                
                self.Get_Issue_Info(self.Issue_ID!)
        }
    }
    
    func Verify()
    {
        let refreshAlert = UIAlertController(title: "Solution provided !!", message: "Are you sure to Solution provided", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            self.Verify_Issue(self.Issue_ID!, WorkID: AppUser.WorkID!)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    func Reject()
    {
        let refreshAlert = UIAlertController(title: "Reject Issue!!", message: "Are you sure to reject Issue", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            self.Verify_Issue(self.Issue_ID!, WorkID: AppUser.WorkID!)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func CloseIssueStatusChange() {
        
        let refreshAlert = UIAlertController(title: "Close Issue!!", message: "Are you sure to Close Issue", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            let Status = self.CloseIssueView.IssueStatus
            
            self.CloseIssueFinish(IssueStatus: Status!)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            
            self.CloseIssueView.clearStatus()
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)

        
        
        
    }
    
    func CloseIssueFinish(IssueStatus:Int)
    {
        //let CommentTitle = "@Issue Priority Change"
        Close_Issue(self.Issue_ID!, WorkID: AppUser.WorkID!, CloseType: String(describing: IssueStatus))
        
        let CommentText = AuthorNameEN! + " " +  AuthorNameCN! + " Close Issue"
        
        if (!(AppUser.WorkID?.isEmpty)!)
        {
            Comment_Insert(AppUser.WorkID!, IssueID: self.Issue_ID!, Comment: CommentText)
        }
    }
    
    func Close_Issue(_ IssueID:String,WorkID:String,CloseType:String)
    {
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Close_Issue", parameters: ["IssueNo": IssueID,"CloseType":CloseType,"WorkID":WorkID])
            .responseJSON { response in
                
                
        }
    }
    
    func PriorityChange()
    {
        
        let OldPriority = Int(Issue_Priority!)
        
        let SelectPriority = ChangePriorityView.SelectedPriority
        
        if(OldPriority != SelectPriority)
        {
            let refreshAlert = UIAlertController(title: "Priority Change !!", message: "Are you sure to Priority Change", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                
                self.Issue_Priority = String(self.ChangePriorityView.SelectedPriority)
                
                self.Change_Issue_Priority(self.Issue_ID!, Priority: String(SelectPriority))
                
                let CommentText = "◎Issue Priority Change： 『" + self.PriorityConvert(OldPriority!) + "』change to 『" + self.PriorityConvert(SelectPriority) + "』"
                
                if (!(AppUser.WorkID?.isEmpty)!)
                {
                    self.Comment_Insert(AppUser.WorkID!, IssueID: self.Issue_ID!, Comment: CommentText)
                }
                
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                
                self.ChangePriorityView.Set_Priority(OldPriority!)
                
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    func Change_Issue_Priority(_ IssueID:String,Priority:String)
    {
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Change_Issue_Priority", parameters: ["IssueID": IssueID,"Priority":Priority])
            .responseJSON { response in
                
                
        }
    }
    
    
    func PriorityConvert(_ Priority:Int) ->String {
        
        var PriorityDisplayText:String = "";
        
        
        switch Priority {
            
        case 1:
            PriorityDisplayText = "Critical (P1)";
            
            break;
        case  2:
            PriorityDisplayText = "Major (P2)";
            break;
        case  3:
            PriorityDisplayText = "Minor (P3)";
            break;
            
        default:
            break;
            
            
        }
        return PriorityDisplayText;
    }
    
    func Close_Issue()
    {
        performSegue(withIdentifier: "Issue_Close", sender: self)
    }
    func Change_Priority()
    {
        performSegue(withIdentifier: "Change_Priority", sender: self)
    }
    
    func Change_Owner()
    {
        performSegue(withIdentifier: "Change_Owner", sender: self)
    }
    
    func Camera_Photo_Pic(_ sender:AnyObject)
    {
        //        if UIImagePickerController.isSourceTypeAvailable(
        //            UIImagePickerControllerSourceType.camera) {
        //
        //            let imagePicker = UIImagePickerController()
        //
        //            imagePicker.delegate = self
        //            imagePicker.sourceType =
        //                UIImagePickerControllerSourceType.camera
        //            imagePicker.mediaTypes = [kUTTypeImage as String]
        //            //imagePicker.mediaTypes = [kUTTypeMovie as String]
        //            imagePicker.allowsEditing = false
        //
        //            self.present(imagePicker, animated: true,
        //                                       completion: nil)
        //            //newMedia = true
        //        }
        
        let fusuma = FusumaViewController()
        
        fusuma.delegate = self
        fusuma.cropHeightRatio = 0.6
        
        self.present(fusuma, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
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
        
        let _Img_Edit_Issue = cell.Img_Issue
        let Img_EditGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(EditIssueViewController.GoToZoome(sender:)))
        _Img_Edit_Issue?.isUserInteractionEnabled = true
        _Img_Edit_Issue?.addGestureRecognizer(Img_EditGestureRecognizer)
        
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
        
        if(Issue_Command_List[(indexPath as NSIndexPath).row].Command_File?.isEmpty)!
        {
            
            cell.Col_Img_Height.constant = 0
            
            cell.Img_Command.layoutIfNeeded()        }
        else
        {
            cell.Col_Img_Height.constant = 100
            
            cell.Img_Command.layoutIfNeeded()
            
            AppClass.WebImgGet(Issue_Command_List[(indexPath as NSIndexPath).row].Command_File!,ImageView: cell.Img_Command)
            
            let _Img_Edit_Issue = cell.Img_Command
            
            let Img_EditGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(EditIssueViewController.GoToZoome(sender:)))
            _Img_Edit_Issue?.isUserInteractionEnabled = true
            _Img_Edit_Issue?.addGestureRecognizer(Img_EditGestureRecognizer)
            
        }
        
        if(Issue_Command_List[(indexPath as NSIndexPath).row].Command_Content?.isEmpty)!
        {
            
        }
        else
        {
            
        }
        
        
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("test")
    }
    
    
    func GoToZoome(sender:UITapGestureRecognizer)
    {
        let displacedView = sender.view as! UIImageView
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZoomImageView") as! ZoomViewController
        
        popOverVC.ZoomImage = displacedView.image
        
        let nav = UINavigationController(rootViewController: popOverVC)
        
        self.present(nav, animated: true, completion: nil)
        
    }
    
    func galleryConfiguration() -> GalleryConfiguration {
        
        return [
            
            GalleryConfigurationItem.closeButtonMode(.builtIn),
            
            GalleryConfigurationItem.pagingMode(.standard),
            GalleryConfigurationItem.presentationStyle(.displacement),
            GalleryConfigurationItem.hideDecorationViewsOnLaunch(false),
            
            //GalleryConfigurationItem.swipeToDismissMode(.vertical),
            //GalleryConfigurationItem.toggleDecorationViewsBySingleTap(false),
            
            GalleryConfigurationItem.overlayColor(UIColor(white: 0.035, alpha: 1)),
            GalleryConfigurationItem.overlayColorOpacity(1),
            GalleryConfigurationItem.overlayBlurOpacity(1),
            GalleryConfigurationItem.overlayBlurStyle(UIBlurEffectStyle.light),
            
            //GalleryConfigurationItem.videoControlsColor(.white),
            
            //GalleryConfigurationItem.maximumZoomScale(8),
            GalleryConfigurationItem.swipeToDismissThresholdVelocity(500),
            
            GalleryConfigurationItem.doubleTapToZoomDuration(0.15),
            
            GalleryConfigurationItem.blurPresentDuration(0.5),
            GalleryConfigurationItem.blurPresentDelay(0),
            GalleryConfigurationItem.colorPresentDuration(0.25),
            GalleryConfigurationItem.colorPresentDelay(0),
            
            GalleryConfigurationItem.blurDismissDuration(0.1),
            GalleryConfigurationItem.blurDismissDelay(0.4),
            GalleryConfigurationItem.colorDismissDuration(0.45),
            GalleryConfigurationItem.colorDismissDelay(0),
            
            GalleryConfigurationItem.itemFadeDuration(0.3),
            GalleryConfigurationItem.decorationViewsFadeDuration(0.15),
            GalleryConfigurationItem.rotationDuration(0.15),
            
            GalleryConfigurationItem.displacementDuration(0.55),
            GalleryConfigurationItem.reverseDisplacementDuration(0.25),
            GalleryConfigurationItem.displacementTransitionStyle(.springBounce(0.7)),
            GalleryConfigurationItem.displacementTimingCurve(.linear),
            
            GalleryConfigurationItem.statusBarHidden(true),
            GalleryConfigurationItem.displacementKeepOriginalInPlace(false),
            GalleryConfigurationItem.displacementInsetMargin(50)
        ]
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        switch source {
            
        case .camera:
            
            print("Image captured from Camera")
            
        case .library:
            
            print("Image selected from Camera Roll")
            
        default:
            
            print("Image selected")
        }
        
        ImagePicker(image: image)
    }
    
    func ImagePicker(image: UIImage)
    {
        
        let selectedImage = image
        
        let imageName = UUID().uuidString
        
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName + ".jpg")
        
        if let jpegData = UIImageJPEGRepresentation(selectedImage, 80) {
            
            try? jpegData.write(to: URL(fileURLWithPath: imagePath), options: [.atomic])
            
        }
        
        dismiss(animated: true, completion: nil)
        
        
        let alert = UIAlertController(title: "\n\n\n\n\n\n\n", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Send",
                                      style: UIAlertActionStyle.default,
                                      handler: {(alert: UIAlertAction!) in self.SendImageToWorkNote(ImagePath: imagePath)}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        
        let width : NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300);
        
        alert.view.addConstraint(width);
        
        let margin:CGFloat = 25.0
        let rect = CGRect(x: margin, y: margin, width: 250, height: 160)
        let imageView = UIImageView(frame: rect)
        
        imageView.image = image
        
        alert.view.addSubview(imageView)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func SendImageToWorkNote(ImagePath:String)
    {
        
        if AppUser.WorkID! != "" {
            
            Upload_Issue_File(AppUser.WorkID!, IssueID: Issue_ID!, IssueFilePath: ImagePath)
            
        }
        
    }
    
    
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    func Upload_Issue_File(_ WorkID:String,IssueID:String,IssueFilePath:String)
    {
        let Path = AppClass.ServerPath + "/IMS_App_Service.asmx/Upload_Issue_File_MultiPart"
        
        let theFileName = (IssueFilePath as NSString).lastPathComponent
        
        let fileUrl = URL(fileURLWithPath: IssueFilePath)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                multipartFormData.append(fileUrl, withName: "photo")
                
                
        },
            to: Path,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Issue_Comment_File_Insert", parameters: ["F_Keyin": WorkID,"F_Master_ID":IssueID,"File":theFileName])
            .responseJSON { response in
                
                
        }
        
        //        do {
        //            let NSdata = try Data(contentsOf: URL(fileURLWithPath: IssueFilePath))
        //
        //
        //
        //
        //        } catch {
        //            print("Unable to load data: \(error)")
        //        }
        //
        
        
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        
        print("Number of selection images: \(images.count)")
        
        var count: Double = 0
        
        for image in images {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (3.0 * count)) {
                
                //self.imageView.image = image
                print("w: \(image.size.width) - h: \(image.size.height)")
            }
            count += 1
        }
    }
    
    //    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
    //
    //        print("Image mediatype: \(metaData.mediaType)")
    //        print("Source image size: \(metaData.pixelWidth)x\(metaData.pixelHeight)")
    //        print("Creation date: \(String(describing: metaData.creationDate))")
    //        print("Modification date: \(String(describing: metaData.modificationDate))")
    //        print("Video duration: \(metaData.duration)")
    //        print("Is favourite: \(metaData.isFavourite)")
    //        print("Is hidden: \(metaData.isHidden)")
    //        print("Location: \(String(describing: metaData.location))")
    //    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
        print("video completed and output to file: \(fileURL)")
        // self.fileUrlLabel.text = "file output to: \(fileURL.absoluteString)"
    }
    
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        
        switch source {
            
        case .camera:
            
            print("Called just after dismissed FusumaViewController using Camera")
            
        case .library:
            
            print("Called just after dismissed FusumaViewController using Camera Roll")
            
        default:
            
            print("Called just after dismissed FusumaViewController")
        }
    }
    
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        
        let alert = UIAlertController(title: "Access Requested",
                                      message: "Saving image needs to access your photo album",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { (action) -> Void in
            
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                
                UIApplication.shared.openURL(url)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func fusumaClosed() {
        
        print("Called when the FusumaViewController disappeared")
    }
    
    func fusumaWillClosed() {
        
        print("Called when the close button is pressed")
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
        
        if segue.identifier == "Change_Priority"
        {
            if (!(Issue_ID?.isEmpty)! && !(Issue_Priority?.isEmpty)!)
            {
                let ViewController = segue.destination as! ChangePriorityViewController
                
                ViewController.IssueID = Issue_ID
                
                ViewController.OldSelectedPriority = Int(Issue_Priority!)
                
            }
            
            
        }
        else if segue.identifier == "Issue_Close"
        {
            if (!(Issue_ID?.isEmpty)!)
            {
                let ViewController = segue.destination as! CloseIssueViewController
                
                ViewController.IssueNo = Issue_ID
            }
            
            
        }
        else if segue.identifier == "Change_Owner"
        {
            if (!(ModelID?.isEmpty)!)
            {
                let ViewController = segue.destination as! ChangeOwnerViewController
                
                ViewController.ModelID = ModelID
                
                ViewController.AuthorNameEN = AuthorNameEN
                
                ViewController.AuthorNameCN = AuthorNameCN
                
                ViewController.IssueNo = Issue_ID
            }
            
            
        }
        
        
        
    }
    
    
}

extension UILabel {
    func resizeToText() {
        self.numberOfLines = 0
        self.sizeToFit()
    }
}
