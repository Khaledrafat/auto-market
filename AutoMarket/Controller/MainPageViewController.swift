import UIKit
import SideMenu
import PINRemoteImage
import SwiftSpinner

class MainPageViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var ButtomView: UIView!
    @IBOutlet weak var OffersCollection: UICollectionView!
    @IBOutlet weak var QuestionsCollection: UICollectionView!
    @IBOutlet weak var MainCollection: UICollectionView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var PageController: UIPageControl!
    @IBOutlet weak var Question_View: UIView!
    @IBOutlet weak var Question_View_Height: NSLayoutConstraint!
    
    //Variables & Objects
    var mainSlider = [MainSliderItem]()
    var Questions = [Question]()
    var current_offers = [Offers]()
    var selected_offer = Offers()
    private var currentIndex = 0
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //Status Bar Color
        Services.setStatusBarColor(view: view, withColor: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))
        
        //Style
        Designs.Top_Cornered_Views(View: ButtomView)
        
        ///ScrollView
        //ScrollView Delegation
        ScrollView.delegate = self
        //Stoping ScrollView Bouncing
        ScrollView.bounces = false
        
        ///CollectionVIews
        //Delegation & DataSource
        OffersCollection.delegate = self
        OffersCollection.dataSource = self
        QuestionsCollection.delegate = self
        QuestionsCollection.dataSource = self
        MainCollection.dataSource = self
        MainCollection.delegate = self
        //Registering cells
        OffersCollection.register(UINib(nibName: "OffersCell", bundle: nil), forCellWithReuseIdentifier: "OffersCell")
        QuestionsCollection.register(UINib(nibName: "QuestionsCell", bundle: nil), forCellWithReuseIdentifier: "QuestionsCell")
        MainCollection.register(UINib(nibName: "MainCell", bundle: nil), forCellWithReuseIdentifier: "MainCell")
        DispatchQueue.main.async {
            //Call Get Main Slider Items
            self.Get_MainSlider_Items()
            
            //Call Get Current Offers
            self.Get_CurrentOffers()
            
            //Call Get Questions
            self.Get_Questions()
        }
        
    }
    
    //MARK: - Light Content Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Preparing Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details" {
            let destinationVC = segue.destination as! DetailedViewController
            destinationVC.selected_product = selected_offer
        }
    }
    
    //MARK: - Getting Main Slider Items API
    func Get_MainSlider_Items() {
        SwiftSpinner.show("Loading")
        APIS.MainSlider { (error, mainitems) in
            SwiftSpinner.hide()
            if error != nil {
                print(error!)
                let alert = Services.Failed()
                self.present(alert , animated: true)
            } else {
                self.mainSlider = mainitems!
                // self.PageController.currentPage = 0
                self.PageController.numberOfPages = self.mainSlider.count
                self.MainCollection.reloadData()
            }
        }
    }
    
    //MARK: - Getting Current Offers API
    func Get_CurrentOffers() {
        APIS.Current_Offers { (error, Offers) in
            if error != nil {
                print(error!)
                let alert = Services.Failed()
                self.present(alert , animated: true)
            } else {
                self.current_offers = Offers!
                self.OffersCollection.reloadData()
            }
        }
    }
    
    //MARK: - Getting Questions From API
    func Get_Questions() {
        //Getting User Info From User_Defaults
        guard let user = Services.Check_User_Status() else { return }
        //        SwiftSpinner.show("Loading")
        APIS.Get_Questions(id: user.id!) { (error, success , items) in
            print(user.id!)
            //            SwiftSpinner.hide()
            if error != nil {
                print("Case 4 \(error!)")
            } else {
                self.Questions = items!
                if self.Questions.count == 0 {
                    self.Question_View_Height.constant = 0.0
                    self.Question_View.alpha = 0.0
                } else {
                    self.Question_View_Height.constant = 234
                    self.Question_View.alpha = 1.0
                }
                self.QuestionsCollection.reloadData()
            }
        }
    }
    
    
    //MARK: - MenuButton
    @IBAction func MenuButton(_ sender: Any) {
        let menu = Services.OpenMenu(view: view)
        present(menu , animated: true , completion: nil)
    }
    
    
}


