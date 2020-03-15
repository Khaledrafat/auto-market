import Foundation
import UIKit
import SideMenu

class Services {
    //MARK: - Open SideMenu Function
    class func OpenMenu(view : UIView) -> SideMenuNavigationController {
        let menu = UIStoryboard(name: "SideMenu", bundle: nil).instantiateViewController(withIdentifier: "SideMenu") as! SideMenuNavigationController
        menu.presentationStyle = .viewSlideOut
        menu.menuWidth = view.frame.width - 60
        menu.statusBarEndAlpha = 0
        
        return menu
    }
    
    //MARK: - Addind Colored StatusBar
    class func setStatusBarColor(view : UIView , withColor:UIColor) {
        let tag = 12321
        if let _ = view.viewWithTag(tag){
        } else {
            let overView = UIView()
            overView.frame = UIApplication.shared.statusBarFrame
            overView.backgroundColor = withColor
            overView.tag = tag
            view.addSubview(overView)
        }
    }
    
    //MARK: - EmptyTexts Alert
    class func ShowEmptyAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Warning", message: "Please Fill All Fields", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        return alert
    }
    
    //MARK: - WrongInfo Alert
    class func ShowWrongInfoAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Warning", message: "Please Check Your Info Again", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        
        return alert
    }
    
    //MARK: - EmptyField Alert
    class func MarkEmptyField(text Name : String , TextField : UITextField ) -> UIAlertController {
        let alert = UIAlertController(title: "Warning", message: "Please Fill \(Name) Field", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        TextField.attributedPlaceholder = NSAttributedString(string: "Please Fill", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)])
        
        return alert
    }
    
    //MARK: - Password Charcs Length Alert
    class func check_password_length() -> UIAlertController {
        let alert = UIAlertController(title: "Warning", message: "Password Has To Be More Than 8", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        
        return alert
    }
    
    //MARK: - Wrong Data Alert
    class func Check_Data() -> UIAlertController {
        let alert = UIAlertController(title: "Warning", message: "Please Check Your Data", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        
        return alert
    }
    
    //MARK: - Operation Failure ALert
    class func Failed() -> UIAlertController {
        let alert = UIAlertController(title: "Error!", message: "Sorry , It Seems The Operation Failed Please Try Again Later", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        
        return alert
    }
    
    //MARK: - Operation Done Successfully
    class func Successful() -> UIAlertController {
        let alert = UIAlertController(title: "Done", message: "Operation Finished Successfully , Thank You 😄", preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        
        return alert
    }
    
    //MARK: - Check iF User IS Logged IN OR Not
    class func Check_User_Status() -> User? {
        var user = User()
        if UserDefaults.standard.object(forKey: "user_id") != nil {
            user.id = UserDefaults.standard.object(forKey: "user_id") as? Int
            user.name = UserDefaults.standard.object(forKey: "user_name") as? String
            user.email = UserDefaults.standard.object(forKey: "user_email") as? String
            user.phone = UserDefaults.standard.object(forKey: "user_phone") as? String
            return user
        } else {
            return nil
        }
        
    }
    
}
