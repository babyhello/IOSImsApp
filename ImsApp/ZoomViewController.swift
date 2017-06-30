//
//  ZoomViewController.swift
//  IMS
//
//  Created by 俞兆 on 2017/6/28.
//  Copyright © 2017年 Mark. All rights reserved.
//

import UIKit

class ZoomViewController: UIViewController ,UIScrollViewDelegate{

    @IBOutlet weak var Scl_Content: UIScrollView!
    
    @IBOutlet weak var Img_Content: UIImageView!
    
    var ZoomImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.Scl_Content.minimumZoomScale = 1.0
        
        self.Scl_Content.maximumZoomScale = 6.0

        self.Scl_Content.delegate = self
        
        self.Img_Content.image = ZoomImage
                
        let done = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(Cancel))
        
        navigationItem.rightBarButtonItem = done
        
        // Do any additional setup after loading the view.
    }

    func Cancel()
    {
    dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return Img_Content
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
