//
//  NewIssueViewController.swift
//  com.msi.IMSApp
//
//  Created by 俞兆 on 2016/7/21.
//  Copyright © 2016年 Mark. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MobileCoreServices
import AssetsLibrary

protocol NewIssueViewViewDelegate: class {         // make this class protocol so you can create `weak` reference
    func Cancel_NewIssue()
    func Finish_Issue()
}

class NewIssueViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var Img_Author: UIImageView!
    weak var delegate: NewIssueViewViewDelegate?
    @IBOutlet weak var BottomHeight: NSLayoutConstraint!
    
    @IBOutlet weak var Scl_Content: UIScrollView!
    
    @IBOutlet weak var VW_Bottom: UIView!
    @IBOutlet weak var txt_Subject: UITextView!
    
    @IBOutlet weak var lbl_Author: UILabel!
    var height = 0
    
    var ModelID:String?
    
    var ModelName:String?
    
    var MySubView:IssueImage!
    
    var SubViewTag = 100
    
    var IssueNo:String?
    
    var FromScanText:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        // Do any additional setup after loading the view.
        
        VW_Bottom.layer.borderWidth = 1
        
        VW_Bottom.layer.borderColor = UIColor(hexString: "#dcdde1").cgColor
        
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(Finish_Issue))
        
        navigationItem.rightBarButtonItem = done
        
        let Cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(Cancel_NewIssue))
        
        navigationItem.leftBarButtonItem = Cancel
        
        self.title = ModelName
        
