//
//  EditBusinessProfileViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/9/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SDWebImage
protocol ChangeImageDelegate{
    func minusImage(index:Int,imageId:Int)
    func addImage(index:Int)
    func editImage(index:Int,imageId:Int)
    func editOffer(index:Int,imageId:Int,caption:String)
}

class EditBusinessProfileViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,ChangeImageDelegate , UINavigationControllerDelegate, UIImagePickerControllerDelegate,UICollectionViewDelegateFlowLayout,SendImageDelegate, UIPickerViewDelegate, UIPickerViewDataSource,MapDelegate{
    @IBOutlet weak var cityDoneBtn: UIButton!
    @IBOutlet weak var regionBtnDone: UIButton!
    @IBOutlet weak var regionPickerView: UIPickerView!
    @IBOutlet weak var cityPickerView: UIPickerView!
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var regionBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var googleMapsView: GMSMapView!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var businessDescTxt: UITextField!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var businessNameTxt: UITextField!
    @IBOutlet weak var contactTxt: UITextField!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var editLogoLBL: UILabel!
    @IBOutlet weak var editImageLBL: UILabel!
    @IBOutlet weak var userNametxt: UITextField!
    @IBOutlet weak var imageBtn: UIButton!
    
    @IBOutlet weak var galleryBtn: UIButton!
    //MARK:Variable
    var type:Int = 0
    var lat:Double = 0
    var long:Double = 0
    var photoList:[UIImage] = [UIImage(named:"car3.png" )!,UIImage(named:"car4.png" )!,UIImage(named:"car5.png" )!]
     var relatedFileList:[RelatedFilesBean] = []
     var categoryList:[CategoryBean] = []
    var categSelected = -1
    var citySelected = -1
    var regionSelected = -1
    var defaultRegionId :Int = -1
    var defaultCityId:Int = -1
     var pickerController = UIImagePickerController()
    var index:Int?
        var imageflag:Bool = false
      var address:String? = ""
    var photoImg:UIImage?
    var logoImg:UIImage?
    var region:String = ""
    var city:String = ""
    var oldCategory:CategoryBean = CategoryBean()
    var regionList:[RegionBean] = []
    var cityList :[Interest] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(editLogoFunc))
        editLogoLBL.isUserInteractionEnabled = true
        editLogoLBL.addGestureRecognizer(tap)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(editImgFunc))
        editImageLBL.isUserInteractionEnabled = true
        editImageLBL.addGestureRecognizer(tap2)
        
        hideKeyboardWhenTappedAround()
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        self.activityIndicator.isHidden = true
        
        
       collectionView.delegate = self
        collectionView.dataSource = self
