//
//  EditOfferViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/9/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Alamofire
class EditOfferViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,ChangeImageDelegate,UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var offercollectionView: UICollectionView!
    var offerList:[OfferBean] = []
      var index:Int?
    var pickerController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        offercollectionView.delegate = self
        offercollectionView.dataSource = self
        hideKeyboardWhenTappedAround()
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        self.activityIndicator.isHidden = true
         NotificationCenter.default.addObserver(self, selector: #selector(refreshOfferPage(_:)), name: NSNotification.Name(rawValue: "refreshPageOffer"), object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if offerList.count > 0 {
            return offerList.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "EditOfferCollectionViewCell", for: indexPath) as? EditOfferCollectionViewCell
        cell?.index = indexPath.row
        cell?.changeImageDelegate = self
        if offerList[indexPath.row].image != nil {
            cell?.photo.image = offerList[indexPath.row].image
        }else{
        cell?.photo.sd_setImage(with: URL(string:offerList[indexPath.row].photo!), placeholderImage: UIImage(named: "gallery.png"))
        }
        cell?.captionTxt.text = offerList[indexPath.row].caption
        cell?.editOffer.layer.cornerRadius = 10
        cell?.imageId = offerList[indexPath.row].id
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 133, height: 250)
    }
    //MARK:delegate function
    func editImage(index: Int,imageId:Int) {
    }
    func editOffer(index:Int,imageId:Int,caption:String){
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                          multipartFormData.append(((caption).data(using: .utf8)!), withName: "caption")
                if self.offerList[index].image != nil {
                    let cameraImgData = UIImageJPEGRepresentation(self.offerList[index].image!, 0.5)!
                   multipartFormData.append(cameraImgData, withName:"image", fileName:"image.jpg", mimeType: "image/JPEG")
                }
                
        },
            to: "https://pencilnetwork.com/bussines_book/api/offers/\(imageId)",
            method:.post,
            encodingCompletion: { encodingResult in
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON{ response in
                        //   self.activityIndicator.stopAnimating()
                        print(response)
                        
                        if let data = response.result.value as? [String:Any]{
                            if let flag = data["flag"] as? String{
                                if flag == "1"{
                                    self.showToast(message : "Edit Successfully")
                                }else{
                                    self.showToast(message : "Edit fail")
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
        }else{
            
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func minusImage(index:Int,imageId:Int){
      
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
 
        if networkExist == true {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            Alamofire.request("https://pencilnetwork.com/bussines_book/api/offers/\(imageId)", method:.delete, parameters: nil,encoding: JSONEncoding.default, headers:nil)
                .responseJSON { response in
                    print(response)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
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
        
        offerList.remove(at: index)
        offercollectionView.reloadData()
        
    }
    func addImage(index:Int){
        self.index = index
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            pickerController.allowsEditing = true
            
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    // MARK:Function
      @objc func refreshOfferPage(_ notification: NSNotification){
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
    func getData(){
       offerList = []
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        var userid = UserDefaults.standard.value(forKey: "id") as? Int
        Alamofire.request("https://pencilnetwork.com/bussines_book/api/bussines/\(userid!)", method:.get, parameters: nil,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    if let datares = response.result.value as? [String:Any]{
                        if let data = datares["data"] as? [String:Any]{
                           
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
                                self.offercollectionView.reloadData()
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
       
            offerList[index!].image = info[UIImagePickerControllerEditedImage] as! UIImage
            
            dismiss(animated:true, completion: nil)
            offercollectionView.reloadData()
        }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
