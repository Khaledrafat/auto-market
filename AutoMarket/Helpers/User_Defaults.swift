import Foundation
import UIKit

class User_Default {
    //MARK: - Save User Data
    class func saveUserData(id : Int , email : String , name : String , phone : String) {
        let def = UserDefaults.standard
        def.set(id, forKey: "user_id")
        def.set(name, forKey: "user_name")
        def.set(email, forKey: "user_email")
        def.set(phone, forKey: "user_phone")
        def.synchronize()
    }
    
    //MARK: - Remove User Data
    class func removeUserData() {
        let def = UserDefaults.standard
        def.set(nil, forKey: "user_id")
        def.set(nil, forKey: "user_name")
        def.set(nil, forKey: "user_email")
        def.set(nil, forKey: "user_phone")
        def.synchronize()
    }
    
    //MARK: - Restart App
    class func restart_app() {
        guard let window = UIApplication.shared.keyWindow else { return }
        if Services.Check_User_Status() != nil {
            let tab = UIStoryboard(name: "MenuMainSec", bundle: nil).instantiateViewController(withIdentifier: "MainPage")
            window.rootViewController = tab
            UIView.transition(with: window, duration: 0.8, options: .transitionFlipFromTop, animations: nil, completion: nil)
        } else {
            let tab = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Start")
            window.rootViewController = tab
            UIView.transition(with: window, duration: 0.8, options: .transitionFlipFromTop, animations: nil, completion: nil)
        }
    }
}
