import UIKit
import SwiftSpinner

class CreateAccountViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var ButtomView: UIView!
    @IBOutlet weak var NameLine: UIView!
    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var PhoneLine: UIView!
    @IBOutlet weak var PhoneText: UITextField!
    @IBOutlet weak var EmailLine: UIView!
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var PasswordLine: UIView!
    @IBOutlet weak var PasswordText: UITextField!
     
    //Variables & Objects
    
    //MARK: - VIewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //Status Bar Color
        Services.setStatusBarColor(view: view, withColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
        
        //ButtonView Design
        Designs.Top_Cornered_Views(View: ButtomView)
        
        //TextFields Delegations
        NameText.delegate = self
        PhoneText.delegate = self
        EmailText.delegate = self
        PasswordText.delegate = self
        
    }
    
    //MARK: - Light Content Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Dismiss Button
    @IBAction func DismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil
        )
    }
    
    //MARK: - RegisterButton
    @IBAction func RegisterButton(_ sender: Any) {
        //End Using Keyboard
        view.endEditing(true)
        
        //MARK: - Checking Empty Fields
        if NameText.text?.isEmpty == true {
            let alert = Services.MarkEmptyField(text: "Name", TextField: NameText)
            present(alert , animated:  true)
        } else if PasswordText.text?.isEmpty == true {
            let alert = Services.MarkEmptyField(text: "Password", TextField: PasswordText)
            present(alert , animated:  true)
        } else if PhoneText.text?.isEmpty == true {
            let alert = Services.MarkEmptyField(text: "Phone", TextField: PhoneText)
            present(alert , animated:  true)
        } else if EmailText.text?.isEmpty == true {
            let alert = Services.MarkEmptyField(text: "Email", TextField: EmailText)
            present(alert , animated:  true)
        } else {
            let email = EmailText.text!
            let password = PasswordText.text!
            let phone = PhoneText.text!
            let name = NameText.text!
            //MARK: -  Checking Password has more than 8 charcs
            if password.count < 8 {
                let alert = Services.check_password_length()
                present(alert , animated: true)
            } else if Int(phone) != nil {
                //MARK: - Calling Register API Function
                view.isUserInteractionEnabled = false
                SwiftSpinner.show("Registering")
                APIS.Register(Email: email, name: name, phone: phone, password: password) { (error, success, warning) in
                    SwiftSpinner.hide()
                    //MARK: - Checking IF E-Mail is Used Before
                    if error == nil && success == false && warning != nil {
                        let alert = UIAlertController(title: "Warning", message: "\(warning!)", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert , animated: true)
                        self.view.isUserInteractionEnabled = true
                    } else if error == nil && success == false && warning == nil {
                        let alert = Services.Check_Data()
                        self.present(alert , animated: true)
                        self.view.isUserInteractionEnabled = true
                    } else if success == true
                        //MARK: - Checking IF Operation iS A Success
                    {
                        guard let window = UIApplication.shared.keyWindow else { return }
                        let tab = UIStoryboard(name: "MenuMainSec", bundle: nil).instantiateViewController(withIdentifier: "MainPage")
                        window.rootViewController = tab
                        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
                        self.view.isUserInteractionEnabled = true
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
    
    //MARK: - KeyBoard Should Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
}


//MARK: - TextFields
extension CreateAccountViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case NameText:
            Designs.Selected_View(Lineview: NameLine, textField: NameText, placeholder: "الاسم بالكامل")
        case PhoneText:
            Designs.Selected_View(Lineview: PhoneLine, textField: PhoneText, placeholder: "رقم الهاتف")
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
        case NameText:
            Designs.Normal_View(Lineview: NameLine, textField: NameText, placeholder: "الاسم بالكامل")
        case PhoneText:
            Designs.Normal_View(Lineview: PhoneLine, textField: PhoneText, placeholder: "رقم الهاتف")
        case EmailText:
            Designs.Normal_View(Lineview: EmailLine, textField: EmailText, placeholder: "البريد الاكتروني")
        case PasswordText:
            Designs.Normal_View(Lineview: PasswordLine, textField: PasswordText, placeholder: "كلمة المرور")
        default:
            return
        }
    }
    
}
