import UIKit

class MarketCollectionViewCell: UICollectionViewCell {

    //Outlets
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var PercentLabel: UILabel!
    @IBOutlet weak var ProductImage: UIImageView!
    @IBOutlet weak var ProductDescription: UILabel!
    @IBOutlet weak var PercentHeight: NSLayoutConstraint!
    @IBOutlet weak var PercentWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Designs.Full_Cornered_Views(View: MainView, Degree: 5)
        Designs.Side_Cornered_Labels(Label: PercentLabel, Degree: 5)
    }

}
