import UIKit
import SwiftSpinner

class LoginViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var ButtomView: UIView!
    @IBOutlet weak var EmailLine: UIView!
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var PasswordLine: UIView!
    @IBOutlet weak var PasswordText: UITextField!
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //Status Bar Color
        Services.setStatusBarColor(view: view, withColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
        
        //ButtomView Design
        Designs.Top_Cornered_Views(View: ButtomView)
        
        //TextField Delegation
        EmailText.delegate = self
        PasswordText.delegate = self
    }
    
    //MARK: - Light Content Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - DismissButton
    @IBAction func DismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - LoginButton
    @IBAction func LoginButton(_ sender: Any) {
        view.isUserInteractionEnabled = false
        //MARK: - Cheking Inputs
        if EmailText.text?.isEmpty == false && PasswordText.text?.isEmpty == false {
            let email = EmailText.text!
            let password = PasswordText.text!
            //MARK: - Call Login API Function
            SwiftSpinner.show("Logging In")
            APIS.login(Email: email, Password: password) { (error, user) in
                SwiftSpinner.hide()
                if error == nil && user == nil {
                    let alert = Services.ShowWrongInfoAlert()
                    self.present(alert , animated: true)
                    self.view.isUserInteractionEnabled = true
                } else if user != nil {
                    guard let window = UIApplication.shared.keyWindow else { return }
                    let tab = UIStoryboard(name: "MenuMainSec", bundle: nil).instantiateViewController(withIdentifier: "MainPage")
                    window.rootViewController = tab
                    UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
                    self.view.isUserInteractionEnabled = true
                }
            }
        } else {
            let alert = Services.ShowEmptyAlert()
            present(alert , animated: true , completion: nil)
            view.isUserInteractionEnabled = true
        }
    }
    
    //MARK: - KeyBoard Should Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
}


//MARK: - TextFields
extension LoginViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case EmailText:
            Designs.Selected_View(Lineview: EmailLine, textField: EmailText, placeholder: "البريد الاكتروني")
        case PasswordText:
            Designs.Selected_View(Lineview: PasswordLine, textField: PasswordText, placeholder: "كلمة المرور")
        default:
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case EmailText:
            Designs.Normal_View(Lineview: EmailLine, textField: EmailText, placeholder: "البريد الاكتروني")
        case PasswordText:
            Designs.Normal_View(Lineview: PasswordLine, textField: PasswordText, placeholder: "كلمة المرور")
        default:
            return
        }
    }
    
}
