import UIKit

class ContactUsViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var ButtomView: UIView!
    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var MessageTitle: UITextField!
    @IBOutlet weak var MessageBody: UITextField!
    @IBOutlet weak var NameLine: UIView!
    @IBOutlet weak var TitleLine: UIView!
    @IBOutlet weak var MessageLine: UIView!
    
    //Variables & Objects
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //Status Bar Color
        Services.setStatusBarColor(view: view, withColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
        
        //Style
        Designs.Top_Cornered_Views(View: ButtomView)
        
        //TextFields Delegation
        UserName.delegate = self
        MessageBody.delegate = self
        MessageTitle.delegate = self
    }
    
    //MARK: - Light Content Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - KeyBoard Should Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    //MARK: - MenuButton
    @IBAction func MenuButton(_ sender: Any) {
        view.endEditing(true)
        let menu = Services.OpenMenu(view: view)
        present(menu , animated: true , completion: nil)
    }
    
    //MARK: - Send Your Opinions Button (Contact US)
    @IBAction func SendMessageButton(_ sender: Any) {
        view.isUserInteractionEnabled = false
        //Load User Data
        guard let user = Services.Check_User_Status() else { print("Case 34") ; return }
        
        //Checking Empty Fields
        if UserName.text?.isEmpty == true {
            let alert = Services.MarkEmptyField(text: "Please Fill", TextField: UserName)
            present(alert , animated: true)
            view.isUserInteractionEnabled = true
        } else if MessageTitle.text?.isEmpty == true {
            let alert = Services.MarkEmptyField(text: "Please Fill", TextField: MessageTitle)
            present(alert , animated: true)
            view.isUserInteractionEnabled = true
        } else if MessageBody.text?.isEmpty == true {
            let alert = Services.MarkEmptyField(text: "Please Fill", TextField: MessageBody)
            present(alert , animated: true)
            view.isUserInteractionEnabled = true
        } else {
            let user_id = String(user.id!)
            let email = user.email!
            let title = MessageTitle.text!
            let message = MessageBody.text!
            APIS.Contact_US(userID: user_id, email: email, title: title, message: message) { (error, success) in
                if error != nil {
                    print(error!)
                    let alert = Services.Failed()
                    self.present(alert, animated: true)
                    self.view.isUserInteractionEnabled = true
                } else {
                    let alert = Services.Successful()
                    self.present(alert, animated: true)
                    self.MessageBody.text = ""
                    self.MessageTitle.text = ""
                    self.UserName.text = ""
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    }
}


//MARK: - TextFields
extension ContactUsViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case UserName :
            Designs.Selected_View(Lineview: NameLine, textField: UserName, placeholder: "اسم المستخدم")
        case MessageTitle :
            Designs.Selected_View(Lineview: TitleLine, textField: MessageTitle, placeholder: "عنوان الرسالة")
        case MessageBody :
            Designs.Selected_View(Lineview: MessageLine, textField: MessageBody, placeholder: "محتوي الرسالة")
        default :
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case UserName :
            Designs.Normal_View(Lineview: NameLine, textField: UserName, placeholder: "اسم المستخدم")
        case MessageTitle :
            Designs.Normal_View(Lineview: TitleLine, textField: MessageTitle, placeholder: "عنوان الرسالة")
        case MessageBody :
            Designs.Normal_View(Lineview: MessageLine, textField: MessageBody, placeholder: "محتوي الرسالة")
        default :
            return
        }
    }
}