//        if(FromScanText != "")
//        {
//            print(FromScanText)
//            
//            txt_Subject.text = FromScanText
//        }
//        else
//        {
//            txt_Subject.text = "Please enter a issue Subject"
//        }
        if txt_Subject.text.isEmpty {
            txt_Subject.text = "Please enter a issue Subject"
            txt_Subject.textColor = UIColor.lightGray
        }
        
        txt_Subject.textColor = UIColor.lightGray
        txt_Subject?.delegate = self
        
        let Camera = VW_Bottom
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(NewIssueViewController.Camera_Photo_Pic(_:)))
        Camera?.isUserInteractionEnabled = true
        Camera?.addGestureRecognizer(tapGestureRecognizer)
        
        if AppUser.WorkID! != "" {
            
            Issue_Init(AppUser.WorkID!)
            
        }
        
        Img_Author.layer.cornerRadius = Img_Author.frame.width/2.0
        
        Img_Author.clipsToBounds = true
        
        
        //let ImageArray: [[UIImage]] = [[UIImage(named: "1-1")!, UIImage(named: "1-2")!], [UIImage(named: "2-1")!, UIImage(named: "2-2")!]]
        
        
    }
    
    func Upload_Issue_File(_ WorkID:String,IssueID:String,IssueFilePath:String)
    {
        let Path = AppClass.ServerPath + "/IMS_App_Service.asmx/Upload_Issue_File_MultiPart"
        
        let theFileName = (IssueFilePath as NSString).lastPathComponent
        print(theFileName)
        let fileUrl = URL(fileURLWithPath: IssueFilePath)
        print(fileUrl)
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
        
//        Alamofire.upload(
//            multipartFormData: { multipartFormData in
//                multipartFormData.append(unicornImageURL, withName: "unicorn")
//                multipartFormData.append(rainbowImageURL, withName: "rainbow")
//            },
//            to: "https://httpbin.org/post",
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON { response in
//                        debugPrint(response)
//                    }
//                case .failure(let encodingError):
//                    print(encodingError)
//                }
//            }
//        )
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Upload_Issue_File", parameters: ["F_Keyin": WorkID,"F_Master_ID":IssueID,"F_Master_Table":"C_Issue","File":theFileName])
            .responseJSON { response in
                
               print(response)
        }


    }
    
    func Cancel_NewIssue()
    {
        
        delegate?.Cancel_NewIssue()
        
        _ = navigationController?.popViewController(animated: true)
        
        //self.tabBarController?.tabBar.hidden = false
        
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
    
    func CameraFun(_ Camera:AnyObject)
    {
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let subviewHeight = Int(self.view.frame.size.width) / 4 * 3
        
        MySubView = IssueImage(frame: CGRect(x:10,y:Int(txt_Subject.frame.origin.y + txt_Subject.frame.height) + height, width:Int(self.view.frame.size.width), height:subviewHeight))
        
        MySubView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        let imageName = UUID().uuidString
        
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName + ".jpg")
        
        if let jpegData = UIImageJPEGRepresentation(selectedImage, 80) {
            
            try? jpegData.write(to: URL(fileURLWithPath: imagePath), options: [.atomic])
            
            
            self.MySubView.Img_Issue.image = UIImage(contentsOfFile: imagePath)
            
            //MySubView.Img_Issue.image = UIImage(named: "btn_share_back")
            
            let imageView = self.MySubView.Img_Cancel
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(NewIssueViewController.Cancel_Click(_:)))
            imageView?.isUserInteractionEnabled = true
            imageView?.addGestureRecognizer(tapGestureRecognizer)
            self.MySubView.tag = self.SubViewTag
            imageView?.tag = self.SubViewTag
            self.height =  self.height + subviewHeight + 20
            self.Scl_Content.isUserInteractionEnabled = true
            self.Scl_Content.addSubview(self.MySubView)
            
            if Int(self.Scl_Content.frame.size.height) <  self.height{
                
                let ContentHeight = self.height -  Int(self.Scl_Content.frame.size.height)
                
                self.Scl_Content.contentSize = CGSize(width: self.view.frame.size.width, height: self.Scl_Content.contentSize.height + CGFloat(ContentHeight))
                
            }
            
            self.Upload_Issue_File(AppUser.WorkID!,IssueID: self.IssueNo!,IssueFilePath: imagePath)
            
        }

       
        
        dismiss(animated: true, completion: nil)
        
        SubViewTag = SubViewTag + 1
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    func Camera_Photo_Pic(_ Camera:AnyObject)
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
    
    func Cancel_Click(_ sender: UITapGestureRecognizer)
    {
        //let tag = sender.view!.tag
        
        let tag = sender.view?.tag
        
        print(tag!)
        
        if let viewWithTag = self.Scl_Content.viewWithTag(tag!) {
            
            let subviewHeight = Int(self.view.frame.size.width) / 4 * 3
            
            height =  height - subviewHeight - 20
            
            
            viewWithTag.removeFromSuperview()
        }
        else {
            //println("tag not found")
        }
    }
    
    func Issue_Init(_ WorkID:String)
    {
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Issue_Init", parameters: ["F_Keyin": WorkID])
            .responseJSON { response in
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        let IssueInfo = ObjectString!
                        
                        
                        if IssueInfo.count > 0
                        {
                            self.IssueNo = IssueInfo[0]["F_SeqNo"] as? String
                            
                            //print(self.IssueNo!)
                            
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
    
    func New_Issue(_ Issue_ID:String,PM_ID:String,Priority:String,Subject:String)
    {
        
        let _PM_ID:String = PM_ID
        
        
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Issue_Update", method: .post, parameters: ["F_SeqNo": Issue_ID,"F_PM_ID":_PM_ID,"F_Priority":Priority,"F_Subject":Subject], encoding: JSONEncoding.default).responseJSON { response in
            
            
        }
        
    }
    
    func Upload_Issue_File(_ imagePath:String)
    {
        
        if IssueNo != "" {
            Upload_Issue_File(AppUser.WorkID!,IssueID: IssueNo!,IssueFilePath: imagePath)
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txt_Subject.textColor == UIColor.lightGray {
            txt_Subject.text = nil
            txt_Subject.textColor = UIColor.black
        }    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txt_Subject.text.isEmpty {
            txt_Subject.text = "Please enter a issue Subject"
            txt_Subject.textColor = UIColor.lightGray
        }
    }
    
    func Finish_Issue()
    {
        
        let Subject = txt_Subject.text
        
        let Priority = "1"
        
        New_Issue(IssueNo!,PM_ID: ModelID!,Priority: Priority,Subject: Subject!)
        
        //let subViews = self.Scl_Content.subviews
        
//        for subView in subViews
//        {
//            if (subView as? IssueImage) != nil {
//                
//                let IssueImageView:IssueImage =  (subView as? IssueImage)!
//                
//                //Upload_Issue_File(IssueImageView.Img_Issue.image!)
//            }
//        }
        //Upload_Issue_File(UIImage(named: "btn_share_back")!)
        
        
       _ = navigationController?.popViewController(animated: true)
        
       
        //performSegueWithIdentifier("NewIssueToEditIssue", sender: self)
    }
    
    func SelectPriority()
    {
        performSegue(withIdentifier: "SelectPriority", sender: self)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        //print(viewController)
        //viewController.viewDidLoad()
        if let controller = viewController as? ProjectIssueListTableViewController {
            controller.viewDidLoad()    // Here you pass the data back to your original view controller
            
            
        }
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        //        if parent == nil {
        //            parent?.viewDidLoad()
        //        }
        //        else
        //        {
        //            parent?.viewDidLoad()
        //        }
        parent?.viewDidLoad()
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        
        parent?.viewDidLoad()
    }
    
    func SelectProject()
    {
        performSegue(withIdentifier: "SelectProject", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "NewIssueToEditIssue" {
            
            let ViewController = segue.destination as! EditIssueViewController
            
            ViewController.Issue_ID = IssueNo
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func keyboardWillShow(_ notification:Foundation.Notification)
    {
        //        let userInfo:NSDictionary = notification.userInfo!
        //        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        //        let keyboardRectangle = keyboardFrame.CGRectValue()
        //        let keyboardHeight = keyboardRectangle.height
        //
        //        if let userInfo = notification.userInfo
        //        {
        //            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
        //            {
        //                print(keyboardHeight)
        //                //BottomHeight.constant = keyboardSize.height
        //                BottomHeight.constant = keyboardSize.height + VW_Bottom.frame.height
        //                view.setNeedsLayout()
        //
        //            }
        //        }
        
        var info = (notification as NSNotification).userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.BottomHeight.constant = keyboardFrame.size.height
            self.view.setNeedsLayout()
        })
        
    }
    
    func keyboardWillHide(_ notification:Foundation.Notification)
    {
        BottomHeight.constant = 0.0
        view.setNeedsLayout()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30, height: 60))
        
        let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        var rowString = String()
        switch row {
        case 0:
            rowString = "Washington"
            myImageView.image = UIImage(named:"ic_issue_prioP1")
        case 1:
            rowString = "Beijing"
            myImageView.image = UIImage(named:"ic_issue_prioP2")
        case 2: break
        default:
            rowString = "Error: too many rows"
            myImageView.image = nil
        }
        let myLabel = UILabel(frame: CGRect(x: 60, y: 0, width: pickerView.bounds.width - 90, height: 60 ))
        //myLabel.font = UIFont(name:some, font, size: 18)
        myLabel.text = rowString
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // do something with selected row
    }
    
    
}
