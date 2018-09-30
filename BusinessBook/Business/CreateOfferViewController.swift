//
//  CreateOfferViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/6/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Alamofire
class CreateOfferViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var defaultImg: UIImageView!
   
    @IBOutlet weak var caption: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var pickerController = UIImagePickerController()
    var flag:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        self.activityIndicator.isHidden = true
        
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(CreateOfferViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateOfferViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(deleteCreateOffer(_:)), name: NSNotification.Name(rawValue: "deleteCreateOffer"), object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func galleryAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            pickerController.allowsEditing = true
            
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    //MARK:Function
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        flag = true
        defaultImg.image = info[UIImagePickerControllerEditedImage] as! UIImage
        dismiss(animated:true, completion: nil)
       
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func checkTxtField()->Bool{
        var validFlag = true
      
        if flag == false{
            validFlag = false
            let alert = UIAlertController(title: "alert", message: "You should enter offer image", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        return validFlag
    }
    func sendData(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        let cameraImgData = UIImageJPEGRepresentation(self.defaultImg.image!, 0.5)!
//        let bussines_id = "\()"
        var captiontxt = ""
        if self.caption.text != ""{
             captiontxt = self.caption.text!
            
        }
        let url = Constant.baseURL + Constant.URICreateOffer
        var busineeId = UserDefaults.standard.value(forKey: "id") as! Int
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                multipartFormData.append((("\(busineeId)".data(using: .utf8)!)), withName: "bussines_id")
                if captiontxt != ""{
                   
                    multipartFormData.append(((captiontxt).data(using: .utf8)!), withName: "caption")
                }
                
                multipartFormData.append(cameraImgData, withName:"image", fileName:"image", mimeType: "image/JPEG")
            
                
                
        },
            to: url,
            method:.post,
            encodingCompletion: { encodingResult in
               
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON{ response in
                        //   self.activityIndicator.stopAnimating()
                        print(response)
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        if let data = response.result.value as? [String:Any]{
                            if let flag = data["flag"] as? String{
                                if flag == "0"{
                                     self.showToast(message : " create fail")
                                }else{
                                     self.showToast(message : " create Success")
                                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "returnToBusiness"), object: nil, userInfo: nil)
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
      @objc func deleteCreateOffer(_ notification: NSNotification){
        defaultImg.image = UIImage(named:"car3.png")
        self.caption.text = ""
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
           // if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
          
            //}
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
          //  if self.view.frame.origin.y != 0{
//                self.view.frame.origin.y += keyboardSize.height
             self.view.frame.origin.y  = 0
           // }
        }
    }
}
