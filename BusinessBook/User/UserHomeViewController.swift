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
class UserHomeViewController: UIViewController ,SendBusinessDelegate{
    //MARK:IBOUTlet
    
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var noDataResult: UILabel!
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
    var segmentIndex = 0
    var searchCategory = false
    var categoryId:Int?
    var searchCurrentPage = 0
    var searchTotalPage = 0
    var searchFlag = false
    var defaultCurrentPage = 0
    var defaultTotalPage = 0
    var ShortCutCategory:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        historicPlaceBtn.titleLabel?.numberOfLines = 1
        historicPlaceBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        historicPlaceBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
         menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "UserMenuViewController") as! UserMenuViewController
        activityIndicator.isHidden = true
         activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        getCategory()
           getCity()
         BussinessList = []
        if UIDevice().type == .iPhone5S{
            NotificationCenter.default.addObserver(self, selector: #selector(UserHomeViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(UserHomeViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        }
        hideKeyboardWhenTappedAround()
        regionBtn.isEnabled = false
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        if networkExist == true {
            
            if searchCategory == true {
                searchByCategory(categoryId:categoryId!)
            }else{
                getData()
            }
        }else{
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        offerCollectionView.delegate = self
        offerCollectionView.dataSource = self
       
      
       styleBtn()
        
      
//        let myimage = UIImage(named: "menu.png")?.withRenderingMode(.alwaysOriginal)
//        let barButtonItem2 = UIBarButtonItem(image: myimage, style: .plain, target: self, action: #selector(MenuButtonTapped))
//        self.navigationItem.leftBarButtonItem = barButtonItem2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:MENU FUnction
   
    override func viewWillAppear(_ animated: Bool) {
               super.viewWillAppear(true)
        if segmentIndex == 1 {
            segmentControl.selectedSegmentIndex = 1
             view2.isHidden = false
        }
    }
   
   
    //MARK:Function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailVC" {
            var  detailVc:DetailBusinessViewController = (segue.destination as? DetailBusinessViewController)!
            detailVc.id = BusinessNo
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if segmentIndex == 0 {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            // if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= keyboardSize.height
            
            //}
        }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if segmentIndex == 0 {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            //  if self.view.frame.origin.y != 0{
            //                self.view.frame.origin.y += keyboardSize.height
            self.view.frame.origin.y  = 0
            // }
        }
        }
    }
    func sendBusinessNo(index:Int){
        BusinessNo = index 
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
       ineedHotelBtn.layer.cornerRadius = 10
       iamHungryBtn.layer.cornerRadius = 10
       anotherBtn.layer.cornerRadius = 10 //styleGradientBtn(button:ineedHotelBtn,topColor:UIColor.white.cgColor,bottom:UIColor.red.cgColor)
//  styleGradientBtn(button:iamHungryBtn,topColor:UIColor.white.cgColor,bottom:UIColor.green.cgColor)
//        styleGradientBtn(button:anotherBtn,topColor:UIColor.gray.cgColor,bottom:UIColor.white.cgColor)
       
       
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
                                if data.count > 0 {
                                    let defaultCategy = CategoryBean()
                                    defaultCategy.id = -1
                                    defaultCategy.name = "Select Category"
                                    self.categoryList.append(defaultCategy)
                                }
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
        cityList = []
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
                        if let datares = response.result.value as? [String:Any]{
                            if let data = datares["data"] as? [Dictionary<String,Any>]{
                                if data.count > 0 {
                                    let defaultcity = CityBean()
                                    defaultcity.id = -1
                                    defaultcity.name = "Select City"
                                    self.cityList.append(defaultcity)
                                }
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
                                self.cityPickerView.delegate = self
                                self.cityPickerView.dataSource = self
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
        regionList = []
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        regionBtn.isEnabled = false
        if networkExist == true {
           
            if cityList.count > 0 && citySelected != -1 {
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            let url = Constant.baseURL + Constant.URIRegion + "\(cityList[citySelected].id!)"
            Alamofire.request(url, method:.get, parameters: nil,encoding: JSONEncoding.default, headers:nil)
                .responseJSON { response in
                    print(response)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    switch response.result {
                    case .success:
                        if let datares = response.result.value as? [String:Any]{
                            if let data = datares["data"] as? [Dictionary<String,Any>]{
                                if data.count > 0 {
                                    let defaultRegion = RegionBean()
                                    defaultRegion.id = -1
                                    defaultRegion.name = "Select Region"
                                    self.regionList.append(defaultRegion)
                                }
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
                                self.regionBtn.isEnabled = true
                                self.regionPickerView.delegate = self
                                self.regionPickerView.dataSource = self
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
//                let alert = UIAlertController(title: "", message: "select city" , preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
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
        let url = Constant.baseURL + Constant.URIDefaultSearch + "\(user_id)" + "/\(defaultCurrentPage + 1)"
        Alamofire.request(url, method:.get, parameters: nil,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    if let datares = response.result.value as? [String:Any]{
                        if let meta = datares["meta"] as?[String:Any] {
                           if let current_page = meta["current_page"] as? Int {
                                self.defaultCurrentPage = current_page
                            }
                            if let total = meta["total"] as? Int {
                                self.defaultTotalPage = total
                            }
                        }
                        if let flag = datares["flag"] as? String {
                            if flag == "0"{
                                self.showToast(message: "fail")
                            }
                        }
                        if let data  = datares["data"] as? [Dictionary<String,Any>]{
                            if data.count == 0 {
                                self.noDataResult.isHidden = false
                                self.defaultCurrentPage = -1
                                self.defaultTotalPage = -1
                            }else{
                                self.noDataResult.isHidden = true
                            }
                            for item in data{
                                let business = BusinessBean()
                                if let address = item["address"] as? String{
                                    business.address = address
                                }
                                if let average_rating = item["average_rating"] as? Double{
                                    business.average_Rating = average_rating
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
        let url = Constant.baseURL + "bussines/search/category"
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
                            if data.count == 0 {
                                self.noDataResult.isHidden = false
                            }else{
                                self.noDataResult.isHidden = true
                            }
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
    func searchBusiness(){
        
        var user_id = UserDefaults.standard.value(forKey: "user_id") as! String
        var parameter :[String:AnyObject] = [String:AnyObject]()
        if categSelected != -1 {
             parameter["category_id"] =  "\(categoryList[categSelected].id!)" as AnyObject?
        }
      parameter["bussines_name"] = searchName.text!  as AnyObject?
        if citySelected != -1 {
        parameter["city_id"] = "\(cityList[citySelected].id!)" as AnyObject?
        }
        if regionSelected != -1 {
        parameter["regoin_id"] = "\(regionList[regionSelected].id!)" as AnyObject?
        }
        parameter["page_number"] = "\(searchCurrentPage + 1)"  as AnyObject?
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        let url = Constant.baseURL + Constant.URIBusinessSearch
        Alamofire.request(url, method:.post, parameters: parameter,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    if let datares = response.result.value as? [String:Any]{
                        if let meta = datares["meta"] as? [String:Any]{
                            if let current_page = meta["current_page"] as? Int {
                                self.searchCurrentPage = current_page
                            }
                            if let total = meta["total"] as? Int {
                                self.searchTotalPage = total
                            }
                        }
                        if let flag = datares["flag"] as? String{
                            if flag == "0"{
                                self.showToast(message: "Response fail")
                            }
                        }
                        
                        if let data  = datares["data"] as? [Dictionary<String,Any>]{
                            if data.count == 0 {
                                self.noDataResult.isHidden = false
                                 self.searchCurrentPage = -1
                                self.searchTotalPage = -1 
                            }else{
                                self.noDataResult.isHidden = true
                            }
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
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    //MARK:IBAction
    
    @IBAction func otherBtnAction(_ sender: Any) {
        ShortCutCategory = true
          BussinessList = []
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        if networkExist == true {
            searchByCategory(categoryId:60)
        }else{
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func searchBtnAction(_ sender: Any) {
        let name = searchName.text?.trimmingCharacters(in: .whitespaces)
        if  name != "" ||  categSelected != -1 ||  citySelected != -1 && (searchName.text != "" || regionSelected != -1 || categSelected != -1){
            BussinessList = []
           searchFlag = true
            ShortCutCategory = false
            searchCurrentPage = 0
            searchBusiness()
        }else{
            let alert = UIAlertController(title: "Warning", message: "You should select region or category or business name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func categoryBtnAction(_ sender: Any) {
        categoryPickerView .isHidden = !categoryPickerView.isHidden
        categoryDone.isHidden = !categoryDone.isHidden
    }
    
    @IBAction func historicPlaceAction(_ sender: Any) {
        ShortCutCategory = true
          BussinessList = []
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        if networkExist == true {
            searchByCategory(categoryId:60)
        }else{
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
 
    @IBAction func hospitalBtnAction(_ sender: Any) {
          ShortCutCategory = true
          BussinessList = []
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        if networkExist == true {
            searchByCategory(categoryId:58)
        }else{
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func IAMHUNGRYAction(_ sender: Any) {
          ShortCutCategory = true
          BussinessList = []
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        if networkExist == true {
            searchByCategory(categoryId:38)
        }else{
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func INEEDHotelAction(_ sender: Any) {
          ShortCutCategory = true
          BussinessList = []
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        if networkExist == true {
            searchByCategory(categoryId:61)
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
            segmentIndex = 0
        case 1:
            view2.isHidden = false 
            segmentIndex = 1
        default:
            print("")
        }
    }
    

    @IBAction func categoryDoneBtnAction(_ sender: Any) {
        categoryPickerView.isHidden = true
        categoryDone.isHidden = true
        if categoryList.count > 0 {
            if categSelected == -1 {
                categSelected = -1
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
                citySelected = -1
                cityBtn.setTitle(cityList[0].name, for: .normal)
            }else{
                cityBtn.setTitle(cityList[citySelected].name, for: .normal)
            }
            getRegion()
        }
    }
    
    @IBAction func regionDoneAction(_ sender: Any) {
        regionPickerView.isHidden = true
        regionDone.isHidden = true
        if regionList.count > 0 {
            if regionSelected == -1 {
                regionSelected = -1
                regionBtn.setTitle(regionList[0].name, for: .normal)
            }else{
                regionBtn.setTitle(regionList[regionSelected].name, for: .normal)
            }
        }
    }
    
    @IBAction func cityBtnAction(_ sender: Any) {
        cityPickerView.isHidden = !cityPickerView.isHidden
        cityDone.isHidden = !cityDone.isHidden
     
    }
    
    @IBAction func regionBtnAction(_ sender: Any) {
        regionPickerView.isHidden = !regionPickerView.isHidden
        regionDone.isHidden = !regionDone.isHidden
        
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
        let captionTextWidth = ((view.frame.width - 26 )/3)
        let size = CGSize(width:captionTextWidth,height:1000)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize:15)]
        if BussinessList[indexPath.row].name != "" && BussinessList[indexPath.row].name != nil {
            let estimateFrame = NSString(string: BussinessList[indexPath.row].name!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            let height  = estimateFrame.height + 155
            return CGSize(width: (view.frame.width - 21 )/3 , height: height)
        }else{
            let estimateFrame = NSString(string: "").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            let height  = estimateFrame.height + 155
            //  return CGSize(width: 133, height: height)
            return CGSize(width: (view.frame.width - 21)/3 , height: height)
        }
     //   return CGSize(width: 125, height: 160)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserHomeOfferCollectionViewCell", for: indexPath)as? UserHomeOfferCollectionViewCell
        if BussinessList[indexPath.row].logo != nil {
            
        cell?.photo.sd_setImage(with: URL(string:BussinessList[indexPath.row].logo!), placeholderImage: UIImage(named: "gallery.png"))
        }
            cell?.caption.text  = BussinessList[indexPath.row].name
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       BusinessNo = indexPath.row
        let imageDataDict:[String: Any] = ["id":BussinessList[indexPath.row].id]
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SendBusID"), object: nil, userInfo: imageDataDict)
//        view6.isHidden = false
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailBusinessViewController") as! DetailBusinessViewController
        vc.id = BussinessList[indexPath.row].id!
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if ShortCutCategory == false {
            if searchFlag == true {
                if indexPath.row == BussinessList.count - 1 {
                    print("HELLO",indexPath.row)
                    if searchCurrentPage < searchTotalPage {
                       searchBusiness()
                    }
                }
            }else{ // default search 
                 if indexPath.row == BussinessList.count - 1 {
                    if defaultCurrentPage <   defaultTotalPage {
                        getData()
                    }
                }
         }
       }
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
             if row == 0 {
                categSelected = -1
             }else{
                categSelected = row
            }
        
        categoryBtn.setTitle(categoryList[row].name, for: .normal)
            
        }else if pickerView == cityPickerView{
            if row == 0 {
                citySelected = -1
            }else{
               citySelected = row
            }
            
            cityBtn.setTitle(cityList[row].name, for: .normal)
            
             regionSelected = -1
            
            regionBtn.setTitle("Select region", for: .normal)
            
        }else{
                if row == 0 {
                    regionSelected = -1
                }else{
                     regionSelected = row
              }
           
            regionBtn.setTitle(regionList[row].name, for: .normal)
            
        }
    }
}
