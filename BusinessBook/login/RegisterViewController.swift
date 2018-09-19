//
//  RegisterViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/5/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import Alamofire
import SDWebImage
protocol SendImageDelegate{
    func sendImage(image:UIImage)
}
class RegisterViewController: UIViewController,SendImageDelegate , UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource,CLLocationManagerDelegate,MapDelegate{
    //MARK:IBOUtlet
    
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var setLocation: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var category: UIButton!
    
    @IBOutlet weak var logoBtn: UIButton!
    @IBOutlet weak var businessdesTxt: UITextField!
    @IBOutlet weak var businessName: UITextField!
    @IBOutlet weak var contactNo: UITextField!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var googleMapsView: GMSMapView!
    //MARK:Variable
    var pickerController = UIImagePickerController()
    var imageflag:Bool = false
    var categoryList:[CategoryBean] = []
    var categSelected = -1
   var locationManager = CLLocationManager()
    var lat:Double? = 0
    var long:Double? = 0
     var locationFlag = false
    var name:String?
    var id:Int?
    var city:String = ""
    var region:String = ""
//      var googleMapsView:GMSMapView!
    var address:String? = ""
    var photoImg:UIImage?
    var logoImg:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        activityindicator.isHidden = true
        activityindicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        confirmBtn.layer.cornerRadius = 10 
        //current location
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
         self.locationManager.delegate = self
        setLocation.layer.cornerRadius = 10
         self.navigationController?.navigationBar.topItem?.title = ""
         self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "Creating business"
        hideKeyboardWhenTappedAround()
        
       
        businessdesTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        businessName.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
         contactNo.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
         addressTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        getCategory()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    //MARK:IBAction
    @IBAction func imageBtnAction(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AlertImageViewController") as! AlertImageViewController
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        viewController.sendDelegate = self 

        self.present(viewController, animated: false)
    }
    
    @IBAction func logoBtnAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            pickerController.allowsEditing = true
            
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func categoryBtnAction(_ sender: Any) {
        pickerView.isHidden = !pickerView.isHidden
        doneBtn.isHidden = !doneBtn.isHidden
    }
    
