//
//  IssueVoice.swift
//  IMS
//
//  Created by 俞兆 on 2017/6/18.
//  Copyright © 2017年 Mark. All rights reserved.
//
import UIKit
import MediaPlayer
import AVFoundation
import AVKit

@IBDesignable

class IssueVoice: UIView {


    
    @IBOutlet weak var IssueImageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var Img_Issue: UIImageView!
    
    @IBOutlet weak var Img_Cancel: UIImageView!
    
    var player: AVPlayer?
    
    var MyCustview:UIView!
    
    var VoicePath:String!
    
    init(frame: CGRect,VoicePath: String){
        
        self.VoicePath = VoicePath
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func Hide_CancelBtn()
    {
        Img_Cancel.isHidden = true
        
    }
    
    func setup() {
        
        VoicePath = AppClass.ConvertServerPath(Path: VoicePath)
        
        MyCustview = loadViewFromNib()
        self.Img_Issue.bringSubview(toFront: MyCustview)
        MyCustview.frame = bounds
        MyCustview.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        IssueImageHeight.constant = MyCustview.frame.height
        
        let Img_Issue = self.Img_Issue
        let tapVoicePlay = UITapGestureRecognizer(target:self, action:#selector(IssueVoice.Voice_Play(_:)))
        Img_Issue?.isUserInteractionEnabled = true
        Img_Issue?.addGestureRecognizer(tapVoicePlay)
        
        
        addSubview(MyCustview)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for:type(of: self))
        let nib = UINib(nibName: "IssueVoice", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    func Voice_Play(_ Video:AnyObject)
    {
        do {
            
            let VideoNSUrl  = URL(fileURLWithPath: VoicePath)
            
            let item = AVPlayerItem(url: VideoNSUrl)
            
            NotificationCenter.default.addObserver(self, selector: #selector(IssueVoice.Play_Finish), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
            
            player = AVPlayer(playerItem: item)
            
            Img_Issue.backgroundColor = UIColor.red
//            
//            print("歌曲长度：\(player!.duration)")
            player!.play()
        } catch let err {
            print("播放失败:\(err.localizedDescription)")
        }
        
    }
    
    func Play_Finish(){
         Img_Issue.backgroundColor = UIColor.clear
    }
    
}
