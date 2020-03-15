import UIKit
import PINRemoteImage
import SwiftSpinner

class DetailedViewController: UIViewController ,UIGestureRecognizerDelegate {
    
    //Outlets
    @IBOutlet weak var SelectedImage: UIImageView!
    @IBOutlet weak var DiscountLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var ContentLabel: UILabel!
    @IBOutlet weak var RelativeCollection: UICollectionView!
    @IBOutlet weak var ButtomView: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    //Variables & Objects
    var selected_product = Offers()
    var products = [Offers]()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //Status Bar Color
        Services.setStatusBarColor(view: view, withColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
        
        //Disabling OverScrolling
        ScrollView.bounces = false
        
        //Style
        Designs.Top_Cornered_Views(View: ButtomView)
        
        ///CollectionView
        //Registering Cell
        RelativeCollection.register(UINib(nibName: "MarketCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MarketCell")
        //Delegation & DataSource
        RelativeCollection.dataSource = self
        RelativeCollection.delegate = self
        
        //Page Data
        SelectedImage.pin_updateWithProgress = true
        let url = URL(string: URLS.Images + selected_product.image!)
        SelectedImage.pin_setImage(from: url!)
        DiscountLabel.text = "20%"
        ContentLabel.text = selected_product.name!
        DescriptionLabel.text = selected_product.description!
        
        //MARK: - Get Related Offers API
        APIS.Realted_Offers(category_id: selected_product.category_id!, offer_id: selected_product.id!) { (error, container) in
            if error != nil {
                print(error!)
                let alert = Services.Failed()
                self.present(alert , animated: true)
            } else {
                self.products = container!
                self.RelativeCollection.reloadData()
            }
        }
        
        //MARK: - Swipe To Go Back
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    //MARK: - Swipe Gesture Function
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: - Light Content Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Dismiss Button
    @IBAction func DismissButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK: - Collection View
extension DetailedViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketCell", for: indexPath) as! MarketCollectionViewCell
        cell.PercentHeight.constant = CGFloat(40)
        cell.PercentWidth.constant = CGFloat(48)
        cell.PercentLabel.text = "خصم يصل الي 20%"
        let image_url = products[indexPath.row].image!
        let url = URL(string: URLS.Images + image_url)
        cell.ProductImage.pin_updateWithProgress = true
        cell.ProductImage.pin_setImage(from: url!)
        cell.ProductDescription.text = products[indexPath.row].description!
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected_product = products[indexPath.row]
        self.ScrollView.setContentOffset(CGPoint(x: ScrollView.contentOffset.x, y: 0), animated: true)
        self.viewDidLoad()
    }
    
    //MARK: - CollectionView Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 12, bottom: 12, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ( view.frame.size.width - 40 ) / 2
        let height = ( RelativeCollection.frame.size.height - 30 )
        return CGSize(width: width, height: height)
    }
    
}
