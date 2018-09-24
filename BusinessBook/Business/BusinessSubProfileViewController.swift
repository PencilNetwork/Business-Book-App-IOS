//
//  BusinessSubProfileViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/6/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
class BusinessSubProfileViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameLBl: UILabel!
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
    var lat:Double = 0
    var long:Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
         activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
                self.activityIndicator.isHidden = true
        
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
        relatedFileCollectionView.delegate = self
        relatedFileCollectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(refreshOffer(_:)), name: NSNotification.Name(rawValue: "refreshOffer"), object: nil)
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
    
    @objc func refreshOffer(_ notification: NSNotification){
        offerList = []
        relatedFileList = []
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
            getData()
            
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
                        print(pm.locality)
                        print(pm.subLocality)
                        print(pm.thoroughfare)
                        print(pm.postalCode)
                        print(pm.subThoroughfare)
                        
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
  
    func getData(){
        //"https://pencilnetwork.com/bussines_book/api/bussines/\(userid!)"
             self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        var userid = UserDefaults.standard.value(forKey: "id") as? Int
        var url = Constant.baseURL + Constant.URIGetBusiness
        Alamofire.request(url + "\(userid!)", method:.get, parameters: nil,encoding: JSONEncoding.default, headers:nil)
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
                                self.long = Double(langitude)!
                            }
                            if let lattitude = data["lattitude"] as? String{
                               self.lat = Double(lattitude)!
                            }
                           
                            if let category = data["category"] as? [String:Any]{
                                if let name = category["name"] as? String {
                                    self.categoryLBL.text = name
                                }
                            }
                            if let offers = data["offers"] as? [Dictionary<String,Any>]{
                                for item in offers{
                                    var offer = OfferBean()
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
                            if let files = data["files"] as? [Dictionary<String,Any>]{
                                
                                for item in files{
                                    var relatedfile = RelatedFilesBean()
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
                            if let owner = data["owner"] as? [String:Any]{
                                if let email = owner["email"] as? String {
                                    self.emailLBL.text = email
                                }
                                if let username = owner["name"] as? String{
                                   self.nameLBl.text = username
                                }
                            }//.sd_setImage(with:  URL(string:AlbumList[indexPath.row].thumbnailUrl!), placeholderImage: UIImage(named: "profile.jpg"))
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
    
}
