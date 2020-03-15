import UIKit
import PINRemoteImage
import SwiftSpinner

class MarketViewController: UIViewController ,UIGestureRecognizerDelegate {
    
    //Outlets
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var ButtomView: UIView!
    @IBOutlet weak var Static_Image: UIImageView!
    @IBOutlet weak var Static_Discount: UILabel!
    @IBOutlet weak var Static_Content: UILabel!
    @IBOutlet weak var MarketCollection: UICollectionView!
    @IBOutlet weak var CategoryMainView: UIView!
    @IBOutlet weak var CategoryButtom: UIView!
    @IBOutlet weak var CategoryTable: UITableView!
    @IBOutlet weak var topConstrain: NSLayoutConstraint!
    
    
    //Variables & Objects
    var selected_product = Offers()
    var offers = [Offers]()
    var categories = [Category]()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //Status Bar Color
        Services.setStatusBarColor(view: view, withColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
        
        CategoryTable.bounces = false
        
        //Hiding Categories
        CategoryMainView.alpha = 1
        CategoryMainView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
        
        ///CollectionView
        //Registering Cell
        MarketCollection.register(UINib(nibName: "MarketCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MarketCell")
        //Delegation & Datasource
        MarketCollection.delegate = self
        MarketCollection.dataSource = self
        
        ///TableView
        //CategoryTable Delegate & Datasource
        CategoryTable.delegate = self
        CategoryTable.dataSource = self
        //Registering Cell
        CategoryTable.register(UINib(nibName: "CategoryTableCell", bundle: nil), forCellReuseIdentifier: "CategoryTableCell")
        
        //Styling
        Designs.Top_Cornered_Views(View: ButtomView)
        Designs.Top_Cornered_Views(View: CategoryButtom)
        
        //Call Get_Offers API
        Get_Offers()
        
        //MARK: - Swipe To Go Back
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: - Get Offers API
    func Get_Offers() {
        SwiftSpinner.show("Loading")
        APIS.All_Offers { (error, container) in
            SwiftSpinner.hide()
            if error != nil {
                print(error!)
                let alert = Services.Failed()
                self.present(alert , animated: true)
            } else {
                self.offers = container!
                self.MarketCollection.reloadData()
            }
        }
    }
    
    //MARK: - Light Content Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailed" {
            let DestinationVC = segue.destination as! DetailedViewController
            DestinationVC.selected_product = self.selected_product
        }
    }
    
    //MARK: - MenuButton
    @IBAction func MenuButton(_ sender: Any) {
        let menu = Services.OpenMenu(view: view)
        present(menu , animated: true)
    }
    
    //MARK: - Filter Button (Categories)
    @IBAction func CategoryButton(_ sender: Any) {
        //Show Categories View
        UIView.animate(withDuration: 0.5) {
            self.CategoryMainView.alpha = 1
            self.TopView.alpha = 0.5
            self.ButtomView.alpha = 0.5
            self.view.layer.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.CategoryMainView.transform = .identity
        }
        //MARK: - Get All Categories
        APIS.Get_Categories { (error, result) in
            if error != nil {
                let alert = Services.Failed()
                self.present(alert , animated: true)
            } else {
                self.categories = result!
                self.CategoryTable.reloadData()
            }
        }
        
    }
    
    //MARK: - Dismiss Filter Button (Categories)
    @IBAction func DismissCategories(_ sender: Any) {
        Dismiss_Filter()
    }
    
    //MARK: - Dismiss Filter Function
    func Dismiss_Filter() {
        UIView.animate(withDuration: 0.5) {
            self.CategoryMainView.alpha = 0
            self.TopView.alpha = 1
            self.ButtomView.alpha = 1
            self.view.layer.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1333333333, blue: 0.3843137255, alpha: 1)
            self.CategoryMainView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
        }
    }
    
}



//MARK: - CollectionView
extension MarketViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketCell", for: indexPath) as! MarketCollectionViewCell
        if indexPath.row == 0 || indexPath.row % 5 == 0{
            cell.PercentHeight.constant = CGFloat(48)
            cell.PercentWidth.constant = CGFloat(48)
        } else {
            cell.PercentHeight.constant = CGFloat(40)
            cell.PercentWidth.constant = CGFloat(48)
        }
        cell.PercentLabel.text = "20%"
        let image_url = offers[indexPath.row].image!
        let url = URL(string: URLS.Images + image_url)
        cell.ProductImage.pin_updateWithProgress = true
        cell.ProductImage.pin_setImage(from: url!)
        cell.ProductDescription.text = offers[indexPath.row].description!
        
        return cell
    }
    
    //Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 24, bottom: 12, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 || indexPath.row % 5 == 0 {
            let width = view.frame.size.width - 48
            let height = CGFloat(200)
            return CGSize(width: width, height: height)
        } else {
            let width =  (view.frame.size.width - 64 ) / 2
            let height = CGFloat(140)
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected_product = offers[indexPath.row]
        performSegue(withIdentifier: "detailed", sender: self)
    }
    
}


//MARK: - TableView
extension MarketViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableCell") as! CategoryTableCell
        cell.categoryLabel.text = categories[indexPath.row].name!
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(40)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categories[indexPath.row].name == "الكل" {
            //MARK: - Call Get All Offers API
            self.Get_Offers()
        } else {
            //MARK: - Get Selected Category Offers
            let category_id = categories[indexPath.row].id!
            SwiftSpinner.show("Loading")
            APIS.Get_Selected_Category(category_id: category_id) { (error, result) in
                SwiftSpinner.hide()
                if error != nil {
                    let alert = Services.Failed()
                    self.present(alert , animated: true)
                } else {
                    self.offers.removeAll()
                    self.offers = result!
                    self.MarketCollection.reloadData()
                }
            }
        }
        Dismiss_Filter()
    }
    
}
