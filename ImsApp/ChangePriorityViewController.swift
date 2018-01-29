//
//  ChangePriorityViewController.swift
//  IMS
//
//  Created by 俞兆 on 2017/6/22.
//  Copyright © 2017年 Mark. All rights reserved.
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



class ChangePriorityViewController: UIViewController,UITextViewDelegate,UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UINavigationControllerDelegate, FusumaDelegate{
    
    
    @IBOutlet weak var Btn_PriorityOne: UIButton!
    @IBOutlet weak var Btn_PriorityTwo: UIButton!
    @IBOutlet weak var Btn_PriorityThree: UIButton!
    
    @IBAction func Btn_PriorityOne_Click(_ sender: Any) {
        Set_Priority(1)
    }
    
    @IBAction func Btn_PriorityTwo_Click(_ sender: Any) {
        Set_Priority(2)
    }
    
    @IBAction func Btn_PriorityThree_Click(_ sender: Any) {
        Set_Priority(3)
    }
    @IBOutlet weak var txt_Reason: UITextView!
    
    @IBOutlet weak var Scl_Content: UIScrollView!
    
    @IBOutlet weak var VW_Photo: UIView!
    
    @IBOutlet weak var VW_Video: UIView!
    
    @IBOutlet weak var VW_MicroPhone: UIView!
    
    @IBOutlet weak var Btn_Microphone: UIImageView!
    
    var height = 0
    
    var recoder_manager = VoiceRecord()//初始化
    
    var MySubView:IssueImage!
    
    var MySubVideoView:IssueVideo?
    
    var MySubVoiceView:IssueVoice?
    
    var SubViewTag = 100
    
    var IssueNo:String?
    
    var SelectedPriority = 1
    
    var IssueID:String!
    
    var OldSelectedPriority:Int!
    
