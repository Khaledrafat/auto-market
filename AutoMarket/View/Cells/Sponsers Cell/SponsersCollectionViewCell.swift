import UIKit

class SponsersCollectionViewCell: UICollectionViewCell {

    //Outlets
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var LabelView: UIView!
    @IBOutlet weak var SponserImage: UIImageView!
    @IBOutlet weak var SponserLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Views Design
        Designs.Buttom_Cornered_Views(View: LabelView)
        Designs.Full_Cornered_Views(View: MainView, Degree: 5)
    }

}
