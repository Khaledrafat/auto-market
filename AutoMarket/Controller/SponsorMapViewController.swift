import UIKit
import SwiftSpinner
import PINRemoteImage

class SponsorMapViewController: UIViewController , UIScrollViewDelegate{
    
    //Outlets
    var Image_URL = String()
    
    //Variables & Objects
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var MapImage: UIImageView!
    @IBOutlet weak var ButtomView: UIView!
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //Adding Status Bar
        Services.setStatusBarColor(view: view, withColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
        
        //Scroll View Delegation & Zooming
        ScrollView.delegate = self
        ScrollView.minimumZoomScale = 1.0
        ScrollView.maximumZoomScale = 6.0
        
        //Styling
        Designs.Top_Cornered_Views(View: ButtomView)
        
        //Downloading Map Image
        let url = URL(string: URLS.Images + Image_URL)
        MapImage.pin_updateWithProgress = true
        MapImage.pin_setImage(from: url!)
    }
    
    //MARK: - Dismiss Button
    @IBAction func DismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - ScrollView Zooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return MapImage
    }
    
    //MARK: - Light Content Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
