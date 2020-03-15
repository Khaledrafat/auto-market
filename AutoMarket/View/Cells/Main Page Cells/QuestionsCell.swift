import UIKit

class QuestionsCell: UICollectionViewCell {
    
    //Outlets
    @IBOutlet weak var QuestionsView: UIView!
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var NumbersLabel: UILabel!
    
    //Variables & Objects
    var first_closure : (()->())?
    var second_closure : (()->())?
    
    //MARK: - ViewDidLoad
    override func awakeFromNib() {
        super.awakeFromNib()
        Designs.Full_Cornered_Views(View: QuestionsView, Degree: 5)
    }
    
    @IBAction func ButtonClicked(_ sender: UIButton) {
        if sender.tag == 0 {
            first_closure?()
        } else if sender.tag == 1 {
            second_closure?()
        }
    }
    

}