//        pickerView.delegate = self
//        pickerView.dataSource = self
        confirmBtn.layer.cornerRadius = 10
        userNametxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        businessDescTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        businessNameTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        contactTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        addressTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        emailTxt.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        

        getCategory()
        // Do any additional setup after loading the view.
        relatedFileList = []
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
            getData()
            
        }else{
            
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
          NotificationCenter.default.addObserver(self, selector: #selector(refresh(_:)), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        getCity()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
      
    }
  
    @IBAction func imageAction(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AlertImageViewController") as! AlertImageViewController
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        viewController.sendDelegate = self
        
        self.present(viewController, animated: false)
        
    }
    
    @IBAction func galleyAction(_ sender: Any) {
        type = 2
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            pickerController.allowsEditing = true
            
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func categoryAction(_ sender: Any) {
        pickerView.isHidden = !pickerView.isHidden
        doneBtn.isHidden = !doneBtn.isHidden
    }
    
    @IBAction func doneAction(_ sender: Any) {
        pickerView.isHidden = true
        doneBtn.isHidden = true
        if categoryList.count > 0 {
            if categSelected == -1 {
                categSelected = 0
                categoryBtn.setTitle(categoryList[0].name, for: .normal)
            }else{
                categoryBtn.setTitle(categoryList[categSelected].name, for: .normal)
            }
        }
    }
    
    @IBAction func confirmAction(_ sender: Any) {
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
    
    @IBAction func setYourLocationAction(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AnotherMapViewController") as! AnotherMapViewController
        viewController.lat = lat
        viewController.long = long
        viewController.mapDelegate = self
        self.navigationController?.pushViewController(viewController, animated: false)
        
    }
    @IBAction func cityDoneBtnAction(_ sender: Any) {
         regionBtn.setTitle("region", for: .normal)
        cityPickerView.isHidden = true
        cityDoneBtn.isHidden = true
        if cityList.count > 0 {
            if citySelected == -1 {
                citySelected = 0
                cityBtn.setTitle(cityList[0].name, for: .normal)
                
            }else{
                cityBtn.setTitle(cityList[citySelected].name, for: .normal)
            }
            getRegion(cityId: cityList[citySelected].id!)
        }
        
    }
    
    @IBAction func regionDoneAction(_ sender: Any) {
        regionPickerView.isHidden = true
        regionBtnDone.isHidden = true
        if regionList.count > 0 {
            if regionSelected == -1 {
                regionSelected = 0
                regionBtn.setTitle(regionList[0].name, for: .normal)
            }else{
                regionBtn.setTitle(regionList[regionSelected].name, for: .normal)
            }
        }
    }
    @IBAction func regionBtnAction(_ sender: Any) {
        regionPickerView.isHidden = !regionPickerView.isHidden
        regionBtnDone.isHidden = !regionBtnDone.isHidden
    }
    @IBAction func cityBtnAction(_ sender: Any) {
        cityPickerView.isHidden = !cityPickerView.isHidden
        cityDoneBtn.isHidden = !cityDoneBtn.isHidden
    }
    //Mark:function
    
    @objc
    func editLogoFunc(sender:UITapGestureRecognizer) {
        print("tap working")
        type = 2
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            pickerController.allowsEditing = true
            
            self.present(pickerController, animated: true, completion: nil)
        }
    }

    @objc
    func editImgFunc(sender:UITapGestureRecognizer) {
        print("tap working")
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AlertImageViewController") as! AlertImageViewController
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        viewController.sendDelegate = self
        
        self.present(viewController, animated: false)
    }
    @objc func refresh(_ notification: NSNotification){
        relatedFileList = []
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
            getData()
            
        }else{
            
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        }
    func createMap(lat:Double,long:Double){
      self.lat = lat
        self.long = long 
       
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
    func sendImage(image:UIImage){
        imageflag = true
        photoImg = image
        imageBtn.setImage(image, for: .normal)
    }
    func getCategory(){
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
            Alamofire.request(Constant.baseURL + "categories", method:.get, parameters: nil,encoding: JSONEncoding.default, headers:nil)
                .responseJSON { response in
                    print(response)
                    //                    self.activityIndicator.stopAnimating()
                    //                    self.activityIndicator.isHidden = true
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
    // MARK:Collectionview
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if relatedFileList.count > 0 {
                return relatedFileList.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditProfileBusinessCollectionViewCell", for: indexPath) as! EditProfileBusinessCollectionViewCell
        if relatedFileList[indexPath.row].photo == nil {
        cell.photo.sd_setImage(with: URL(string:relatedFileList[indexPath.row].image!), placeholderImage: UIImage(named: "gallery.png"))
        }else{
            cell.photo.image = relatedFileList[indexPath.row].photo
        }
        cell.index = indexPath.row
        cell.changeImageDelegate = self
      
        cell.imageId = relatedFileList[indexPath.row].id
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 130, height: 130)
    }
    //MARK: delegatefunction
    func editOffer(index:Int,imageId:Int,caption:String){
        
    }
    func deleterelatedFiles(index:Int,imageId:Int){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
            Alamofire.request(Constant.baseURL + "files/\(imageId)", method:.delete, parameters: nil,encoding: JSONEncoding.default, headers:nil)
                .responseJSON { response in
                    print(response)
                     self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    switch response.result {
                    case .success:
                        if let datares = response.result.value as? [String:Any]{
                            if let flag = datares["flag"] as? String {
                                if flag == "0" {
                                    
                                    self.showToast(message : "delete fail ")
                                }else{
                                    self.showToast(message : "deleted Successfully")
                                }
                            }
                            
                            
                        }
                    case .failure(let error):
                        print(error)
                        if let errorstring  = error as?String {
                            let alert = UIAlertController(title: "", message: errorstring, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
            }
        }else{
            
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        relatedFileList.remove(at: index)
        collectionView.reloadData()
        
    }
    func minusImage(index:Int,imageId:Int){
        //https://pencilnetwork.com/bussines_book/api/files/2
        let refreshAlert = UIAlertController(title: "", message: "Are you sure you want to delete related file?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.deleterelatedFiles(index:index,imageId:imageId)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
      
        
    }
    func addImage(index:Int){
        self.index = index
        type = 1
        let refreshAlert = UIAlertController(title: "", message: "Are you sure you want to replace related file?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                self.pickerController.delegate = self
                self.pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.pickerController.allowsEditing = true
                
                self.present(self.pickerController, animated: true, completion: nil)
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
       
    }
    func editImage(index:Int,imageId:Int){
       
    }
      //MARK: function
    func getRegion(cityId:Int){
        regionList = []
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        regionBtn.isEnabled = false
        if networkExist == true {
            
            if cityList.count > 0 && citySelected != -1 || defaultCityId != -1  {
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                let url = Constant.baseURL + Constant.URIRegion + "\(cityId)"
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
                                for item in data {
                                    let city = Interest()
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
    func checkTxtField()->Bool{
        var validFlag = true
        if userNametxt.text == "" {
            validFlag = false
            userNametxt.backgroundColor = .red
        }
       
        if businessNameTxt.text ==  "" {
            validFlag = false
            businessNameTxt.backgroundColor = .red
        }
        if contactTxt.text ==  "" {
            validFlag = false
            contactTxt.backgroundColor = .red
        }
        if addressTxt.text ==  "" {
            validFlag = false
            addressTxt.backgroundColor = .red
        }
        if emailTxt.text ==  "" {
            validFlag = false
            emailTxt.backgroundColor = .red
        }else{
            if isValidEmail(testStr: emailTxt.text!) == false{
                validFlag = false
                let alert = UIAlertController(title: "Warning", message: "InValid Email", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
//        if categSelected == -1 {
//            validFlag = false
//            let alert = UIAlertController(title: "Warning", message: "select your category ", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
        if businessDescTxt.text ==  "" {
            validFlag = false
            businessDescTxt.backgroundColor = .red
        }
//        if imageflag == false{
//            validFlag = false
//            let alert = UIAlertController(title: "alert", message: "You should enter image", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
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
    func replaceRelatedFiles(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let cameraImgData = UIImageJPEGRepresentation(self.relatedFileList[index!].photo!, 0.5)!
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                //                multipartFormData.append(((busnessId).data(using: .utf8)!), withName: "bussines_id")
                multipartFormData.append(cameraImgData, withName:"image", fileName:"image", mimeType: "image/JPEG")
                
        },
            to: Constant.baseURL + "files/\(relatedFileList[index!].id!)",
            method:.post,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON{ response in
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        print(response)
                        
                        if let data = response.result.value as? [String:Any]{
                            if let flag = data["flag"] as? String{
                                if flag == "1"{
                                    self.showToast(message : "Edit Successfully")
                                }else{
                                    self.showToast(message : "fail")
                                }
                            }
                            
                        }
                    }
                case .failure(let error):
                    print(error)
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    let alert = UIAlertController(title: "", message: error as! String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
        }
        )
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if type == 1{
       relatedFileList[index!].photo = info[UIImagePickerControllerEditedImage] as! UIImage
       
        dismiss(animated:true, completion: nil)
        collectionView.reloadData()
           replaceRelatedFiles()
        }else{  // edit gallery
           logoImg = info[UIImagePickerControllerEditedImage] as! UIImage
            galleryBtn.setImage(info[UIImagePickerControllerEditedImage] as! UIImage, for: .normal)
             dismiss(animated:true, completion: nil)
        }
    }
   
    //MARK:pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          if pickerView == self.pickerView {
              if categoryList.count > 0 {
                 return categoryList.count
              }else{
                return 0
              }
        }else if pickerView == cityPickerView {
             if cityList.count > 0 {
                return cityList.count
             }else{
                return 0
             }
    }else{
           if regionList.count > 0 {
              return regionList.count
           }else{
              return 0
          }
       }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          if pickerView == self.pickerView {
             return categoryList[row].name
          }else if pickerView == cityPickerView {
             return cityList[row].name
         }else{
            return regionList[row].name
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.pickerView {
           categSelected = row
           categoryBtn.setTitle(categoryList[row].name, for: .normal)
      }else if pickerView == cityPickerView{
           citySelected = row
           cityBtn.setTitle(cityList[row].name, for: .normal)
    
    
          regionBtn.setTitle("region", for: .normal)
    }else{
         regionSelected = row
         regionBtn.setTitle(regionList[row].name, for: .normal)
    
    }
    }
    func sendData(){
       
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        let busineeId = UserDefaults.standard.value(forKey: "id") as! Int
        let ownerId = UserDefaults.standard.value(forKey: "ownerId") as! Int
        let desc = businessDescTxt.text!
        var name = businessNameTxt.text!
        var contactNo = contactTxt.text!
        var addrestxt = addressTxt.text!
        var categId = ""
          if categSelected != -1 {
              categId =   "\(categoryList[categSelected].id!)"
          }else{
              categId =  "\(oldCategory.id!)"
        }
        
        var cityId:Int = 0
        if citySelected != -1 { // change city
           cityId  = cityList[citySelected].id!
            defaultRegionId = -1
        }else{
            cityId = defaultCityId
        }
        var regionId = ""
        if regionSelected != -1 {
            regionId = "\(regionList[regionSelected].id!)"
        }else{ //
            if  defaultRegionId ==  -1 { // change city and not select tregion
                regionId = ""
            }else{ // donot change city and region
                 regionId = "\(defaultRegionId)"
            }
            
        }
        //https://pencilnetwork.com/bussines_book/api/
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                multipartFormData.append(((name.data(using: .utf8)!)), withName: "name")
                
                multipartFormData.append(((desc).data(using: .utf8)!), withName: "description")
                multipartFormData.append(((contactNo).data(using: .utf8)!), withName: "contact_number")
                multipartFormData.append((("\(cityId)").data(using: .utf8)!), withName: "city_id")
                multipartFormData.append(((regionId).data(using: .utf8)!), withName: "regoin_id")
                multipartFormData.append(((addrestxt).data(using: .utf8)!), withName: "address")
                 multipartFormData.append((("\(self.lat)").data(using: .utf8)!), withName: "lattitude")
                multipartFormData.append((("\(self.long)").data(using: .utf8)!), withName: "langitude")
                multipartFormData.append(((categId).data(using: .utf8)!), withName: "category_id")
                 multipartFormData.append((("\(ownerId)").data(using: .utf8)!), withName: "owner_id")
                if self.photoImg != nil{
                     let cameraImgData = UIImageJPEGRepresentation(self.photoImg!, 0.5)!
                      multipartFormData.append(cameraImgData, withName:"image", fileName:"image.jpg", mimeType: "image/JPEG")
                }
              
                if self.logoImg != nil{
                    let logoImgData = UIImageJPEGRepresentation(self.logoImg!, 0.5)!
                     multipartFormData.append(logoImgData, withName:"logo", fileName:"logo.jpg", mimeType: "image/JPEG")
                }
                
                
        },
            to: Constant.baseURL + "bussines/\(busineeId)",
            method:.post,
            encodingCompletion: { encodingResult in
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON{ response in
                        //   self.activityIndicator.stopAnimating()
                        print(response)
                        
                        if let data = response.result.value as? [String:Any]{
                            if let flag = data["flag"] as? String{
                                if flag == "0"{
                                    self.showToast(message : " Edit fail")
                                }else{
                                    self.showToast(message : " Edit Success")
                                }
                            }
                            
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
    func getData(){
        defaultRegionId  = -1
         defaultCityId = -1
        //https://pencilnetwork.com/bussines_book/api/bussines/{bussines}
//        self.activityIndicator.isHidden = false
//        self.activityIndicator.startAnimating()
         var userid = UserDefaults.standard.value(forKey: "id") as? Int
         var url = Constant.baseURL + Constant.URIGetBusiness
        Alamofire.request(url + "\(userid!)", method:.get, parameters: nil,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
//                self.activityIndicator.stopAnimating()
//                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    if let datares = response.result.value as? [String:Any]{
                        if let data = datares["data"] as? [String:Any]{
                            if let description = data["description"] as? String{
                                self.businessDescTxt.text = description
                            }
                            if let name = data["name"] as? String {
                                self.businessNameTxt.text = name
                            }
                            if let address = data["address"] as? String{
                                self.addressTxt.text = address
                            }
                            if let city = data["city"] as? String{
                                self.cityBtn.setTitle(city, for: .normal)
                            }
                            if let city_id = data["city_id"] as? Int {
                                self.defaultCityId = city_id
                            }
                            if let region = data["regoin"] as? [String:Any]{
                                var reg = RegionBean()
                                if let id = region["id"] as? Int{
                                   self.defaultRegionId = id
                                }
                                if let name = region["name"] as? String{
                                    self.regionBtn.setTitle(name, for: .normal)
                                }
                            }
                            if let contact_number = data["contact_number"]as? String{
                                self.contactTxt.text = contact_number
                            }
                            if let image = data["image"] as? String {
                              
                                self.imageBtn.sd_setImage(with:  URL(string:image), for: .normal)
                            }
                            if let logo = data["logo"] as? String{
                               
                                self.galleryBtn.sd_setImage(with:  URL(string:logo), for: .normal)
                            }
                            if let langitude = data["langitude"] as? String{
                                self.long = Double(langitude)!
                            }
                            if let lattitude = data["lattitude"] as? String{
                                self.lat = Double(lattitude)!
                            }
                            
                            if let category = data["category"] as? [String:Any]{
                                if let name = category["name"] as? String {
                                    self.categoryBtn.setTitle(name, for: .normal)
                                    self.oldCategory.name = name
                                }
                                 if let id = category["id"] as? Int {
                                    self.oldCategory.id = id
                                }
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
                                self.collectionView.reloadData()
                            }
                            if let owner = data["owner"] as? [String:Any]{
                                if let email = owner["email"] as? String {
                                    self.emailTxt.text = email
                                }
                                if let username = owner["name"] as? String{
                                    self.userNametxt.text = username
                                }
                            }
                        }
                        let camera = GMSCameraPosition.camera(withLatitude: self.lat, longitude: self.long, zoom: 16.0)
                        
                        self.googleMapsView.camera = camera
                        
                        
                        print("currentlocation",self.lat,self.long)
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
                        self.getAddressFromLatLon(pdblLatitude: self.lat, withLongitude: self.long,marker: marker)
                        marker.map = self.googleMapsView
                        
                        self.getRegion(cityId:self.defaultCityId)
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
