import Foundation
import UIKit

class Designs {
    class func Top_Cornered_Views(View : UIView) {
        View.layer.cornerRadius = 25
        View.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        View.layer.masksToBounds = true
    }
    
    class func Buttom_Cornered_Views(View : UIView) {
        View.layer.cornerRadius = 5
        View.layer.maskedCorners = [.layerMaxXMaxYCorner , .layerMinXMaxYCorner]
        View.layer.masksToBounds = true
    }
    
    class func Full_Cornered_Views(View : UIView , Degree : CGFloat) {
        View.layer.cornerRadius = Degree
        View.layer.masksToBounds = true
    }
    
    class func Side_Cornered_Labels(Label : UILabel , Degree : CGFloat) {
        Label.layer.masksToBounds = true
        Label.layer.maskedCorners = [.layerMinXMaxYCorner , .layerMaxXMinYCorner]
        Label.layer.cornerRadius = Degree
    }
    
    class func Selected_View(Lineview : UIView , textField : UITextField , placeholder : String) {
        Lineview.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) ])
    }
    
    class func Normal_View(Lineview : UIView , textField : UITextField , placeholder : String) {
        Lineview.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) ])
    }
}
