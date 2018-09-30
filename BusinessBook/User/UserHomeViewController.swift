//
//  UserHomeViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/23/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Alamofire
protocol SendBusinessDelegate{
    func sendBusinessNo(index:Int)
}
class UserHomeViewController: UIViewController ,menuDelegate,SendBusinessDelegate{
    //MARK:IBOUTlet
    
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var regionDone: UIButton!
    @IBOutlet weak var regionPickerView: UIPickerView!
    @IBOutlet weak var cityDone: UIButton!
    @IBOutlet weak var cityPickerView: UIPickerView!
    @IBOutlet weak var categoryDone: UIButton!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var hospitalBtn: UIButton!
   
    @IBOutlet weak var regionBtn: UIButton!
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var searchName: UITextField!
    @IBOutlet weak var offerCollectionView: UICollectionView!
    
    
    @IBOutlet weak var regionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var anotherBtn: UIButton!
    @IBOutlet weak var historicPlaceBtn: UIButton!
    
    @IBOutlet weak var ineedHotelBtn: UIButton!
    @IBOutlet weak var iamHungryBtn: UIButton!
    //MARK:variable
    var menu_vc:UserMenuViewController!
    var BussinessList:[BusinessBean] = []
    var categoryList:[CategoryBean] = []
    var cityList:[CityBean] = []
    var regionList:[RegionBean] = []
     var categSelected = -1
    var BusinessNo = -1
    var citySelected = -1
    var regionSelected = -1
    override func viewDidLoad() {
        super.viewDidLoad()
         menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "UserMenuViewController") as! UserMenuViewController
        activityIndicator.isHidden = true
         activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        getCategory()
        regionBtn.isEnabled = false
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        if networkExist == true {
            getData()
        }else{
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        offerCollectionView.delegate = self
        offerCollectionView.dataSource = self
       
      
        styleBtn()
        
        
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0, y: 0.0, width: 20, height: 20)
        menuBtn.setImage(UIImage(named:"menu.png"), for: .normal)
        menuBtn.addTarget(self, action: #selector(MenuButtonTapped), for: UIControlEvents.touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        if #available(iOS 9.0, *) {
            let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
            currWidth?.isActive = true
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 9.0, *) {
            let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
            currHeight?.isActive = true
        } else {
            // Fallback on earlier versions
        }
        
