//
//  ViewPhotoViewController.swift
//  com.msi.IMSApp
//
//  Created by 俞兆 on 2016/8/9.
//  Copyright © 2016年 Mark. All rights reserved.
//

import UIKit
import Photos

class ViewPhotoViewController: UIViewController {

    var assetCollection: PHAssetCollection!
    var photosAsset: PHFetchResult<AnyObject>!
    var index: Int = 0
    
    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnTap = true    //!!Added Optional Chaining
        
        self.displayPhoto()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func displayPhoto(){
        // Set targetSize of image to iPhone screen size
        //let screenSize: CGSize = UIScreen.main.bounds.size
        //let targetSize = CGSize(width: screenSize.width, height: screenSize.height)
    }


}
