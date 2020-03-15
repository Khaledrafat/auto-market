import UIKit

class LogoutViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var ButtomView: UIView!
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //Status Bar Color
        Services.setStatusBarColor(view: view, withColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
        
        //Style
        Designs.Top_Cornered_Views(View: ButtomView)
    }
    
    //MARK: - Light Content Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:  -Menu Button
    @IBAction func MenuButton(_ sender: Any) {
        let menu = Services.OpenMenu(view: view)
        present(menu , animated: true , completion: nil)
    }
    
    //MARK: - Logout Button
    @IBAction func LogoutButton(_ sender: Any) {
        let alert = UIAlertController(title: "Logout", message: "Are you Sure You Want To Logout ?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            User_Default.removeUserData()
            User_Default.restart_app()
        }
        let action2 = UIAlertAction(title: "No", style: .cancel) { (action) in
            User_Default.restart_app()
        }
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert , animated: true)
    }
    
    //MARK: - Cancel Logout Button
    @IBAction func CancelLogout(_ sender: Any) {
        User_Default.restart_app()
    }
    
    
}
