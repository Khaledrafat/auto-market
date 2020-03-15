import UIKit

class ForgotPasswordViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var ButtomView: UIView!
    @IBOutlet weak var EmailLine: UIView!
    @IBOutlet weak var EmailText: UITextField!
    
    //MARK:  - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //Status Bar Color
        Services.setStatusBarColor(view: view, withColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
        
        //ButtomView Design
        Designs.Top_Cornered_Views(View: ButtomView)
        
        //TextField Delegation
        EmailText.delegate = self
    }
    
    //MARK: - Light Content Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Dismiss Button
    @IBAction func DismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Remembered Password
    @IBAction func RememberedButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Sending Remember Password E-Mail
    @IBAction func SendMail(_ sender: Any) {
        if EmailText.text?.isEmpty == true {
            //Checking for empty Field
            let alert = Services.MarkEmptyField(text: "Email", TextField: EmailText)
            present(alert , animated: true)
        } else {
            let email = EmailText.text!
            view.isUserInteractionEnabled = false
            //MARK: - Forgot Password API
            APIS.ForgotPassword(email: email) { (error, success) in
                if error != nil {
                    self.view.isUserInteractionEnabled = true
                    print("errorrrrrrrrrrrr")
                } else if error == nil && success == true {
                    //Sent Successfully
                    let alert = UIAlertController(title: "Success", message: "Mail Sent Successfully", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Done", style: .default) { _ in
                        self.EmailText.text = ""
                        self.view.endEditing(true)
                    }
                    alert.addAction(action)
                    self.present(alert , animated: true)
                    self.view.isUserInteractionEnabled = true
                } else if error == nil && success == false {
                    //Wrong Mail
                    let alert = Services.ShowWrongInfoAlert()
                    self.present(alert , animated: true)
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    //MARK: - KeyBoard Should Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
}


//MARK: - TextFields
extension ForgotPasswordViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case EmailText:
            Designs.Selected_View(Lineview: EmailLine, textField: EmailText, placeholder: "البريد الاكتروني")
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case EmailText:
            Designs.Normal_View(Lineview: EmailLine, textField: EmailText, placeholder: "البريد الاكتروني")
        default:
            break
        }
    }
}
