//
//  UploadRelatedFilesViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/9/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Alamofire
class UploadRelatedFilesViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate  {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var defaultImg: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var relatedList:[UIImage] = []
    var pickerController = UIImagePickerController()
      var menuDel:menuDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        activityIndicator.isHidden = true
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
          NotificationCenter.default.addObserver(self, selector: #selector(deletefiles(_:)), name: NSNotification.Name(rawValue: "deletefiles"), object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("appear")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func confirmBtnAction(_ sender: Any) {
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
    

    @IBAction func galleryAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            pickerController.allowsEditing = true
            
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    //MARK:collectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if relatedList.count > 0{
            return relatedList.count
        }else{
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "relatedcell", for: indexPath) as! relatedFilesCollectionViewCell
        if relatedList.count > 0 {
            cell.photo.image = relatedList[indexPath.row]
        }
        return cell
    }
    //MARK:Function
     @objc func deletefiles(_ notification: NSNotification){
        relatedList = []
        collectionView.reloadData()
         defaultImg.isHidden = false
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        defaultImg.isHidden = true
        relatedList.append(info[UIImagePickerControllerEditedImage] as! UIImage)
        dismiss(animated:true, completion: nil)
        collectionView.reloadData()
    }
    func sendData(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let url = Constant.baseURL + Constant.URIUploadFiles
        var imagesData:[Data] = []
        for item in relatedList{
            var cameraImgData = UIImageJPEGRepresentation(item, 0.5)!
            imagesData.append(cameraImgData)
        }
        var businss_id = "\((UserDefaults.standard.value(forKey: "id") as! Int))"
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                multipartFormData.append(((businss_id).data(using: .utf8)!), withName: "bussines_id")

               
        var imageParamName = "image"
                for imageData in imagesData {
                    multipartFormData.append(imageData, withName: "\(imageParamName)[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                }

        },
            to: url,
            method:.post,
            encodingCompletion: { encodingResult in
               
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON{ response in
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        print(response)

                        if let datares = response.result.value as? [String:Any]{
                            if let flag = datares["flag"] as? String {
                                if flag == "1"{
                                    self.showToast(message : " upload Successfully")
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "returnToBusiness"), object: nil, userInfo: nil)
                                   
//                                    let alert = UIAlertController(title: "", message: " upload Successfully" as! String, preferredStyle: UIAlertControllerStyle.alert)
//                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                                    self.present(alert, animated: true, completion: nil)
                                }else{ // flag== 0
                                    let alert = UIAlertController(title: "", message: "Response fail try Again" as! String, preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)

                                }
                            }
                            if let data = datares["data"] as? [String:Any]{
                                
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
}
extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x:  80, y: self.view.frame.size.height-100, width: 250, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }
