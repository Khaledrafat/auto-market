import UIKit
import Alamofire
import SwiftyJSON

class APIS {
    
    //MARK: - Login API Function
    class func login(Email : String , Password : String , completion : @escaping (_ error : Error? , _ theUser : User?) -> Void ) {
        let url = URLS.login
        let params = ["email" : Email , "password" : Password]
        AF.request(url, method: .post, parameters: params)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error) :
                    completion(error , nil)
                    print("Error is \(error)")
                case .success(let value) :
                    let json = JSON(value)
                    if json["result"]["email"].string != nil {
                        var user = User()
                        user.id = json["result"]["id"].intValue
                        user.email = json["result"]["email"].stringValue
                        user.name = json["result"]["name"].stringValue
                        user.phone = json["result"]["phone"].stringValue
                        User_Default.saveUserData(id: user.id!, email: user.email!, name: user.name! , phone: user.phone!)
                        completion(nil , user)
                    } else {
                        completion(nil , nil)
                    }
                    
                }
        }
    }
    
    
    //MARK: - Register API Function
    class func Register(Email : String , name : String , phone : String , password : String , completion : @escaping (_ error : Error? ,_ success : Bool ,_ warning : String?) -> Void ) {
        let url = URLS.register
        let params = ["name" : name , "email" : Email , "password" : password , "phone" : phone]
        AF.request(url, method: .post, parameters: params)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error) :
                    completion(error , false , nil)
                case .success(let value) :
                    let json = JSON(value)
                    if json["result"]["name"].string != nil {
                        var user = User()
                        user.id = json["result"]["id"].intValue
                        user.email = json["result"]["email"].stringValue
                        user.name = json["result"]["name"].stringValue
                        user.phone = json["result"]["phone"].stringValue
                        User_Default.saveUserData(id: user.id!, email: user.email!, name: user.name! , phone: user.phone!)
                        completion(nil , true , nil)
                    } else if response.response?.statusCode == 422 {
                        if json["errors"]["email"].string != nil {
                            completion(nil , false ,json["errors"]["email"].string!)
                        } else {
                            completion(nil , false , nil)
                        }
                    }
                }
        }
    }
    
    //MARK: - Forgot Password API
    class func ForgotPassword(email : String , completion : @escaping (_ error : Error? ,_ success : Bool ) -> Void ) {
        let url = URLS.forgotpassword
        let params = ["email" : email]
        AF.request(url, method: .post, parameters: params, headers: nil)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error) :
                    completion(error , false)
                case .success( _ ) :
                    if response.response?.statusCode == 200 {
                        completion(nil , true)
                    } else {
                        completion(nil , false)
                    }
                }
        }
    }
    
    //MARK: - Get Questions API
    class func Get_Questions(id : Int , completion : @escaping (_ error : Error? , _ success : Bool ,_ Questions : [Question]?) -> Void ) {
        let url = URLS.questions
        let params = ["user_id" : id]
        AF.request(url, method: .get, parameters: params)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error) :
                    completion(error , false , nil)
                case .success(let value) :
                    let json = JSON(value)
                    var items = [Question]()
                    guard let results = json["result"].array else { return }
                    for item in results {
                        var question = Question()
                        question.id = item["id"].intValue
                        question.name = item["name"].stringValue
                        items.append(question)
                    }
                    completion(nil , true , items)
                }
        }
    }
    
    //MARK: - Contact US API
    class func Contact_US(userID : String , email : String , title : String , message : String , completion : @escaping (_ error : Error? ,_ success : Bool) -> Void) {
        let url = URLS.contact_us
        let params = ["user_id" : userID , "email" : email , "title" : title , "description" : message]
        AF.request(url, method: .post, parameters: params, headers: nil)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error) :
                    completion(error , false)
                case .success( _ ) :
                    completion(nil , true)
                }
        }
    }
    
    //MARK: - Main Slider Items
    class func MainSlider(completion : @escaping (_ error : Error? ,_ mainitems : [MainSliderItem]?) -> Void) {
        let url = URLS.mainSliderItems
        AF.request(url)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error) :
                    completion(error , nil)
                case .success(let value) :
                    let json = JSON(value)
                    var mainItems = [MainSliderItem]()
                    guard let result = json["result"].array else { return }
                    for item in result {
                        var mainitem = MainSliderItem()
                        mainitem.id = item["id"].intValue
                        mainitem.image = item["image"].stringValue
                        mainItems.append(mainitem)
                    }
                    completion(nil , mainItems)
                }
        }
    }
    
    //MARK: - Current Offers API
    class func Current_Offers(completion : @escaping (_ error : Error? ,_ Offers : [Offers]? ) -> Void) {
        let url = URLS.current_Offers
        AF.request(url , method: .get)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error) :
                    completion(error , nil)
                case .success(let value) :
                    let json = JSON(value)
                    guard let results = json["result"].array else { return }
                    var items = [Offers]()
                    for result in results {
                        var item = Offers()
                        item.id = result["id"].intValue
                        item.image = result["image"].stringValue
                        item.name = result["name"].stringValue
                        item.description = result["description"].stringValue
                        item.feature = result["feature"].intValue
                        item.category_id = result["category_id"].intValue
                        items.append(item)
                    }
                    completion(nil , items)
                }
        }
    }
    
    //MARK: - Related Offer API
    class func Realted_Offers(category_id : Int , offer_id : Int , completion : @escaping (_ error : Error? , _ Offers : [Offers]?) -> Void) {
        let url = URLS.related_Offers
        let params = ["category_id" : category_id , "offer_id" : offer_id ]
        AF.request(url, method: .get , parameters: params)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error) :
                    print(error)
                    completion(error , nil)
                case .success(let value) :
                    let json = JSON(value)
                    guard let results = json["result"].array else { return }
                    var items = [Offers]()
                    for result in results {
                        var item = Offers()
                        item.id = result["id"].intValue
                        item.image = result["image"].stringValue
                        item.name = result["name"].stringValue
                        item.description = result["description"].stringValue
                        item.feature = result["feature"].intValue
                        item.category_id = result["category_id"].intValue
                        items.append(item)
                    }
                    completion(nil , items)
                }
        }
    }
    
    //MARK: - All Offers
    class func All_Offers(completion : @escaping (_ error : Error? ,_ Offers : [Offers]? ) -> Void) {
        let url = URLS.all_Offers
        AF.request(url , method: .get)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error) :
                    completion(error , nil)
                case .success(let value) :
                    let json = JSON(value)
                    guard let results = json["result"].array else { return }
                    var items = [Offers]()
                    for result in results {
                        var item = Offers()
                        item.id = result["id"].intValue
                        item.image = result["image"].stringValue
                        item.name = result["name"].stringValue
                        item.description = result["description"].stringValue
                        item.feature = result["feature"].intValue
                        item.category_id = result["category_id"].intValue
                        items.append(item)
                    }
                    print(items)
                    completion(nil , items)
                }
        }
    }
    
    //MARK: - Get Sponsors API
    class func Get_Sponsors(completion : @escaping (_ error : Error? ,_ sponsers : Sponsors?) -> Void) {
        let url = URLS.sponsors
        AF.request(url , method: .get)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error) :
                    completion(error , nil)
                case .success(_) :
                    guard let data = response.data else { return }
                    do {
                        let container = try JSONDecoder().decode(Sponsors.self, from: data)
                        completion(nil , container)
                    } catch {
                        print(error)
                    }
                }
        }
    }
    
    //MARK: - Get Categories API
    class func Get_Categories(completion : @escaping (_ error : Error? ,_ categories : [Category]? ) -> Void) {
        let url = URLS.categories
        AF.request(url , method: .get)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error) :
                    completion(error , nil)
                case .success(let value) :
                    let json = JSON(value)
                    var container = [Category]()
                    guard let result = json["result"].array else { return }
                    //Adding Static Data "الكل"
                    let all_option = Category(id: 00000000, name: "الكل")
                    container.append(all_option)
                    //End OF Adding The Static Data
                    for cat in result {
                        var category = Category()
                        category.id = cat["id"].intValue
                        category.name = cat["name"].stringValue
                        container.append(category)
                    }
                    completion(nil , container)
                }
        }
    }
    
    //MARK: - Get Selected Category Offers API
    class func Get_Selected_Category(category_id : Int , completion : @escaping (_ error : Error? ,_ offers : [Offers]? ) -> Void) {
        let url = URLS.all_Offers
        let params = ["category_id" : category_id ]
        AF.request(url, method: .get, parameters: params, headers: nil)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error) :
                    completion(error , nil)
                case .success(let value) :
                    let json = JSON(value)
                    guard let results = json["result"].array else { return }
                    var items = [Offers]()
                    for result in results {
                        var item = Offers()
                        item.id = result["id"].intValue
                        item.image = result["image"].stringValue
                        item.name = result["name"].stringValue
                        item.description = result["description"].stringValue
                        item.feature = result["feature"].intValue
                        item.category_id = result["category_id"].intValue
                        items.append(item)
                    }
                    print(items)
                    completion(nil , items)
                }
        }
    }
    
    //MARK: - Send Answer API
    class func Send_Answer(user_id : Int , question_id : Int , answer : Int , completion : @escaping (_ error : Error? ,_ success : Bool) -> Void) {
        let url = URLS.answer
        let params = ["user_id" : user_id , "question_id" : question_id , "answer" : answer ]
        AF.request(url, method: .get, parameters: params, headers: nil)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error) :
                    completion(error , false)
                case .success(_) :
                    if response.response?.statusCode == 422 {
                        completion(nil , false)
                    } else {
                        completion(nil , true)
                    }
                }
        }
    }
    
    //MARK: - About US API
    class func About_US(completion : @escaping (_ error : Error? ,_ result : AboutUS?) -> Void) {
        let url = URLS.AboutUS
        AF.request(url , method: .get)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error) :
                    completion(error , nil)
                case .success(let value) :
                    let json = JSON(value)
                    guard let json_array = json["result"].array else { return }
                    var container = AboutUS()
                    container.id = json_array[0]["id"].intValue
                    container.map_image = json_array[0]["app_image"].stringValue
                    container.description = json_array[0]["description"].stringValue
                    completion(nil ,container)
                }
        }
    }
    
    //MARK: - Update Profile API
    class func Update_Profile(name : String , email : String , phone : String , user_id : String , completion : @escaping (_ error : Error? ,_ success : Bool) -> Void) {
        let url = URLS.update_profile
        let params = ["name" : name , "email" : email , "phone" : phone , "user_id" : user_id ]
        AF.request(url, method: .post, parameters: params, headers: nil)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error) :
                    completion(error , false)
                case .success( _ ) :
                    if response.response?.statusCode == 200 {
                        completion(nil , true)
                    } else {
                        completion(nil , false)
                    }
                }
        }
    }
    
    //MARK: - Social Login / Register
    class func Social_Login( id : String ,name : String , email : String , phone : String , provider : String , completion : @escaping (_ error : Error? ,_ success : Bool ,_ FBResult : FaceBook?) -> Void) {
        let url = URLS.social_login
        let params = ["name" : name , "email" : email , "phone" : phone , "provider" : provider , "provider_id" : id]
        AF.request(url, method: .post, parameters: params, headers: nil)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error) :
                    completion(error , false , nil)
                case .success(let value) :
                    if response.response?.statusCode == 200 {
                        let json = JSON(value)
                        var container = FaceBook()
                        container.id = json["result"]["id"].intValue
                        container.email = json["result"]["email"].stringValue
                        container.name = json["result"]["name"].stringValue
                        container.phone = json["result"]["phone"].stringValue
                        completion(nil , true , container)
                    } else {
                        completion(nil , false , nil)
                    }
                }
        }
    }
    
}
