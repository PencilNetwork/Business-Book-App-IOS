//
//  UserOfferViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/25/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
class UserOfferViewController: UIViewController {
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var regionDone: UIButton!
    @IBOutlet weak var regionPickerView: UIPickerView!
    @IBOutlet weak var cityDone: UIButton!
    @IBOutlet weak var cityPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var regionBtn: UIButton!
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var categoryDone: UIButton!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var offerCollectionView: UICollectionView!
    
    @IBOutlet weak var noofferResult: UILabel!
    @IBOutlet weak var searchName: UITextField!
    var offerList :[OfferBean] = []
      var categoryList:[CategoryBean] = []
    var cityList:[CityBean] = []
    var regionList:[RegionBean] = []
       var categSelected = -1
    var citySelected = -1
    var regionSelected = -1
    var defaultOfferCurrentPage = 0
    var defaultOfferTotalPage = 0
    var searchCurrentPage = 0
    var searchTotalPage = 0
    var searchFlag = false 
    override func viewDidLoad() {
        super.viewDidLoad()
     activityIndicator.isHidden =  true
         activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        getCategory()
        getDefaultOffer()
        getCity()
        offerList = []
         regionBtn.isEnabled = false
        offerCollectionView.delegate = self
        offerCollectionView.dataSource = self
        // Do any additional setup after loading the view.
        let lang = UserDefaults.standard.value(forKey: "lang") as!String
        if lang == "ar" {
            containerView.semanticContentAttribute = .forceRightToLeft
            searchName.placeholder = "selectName".localized(lang: "ar")
            searchName.textAlignment = .right
            categoryBtn.setTitle("selectCategory".localized(lang: "ar"), for: .normal)
            regionBtn.setTitle("selectRegion".localized(lang: "ar"), for: .normal)
            cityBtn.setTitle("selectCity".localized(lang: "ar"), for: .normal)
            searchBtn.setTitle("search".localized(lang: "ar"), for: .normal)
            offerCollectionView.semanticContentAttribute = .forceRightToLeft
            
        }else{
            containerView.semanticContentAttribute = .forceLeftToRight
             offerCollectionView.semanticContentAttribute = .forceLeftToRight
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:Function
    func getCategoryDataBaseIOS(){
        if #available(iOS 10.0, *) {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appdelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Category")
            request.returnsObjectsAsFaults = false // to return data as way as you saved it
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    let defaultCategy = CategoryBean()
                    defaultCategy.id = -1
                    defaultCategy.name = "Select Category"
                    self.categoryList.append(defaultCategy)
                    for result in results as! [NSManagedObject]{
                        var category = CategoryBean()
                        if let name = result.value(forKey: "name") as? String {
                            print("name:\(name)")
                            category.name = name
                        }
                        if let id = result.value(forKey: "id") as? Int {
                            
                            category.id =  id
                        }
                        
                        self.categoryList.append(category)
                    }
                    
                }
                self.categoryPickerView.delegate = self
                self.categoryPickerView.dataSource = self
            }catch{
                print("error to retrieve category ")
            }
        }else{
            
            let context = Storage.shared.context
            let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Category")
            request.returnsObjectsAsFaults = false // to return data as way as you saved it
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    
                    let defaultCategy = CategoryBean()
                    defaultCategy.id = -1
                    defaultCategy.name = "Select Category"
                    self.categoryList.append(defaultCategy)
                    for result in results as! [NSManagedObject]{
                        var category = CategoryBean()
                        if let name = result.value(forKey: "name") as? String {
                            print("name:\(name)")
                            category.name = name
                        }
                        if let id = result.value(forKey: "id") as? Int {
                            
                            category.id =  id
                        }
                        
                        self.categoryList.append(category)
                    }
                    
                }
                self.categoryPickerView.delegate = self
                self.categoryPickerView.dataSource = self
            }catch{
                print("error to retrieve category ")
            }
        }
    }
    func getCityDataBaseIOS(){
        if #available(iOS 10.0, *) {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appdelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName:"City")
            request.returnsObjectsAsFaults = false // to return data as way as you saved it
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    let defaultcity = CityBean()
                    defaultcity.id = -1
                    defaultcity.name = "Select City"
                    self.cityList.append(defaultcity)
                    
                    for result in results as! [NSManagedObject]{
                        let city = CityBean()
                        if let name = result.value(forKey: "name") as? String {
                            print("name:\(name)")
                            city.name = name
                        }
                        if let id = result.value(forKey: "id") as? Int {
                            
                            city.id =  id
                        }
                        
                        self.cityList.append(city)
                    }
                    
                }
                self.cityPickerView.delegate = self
                self.cityPickerView.dataSource = self
            }catch{
                print("error to retrieve category ")
            }
        }else{  /// 9
            
            let context = Storage.shared.context
            let request = NSFetchRequest<NSFetchRequestResult>(entityName:"City")
            request.returnsObjectsAsFaults = false // to return data as way as you saved it
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    
                    let defaultcity = CityBean()
                    defaultcity.id = -1
                    defaultcity.name = "Select City"
                    self.cityList.append(defaultcity)
                    for result in results as! [NSManagedObject]{
                        let city = CityBean()
                        if let name = result.value(forKey: "name") as? String {
                            print("name:\(name)")
                            city.name = name
                        }
                        if let id = result.value(forKey: "id") as? Int {
                            
                            city.id =  id
                        }
                        
                        self.cityList.append(city)
                    }
                    
                }
                self.cityPickerView.delegate = self
                self.cityPickerView.dataSource = self
            }catch{
                print("error to retrieve city ")
            }
        }
    }
    func getDefaultOffer(){
        
        let network = Network()
        
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            let userId = UserDefaults.standard.value(forKey: "user_id") as? String
            let url = Constant.baseURL + Constant.URIDefaultOfferSearch + userId! + "/\(defaultOfferCurrentPage + 1)"
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
                                        self.defaultOfferCurrentPage = current_page
                                    }
                                    if let total = meta["total"] as? Int {
                                        self.defaultOfferTotalPage = total
                                    }
                                }
                                if let data = datares["data"] as? [Dictionary<String,Any>] {
                                    if data.count == 0 {
                                        self.noofferResult.isHidden = false
                                         self.defaultOfferCurrentPage = -1
                                         self.defaultOfferTotalPage = -1
                                    }else{
                                        self.noofferResult.isHidden = true
                                    }
                                for item in data {
                                    var offer = OfferBean()
                                    if let id = item["id"] as? Int{
                                        offer.id =  id
                                    }
                                    if let caption = item["caption"] as? String{
                                        offer.caption = caption
                                    }
                                    if let image = item["image"] as? String{
                                        offer.photo = image
                                    }
                                    if let bussines_id = item["bussines_id"] as? Int {
                                        offer.bussines_id = bussines_id
                                    }
                                    self.offerList.append(offer)
                                    }
                                   self.offerCollectionView.reloadData()
                                }
                                
                            }else{
                                if let data = response.result.value as?  [String:Any]{
                                    if let flag = data["flag"] as? String{
                                        if flag == "0" {
                                        let alert = UIAlertController(title: "", message: " fail" , preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                        }
                                    }
                                }
                                
                          }
                    case .failure(let error):
                        print(error)
                        
                       self.networkFail()
                    }
            }
            
        } else{
    
        networkNotFound()
    }
    }
    func networkFail(){
        let lang = UserDefaults.standard.value(forKey: "lang") as!String
        if lang == "ar" {
            let alert = UIAlertController(title: "", message: "خطأ في الشبكة" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "", message: "Network fail" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func searchBusiness(){
       
        self.activityIndicator.isHidden = false
         self.activityIndicator.startAnimating()
        
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
        parameter["page_number"] = "\(searchCurrentPage + 1)" as AnyObject?
            let url = Constant.baseURL + Constant.URIOfferSearch
            Alamofire.request(url, method:.post, parameters: parameter,encoding: JSONEncoding.default, headers:nil)
                .responseJSON { response in
                    print(response)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    switch response.result {
                    case .success:
                        if let datares = response.result.value as? [String:Any]{
                            if let meta = datares["meta"] as?[String:Any] {
                                if let current_page = meta["current_page"] as? Int {
                                    self.searchCurrentPage = current_page
                                }
                                if let total = meta["total"] as? Int {
                                    self.searchTotalPage = total
                                }
                            }
                            if let data = datares["data"] as? [Dictionary<String,Any>]{
                                if data.count == 0 {
                                   self.noofferResult.isHidden = false
                                     self.searchTotalPage = -1
                                    self.searchCurrentPage = -1
                                }else{
                                    self.noofferResult.isHidden = true
                                }
                            for item in data {
                                var offer = OfferBean()
                                if let id = item["id"] as? Int{
                                    offer.id =  id
                                }
                                if let caption = item["caption"] as? String{
                                    offer.caption = caption
                                }
                                if let image = item["image"] as? String{
                                    offer.photo = image
                                }
                                if let bussines_id = item["bussines_id"] as? Int {
                                    offer.bussines_id = bussines_id
                                }
                                self.offerList.append(offer)
                                }
                                self.offerCollectionView.reloadData()
                            }
                            
                        }else{
                            if let data = response.result.value as?  [String:Any]{
                                if let flag = data["flag"] as? String{
                                    if flag == "0" {
                                        let alert = UIAlertController(title: "", message: " fail" , preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            }
                            
                        }
                    case .failure(let error):
                        print(error)
                        
                          self.networkFail()
                    }
            }
    }
    func getCategory(){
     if UserDefaults.standard.value(forKey: "StoreCategory") as? Bool == true  { // sql
            getCategoryDataBaseIOS()
            
     }else {
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
                        
                         self.networkFail()
                        
                    }
            }
        }else{
            
            networkNotFound()
        }
     }
    }
    func getCity(){
        cityList = []
        if UserDefaults.standard.value(forKey: "StoreCity") as? Bool == true  {
            getCityDataBaseIOS()
        }else{
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
                        
                          self.networkFail()
                        
                    }
            }
        }else{
            networkNotFound()
        }
        }
    }
    func networkNotFound(){
        let lang = UserDefaults.standard.value(forKey: "lang") as!String
        if lang == "ar" {
            let alert = UIAlertController(title: "تحذير", message:"لا يوجد شبكة", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
                            
                             self.networkFail()
                            
                        }
                }
            }else{
                let alert = UIAlertController(title: "", message: "select city" , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            
          networkNotFound()
        }
    }
    //MARK:IBAction
    
    @IBAction func CategoryDoneAction(_ sender: Any) {
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
    
    @IBAction func SelectCategoryBtnAction(_ sender: Any) {
        categoryPickerView.isHidden = !categoryPickerView.isHidden
        categoryDone.isHidden = !categoryDone.isHidden
    }
    
    @IBAction func cityBtnAction(_ sender: Any) {
        cityPickerView.isHidden = !cityPickerView.isHidden
        cityDone.isHidden = !cityDone.isHidden
    }
    
    @IBAction func searchBtnAction(_ sender: Any) {
         let name = searchName.text?.trimmingCharacters(in: .whitespaces)
            if name != "" ||  categSelected != -1 ||  citySelected != -1 && (searchName.text != "" || regionSelected != -1 || categSelected != -1){
                offerList = []
                searchFlag = true
                searchCurrentPage = 0
                searchBusiness()
            }else{
                let alert = UIAlertController(title: "Warning", message: "You should select region or category or business name", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func regionBtnAction(_ sender: Any) {
        regionPickerView.isHidden = !regionPickerView.isHidden
        regionDone.isHidden = !regionDone.isHidden
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
            getRegion()
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
    
}
extension UserOfferViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if offerList.count > 0{
            return offerList.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: (self.view.frame.width - 10)/3, height: 160)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserOfferCollectionViewCell", for: indexPath)as? UserHomeOfferCollectionViewCell
        if offerList[indexPath.row].photo != nil {
        cell?.photo.sd_setImage(with: URL(string:offerList[indexPath.row].photo!), placeholderImage: UIImage(named: "gallery.png"))
        }
        cell?.caption.text  = offerList[indexPath.row].caption
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
            if searchFlag == true {
                if indexPath.row == offerList.count - 1 {
                    print("HELLO",indexPath.row)
                    if searchCurrentPage < searchTotalPage {
                        searchBusiness()
                    }
                }
            }else{ // default search
                if indexPath.row == offerList.count - 1 {
                    if defaultOfferCurrentPage <   defaultOfferTotalPage {
                        getDefaultOffer()
                    }
                }
            }
        }
  
}
extension UserOfferViewController:UIPickerViewDelegate,UIPickerViewDataSource{
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
            regionSelected = -1 
            
            regionBtn.setTitle("region", for: .normal)
            
        }else{
            regionSelected = row
            regionBtn.setTitle(regionList[row].name, for: .normal)
            
        }
    }
}
