import UIKit
import SwiftSpinner

class PhoneViewController: UIViewController {
    //Outlets
    @IBOutlet weak var PhoneText: UITextField!
    @IBOutlet weak var LineView: UIView!
    
    //Variables & Objects
    var face_id = String()
    var face_name = String()
    var face_email = String()
    var provider = String()
    var FBUser = FaceBook()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //TextField Delegation
        PhoneText.delegate = self
        
        //Status Bar
        Services.setStatusBarColor(view: view, withColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
    }
    
    //MARK: - Light Status Bar Content
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - DismissButton
    @IBAction func DismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Return Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    //MARK: - Login / Register Button
    @IBAction func LoginButton(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        if PhoneText.text?.isEmpty == true {
            let alert = Services.MarkEmptyField(text: "Phone", TextField: PhoneText)
            present(alert , animated: true)
            self.view.isUserInteractionEnabled = true
        } else if Int(PhoneText.text!) != nil {
            SwiftSpinner.show("Loading")
            let phone = PhoneText.text!
            //MARK: - Login API
            APIS.Social_Login(id: face_id, name: face_name, email: face_email, phone: phone, provider: provider) { (error, success, result) in
                SwiftSpinner.hide()
                self.view.isUserInteractionEnabled = true
                if error != nil {
                    let alert = Services.Failed()
                    self.present(alert, animated: true)
                } else if error == nil && success == false {
                    let alert = Services.ShowWrongInfoAlert()
                    self.present(alert , animated: true)
                } else {
                    self.FBUser = result!
                    User_Default.saveUserData(id: self.FBUser.id!, email: self.FBUser.email!, name: self.FBUser.name!, phone: self.FBUser.phone!)
                    User_Default.restart_app()
                }
            }
            //String Phone Number Alert
        } else {
            let alert = UIAlertController(title: "!حدث خطأ", message: "من فضلك تاكد من رقم الهاتف المستخدم", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert ,animated: true)
            self.PhoneText.text = ""
            self.view.isUserInteractionEnabled = true
        }
    }
}


//MARK: - TextField Delegation
extension PhoneViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        Designs.Selected_View(Lineview: LineView, textField: PhoneText, placeholder: "رقم الهاتف")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        Designs.Normal_View(Lineview: LineView, textField: PhoneText, placeholder: "رقم الهاتف")
    }
}
