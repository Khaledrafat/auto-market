import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKPlacesKit

class MainViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var ButtomView: UIView!
    @IBOutlet weak var BigButton: UIButton!
    @IBOutlet weak var FacebookButton: Buttons!
    @IBOutlet weak var GooglePlusButton: Buttons!
    @IBOutlet weak var FirstView: UIView!
    @IBOutlet weak var SecondView: UIView!
    
    //Variables & Objects
    var facebook_id = ""
    var facebook_name = String()
    var facebook_email = String()
    var provider = String()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //Status Bar Color
        Services.setStatusBarColor(view: view, withColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
        
        //Getting Views Ready
        FirstView.alpha = 1.0
        SecondView.alpha = 0.0
        
        //Enabling Big Button (Change View Button)
        BigButton.alpha = 1.0
        
        //Buttons & Views Style
        Designs.Top_Cornered_Views(View: ButtomView)
        Designs.Top_Cornered_Views(View: BigButton)
        FacebookButton.layer.borderColor = #colorLiteral(red: 0.231372549, green: 0.3490196078, blue: 0.5960784314, alpha: 1)
        GooglePlusButton.layer.borderColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
    }
    
    //MARK: - Light Content Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Change View Button
    @IBAction func ChangeView(_ sender: Any) {
        FirstView.alpha = 0.0
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.SecondView.alpha = 1.0
        }) { (result) in
            self.BigButton.alpha = 0.0
        }
    }
    
    
    //MARK: - Facebook Button
    @IBAction func FacebookButton(_ sender: Any) {
        let manager = LoginManager()
        manager.logIn(permissions: [.email , .publicProfile], viewController: self) { (result) in
            switch result {
            case .cancelled :
                print("User Cancelled Login")
            case .failed(let error) :
                print("Error \(error)")
            case .success(let grantedPermissions , let declinedPermissions , let AcToken) :
                self.GetUserProfile(accessToken: AcToken)
            }
        }
    }
    
    //MARK: - Get User Info From FaceBook
    func GetUserProfile(accessToken : AccessToken) {
        let params = ["fields" : "id, name, email"]
        GraphRequest(graphPath : "me" , parameters: params).start { (connection, result, error) in
            if error == nil {
                if let data = result as? NSDictionary
                {
                    guard let id  = data.object(forKey: "id") as? String else { print("Case 403") ; return }
                    guard let name  = data.object(forKey: "name") as? String else { print("Case 203") ; return }
                    guard let email = data.object(forKey: "email") as? String
                        else
                    {
                        let alert = UIAlertController(title: "Error!", message: "Sorry , We Couldn't get Your Info From FaceBook Please Login Using Another Method OR Try Again Later", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                        alert.addAction(action)
                        self.present(alert , animated: true)
                        return
                    }
                    self.facebook_id = id
                    self.facebook_name = name
                    self.facebook_email = email
                    self.provider = "facebook"
                    self.performSegue(withIdentifier: "phone", sender: self)
                }
            }
        }
    }
    
    //MARK: - Google+ Button
    @IBAction func GoogleButton(_ sender: Any) {
        print("Google")
    }
    
    //MARK: - Phone Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "phone" {
            let destinationVC = segue.destination as! PhoneViewController
            destinationVC.face_id = facebook_id
            destinationVC.face_name = facebook_name
            destinationVC.face_email = facebook_email
            destinationVC.provider = self.provider
        }
    }
    
}