    @IBAction func setyouLocationbtnAction(_ sender: Any) {
        locationFlag = true
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AnotherMapViewController") as! AnotherMapViewController
        viewController.lat = lat
        viewController.long = long
        viewController.mapDelegate = self 
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    @IBAction func confirmBtnAction(_ sender: Any) {
      var valid =  checkTxtField()
        if valid == true {
            let network = Network()
            let networkExist = network.isConnectedToNetwork()
            
            if networkExist == true {
                sendData()
                
            }else{
                
                let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
           
           
        }
    }
    
    @IBAction func pickerDoneAction(_ sender: Any) {
        pickerView.isHidden = true
        doneBtn.isHidden = true
        if categoryList.count > 0 {
            if categSelected == -1 {
                categSelected = 0
                category.setTitle(categoryList[0].name, for: .normal)
            }else{
                category.setTitle(categoryList[categSelected].name, for: .normal)
            }
        }
    }
    //MARK: Function
   
    func createMap(lat:Double,long:Double){
        self.lat = lat
        self.long = long
       // setLocation.isHidden = true
        googleMapsView.isHidden = false
        containerHeight.constant = 177
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 16)
        self.googleMapsView.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.map = self.googleMapsView
        getAddressFromLatLon(pdblLatitude: lat, withLongitude: long,marker: marker)
        self.googleMapsView.selectedMarker = marker
       
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
                        if let region = pm.locality, !region.isEmpty {
                            // here you have the city name
                            // assign city name to our iVar
                            print("region\(region)")
                            self.region  = region
                        }
                        if let city = pm.addressDictionary!["State"] as? String {
                            self.city = city
                            print(pm.addressDictionary!["State"])
                        }
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
    func getCategory(){
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
            Alamofire.request("https://pencilnetwork.com/bussines_book/api/categories", method:.get, parameters: nil,encoding: JSONEncoding.default, headers:nil)
                .responseJSON { response in
                    print(response)
//                    self.activityIndicator.stopAnimating()
//                    self.activityIndicator.isHidden = true
                    switch response.result {
                    case .success:
                        if let datares = response.result.value as? [String:Any]{
//                            if let flag = datares["flag"] as? String {
//                                if flag == "0" {
//
//                                }
//                            }
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
                                self.pickerView.delegate = self
                                self.pickerView.dataSource = self
                                
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
    func sendImage(image:UIImage){
        imageflag = true
        photoImg = image
        imageBtn.setImage(image, for: .normal)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        logoImg = info[UIImagePickerControllerEditedImage] as! UIImage
        logoBtn.setImage(info[UIImagePickerControllerEditedImage] as! UIImage, for: .normal) 
        dismiss(animated:true, completion: nil)
       
    }
    func checkTxtField()->Bool{
        var validFlag = true
        if locationFlag == false {
            validFlag = false
            let alert = UIAlertController(title: "Warning", message: "select your Location ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        if businessName.text ==  "" {
            validFlag = false
            businessName.backgroundColor = .red
        }
        if contactNo.text ==  "" {
            validFlag = false
            contactNo.backgroundColor = .red
        }
        if addressTxt.text ==  "" {
            validFlag = false
            addressTxt.backgroundColor = .red
        }
       
        if categSelected == -1 {
            validFlag = false
            let alert = UIAlertController(title: "Warning", message: "select your category ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        if businessdesTxt.text ==  "" {
            validFlag = false
            businessdesTxt.backgroundColor = .red
        }
        if imageflag == false{
            validFlag = false
            let alert = UIAlertController(title: "alert", message: "You should enter image", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        return validFlag
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func textFieldDidChange(textField: UITextField){
        textField.backgroundColor = UIColor.white
    }
    //MARK:Function
    func sendData(){
        activityindicator.isHidden = false
        activityindicator.startAnimating()
        let cameraImgData = UIImageJPEGRepresentation(self.photoImg!, 0.5)!
        var ownerId = "\(self.id!)"
        var categId = "\(categoryList[categSelected].id!)"
        var contactNo = self.contactNo.text!
        var businessDes = self.businessdesTxt.text!
        var addressData = self.addressTxt.text!
        var businessName = self.businessName.text!
        
//        multipartFormData.appendBodyPart(data: image1Data, name: "file", fileName: "myImage.png", mimeType: "image/png")
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(((businessName).data(using: .utf8)!), withName: "name")
                multipartFormData.append(((businessDes).data(using: .utf8)!), withName: "description")
                multipartFormData.append(((contactNo).data(using: .utf8)!), withName: "contact_number")
                    multipartFormData.append(((self.city).data(using: .utf8)!), withName: "city")
                multipartFormData.append(((self.region).data(using: .utf8)!), withName: "regoin")
                multipartFormData.append(((addressData).data(using: .utf8)!), withName: "address")
                multipartFormData.append(("\(self.long!)").data(using: .utf8)!, withName: "langitude")
                 multipartFormData.append(("\(self.lat!)").data(using: .utf8)!, withName: "lattitude")
                multipartFormData.append(((categId).data(using: .utf8)!), withName: "category_id")
                multipartFormData.append(((ownerId).data(using: .utf8)!), withName: "owner_id")
                multipartFormData.append(cameraImgData, withName:"image", fileName:"image.jpg", mimeType: "image/JPEG")
//               multipartFormData.appendBodyPart(data: image1Data, name: "file", fileName: "myImage.png", mimeType: "image/png")
                if self.logoImg != nil {
                    let logoData = UIImageJPEGRepresentation(self.logoImg!, 0.5)!
                     multipartFormData.append(logoData, withName:"logo", fileName:"logo.jpg", mimeType: "image/JPEG")
                }
             


        },
            to: "https://pencilnetwork.com/bussines_book/api/bussines/store",
             method:.post,
            encodingCompletion: { encodingResult in
               self.activityindicator.isHidden = true
                self.activityindicator.stopAnimating()
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON{ response in
                        switch response.result {
                         case .success:
                     //   self.activityIndicator.stopAnimating()
                          print(response)
   
                            if let datares = response.result.value as? [String:Any]{
                                if let data  = datares["data"] as? [String:Any]{
                                     if let id = data["id"] as? Int{
                                        UserDefaults.standard.setValue(id, forKey: "id")
                                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "BusinessProfileViewController") as! BusinessProfileViewController
                                        
                                        self.navigationController?.pushViewController(viewController, animated: true)
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
                case .failure(let error):
                    print(error)
                    
                    let alert = UIAlertController(title: "", message: error as! String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                }
        }
        )
        
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        lat = locValue.latitude
        long = locValue.longitude
        locationManager.stopUpdatingLocation()
    }
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
        category.setTitle(categoryList[row].name, for: .normal)
    }
}
