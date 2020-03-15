import UIKit
import SwiftSpinner

class WhoAreWeViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var ButtomView: UIView!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    //Variables & Objects
    var htmlString = String()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //ScrollView Bouncing
        ScrollView.bounces = false
        
        //Status Bar Color
        Services.setStatusBarColor(view: view, withColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
        
        //Style
        Designs.Top_Cornered_Views(View: ButtomView)
        
        //MARK: - Get Description Data API
        SwiftSpinner.show("Loading")
        APIS.About_US { (error, result) in
            SwiftSpinner.hide()
            if error != nil {
                let alert = Services.Failed()
                self.present(alert , animated: true)
            } else {
                //MARK: - HTML TO String For Label
                self.htmlString = result!.description!
                //Getting HTML Data
                do {
                    let htmlText = try NSAttributedString(
                        data: self.htmlString.data(using: String.Encoding.unicode)!,
                        options: [.documentType: NSAttributedString.DocumentType.html],
                        documentAttributes: nil)
                    self.DescriptionLabel.attributedText = htmlText
                    self.DescriptionLabel.font = UIFont(name: "Cairo-SemiBold", size: 17)
                    self.DescriptionLabel.textAlignment = NSTextAlignment.right
                } catch let error {
                    self.DescriptionLabel.attributedText = NSAttributedString(string: "Error: \(error)")
                }
            }
        }
        
    }
    
    //MARK: - Light Content Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    //MARK: - Open Menu Button
    @IBAction func MenuButton(_ sender: Any) {
        let menu = Services.OpenMenu(view: view)
        present(menu , animated: true)
    }
}
