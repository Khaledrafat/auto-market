import UIKit
import SwiftSpinner
import PINRemoteImage

class MapViewController: UIViewController , UIScrollViewDelegate {
    //Outlets
    @IBOutlet weak var ButtomView: UIView!
    @IBOutlet weak var MapImage: UIImageView!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    //Varibales & Objects
    var image_url = String()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //Style
        Designs.Top_Cornered_Views(View: ButtomView)
        
        //Status Bar
        Services.setStatusBarColor(view: view, withColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
        
        //ScrollView Delegation & Zooming FOR Image
        ScrollView.delegate = self
        ScrollView.minimumZoomScale = 1.0
        ScrollView.maximumZoomScale = 6.0
        
        //MARK: - Call About US API
        SwiftSpinner.show("Loading")
        APIS.About_US { (error, result) in
            SwiftSpinner.hide()
            if error != nil {
                print(error!)
                let alert = Services.Failed()
                self.present(alert , animated: true)
            } else {
                self.image_url = result!.map_image!
                let url = URL(string: URLS.Images + self.image_url)
                self.MapImage.pin_updateWithProgress = true
                self.MapImage.pin_setImage(from: url!)
            }
        }
        
    }
    
    //MARK: - Zooming For ScrollView
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.MapImage
    }
    
    //MARK: - Light Content Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Menu Button
    @IBAction func MenuButton(_ sender: Any) {
        let menu = Services.OpenMenu(view: view)
        present(menu , animated: true)
    }
    
}