        self.navigationItem.leftBarButtonItem = menuBarItem
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
//        let myimage = UIImage(named: "menu.png")?.withRenderingMode(.alwaysOriginal)
//        let barButtonItem2 = UIBarButtonItem(image: myimage, style: .plain, target: self, action: #selector(MenuButtonTapped))
//        self.navigationItem.leftBarButtonItem = barButtonItem2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:MENU FUnction
    @objc func respondToGesture(gesture:UISwipeGestureRecognizer){
        switch gesture.direction{
        case UISwipeGestureRecognizerDirection.right:
            print("right")
            showMenu()
        case UISwipeGestureRecognizerDirection.left:
            print("left Swipe")
            close_on_swipe()
        default:
            print("")
        }
    }
    func close_on_swipe(){
        if  AppDelegate.userMenu_bool{
            
        }else{
            closeMenu()
        }
    }
    func showMenu(){
        UIView.animate(withDuration: 0.3){ ()->Void in
            self.menu_vc.view.frame = CGRect(x:0,y:60,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
            self.menu_vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.menu_vc.menuDel = self
            self.addChildViewController(self.menu_vc)
            self.view.addSubview(self.menu_vc.view)
            AppDelegate.userMenu_bool = false
        }
        
    }
    func closeMenu(){
        UIView.animate(withDuration: 0.3, animations: { ()->Void in
            self.menu_vc.view.frame = CGRect(x:-UIScreen.main.bounds.size.width,y:60,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height)
        }) { (finished) in
            self.menu_vc.view.removeFromSuperview()
        }
        
        AppDelegate.userMenu_bool = true
    }
    //MARK:Function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailVC" {
            var  detailVc:DetailBusinessViewController = (segue.destination as? DetailBusinessViewController)!
            detailVc.id = BusinessNo
        }
    }
    func sendBusinessNo(index:Int){
        BusinessNo = index 
    }
    func menuActionDelegate(number:Int){
        switch number{
        case 0:
            print("AllCategory")
            view4.isHidden = false
             view2.isHidden = true
            view3.isHidden = true
              view5.isHidden = true
            view6.isHidden = true
        case 1:
            print("")
            
        case 2:
            print("favourite")
            view3.isHidden = false 
            view2.isHidden = true
            view4.isHidden = true
              view5.isHidden = true
            view6.isHidden = true
        case 3:
            print("")
            view5.isHidden = false
            view4.isHidden = true
            view3.isHidden = true
            view2.isHidden = true
            view6.isHidden = true
        default:
            print("")
            
        }
    }
    func styleSearchBar(searchBar:UISearchBar){
        for view in searchBar.subviews.last!.subviews {
            if type(of: view) == NSClassFromString("UISearchBarBackground"){
                view.alpha = 0.0
            }
        }
    }
    func styleBtn(){
        historicPlaceBtn.layer.cornerRadius = 10
        hospitalBtn.layer.cornerRadius = 10
        ineedHotelBtn.layer.borderWidth = 0.5
        ineedHotelBtn.layer.borderColor = UIColor.white.cgColor
        iamHungryBtn.layer.borderWidth = 0.5
        iamHungryBtn.layer.borderColor = UIColor.white.cgColor
        styleGradientBtn(button:ineedHotelBtn,topColor:UIColor.white.cgColor,bottom:UIColor.red.cgColor)
  styleGradientBtn(button:iamHungryBtn,topColor:UIColor.white.cgColor,bottom:UIColor.green.cgColor)
        styleGradientBtn(button:anotherBtn,topColor:UIColor.gray.cgColor,bottom:UIColor.white.cgColor)
       
       
    }
    func styleGradientBtn(button:UIButton,topColor:CGColor,bottom:CGColor){
        button.layer.cornerRadius = 10
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.colors = [topColor, bottom]
        gradientLayer.borderColor = button.layer.borderColor
        gradientLayer.borderWidth = button.layer.borderWidth
        gradientLayer.cornerRadius =  button.layer.cornerRadius
        button.layer.insertSublayer(gradientLayer, at: 0)
    }
    func getCategory(){
        
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            let url = Constant.baseURL + Constant.URICateg
            Alamofire.request(url, method:.get, parameters: nil,encoding: JSONEncoding.default, headers:nil)
                .responseJSON { response in
                    print(response)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    switch response.result {
                    case .success:
                        if let datares = response.result.value as? [String:Any]{
                            
                            if let data  = datares["data"] as? [[String:Any]]{
                                for item in data{
                                    var category = CategoryBean()
                                    if let id = item["id"] as? Int {
                                        category.id = id
                                    }
                                    if let name = item["name"] as? String{
                                        category.name = name
                                    }
                                    self.categoryList.append(category)
                                }
                                self.categoryPickerView.delegate = self
                                self.categoryPickerView.dataSource = self
                               
                            }
                            
                        }
                    case .failure(let error):
                        print(error)
                        
                        let alert = UIAlertController(title: "", message: "Network fail" , preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
            }
        }else{
            
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func getCity(){
        
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            let url = Constant.baseURL + Constant.URICities
            Alamofire.request(url, method:.get, parameters: nil,encoding: JSONEncoding.default, headers:nil)
                .responseJSON { response in
                    print(response)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    switch response.result {
                    case .success:
                        if let data = response.result.value as? [[String:Any]]{
                            for item in data {
                                let city = CityBean()
                                if let id = item["id"] as? Int {
                                    city.id = id
                                }
                                if let name = item["name"] as? String{
                                    city.name = name
                                }
                                self.cityList.append(city)
                            }
                           
                            
                        }
                    case .failure(let error):
                        print(error)
                        
                        let alert = UIAlertController(title: "", message: "Network fail" , preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
            }
        }else{
            
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func getRegion(){
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
           
            if cityList.count > 0 && citySelected != -1 {
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            let url = Constant.baseURL + Constant.URIRegion + "\(cityList[citySelected].id)"
            Alamofire.request(url, method:.get, parameters: nil,encoding: JSONEncoding.default, headers:nil)
                .responseJSON { response in
                    print(response)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    switch response.result {
                    case .success:
                        if let data = response.result.value as? [[String:Any]]{
                            for item in data {
                               let region = RegionBean()
                                if let id = item["id"] as? Int {
                                    region.id = id
                                }
                                if let name = item["name"] as? String{
                                    region.name = name
                                }
                                if let cityId = item["city_id"] as? Int{
                                    region.cityId = cityId
                                }
                                self.regionList.append(region)
                            }
                            
                            
                        }
                    case .failure(let error):
                        print(error)
                        
                        let alert = UIAlertController(title: "", message: "Network fail" , preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
            }
            }else{
                let alert = UIAlertController(title: "", message: "select city" , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func getData(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
 
      var user_id = UserDefaults.standard.value(forKey: "user_id") as! String
        let url = Constant.baseURL + Constant.URIDefaultSearch + "\(1)"
        Alamofire.request(url, method:.get, parameters: nil,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    if let datares = response.result.value as? [String:Any]{
                        if let flag = datares["flag"] as? String {
                            if flag == "0"{
                                self.showToast(message: "fail")
                            }
                        }
                        if let data  = datares["data"] as? [Dictionary<String,Any>]{
                            for item in data{
                                let business = BusinessBean()
                                if let address = item["address"] as? String{
                                    business.address = address
                                }
                                if let average_rating = item["average_rating"] as? String{
                                    
                                }
                                if let logo = item["logo"] as? String{
                                    business.logo = logo
                                }
                                var catego = CategoryBean()
                                if let category = item["category"] as? [String:Any]{
                                    if let id = category["id"] as? Int {
                                        catego.id = id
                                    }
                                    if let name = category["name"] as? String{
                                        catego.name = name
                                    }
                                   business.category = catego
                                }
                                
                                if let city = item["city"] as? String{
                                    business.city = city
                                }
                                if let   regoin = item["regoin"] as? String{
                                    business.region = regoin
                                }
                                if let contact_number = item["contact_number"] as? String{
                                    business.contact_number = contact_number
                                }
                                if let description = item["description"] as? String{
                                    business.description = description
                                }
                                if let files = item["files"] as? [Dictionary<String,Any>]{
                                    
                                    for ite in files{
                                        var relatedfile = RelatedFilesBean()
                                        if let id = ite["id"] as? Int{
                                            relatedfile.id = id
                                        }
                                        if let image = ite["image"] as? String{
                                            relatedfile.image = image
                                        }
                                        if let bussines_id = ite["bussines_id"] as? Int{
                                            relatedfile.bussines_id = bussines_id
                                        }
                                        business.files.append(relatedfile)
                                    }
                                  
                                    
                                }
                                if let langitude = item["langitude"] as? String{
                                   // business.long = Double(langitude)!
                                }
                                if let lattitude = item["lattitude"] as? String{
                                  //  business.lat = Double(lattitude)!
                                }
                                if let name = item["name"] as? String{
                                    business.name = name
                                }
                                if let image = item["image"] as? String{
                                    business.image = image
                                }
                                if let id = item["id"] as? Int {
                                    business.id = id
                                }
                                if let offers = item["offers"] as? [Dictionary<String,Any>]{
                                    for ite in offers{
                                        var offer = OfferBean()
                                        if let id = ite["id"] as? Int{
                                            offer.id = id
                                        }
                                        if let caption = ite["caption"] as? String{
                                            offer.caption = caption
                                        }
                                        if let photo = ite["image"] as? String{
                                            offer.photo = photo
                                        }
                                        if let bussines_id = ite["bussines_id"] as? Int{
                                            offer.bussines_id = bussines_id
                                        }
                                        business.offers.append(offer)
                                    }
                                    
                                }
                                if let owner = item["owner"] as? [String:Any]{
                                    var own = OwnerBean()
                                    if let email = owner["email"] as? String {
                                       own.email = email
                                    }
                                    if let username = owner["name"] as? String{
                                       own.name = username
                                    }
                                    business.owner = own
                                }
                                self.BussinessList.append(business)
                            }//end for
                            self.offerCollectionView.reloadData()
                           
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                    
                    let alert = UIAlertController(title: "", message: "Network fail" , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
        }
    }
    func searchByCategory(categoryId:Int){
        self.BussinessList = []
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        var user_id = UserDefaults.standard.value(forKey: "user_id") as! String
        var parameter :[String:AnyObject] = [String:AnyObject]()
        parameter["category_id"] =  "\(categoryId)" as AnyObject?
        parameter["searcher_id"] = user_id as AnyObject?
        let url = Constant.baseURL + Constant.URICategorySearch
        Alamofire.request(url, method:.post, parameters: parameter,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    if let datares = response.result.value as? [String:Any]{
                        if let flag = datares["flag"] as? String{
                            if flag == "0"{
                                self.showToast(message: "Response fail")
                            }
                        }
                        
                        if let data  = datares["data"] as? [Dictionary<String,Any>]{
                            for item in data{
                                let business = BusinessBean()
                                if let address = item["address"] as? String{
                                    business.address = address
                                }
                                if let average_rating = item["average_rating"] as? String{
                                    
                                }
                                if let logo = item["logo"] as? String{
                                    business.logo = logo
                                }
                                var catego = CategoryBean()
                                if let category = item["category"] as? [String:Any]{
                                    if let id = category["id"] as? Int {
                                        catego.id = id
                                    }
                                    if let name = category["name"] as? String{
                                        catego.name = name
                                    }
                                    business.category = catego
                                }
                                
                                if let city = item["city"] as? String{
                                    business.city = city
                                }
                                if let   regoin = item["regoin"] as? String{
                                    business.region = regoin
                                }
                                if let contact_number = item["contact_number"] as? String{
                                    business.contact_number = contact_number
                                }
                                if let description = item["description"] as? String{
                                    business.description = description
                                }
                                if let files = item["files"] as? [Dictionary<String,Any>]{
                                    
                                    for ite in files{
                                        var relatedfile = RelatedFilesBean()
                                        if let id = ite["id"] as? Int{
                                            relatedfile.id = id
                                        }
                                        if let image = ite["image"] as? String{
                                            relatedfile.image = image
                                        }
                                        if let bussines_id = ite["bussines_id"] as? Int{
                                            relatedfile.bussines_id = bussines_id
                                        }
                                        business.files.append(relatedfile)
                                    }
                                    
                                    
                                }
                                if let langitude = item["langitude"] as? String{
                                    // business.long = Double(langitude)!
                                }
                                if let lattitude = item["lattitude"] as? String{
                                    //  business.lat = Double(lattitude)!
                                }
                                if let name = item["name"] as? String{
                                    business.name = name
                                }
                                if let image = item["image"] as? String{
                                    business.image = image
                                }
                                if let id = item["id"] as? Int {
                                    business.id = id
                                }
                                if let offers = item["offers"] as? [Dictionary<String,Any>]{
                                    for ite in offers{
                                        var offer = OfferBean()
                                        if let id = ite["id"] as? Int{
                                            offer.id = id
                                        }
                                        if let caption = ite["caption"] as? String{
                                            offer.caption = caption
                                        }
                                        if let photo = ite["image"] as? String{
                                            offer.photo = photo
                                        }
                                        if let bussines_id = ite["bussines_id"] as? Int{
                                            offer.bussines_id = bussines_id
                                        }
                                        business.offers.append(offer)
                                    }
                                    
                                }
                                if let owner = item["owner"] as? [String:Any]{
                                    var own = OwnerBean()
                                    if let email = owner["email"] as? String {
                                        own.email = email
                                    }
                                    if let username = owner["name"] as? String{
                                        own.name = username
                                    }
                                    business.owner = own
                                }
                                self.BussinessList.append(business)
                            }//end for
                            self.offerCollectionView.reloadData()
                           
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                    
                    let alert = UIAlertController(title: "", message: "Network fail" , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
        }
    }
    func searchBusiness(categoryId:Int,cityId:Int,regionId:Int){
        BussinessList = []
        var user_id = UserDefaults.standard.value(forKey: "user_id") as! String
        var parameter :[String:AnyObject] = [String:AnyObject]()
        parameter["category_id"] =  "\(categoryId)" as AnyObject?
      parameter["bussines_name"] = searchName.text!  as AnyObject?
        parameter["city_id"] = "\(cityId)" as AnyObject?
        parameter["regoin_id"] = "\(regionId)" as AnyObject?
        let url = Constant.baseURL + Constant.URIBusinessSearch
        Alamofire.request(url, method:.post, parameters: parameter,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    if let datares = response.result.value as? [String:Any]{
                        if let flag = datares["flag"] as? String{
                            if flag == "0"{
                                self.showToast(message: "Response fail")
                            }
                        }
                        
                        if let data  = datares["data"] as? [Dictionary<String,Any>]{
                            for item in data{
                                let business = BusinessBean()
                                if let address = item["address"] as? String{
                                    business.address = address
                                }
                                if let average_rating = item["average_rating"] as? String{
                                    
                                }
                                if let logo = item["logo"] as? String{
                                    business.logo = logo
                                }
                                var catego = CategoryBean()
                                if let category = item["category"] as? [String:Any]{
                                    if let id = category["id"] as? Int {
                                        catego.id = id
                                    }
                                    if let name = category["name"] as? String{
                                        catego.name = name
                                    }
                                    business.category = catego
                                }
                                
                                if let city = item["city"] as? String{
                                    business.city = city
                                }
                                if let   regoin = item["regoin"] as? String{
                                    business.region = regoin
                                }
                                if let contact_number = item["contact_number"] as? String{
                                    business.contact_number = contact_number
                                }
                                if let description = item["description"] as? String{
                                    business.description = description
                                }
                                if let files = item["files"] as? [Dictionary<String,Any>]{
                                    
                                    for ite in files{
                                        var relatedfile = RelatedFilesBean()
                                        if let id = ite["id"] as? Int{
                                            relatedfile.id = id
                                        }
                                        if let image = ite["image"] as? String{
                                            relatedfile.image = image
                                        }
                                        if let bussines_id = ite["bussines_id"] as? Int{
                                            relatedfile.bussines_id = bussines_id
                                        }
                                        business.files.append(relatedfile)
                                    }
                                    
                                    
                                }
                                if let langitude = item["langitude"] as? String{
                                    // business.long = Double(langitude)!
                                }
                                if let lattitude = item["lattitude"] as? String{
                                    //  business.lat = Double(lattitude)!
                                }
                                if let name = item["name"] as? String{
                                    business.name = name
                                }
                                if let image = item["image"] as? String{
                                    business.image = image
                                }
                                if let id = item["id"] as? Int {
                                    business.id = id
                                }
                                if let offers = item["offers"] as? [Dictionary<String,Any>]{
                                    for ite in offers{
                                        var offer = OfferBean()
                                        if let id = ite["id"] as? Int{
                                            offer.id = id
                                        }
                                        if let caption = ite["caption"] as? String{
                                            offer.caption = caption
                                        }
                                        if let photo = ite["image"] as? String{
                                            offer.photo = photo
                                        }
                                        if let bussines_id = ite["bussines_id"] as? Int{
                                            offer.bussines_id = bussines_id
                                        }
                                        business.offers.append(offer)
                                    }
                                    
                                }
                                if let owner = item["owner"] as? [String:Any]{
                                    var own = OwnerBean()
                                    if let email = owner["email"] as? String {
                                        own.email = email
                                    }
                                    if let username = owner["name"] as? String{
                                        own.name = username
                                    }
                                    business.owner = own
                                }
                                self.BussinessList.append(business)
                            }//end for
                            self.offerCollectionView.reloadData()
                            
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                    
                    let alert = UIAlertController(title: "", message: "Network fail" , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
        }
    }
    @objc func MenuButtonTapped() {
        print("Button Tapped")
        if  AppDelegate.userMenu_bool{
            showMenu()
        }else{
            closeMenu()
        }
    }
    //MARK:IBAction
    
    @IBAction func searchBtnAction(_ sender: Any) {
        if searchName.text != "" ||  categSelected != -1 ||  citySelected != -1 && (searchName.text != "" || regionSelected != -1 || categSelected != -1){
            
       
            searchBusiness(categoryId:categoryList[categSelected].id!,cityId:cityList[citySelected].id!,regionId:regionList[regionSelected].id!)
        }
    }
    
    @IBAction func categoryBtnAction(_ sender: Any) {
        categoryPickerView .isHidden = !categoryPickerView.isHidden
        categoryDone.isHidden = !categoryDone.isHidden
    }
    
    @IBAction func historicPlaceAction(_ sender: Any) {
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        if networkExist == true {
            searchByCategory(categoryId:1)
        }else{
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
 
    @IBAction func hospitalBtnAction(_ sender: Any) {
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        if networkExist == true {
            searchByCategory(categoryId:1)
        }else{
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func IAMHUNGRYAction(_ sender: Any) {
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        if networkExist == true {
            searchByCategory(categoryId:1)
        }else{
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func INEEDHotelAction(_ sender: Any) {
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        if networkExist == true {
            searchByCategory(categoryId:1)
        }else{
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func segmentControlAction(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            view2.isHidden = true
            
        case 1:
            view2.isHidden = false 
            
        default:
            print("")
        }
    }
    

    @IBAction func categoryDoneBtnAction(_ sender: Any) {
        categoryPickerView.isHidden = true
        categoryDone.isHidden = true
        if categoryList.count > 0 {
            if categSelected == -1 {
                categSelected = 0
                categoryBtn.setTitle(categoryList[0].name, for: .normal)
            }else{
                categoryBtn.setTitle(categoryList[categSelected].name, for: .normal)
            }
        }
    }
    
    @IBAction func cityDoneAction(_ sender: Any) {
        cityPickerView.isHidden = true
        cityDone.isHidden = true
        if cityList.count > 0 {
            if citySelected == -1 {
                citySelected = 0
                cityBtn.setTitle(cityList[0].name, for: .normal)
            }else{
                cityBtn.setTitle(cityList[citySelected].name, for: .normal)
            }
        }
    }
    
    @IBAction func regionDoneAction(_ sender: Any) {
        regionPickerView.isHidden = true
        regionDone.isHidden = true
        if regionList.count > 0 {
            if regionSelected == -1 {
                regionSelected = 0
                regionBtn.setTitle(regionList[0].name, for: .normal)
            }else{
                regionBtn.setTitle(regionList[regionSelected].name, for: .normal)
            }
        }
    }
    
    @IBAction func cityBtnAction(_ sender: Any) {
        getCity()
    }
    
    @IBAction func regionBtnAction(_ sender: Any) {
        getRegion()
    }
}
extension UserHomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if BussinessList.count > 0{
            return BussinessList.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 125, height: 160)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserHomeOfferCollectionViewCell", for: indexPath)as? UserHomeOfferCollectionViewCell
        cell?.photo.sd_setImage(with: URL(string:BussinessList[indexPath.row].logo!), placeholderImage: UIImage(named: "gallery.png"))
        cell?.caption.text  = BussinessList[indexPath.row].name
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       BusinessNo = indexPath.row
        let imageDataDict:[String: Any] = ["id":BussinessList[indexPath.row].id]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SendBusID"), object: nil, userInfo: imageDataDict)
        view6.isHidden = false
        
    }
    
}
extension UserHomeViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    //MARK:pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPickerView {
        if categoryList.count > 0{
            return categoryList.count
        }else{
            return 0
        }
        }else if pickerView == cityPickerView{
            if cityList.count > 0 {
            return cityList.count
            }else{
                return 0
            }
        }else{
            if regionList.count > 0 {
            return regionList.count
            }else {
                return 0
            }
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPickerView {
            return categoryList[row].name
        }else if pickerView == cityPickerView{
               return cityList[row].name
        }else{
            return regionList[row].name
        }
     
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPickerView{
        categSelected = row
        categoryBtn.setTitle(categoryList[row].name, for: .normal)
        }else if pickerView == cityPickerView{
            citySelected = row
            cityBtn.setTitle(cityList[row].name, for: .normal)
            regionBtn.isEnabled = true
        }else{
            regionSelected = row
            regionBtn.setTitle(regionList[row].name, for: .normal)
            
        }
    }
}
