import UIKit
import SideMenu

class SideMenuViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var MenuTable: UITableView!
    @IBOutlet weak var User_Name: UILabel!
    
    //Variables & Objects
    var MenuItems = [Menu]()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //Status Bar Color
        Services.setStatusBarColor(view: view, withColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
        
        //Get User Info
        let user = Services.Check_User_Status()!
        User_Name.text = user.name!
        
        //Static Data
        let item1 = Menu(section: "First Section", items: [Items(name: "الرئيسية") , Items(name: "ما هو سيراميكا ماركت") ,Items(name: "المعروضات") ,Items(name: "الرعاة") ,Items(name: "خريطة المعرض")])
        MenuItems.append(item1)
        
        let item2 = Menu(section: "Second Section", items: [Items(name: "تواصل معانا") , Items(name: "الاعدادت")])
        MenuItems.append(item2)
        
        let item3 = Menu(section: "Third Section", items: [Items(name: "تسجيل خروج")])
        MenuItems.append(item3)
        
        ///TableView
        //Delegation & DataSource
        MenuTable.delegate = self
        MenuTable.dataSource = self
        //Registering Cell
        MenuTable.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SideMenu")
    }
    
    //MARK: - Light Content Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


//MARK: - TableView
extension SideMenuViewController : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return MenuItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuItems[section].items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenu", for: indexPath) as! SideMenuTableViewCell
        cell.MenuLabel.text = MenuItems[indexPath.section].items?[indexPath.row].name
        cell.selectionStyle = .none
        
        return cell
    }
    
    //Header Height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(4)
    }
    
    //Header View
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("MenuHeaderView", owner: self, options: nil)?.first as! MenuHeaderView
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(56)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let window = UIApplication.shared.keyWindow else { return }
        if let name = MenuItems[indexPath.section].items?[indexPath.row].name {
            switch name {
            case "الرئيسية":
                print("Main")
                let tab = UIStoryboard(name: "MenuMainSec", bundle: nil).instantiateViewController(withIdentifier: "MainPage")
                window.rootViewController = tab
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            case "ما هو سيراميكا ماركت":
                let tab = UIStoryboard(name: "MenuMainSec", bundle: nil).instantiateViewController(withIdentifier: "WhoAreWe")
                window.rootViewController = tab
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            case "المعروضات":
                let tab = UIStoryboard(name: "MenuMainSec", bundle: nil).instantiateViewController(withIdentifier: "Market")
                window.rootViewController = tab
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            case "الرعاة":
                let tab = UIStoryboard(name: "MenuMainSec", bundle: nil).instantiateViewController(withIdentifier: "Sponsors")
                window.rootViewController = tab
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            case "خريطة المعرض":
                print("Map")
                let tab = UIStoryboard(name: "MenuMainSec", bundle: nil).instantiateViewController(withIdentifier: "MapView")
                window.rootViewController = tab
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            case "تواصل معانا":
                let tab = UIStoryboard(name: "MenuSecondSec", bundle: nil).instantiateViewController(withIdentifier: "Contact Us")
                window.rootViewController = tab
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            case "الاعدادت":
                let tab = UIStoryboard(name: "MenuSecondSec", bundle: nil).instantiateViewController(withIdentifier: "Settings")
                window.rootViewController = tab
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            case "تسجيل خروج":
                let tab = UIStoryboard(name: "MenuSecondSec", bundle: nil).instantiateViewController(withIdentifier: "Logout")
                window.rootViewController = tab
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            default:
                break
            }
        }
    }
    
}
