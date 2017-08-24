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
import AVFoundation
import AVKit
import Fusuma
import MediaPlayer
import Toast_Swift
import UICircularProgressRing

protocol NewIssueViewViewDelegate: class {         // make this class protocol so you can create `weak` reference
    func Cancel_NewIssue()
    func Finish_Issue()
}

class NewIssueViewController: UIViewController,UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate, UINavigationControllerDelegate, FusumaDelegate {
    
    var activityIndicator:UIActivityIndicatorView!
    
    @IBOutlet weak var Cir_Progress: UICircularProgressRingView!
    
    @IBOutlet weak var CoverView: UIView!
    
    //    @IBOutlet weak var Img_Author: UIImageView!
    weak var delegate: NewIssueViewViewDelegate?
    @IBOutlet weak var BottomHeight: NSLayoutConstraint!
    
    @IBOutlet weak var Scl_Content: UIScrollView!
    
    @IBOutlet weak var VW_Bottom: UIView!
    @IBOutlet weak var txt_Subject: UITextView!
    
    @IBOutlet weak var lbl_Author: UILabel!
    
    @IBOutlet weak var VW_Photo: UIView!
    
    @IBOutlet weak var VW_Video: UIView!
    
    @IBOutlet weak var VW_Microphone: UIView!
    @IBOutlet weak var Btn_MicroPhone: UIImageView!
    
    var recoder_manager = VoiceRecord()//初始化
    var height = 0
    
    var ModelID:String?
    
    var ModelName:String?
    
    var MySubView:IssueImage!
    
    var MySubVideoView:IssueVideo?
    
    var MySubVoiceView:IssueVoice?
    
    var SubViewTag = 100
    
    var IssueNo:String?
    
    var FromScanText:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        // Do any additional setup after loading the view.
        
        VW_Bottom.layer.borderWidth = 1
        
        VW_Bottom.layer.borderColor = UIColor(hexString: "#dcdde1").cgColor
        
