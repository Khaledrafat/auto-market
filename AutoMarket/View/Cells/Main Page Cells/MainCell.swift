import UIKit

class MainCell: UICollectionViewCell {

    //Outlets
    @IBOutlet weak var ImageView: UIView!
    @IBOutlet weak var ItemImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Style
        Designs.Full_Cornered_Views(View: ImageView, Degree: 5)
    }

}
