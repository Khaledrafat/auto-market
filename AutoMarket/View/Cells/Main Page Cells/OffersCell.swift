import UIKit

class OffersCell: UICollectionViewCell {

    //Outlets
    @IBOutlet weak var ImageView: UIView!
    @IBOutlet weak var Offers_Image: UIImageView!
    @IBOutlet weak var OfferContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Designs.Full_Cornered_Views(View: ImageView, Degree: 5)
    }

}