    var activityIndicator:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Change Priority"
        
        
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(Finish_Issue))
        
        navigationItem.rightBarButtonItem = done
        
        txt_Reason.delegate = self
        txt_Reason.text = "   Reason"
        txt_Reason.textColor = UIColor.lightGray
        
        let TakePhoto = VW_Photo
        let tapTakePhoto = UITapGestureRecognizer(target:self, action:#selector(ChangePriorityViewController.Take_Photo(_:)))
        TakePhoto?.isUserInteractionEnabled = true
        TakePhoto?.addGestureRecognizer(tapTakePhoto)
        
        let TakeVideo = VW_Video
        let tapTakeVideo = UITapGestureRecognizer(target:self, action:#selector(ChangePriorityViewController.Take_Video(_:)))
        TakeVideo?.isUserInteractionEnabled = true
        TakeVideo?.addGestureRecognizer(tapTakeVideo)
        
        let TakeMicroPhone = VW_MicroPhone
        let tapTakeMicroPhone = UITapGestureRecognizer(target:self, action:#selector(ChangePriorityViewController.Take_MicroPhone(_:)))
        TakeMicroPhone?.isUserInteractionEnabled = true
        TakeMicroPhone?.addGestureRecognizer(tapTakeMicroPhone)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.gray)
        activityIndicator.center=self.view.center
        self.view.addSubview(activityIndicator);
        
        Set_Priority(OldSelectedPriority)
        
    }
    
    func Set_Priority(_ Priority:Int)
    {
        Btn_PriorityOne.setBackgroundImage(UIImage(named: "btn_change_prioP1_nor"), for: .normal)
        Btn_PriorityTwo.setBackgroundImage(UIImage(named: "btn_change_prioP2_nor"), for: .normal)
        Btn_PriorityThree.setBackgroundImage(UIImage(named: "btn_change_prioP3_nor"), for: .normal)
        
        SelectedPriority = Priority
        
        switch Priority {
            
        case 1:
            Btn_PriorityOne.setBackgroundImage(UIImage(named: "btn_change_prioP1_sel"), for: .normal)
            
            Btn_PriorityTwo.setBackgroundImage(UIImage(named: "btn_change_prioP2_nor"), for: .normal)
            Btn_PriorityThree.setBackgroundImage(UIImage(named: "btn_change_prioP3_nor"), for: .normal)
            
            break;
        case  2:
            Btn_PriorityTwo.setBackgroundImage(UIImage(named: "btn_change_prioP2_sel"), for: .normal)
            
            Btn_PriorityOne.setBackgroundImage(UIImage(named: "btn_change_prioP1_nor"), for: .normal)
            
            Btn_PriorityThree.setBackgroundImage(UIImage(named: "btn_change_prioP3_nor"), for: .normal)
            
            
            
            break;
        case  3:
            Btn_PriorityThree.setBackgroundImage(UIImage(named: "btn_change_prioP3_sel"), for: .normal)
            
            Btn_PriorityOne.setBackgroundImage(UIImage(named: "btn_change_prioP1_nor"), for: .normal)
            Btn_PriorityTwo.setBackgroundImage(UIImage(named: "btn_change_prioP2_nor"), for: .normal)
            
            break;
            
        default:
            break;
            
            
        }
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        //dismiss(animated: true, completion: nil)
        // Handle a movie capture
        
        if mediaType == kUTTypeMovie {
            
            let TempVideoPath = info[UIImagePickerControllerMediaURL] as! URL!
            
            guard let path = (TempVideoPath)?.path else { return }
            
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
                
                UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(NewIssueViewController.video(_:didFinishSavingWithError:contextInfo:)), nil)
                
                //let path = TempVideoPath?.absoluteURL?.absoluteString
                
                ImagePickerVideo(path)
                
            }
        }
        
    }
    
    func Take_Video(_ Video:AnyObject)
    {
        
        
        
        startCameraFromViewController(self, withDelegate: self)
        
        
    }
    
    func Take_MicroPhone(_ MicroPhone:AnyObject)
    {
        
        if (Btn_Microphone.backgroundColor == UIColor.red)
        {
            recoder_manager.stopRecord()//结束录音
            
            Btn_Microphone.backgroundColor = UIColor.clear
            
            self.view.makeToast("StopRecord")
            
            VoicePicker(recoder_manager.file_path)
            
        }
        else
        {
            Btn_Microphone.backgroundColor = UIColor.red
            
            recoder_manager.beginRecord()//开始录音
            
            self.view.makeToast("BeginRecord")
            
            
        }
    }
    
    
    func ImagePickerVideo(_ Path: String)
    {
        
        // The info dictionary contains multiple representations of the image, and this uses the original.
        
        
        let subviewHeight = Int(self.view.frame.size.width) / 4 * 3
        
        MySubVideoView = IssueVideo(frame: CGRect(x:5,y: height, width:Int(self.view.frame.size.width), height:subviewHeight),VideoPath: Path,FromFile: true)
        
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
    func VoicePicker(_ Path: String)
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
    
    func Take_Photo(_ Photo:AnyObject)
    {
        
        
        let fusuma = FusumaViewController()
        
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1.2
        
        self.present(fusuma, animated: true, completion: nil)
        
        
        
        
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "   Reason"
            textView.textColor = UIColor.lightGray
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Finish_Issue()
    {
        //let CommentTitle = "@Issue Priority Change"
        Change_Issue_Priority(IssueID!, Priority: String(SelectedPriority))
        
        var CommentText = "◎Issue Priority Change： 『" + PriorityConvert(OldSelectedPriority) + "』change to 『" + PriorityConvert(SelectedPriority) + "』"
        
        CommentText += "Reason: 『" + txt_Reason.text + "』\n";
        
        if (!(AppUser.WorkID?.isEmpty)! && !txt_Reason.text.isEmpty)
        {
            Comment_Insert(AppUser.WorkID!, IssueID: IssueID!, Comment: CommentText)
            
            
        }
        
    }
    
    func play(){
        //进度条开始转动
        activityIndicator.startAnimating()
    }
    
    func stop(){
        //进度条停止转动
        activityIndicator.stopAnimating()
    }
    
    func Upload_Issue_File(_ WorkID:String,IssueID:String,IssueFilePath:[String])
    {
        if IssueFilePath.count == 0
        {
            _ = self.navigationController?.popViewController(animated: true)

        }
        
        
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
            
            Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Upload_Issue_File", parameters: ["F_Keyin": WorkID,"F_Master_ID":IssueID,"F_Master_Table":"C_Comment","File":theFileName])
                .responseJSON { response in
                    
                    
            }
        }
        
        
        
        
    }
    
    func Change_Issue_Priority(_ IssueID:String,Priority:String)
    {
    
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/Change_Issue_Priority", parameters: ["IssueID": IssueID,"Priority":Priority])
            .responseJSON { response in
                
                
        }
    }
    
    
    func Cancel_Issue()
    {
        
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
                                
                                self.UploadCommentFile(CommentNo!)
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
    
    func UploadCommentFile(_ CommentID:String)
    {
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
        
        if(!(AppUser.WorkID?.isEmpty)! && !CommentID.isEmpty)
        {
            Upload_Issue_File(AppUser.WorkID!, IssueID: CommentID, IssueFilePath: FilePathArray)
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
    
    
    
    
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    func ImagePicker(_ image: UIImage)
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
        
        ImagePicker(image)
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
    
}
