import UIKit
import PINRemoteImage
import SwiftSpinner

class SponsorsViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var ButtomView: UIView!
    @IBOutlet weak var SponsersCollection: UICollectionView!
    
    //Variables & Objects
    var sponsors = [Sponsors]()
    var selected_sponsor_map = String()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //Status Bar Color
        Services.setStatusBarColor(view: view, withColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
        
        //ButtomView Design
        Designs.Top_Cornered_Views(View: ButtomView)
        
        ///CollectionView
        //Delegation & DataSource
        SponsersCollection.delegate = self
        SponsersCollection.dataSource = self
        //Registering Cell
        SponsersCollection.register(UINib(nibName: "SponsersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SponserCell")
        //Registering Header
        SponsersCollection.register(UINib(nibName: "SponsorsHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SponsorsHeader")
        
        //Call Get_Sponsors Function
        Get_Sponsors()
    }
    
    //MARK: - Light Content Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Get Sponsors API
    func Get_Sponsors() {
        SwiftSpinner.show("Loading")
        APIS.Get_Sponsors { (error, container) in
            SwiftSpinner.hide()
            if error != nil {
                let alert = Services.Failed()
                self.present(alert , animated: true)
            } else {
                self.sponsors.append(container!)
                self.SponsersCollection.reloadData()
            }
        }
    }
    
    //MARK: - MenuButton
    @IBAction func MenuButton(_ sender: Any) {
        let menu = Services.OpenMenu(view: view)
        present(menu, animated: true , completion: nil)
    }
    
    //MARK: - Preparing Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sponsormap" {
            let destinationVC = segue.destination as! SponsorMapViewController
            destinationVC.Image_URL = selected_sponsor_map
        }
    }
}



//MARK: - CollectionView
extension SponsorsViewController : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    // Number OF Sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let section = (self.sponsors.first?.result.count) ?? 1
        return section
    }
    
    //MARK: - Collection View Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SponsorsHeader", for: indexPath) as! SponsorsHeader
        header.HeaderLabel.text = sponsors.first?.result[indexPath.section].name
        return header
    }
    
    //Header Height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = SponsersCollection.frame.size.width
        let height = CGFloat(52)
        return CGSize(width: width, height: height)
    }
    
    //Rows IN Sections
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number_of_items = (self.sponsors.first?.result[section].images.count) ?? 1
        return number_of_items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SponserCell", for: indexPath) as! SponsersCollectionViewCell
        cell.SponserLabel.text = "الموقع علي الخريطه"
        if let image_url = sponsors.first?.result[indexPath.section].images[indexPath.row].image {
            let url = URL(string: URLS.Images + image_url)
            cell.SponserImage.pin_updateWithProgress = true
            cell.SponserImage.pin_setImage(from: url!)
            cell.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            cell.layer.shadowRadius = 3.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            return cell
        }
        return cell
    }
    
    //MARK: - Collection View Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.size.width - 64) / 2
        let height = CGFloat (140.0)
        
        return CGSize(width: width, height: height)
    }
    
    //Cell Insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 24, bottom: 12, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected_sponsor_map = (sponsors.first?.result[indexPath.section].images[indexPath.row].mapImage ?? "")
        performSegue(withIdentifier: "sponsormap", sender: self)
    }
}