        CoverView.layer.backgroundColor = UIColor(hexString: "#dcdde1").cgColor
        
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(Finish_Issue))
        
        navigationItem.rightBarButtonItem = done
        
        let Cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(Cancel_NewIssue))
        
        navigationItem.leftBarButtonItem = Cancel
        
        self.title = ModelName
        
        if txt_Subject.text.isEmpty {
            txt_Subject.text = "Please enter a issue Subject"
            txt_Subject.textColor = UIColor.lightGray
        }
        
        txt_Subject.textColor = UIColor.lightGray
        txt_Subject?.delegate = self
        
        let TakePhoto = VW_Photo
        let tapTakePhoto = UITapGestureRecognizer(target:self, action:#selector(NewIssueViewController.Take_Photo(_:)))
        TakePhoto?.isUserInteractionEnabled = true
        TakePhoto?.addGestureRecognizer(tapTakePhoto)
        
        let TakeVideo = VW_Video
        let tapTakeVideo = UITapGestureRecognizer(target:self, action:#selector(NewIssueViewController.Take_Video(_:)))
        TakeVideo?.isUserInteractionEnabled = true
        TakeVideo?.addGestureRecognizer(tapTakeVideo)
        
        let TakeMicroPhone = VW_Microphone
        let tapTakeMicroPhone = UITapGestureRecognizer(target:self, action:#selector(NewIssueViewController.Take_MicroPhone(_:)))
        TakeMicroPhone?.isUserInteractionEnabled = true
        TakeMicroPhone?.addGestureRecognizer(tapTakeMicroPhone)
        
        if AppUser.WorkID! != "" {
            
            Issue_Init(AppUser.WorkID!)
            
        }
        
        let moc = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        var MemberData = [DB_Member]()
        
        MemberData = DB_Member.Get_Member(moc)

        lbl_Author.text = MemberData[0].outlook_account
        
        
//        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
//            UIActivityIndicatorViewStyle.gray)
//        activityIndicator.center=self.view.center
//        self.view.addSubview(activityIndicator);
        
        Cir_Progress.isHidden = true
    }
    
    func play(){
        //进度条开始转动
        Cir_Progress.isHidden = false
    }
    
    func stop(){
        //进度条停止转动
        Cir_Progress.isHidden = true
    }
    
    func Upload_Issue_File(_ WorkID:String,IssueID:String,IssueFilePath:[String])
    {
        self.play()
        
        let Path = AppClass.ServerPath + "/IMS_App_Service.asmx/Upload_Issue_File_MultiPart"
        
        Alamofire.upload(
            
            multipartFormData: { multipartFormData in
                for filePath in IssueFilePath
                {
                    let theFileName = (filePath as NSString).lastPathComponent
                    
                    
                    let fileUrl = URL(fileURLWithPath: filePath)
                    
                    multipartFormData.append(fileUrl, withName: theFileName)
                    
                }
                
                
        },
            to: Path,
            
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                    upload.uploadProgress { progress in
                        
                        debugPrint(Float(progress.fractionCompleted))
                        
                        self.Cir_Progress.setProgress(CGFloat(Float(progress.fractionCompleted) * 100), animationDuration: 0)
                        
                        if(Float(progress.fractionCompleted) >= 1)
                        {
                            self.stop()
                            
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
        
        for filename in IssueFilePath
        {
            let theFileName = (filename as NSString).lastPathComponent
            
            Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Upload_Issue_File", parameters: ["F_Keyin": WorkID,"F_Master_ID":IssueID,"F_Master_Table":"C_Issue","File":theFileName])
                .responseJSON { response in
                    
                    
            }
        }
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    func Cancel_NewIssue()
    {
        
        
        delegate?.Cancel_NewIssue()
        
        _ = navigationController?.popViewController(animated: true)
        
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
    
    
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    func Take_Video(_ Video:AnyObject)
    {
        
        
        
        startCameraFromViewController(self, withDelegate: self)
        
        
    }
    
    func Take_MicroPhone(_ MicroPhone:AnyObject)
    {
        
        if (Btn_MicroPhone.backgroundColor == UIColor.red)
        {
            recoder_manager.stopRecord()//结束录音
            
            Btn_MicroPhone.backgroundColor = UIColor.clear
            
            self.view.makeToast("StopRecord")
            
            VoicePicker(Path:recoder_manager.file_path)
            
        }
        else
        {
            Btn_MicroPhone.backgroundColor = UIColor.red
            
            recoder_manager.beginRecord()//开始录音
            
            self.view.makeToast("BeginRecord")
            
            
        }
        
        
        
    }
    
    func Take_Photo(_ Photo:AnyObject)
    {
        
        
        let fusuma = FusumaViewController()
        
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1.2
        
        self.present(fusuma, animated: true, completion: nil)
        
        
        
        
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
    
    func Upload_Issue_File(_ imagePath:[String])
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
        delegate?.Finish_Issue()
        
        //防止多次送出
        
        navigationItem.rightBarButtonItem = nil
        
        let Subject = txt_Subject.text
        
        let Priority = "1"
        
        New_Issue(IssueNo!,PM_ID: ModelID!,Priority: Priority,Subject: Subject!)
        
        let subViews = self.Scl_Content.subviews
        
        var FilePathArray = [String]()
        
        for subView in subViews
        {
            if (subView as? IssueImage) != nil {
                
                let IssueImageView:IssueImage =  (subView as? IssueImage)!
                
                FilePathArray.append(IssueImageView.ImagePath)
            }
            
            if (subView as? IssueVideo) != nil {
                
                let IssueVideoView:IssueVideo =  (subView as? IssueVideo)!
                
                FilePathArray.append(IssueVideoView.VideoPath)
                
                
            }
            
            if (subView as? IssueVoice) != nil {
                
                let IssueVoiceView:IssueVoice =  (subView as? IssueVoice)!
                
                FilePathArray.append(IssueVoiceView.VoicePath)
                
            }
        }
        
        if(FilePathArray.count > 0)
        {
            Upload_Issue_File(FilePathArray)
        }
        else
        {
            _ = navigationController?.popViewController(animated: true)
        }
        
        
        
        
        
        
        
        //performSegue(withIdentifier: "NewIssueToEditIssue", sender: self)
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
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
//    }
    
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
    
    
    // MARK: FusumaDelegate Protocol
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
    
    func ImagePicker(image: UIImage)
    {
        
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = image
        
        let subviewHeight = Int(self.view.frame.size.width) / 4 * 3
        
        MySubView = IssueImage(frame: CGRect(x:5,y: height, width:Int(self.view.frame.size.width), height:subviewHeight))
        
        MySubView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        let imageName = UUID().uuidString
        
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName + ".jpg")
        
        if let jpegData = UIImageJPEGRepresentation(selectedImage, 80) {
            
            self.MySubView.ImagePath = imagePath
            
            try? jpegData.write(to: URL(fileURLWithPath: imagePath), options: [.atomic])
            
            
            self.MySubView.Img_Issue.image = UIImage(contentsOfFile: imagePath)
            
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
                
                self.Scl_Content.contentSize = CGSize(width: self.view.frame.size.width, height: CGFloat(self.height))
                
            }
            
            //self.Upload_Issue_File(AppUser.WorkID!,IssueID: self.IssueNo!,IssueFilePath: imagePath)
            
        }
        
        
        
        dismiss(animated: true, completion: nil)
        
        SubViewTag = SubViewTag + 1
        
    }
    
    func ImagePickerVideo(Path: String)
    {
        
        // The info dictionary contains multiple representations of the image, and this uses the original.
        
        
        let subviewHeight = Int(self.view.frame.size.width) / 4 * 3
        
        MySubVideoView = IssueVideo(frame: CGRect(x:5,y: height, width:Int(self.view.frame.size.width), height:subviewHeight),VideoPath: Path)
        
        MySubVideoView?.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        let imageView = self.MySubVideoView?.Img_Cancel
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(NewIssueViewController.Cancel_Click(_:)))
        imageView?.isUserInteractionEnabled = true
        imageView?.addGestureRecognizer(tapGestureRecognizer)
        self.MySubVideoView?.tag = self.SubViewTag
        imageView?.tag = self.SubViewTag
        self.height =  self.height + subviewHeight + 20
        self.Scl_Content.isUserInteractionEnabled = true
        self.Scl_Content.addSubview(self.MySubVideoView!)
        
        if Int(self.Scl_Content.frame.size.height) <  self.height{
            
            self.Scl_Content.contentSize = CGSize(width: self.view.frame.size.width, height: CGFloat(self.height))
            
            
            
        }
        
        
        dismiss(animated: true, completion: nil)
        
        SubViewTag = SubViewTag + 1
        
    }
    
    func VoicePicker(Path: String)
    {
        
        // The info dictionary contains multiple representations of the image, and this uses the original.
        
        
        let subviewHeight = Int(self.view.frame.size.width) / 4 * 3
        
        MySubVoiceView = IssueVoice(frame: CGRect(x:5,y: height, width:Int(self.view.frame.size.width), height:subviewHeight),VoicePath: Path)
        
        MySubVoiceView?.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        let imageView = self.MySubVoiceView?.Img_Cancel
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(NewIssueViewController.Cancel_Click(_:)))
        imageView?.isUserInteractionEnabled = true
        imageView?.addGestureRecognizer(tapGestureRecognizer)
        self.MySubVoiceView?.tag = self.SubViewTag
        imageView?.tag = self.SubViewTag
        self.height =  self.height + subviewHeight + 20
        self.Scl_Content.isUserInteractionEnabled = true
        self.Scl_Content.addSubview(self.MySubVoiceView!)
        
        if Int(self.Scl_Content.frame.size.height) <  self.height{
            
            self.Scl_Content.contentSize = CGSize(width: self.view.frame.size.width, height: CGFloat(self.height))
            
        }
        
        SubViewTag = SubViewTag + 1
        
    }
    
    func startCameraFromViewController(_ viewController: UIViewController, withDelegate delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            return false
        }
        
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
        cameraController.allowsEditing = false
        cameraController.delegate = delegate
        
        present(cameraController, animated: true, completion: nil)
        return true
    }
    
    func video(_ videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        var title = "Success"
        var message = "Video was saved"
        if let _ = error {
            title = "Error"
            message = "Video failed to save"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        //dismiss(animated: true, completion: nil)
        // Handle a movie capture
        
        if mediaType == kUTTypeMovie {
            
            let TempVideoPath = info[UIImagePickerControllerMediaURL] as! NSURL!
            
            guard let path = (TempVideoPath)?.path else { return }
            
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
                
                UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(NewIssueViewController.video(_:didFinishSavingWithError:contextInfo:)), nil)
                
                //let path = TempVideoPath?.absoluteURL?.absoluteString
                
                ImagePickerVideo(Path:path)
                
            }
        }
        
    }
    
    func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        var title = "Success"
        var message = "Video was saved"
        if let _ = error {
            title = "Error"
            message = "Video failed to save"
        }
    }
}

