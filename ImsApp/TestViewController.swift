//
//  TestViewController.swift
//  com.msi.IMSApp
//
//  Created by 俞兆 on 2016/8/1.
//  Copyright © 2016年 Mark. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TestViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
   
    
    @IBOutlet weak var pickviewData: UIPickerView!
    @IBOutlet weak var ImgVew: UIImageView!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        pickviewData.dataSource = self
        pickviewData.delegate = self
        AppClass.WebImgGet("http://wtsc.msi.com/Code/10015657@2015-1204-0522-206781_ModelIMG_TCS.jpg",ImageView:ImgVew)
        
        
//        var img = UIImage()
//        
//        
//        Alamofire.request(.GET, "http://wtsc.msi.com/Code/10015657@2015-1204-0522-206781_ModelIMG_TCS.jpg")
//            .responseImage { response in
//                
//                //return response.result.value
//                
//                if let image = response.result.value {
//                    
//                 img = image
//                }
//        }
       
        //self.ImgVew.image = img

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30,height: 40))
        
        let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
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
        let myLabel = UILabel(frame: CGRect(x: 40, y: 0, width: pickerView.bounds.width - 90, height: 40 ))
        //myLabel.font = UIFont(name:some, font, size: 18)
        myLabel.text = rowString
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // do something with selected row
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