//MARK: - CollectionView
extension MainPageViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == OffersCollection {
            return current_offers.count
        } else if collectionView == QuestionsCollection {
            return Questions.count
        } else {
            return mainSlider.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == OffersCollection {
            selected_offer = current_offers[indexPath.row]
            performSegue(withIdentifier: "details", sender: self)
        }
    }
    
    //Cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Offers Cell
        if collectionView == OffersCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OffersCell", for: indexPath) as! OffersCell
            let image_url = String(URLS.Images + current_offers[indexPath.row].image!)
            let url = URL(string: image_url)
            cell.Offers_Image.pin_updateWithProgress = true
            cell.Offers_Image.pin_setImage(from: url!)
            cell.OfferContent.text = current_offers[indexPath.row].name!
            return cell
            
            //Questions Cell
        } else if collectionView == QuestionsCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionsCell", for: indexPath) as! QuestionsCell
            cell.NumbersLabel.text = "\(indexPath.row + 1)/\(Questions.count)"
            cell.QuestionLabel.text = Questions[indexPath.row].name
            let user = Services.Check_User_Status()!
            //Yes - No Answers
            cell.first_closure = {
                //MARK: - Send Answer API Function
                self.QuestionsCollection.isUserInteractionEnabled = false
                APIS.Send_Answer(user_id: user.id!, question_id: self.Questions[indexPath.row].id!, answer: 0) { (error, success) in
                    self.QuestionsCollection.isUserInteractionEnabled = true
                    if success == false {
                        let alert = Services.Failed()
                        self.present(alert , animated: true)
                    } else {
                        if indexPath.row + 1 == self.Questions.count {
                            self.Question_View.alpha = 0.0
                            self.Question_View_Height.constant = 0.0
                            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
                                self.view.layoutIfNeeded()
                            })
                        } else {
                            let indexPath = IndexPath(row: indexPath.row + 1, section: 0)
                            self.QuestionsCollection.scrollToItem(at: indexPath, at: .left, animated: true)
                        }
                    }
                }
            }
            
            cell.second_closure = {
                //MARK: - Send Answer API Function
                self.QuestionsCollection.isUserInteractionEnabled = false
                APIS.Send_Answer(user_id: user.id!, question_id: self.Questions[indexPath.row].id!, answer: 1) { (error, success) in
                    self.QuestionsCollection.isUserInteractionEnabled = true
                    if success == false {
                        let alert = Services.Failed()
                        self.present(alert , animated: true)
                    } else {
                        if indexPath.row + 1 == self.Questions.count {
                            self.Question_View.alpha = 0.0
                            self.Question_View_Height.constant = 0.0
                            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
                                self.view.layoutIfNeeded()
                            })
                        } else {
                            let indexPath = IndexPath(row: indexPath.row + 1, section: 0)
                            self.QuestionsCollection.scrollToItem(at: indexPath, at: .left, animated: true)
                        }
                    }
                }
            }
            return cell
            
            //MainCollection Cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as! MainCell
            let image_url = String(URLS.Images + mainSlider[indexPath.row].image!)
            let url = URL(string: image_url)
            cell.ItemImage.pin_updateWithProgress = true
            cell.ItemImage.pin_setImage(from: url!)
            
            return cell
        }
    }
    
    //MARK: - CollectionView Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == OffersCollection {
            return UIEdgeInsets(top: 4, left: 24, bottom: 4, right: 24)
        } else if collectionView == MainCollection {
            return UIEdgeInsets(top: 20, left: 0, bottom: 8, right: 0)
        } else {
            return UIEdgeInsets(top: 32, left: 0, bottom: 24, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == OffersCollection {
            let width = ( OffersCollection.frame.size.width - 64 ) / 2
            let height = ( OffersCollection.frame.size.height - 64 ) / 2
            
            return CGSize(width: width, height: height)
        } else if collectionView == QuestionsCollection {
            let width = QuestionsCollection.frame.size.width
            let height = QuestionsCollection.frame.size.height - 56
            
            return CGSize(width: width, height: height)
        } else {
            let width = MainCollection.frame.size.width
            let height = MainCollection.frame.size.height
            
            return CGSize(width: width, height: height)
        }
    }
    
    //MARK: - Page Controller Sliding / Starting Position
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.currentIndex = Int(MainCollection.contentOffset.x / self.MainCollection.frame.size.width)
        self.PageController.currentPage = self.currentIndex
    }
    
}
