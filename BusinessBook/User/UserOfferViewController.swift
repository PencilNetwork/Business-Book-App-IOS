//
//  UserOfferViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/25/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Alamofire
class UserOfferViewController: UIViewController {
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
    
    @IBOutlet weak var searchName: UITextField!
    var offerList :[OfferBean] = []
      var categoryList:[CategoryBean] = []
    var cityList:[CityBean] = []
    var regionList:[RegionBean] = []
       var categSelected = -1
    var citySelected = -1
    var regionSelected = -1
    override func viewDidLoad() {
        super.viewDidLoad()
     activityIndicator.isHidden =  true
         activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        getCategory()
        getDefaultOffer()
        
        offerCollectionView.delegate = self
        offerCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getDefaultOffer(){
        offerList = []
        let network = Network()
        
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            let userId = UserDefaults.standard.value(forKey: "user_id") as? String
            let url = Constant.baseURL + Constant.URIDefaultOfferSearch + userId!
            Alamofire.request(url, method:.get, parameters: nil,encoding: JSONEncoding.default, headers:nil)
                .responseJSON { response in
                    print(response)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    switch response.result {
                    case .success:
                            if let data = response.result.value as? [[String:Any]]{
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
                        
                        let alert = UIAlertController(title: "", message: "Network fail" , preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
            }
            
        } else{
    
    let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
    }
    }
    func searchBusiness(categoryId:Int,cityId:Int,regionId:Int){
       
            offerList = []
            var user_id = UserDefaults.standard.value(forKey: "user_id") as! String
            var parameter :[String:AnyObject] = [String:AnyObject]()
            parameter["category_id"] =  "\(categoryId)" as AnyObject?
            parameter["bussines_name"] = searchName.text!  as AnyObject?
            parameter["city_id"] = "\(cityId)" as AnyObject?
            parameter["regoin_id"] = "\(regionId)" as AnyObject?
            let url = Constant.baseURL + Constant.URIOfferSearch
            Alamofire.request(url, method:.post, parameters: parameter,encoding: JSONEncoding.default, headers:nil)
                .responseJSON { response in
                    print(response)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    switch response.result {
                    case .success:
                        if let data = response.result.value as? [[String:Any]]{
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
                        
                        let alert = UIAlertController(title: "", message: "Network fail" , preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
            }
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
         getCity()
    }
    
    @IBAction func searchBtnAction(_ sender: Any) {
            if searchName.text != "" ||  categSelected != -1 ||  citySelected != -1 && (searchName.text != "" || regionSelected != -1 || categSelected != -1){
                searchBusiness(categoryId:categoryList[categSelected].id!,cityId:cityList[citySelected].id!,regionId:
                    regionList[regionSelected].id!)
        }
    }
    
    @IBAction func regionBtnAction(_ sender: Any) {
         getRegion()
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
    
}
extension UserOfferViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if offerList.count > 0{
            return offerList.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: (self.view.frame.width - 20)/2, height: 160)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserOfferCollectionViewCell", for: indexPath)as? UserHomeOfferCollectionViewCell
        cell?.photo.sd_setImage(with: URL(string:offerList[indexPath.row].photo!), placeholderImage: UIImage(named: "gallery.png"))
        cell?.caption.text  = offerList[indexPath.row].caption
        return cell!
    }
}
extension UserOfferViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    //MARK:pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if categoryList.count > 0{
            return categoryList.count
        }else{
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row].name
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categSelected = row
        categoryBtn.setTitle(categoryList[row].name, for: .normal)
    }
}
