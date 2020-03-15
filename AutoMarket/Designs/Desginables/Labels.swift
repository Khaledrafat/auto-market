import Foundation
import UIKit

@IBDesignable class Labels : UILabel {
    @IBInspectable var cornerRadius : CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
}
