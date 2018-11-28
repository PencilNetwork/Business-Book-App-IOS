//
//  DetailBusinessViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/26/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyStarRatingView
import Alamofire

class DetailBusinessViewController: UIViewController {
    //MARK:IBoutlet
    @IBOutlet weak var offerlbl: UILabel!
    
    @IBOutlet weak var rateUs: UILabel!
    @IBOutlet weak var relatedFiles: UILabel!
    
    @IBOutlet weak var emailTxt: UILabel!
    @IBOutlet weak var categoryTxt: UILabel!
    @IBOutlet weak var regionTxt: UILabel!
    @IBOutlet weak var cityTxt: UILabel!
    @IBOutlet weak var addressTxt: UILabel!
    @IBOutlet weak var contactNoTxt: UILabel!
    @IBOutlet weak var businessDesTxt: UILabel!
    @IBOutlet weak var businessNameTxt: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var regionLBL: UILabel!
    @IBOutlet weak var cityLBL: UILabel!
    @IBOutlet weak var relateFilesHeight: NSLayoutConstraint!
    @IBOutlet weak var offerHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var favouriteBtn: UIButton!
    
    @IBOutlet weak var busRatingView: SwiftyStarRatingView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var rateUsView: SwiftyStarRatingView!
    
    @IBOutlet weak var emailLBL: UILabel!
    @IBOutlet weak var categoryLBL: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var contactNO: UILabel!
    @IBOutlet weak var businessDescription: UILabel!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var cameraIng: UIImageView!
    @IBOutlet weak var googleMap: GMSMapView!
    @IBOutlet weak var relatedFileCollectionView: UICollectionView!
    @IBOutlet weak var offerCollectionView: UICollectionView!
    var offerList:[OfferBean] = []
    var relatedFileList:[RelatedFilesBean] = []
    var address:String? = ""
    var id:Int?
    var long :Double = 0
    var lat:Double = 0
    var favourite :Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.white
         activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        relatedFileCollectionView.dataSource = self
        relatedFileCollectionView.delegate = self
        offerCollectionView.dataSource = self
        offerCollectionView.delegate = self
        busRatingView.isEnabled = false
     // NotificationCenter.default.addObserver(self, selector: #selector(SendBusID(_:)), name: NSNotification.Name(rawValue: "SendBusID"), object: nil)
       
