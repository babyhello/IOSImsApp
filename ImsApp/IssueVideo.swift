//
//  IssueVideo.swift
//  IMS
//
//  Created by 俞兆 on 2017/6/7.
//  Copyright © 2017年 Mark. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import AVKit

class IssueVideo: UIView {
    
    @IBOutlet var MainView: UIView!
    @IBOutlet weak var IssueVideoHeight: NSLayoutConstraint!
    
    @IBOutlet weak var Img_Cancel: UIImageView!
    //    @IBOutlet weak var IssueVideoHeight: NSLayoutConstraint!
    @IBOutlet weak var Issue_Video_VW: UIView!
    //
    //    @IBOutlet weak var Issue_Video_VW: UIView!
    //
    //    @IBOutlet weak var Img_Cancel: UIImageView!
    
    
    
    var VideoPath:String!
    
    var MyCustview:UIView!
    
    var playerViewController = AVPlayerViewController()
    
    var FromFile:Bool!
    
    init(frame: CGRect,VideoPath: String,FromFile:Bool){
        
        self.VideoPath = VideoPath
        self.FromFile = FromFile
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
        
        
        MyCustview = loadViewFromNib()
        MyCustview.frame = bounds
        MyCustview.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        IssueVideoHeight.constant = MyCustview.frame.height
        
        var avPlayer: AVPlayer!
        
        let TrueVideoPath:URL
        
        if(FromFile)
        {
            TrueVideoPath = URL(fileURLWithPath: VideoPath)
        }
        else
        {
            
            TrueVideoPath = URL(string: AppClass.ConvertServerPath(Path: VideoPath))!
        }
        
        let videoURL = TrueVideoPath.absoluteURL
        
        avPlayer = AVPlayer(url: videoURL as! URL)
        let playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.frame = bounds
        MyCustview.layer.addSublayer(playerLayer)
        //avPlayer.play()
        
        
        let player = avPlayer
        
        playerViewController.player = player
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(IssueVideo.Video_Click(_:)))
        
        
        MyCustview.addGestureRecognizer(tapGestureRecognizer)
        
        addSubview(MyCustview)
        
    }
    
    func Video_Click(_ sender: UITapGestureRecognizer)
    {
        var avPlayer: AVPlayer!
        
        let TrueVideoPath = URL(string: AppClass.ConvertServerPath(Path: VideoPath))!
        
        let videoURL = TrueVideoPath.absoluteURL
        
        avPlayer = AVPlayer(url: videoURL as! URL)
        
        playerViewController.player = avPlayer
        
        let currentController = AppClass.getCurrentViewController()
        
        currentController?.present(playerViewController, animated: false)
        {
            self.playerViewController.player!.play()
        }
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for:type(of: self))
        let nib = UINib(nibName: "IssueVideo", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
}
