import UIKit
import SwiftSpinner

class SettingsViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var Buttomview: UIView!
    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var NameLine: UIView!
    @IBOutlet weak var PhoneText: UITextField!
    @IBOutlet weak var PhoneLine: UIView!
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var EmailLine: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Status Bar Color
        Services.setStatusBarColor(view: view, withColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
        
        //Style
        Designs.Top_Cornered_Views(View: Buttomview)
        
        //TextField Delegation
        EmailText.delegate = self
        PhoneText.delegate = self
        NameText.delegate = self
    }
    
    //MARK: - Update Data Button
    @IBAction func UpdateData(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        //Checking Empty Fields
        if NameText.text?.isEmpty == true || PhoneText.text?.isEmpty == true || EmailText.text?.isEmpty == true {
            let alert = Services.ShowEmptyAlert()
            present(alert , animated: true)
            self.view.isUserInteractionEnabled = true
        } else if Int(PhoneText.text!) != nil {
            SwiftSpinner.show("Loading")
            let email = EmailText.text!
            let name = NameText.text!
            let phone = PhoneText.text!
            guard let user = Services.Check_User_Status() else { print("Cade 43") ;
                self.view.isUserInteractionEnabled = true ; return }
            let user_id = String(user.id!)
            APIS.Update_Profile(name: name, email: email, phone: phone, user_id: user_id) { (error, success) in
                SwiftSpinner.hide()
                if error != nil {
                    let alert = Services.Failed()
                    self.present(alert , animated: true)
                } else if error == nil && success == false {
                    let alert = Services.Check_Data()
                    self.present(alert , animated: true)
                } else {
                    let alert = Services.Successful()
                    self.present(alert , animated: true)
                    User_Default.saveUserData(id: user.id!, email: email, name: name, phone: phone)
                    self.NameText.text = ""
                    self.EmailText.text = ""
                    self.PhoneText.text = ""
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
    
    
    //MARK: - MenuButton
    @IBAction func MenuButton(_ sender: Any) {
        view.endEditing(true)
        let menu = Services.OpenMenu(view: view)
        present(menu , animated: true , completion: nil)
    }
    
    //MARK: - Light Content Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Keyboard Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}


//MARK: - TextFields
extension SettingsViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case NameText :
            Designs.Selected_View(Lineview: NameLine, textField: NameText, placeholder: "اسم المستخدم")
        case PhoneText :
            Designs.Selected_View(Lineview: PhoneLine, textField: PhoneText, placeholder: "رقم التليفون")
        case EmailText :
            Designs.Selected_View(Lineview: EmailLine, textField: EmailText, placeholder: "example@gmail.com")
        default :
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case NameText :
            Designs.Normal_View(Lineview: NameLine, textField: NameText, placeholder: "اسم المستخدم")
        case PhoneText :
            Designs.Normal_View(Lineview: PhoneLine, textField: PhoneText, placeholder: "رقم التليفون")
        case EmailText :
            Designs.Normal_View(Lineview: EmailLine, textField: EmailText, placeholder: "example@gmail.com")
        default :
            return
        }
    }
}