        // Do any additional setup after loading the view.
        let lang = UserDefaults.standard.value(forKey: "lang") as!String
        if lang == "ar" {
            containerView.semanticContentAttribute = .forceRightToLeft
            relatedFileCollectionView.semanticContentAttribute = .forceRightToLeft
            offerCollectionView.semanticContentAttribute = .forceRightToLeft
            emailTxt.text = "email".localized(lang: "ar") + ":"
            businessNameTxt.text = "businessName".localized(lang: "ar") + ":"
            businessDesTxt.text = "busDes".localized(lang: "ar") + ":"
            contactNoTxt.text = "contactNo".localized(lang: "ar") + ":"
            categoryTxt.text = "category".localized(lang: "ar") + ":"
            regionTxt.text = "region".localized(lang: "ar") + ":"
            cityTxt.text = "city".localized(lang: "ar") + ":"
            addressTxt.text = "address".localized(lang: "ar") + ":"
            offerlbl.text = "offer".localized(lang: "ar")
            relatedFiles.text = "relatedFiles".localized(lang: "ar")
            rateUs.text = "rateUs".localized(lang: "ar")
            businessNameTxt.textAlignment = .right
            businessName.textAlignment = .right
            businessDesTxt.textAlignment = .right
            businessDescription.textAlignment = .right
            contactNoTxt.textAlignment = .right
            contactNO.textAlignment = .right
            addressTxt.textAlignment = .right
            addressLbl.textAlignment = .right
            cityTxt.textAlignment = .right
           cityLBL.textAlignment = .right
            regionTxt.textAlignment = .right
            regionLBL.textAlignment = .right
            categoryLBL.textAlignment = .right
            categoryTxt.textAlignment = .right
            emailTxt.textAlignment = .right
            emailLBL.textAlignment = .right
           
        }else{
            containerView.semanticContentAttribute = .forceLeftToRight
            relatedFileCollectionView.semanticContentAttribute = .forceLeftToRight
            offerCollectionView.semanticContentAttribute = .forceLeftToRight
            businessNameTxt.textAlignment = .left
            businessName.textAlignment = .left
            businessDesTxt.textAlignment = .left
            businessDescription.textAlignment = .left
            contactNoTxt.textAlignment = .left
            contactNO.textAlignment = .left
            addressTxt.textAlignment = .left
            addressLbl.textAlignment = .left
            cityTxt.textAlignment = .left
            cityLBL.textAlignment = .left 
            regionTxt.textAlignment = .left
            regionLBL.textAlignment = .left 
            categoryLBL.textAlignment = .left
            categoryTxt.textAlignment = .left
            emailTxt.textAlignment = .left
            emailLBL.textAlignment = .left
           
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
          createRating()
            
        }else{
            
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getDatasID()
    }
    func getDatasID(){
        
                let network = Network()
                let networkExist = network.isConnectedToNetwork()
                
                if networkExist == true {
                    getData(busId:id!)
                    getFavourite()
                }else{
                    
                    let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
               
        
        }
    
    func getFavourite(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
         var userId = UserDefaults.standard.value(forKey: "user_id") as? String
        //https://pencilnetwork.com/bussines_book/api/favoirtes/searcher_id/bussines_id
        let url = Constant.baseURL + Constant.URIStatusFavourite + userId! + "/\(self.id!)"
        Alamofire.request(url , method:.get, parameters: nil,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    if let data = response.result.value as? [String:Any]{
                        if let rating = data["rating"] as? Double {
                            self.rateUsView.value = CGFloat(rating)
                        }
                        self.rateUsView.addTarget(self, action: #selector(self.tapFunction), for: .valueChanged)
                        if let flag = data["flag"] as? String{
                            if flag == "0" {
                                self.favouriteBtn.setImage(UIImage(named: "emptyheart.png"), for: .normal)
                                self.favourite = false
                            }else{
                                self.favouriteBtn.setImage(UIImage(named: "heart.png"), for: .normal)
                                self.favourite = true
                            }
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "", message: error.localizedDescription as! String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    func insertFavourite(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        var userId = UserDefaults.standard.value(forKey: "user_id") as? String
        let url = Constant.baseURL + Constant.URIInsertFavourite
          var parameter :[String:AnyObject] = [String:AnyObject]()
         parameter["bussines_id"] =  "\(id!)" as AnyObject?
         parameter["searcher_id"] = userId! as AnyObject?
        Alamofire.request(url , method:.post, parameters: parameter,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    if let data = response.result.value as? [String:Any]{
                        if let flag = data["flag"] as? String{
                            if flag == "0" {
                                self.showToast(message: "fail to Add to favourite")
                                self.favourite = false
                            }else{
                                self.favouriteBtn.setImage(UIImage(named: "heart.png"), for: .normal)
                                self.showToast(message: "success to Add to favourite")
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                     self.favourite = false
                    let alert = UIAlertController(title: "", message: error.localizedDescription as! String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
   
    func createRating(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        var parameter :[String:AnyObject] = [String:AnyObject]()
        parameter["bussines_id"] =  "\(id!)" as AnyObject?
        var userId = UserDefaults.standard.value(forKey: "user_id") as? String
        parameter["searcher_id"] = userId! as AnyObject?
        parameter["rating"] = "\(rateUsView.value)" as AnyObject?
        let url = Constant.baseURL + Constant.URIRatings
        Alamofire.request(url , method:.post, parameters: parameter,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    if let data = response.result.value as? [String:Any]{
                        if let flag = data["flag"] as? String{
                            if flag == "0" {
                                self.showToast(message: "fail upload")
                            }else{
                                self.showToast(message: "success upload")
                            }
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "", message: error.localizedDescription as! String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    func getData(busId:Int){
        //"https://pencilnetwork.com/bussines_book/api/bussines/\(userid!)"
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
       
        let url = Constant.baseURL + Constant.URIGetBusiness
        Alamofire.request(url + "\(busId)", method:.get, parameters: nil,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    if let datares = response.result.value as? [String:Any]{
                        if let data = datares["data"] as? [String:Any]{
                            if let description = data["description"] as? String{
                                self.businessDescription.text = description
                            }
                            if let city = data["city"] as? String{
                                self.cityLBL.text = city
                            }
                            if let region = data["regoin"] as? Dictionary<String,Any>{
                                if let name = region["name"] as? String{
                                    self.regionLBL.text = name
                                }
                            }
                            if let average_rating = data["average_rating"] as? Double {
                                self.busRatingView.value = CGFloat(average_rating)
                            }
                            if let name = data["name"] as? String {
                                self.businessName.text = name
                            }
                            if let image = data["image"] as? String {
                                self.cameraIng.sd_setImage(with:  URL(string:image), placeholderImage: UIImage(named: "gallery.png"))
                            }
                            if let logo = data["logo"] as? String{
                                self.logoImg.sd_setImage(with:  URL(string:logo), placeholderImage: UIImage(named: "gallery.png"))
                            }
                            if let address = data["address"] as? String{
                                self.addressLbl.text = address
                            }
                            if let contact_number = data["contact_number"]as? String{
                                self.contactNO.text = contact_number
                            }
                            if let langitude = data["langitude"] as? String{
                                if Double(langitude) != nil {
                                   self.long = Double(langitude)!
                                }
                            }
                            if let lattitude = data["lattitude"] as? String{
                                if   Double(lattitude) != nil {
                                    self.lat = Double(lattitude)!
                                }
                            }
                            
                            if let category = data["category"] as? [String:Any]{
                                if let name = category["name"] as? String {
                                    self.categoryLBL.text = name
                                }
                            }
                            if let offers = data["offers"] as? [Dictionary<String,Any>]{
                                for item in offers{
                                    let offer = OfferBean()
                                    if let id = item["id"] as? Int{
                                        offer.id = id
                                    }
                                    if let caption = item["caption"] as? String{
                                        offer.caption = caption
                                    }
                                    if let photo = item["image"] as? String{
                                        offer.photo = photo
                                    }
                                    self.offerList.append(offer)
                                }
                                self.offerCollectionView.reloadData()
                               
                            }
                            if self.offerCollectionView.collectionViewLayout.collectionViewContentSize.height > 9000{
                                
                            }else{
                                if self.offerList.count > 0 {
                                    self.offerHeight.constant = self.offerCollectionView.collectionViewLayout.collectionViewContentSize.height
                                     self.relateFilesHeight.constant = 10
                                    self.viewHeight.constant = self.offerHeight.constant + self.relateFilesHeight.constant + 740
                                   
                                    self.view.setNeedsLayout()
                                }
                            }
                            
                            if let files = data["files"] as? [Dictionary<String,Any>]{
                                
                                for item in files{
                                    let relatedfile = RelatedFilesBean()
                                    if let id = item["id"] as? Int{
                                        relatedfile.id = id
                                    }
                                    if let image = item["image"] as? String{
                                        relatedfile.image = image
                                    }
                                    self.relatedFileList.append(relatedfile)
                                }
                                self.relatedFileCollectionView.reloadData()
                            }
                            if self.relatedFileList.count > 0{
                                self.relateFilesHeight.constant = self.relatedFileCollectionView.collectionViewLayout.collectionViewContentSize.height
                                self.viewHeight.constant = self.offerHeight.constant + self.relateFilesHeight.constant + 740
                                self.view.setNeedsLayout()
                            }else{
                                 self.relateFilesHeight.constant = 10
                                self.viewHeight.constant = self.offerHeight.constant + 10 + 740
                                self.view.setNeedsLayout()
                            }
                            if let owner = data["owner"] as? [String:Any]{
                                if let email = owner["email"] as? String {
                                    self.emailLBL.text = email
                                }
                                
                            }
                        }
                        let camera = GMSCameraPosition.camera(withLatitude: self.lat, longitude: self.long, zoom: 16.0)
                        
                        self.googleMap.camera = camera
                        
                        
                        print("currentlocation",self.lat,self.long)
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
                        self.getAddressFromLatLon(pdblLatitude: self.lat, withLongitude: self.long,marker: marker)
                        marker.map = self.googleMap
                        self.googleMap.selectedMarker = marker
                    }
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "", message: error.localizedDescription as! String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double,marker: GMSMarker) {
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = pdblLatitude
        //21.228124
        let lon: Double = pdblLongitude
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        var addressString : String = ""
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }else { // success
                    let pm = placemarks! as [CLPlacemark]
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country)
                      
                        
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        
                        self.address = addressString
                        print(addressString)
                        
                        marker.title =  addressString
                        marker.snippet = addressString
                    }
                }
        })
        
    }
    func deleteFavourite(businesId:Int){
        var userId = UserDefaults.standard.value(forKey: "user_id") as? String
    //    let url = Constant.baseURL + "favoirtes/ " + "\(userId!)/\(businesId) "
         let url = Constant.baseURL + Constant.URIDeleteFavourite + userId! + "/\(self.id!)"
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        print(url)
        Alamofire.request(url , method:.delete, parameters: nil,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    
                    if let data = response.result.value as? [String:Any]{
                        if let flag = data["flag"] as? String {
                            if flag == "0"{
                                self.showToast(message: "fail delete favourite")
                                 self.favourite = true
                            }else{
                               
                                 self.favouriteBtn.setImage(UIImage(named: "emptyheart.png"), for: .normal)
                                self.showToast(message: "success delete favourite")
                            }
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                     self.favourite = true
                    let alert = UIAlertController(title: "", message: error.localizedDescription as! String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK:IBAction
    

    @IBAction func favouriteBtnAction(_ sender: Any) {
        favourite = !favourite
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
            if favourite == true {
                insertFavourite()
            }else{
                deleteFavourite(businesId:id!)
            }
        }else{
            
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
       
    }
}
extension DetailBusinessViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == offerCollectionView {
            return offerList.count
        }else{
            return relatedFileList.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == offerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OfferCollectionViewCell", for: indexPath) as! OfferCollectionViewCell
            cell.photo.sd_setImage(with: URL(string:offerList[indexPath.row].photo!), placeholderImage: UIImage(named: "gallery.png"))
            cell.descriptionLBL.text = offerList[indexPath.row].caption
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "relatedFilesCollectionViewCell", for: indexPath) as! relatedFilesCollectionViewCell
            cell.photo.sd_setImage(with: URL(string:relatedFileList[indexPath.row].image!), placeholderImage: UIImage(named: "gallery.png"))
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView == offerCollectionView {
            
            let captionTextWidth = 190
            let size = CGSize(width:captionTextWidth,height:1000)
            let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize:15)]
            if offerList[indexPath.row].caption != "" && offerList[indexPath.row].caption != nil {
                let estimateFrame = NSString(string: offerList[indexPath.row].caption!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                let height  = estimateFrame.height + 130
                return CGSize(width: 200, height: height)
            }else{
                let estimateFrame = NSString(string: "").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                let height  = estimateFrame.height + 130
                return CGSize(width: 110, height: height)
            }
            
        }else{
            return CGSize(width: 120, height: 120)
        }
        
    }
}
