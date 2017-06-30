//
//  AppClass.swift
//  ImsApp
//
//  Created by 俞兆 on 2016/7/5.
//  Copyright © 2016年 Mark. All rights reserved.
//
import UIKit
import Alamofire
import AlamofireImage

open class AppClass
{
    open static var ImagePath = "http://wtsc.msi.com.tw/IMS/IMS_App_Service.asmx/Get_File?FileName=//172.16.111.114/File/SDQA/Code/Admin/"
    
    //public static var ServerPath = "http://172.16.98.4/IMSApp"
    
    open static var ServerPath = "http://wtsc.msi.com.tw/IMS"
    
    open static func Alert(_ Message:String,SelfControl:AnyObject)
    {
        let alertController = UIAlertController(title: "", message:
            Message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        SelfControl.present(alertController, animated: true, completion: nil)
    }
    
    open static func Alert(_ Message:String,MessageTitle:String,SelfControl:AnyObject)
    {
        let alertController = UIAlertController(title: MessageTitle, message:
            Message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        SelfControl.present(alertController, animated: true, completion: nil)
    }
    
    
    open static func PriorityImage(_ Priotity:String)-> UIImageView
    {
        var imageName = ""
        
        switch Priotity {
        case "1":
            imageName = "ic_issue_prioP1"
            break;
        case "2":
            imageName = "ic_issue_prioP2"
            break;
        case "3":
            imageName = "ic_issue_prioP3"
            break;
        default: break
            
        }
        
        let image = UIImageView(image: UIImage(named: imageName))
        
        return image
        
    }
    
    open static func DateStringtoShortDate(_ DateString:String) -> String
    {
        if DateString.length >= 10 {
            
            return (DateString as NSString).substring(with: NSMakeRange(0, 10))
            
        }
        else
            
        {
            return DateString
        }
        
    }
    
    
    
    open static func WebImgGet(_ Path:String,ImageView:UIImageView)
    {

        let size = ImageView.frame.size
        
        let url = URL(string: ("http://wtsc.msi.com.tw/IMS/IMS_App_Service.asmx/Get_File?FileName=" + Path).addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!)!
        
        let placeholderImage = UIImage(contentsOfFile: "default_logo")
        
        ImageView.af_setImage(withURL: url,placeholderImage: placeholderImage,filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: size, radius: 0.0))
        
        
    }
    
    open static func WebImg(_ Path:String) -> UIImage
    {
        
        var DisplayImage = UIImage()
        
        
        
        //let encodedName = Path.addingPercentEscapes(using: String.Encoding.utf8)
        
        let encodedName = Path.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        //print(encodedName)
        
        Alamofire.request(encodedName!)
            .responseImage { response in
                
                //print(response.data)
                //return response.result.value
                
                
                if let image = response.result.value {
                    //print(image)
                    //DisplayImage =  image
                    
                  DisplayImage =  UIImage(cgImage: image.cgImage!)
                    
                }
        }
        
        
        return DisplayImage
        
    }
    open static func Get_Unique_FileName() -> String
    {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        let second = calendar.component(.second, from: date as Date)
        let nanosecond = calendar.component(.nanosecond, from: date as Date)
        
        return String(hour) + String(minutes) + String(second) + String(nanosecond)
    }
    
}

extension UIColor {
    convenience init(hexString:String) {
        let hexString:NSString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
        let scanner            = Scanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
}

extension UILabel{
    func SetLabelDefaultSize(_ DefaultSize:CGFloat)
    {
        //        if AppUser.OldFontSize != 1 && AppUser.OldFontSize != nil  {
        //
        //            self.font = self.font.fontWithSize(self.font.pointSize / AppUser.OldFontSize!)
        //
        //        }
        //
        //
        //            self.font = self.font.fontWithSize(self.font.pointSize * DefaultSize)
        //
        //
        
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension String {
    var length: Int {
        return characters.count
    }
}

extension String {
    struct NumberFormatter {
        static let instance = Foundation.NumberFormatter()
    }
    var doubleValue:Double? {
        return NumberFormatter.instance.number(from: self)?.doubleValue
    }
    var integerValue:Int? {
        return NumberFormatter.instance.number(from: self)?.intValue
    }
}
