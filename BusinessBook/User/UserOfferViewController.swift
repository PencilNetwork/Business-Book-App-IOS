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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var regionBtn: UIButton!
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var categoryDone: UIButton!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var offerCollectionView: UICollectionView!
    var offerList :[OfferBean] = [OfferBean(photo:"car3.png", caption: "112", id:1),OfferBean(photo:"car3.png", caption: "112", id:1)]
      var categoryList:[CategoryBean] = []
       var categSelected = -1
    override func viewDidLoad() {
        super.viewDidLoad()
     activityIndicator.isHidden =  true
         activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        getCategory()
        offerCollectionView.delegate = self
        offerCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getDefaultOffer(){
        let network = Network()
        
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            let userId = UserDefaults.standard.value(forKey: "user_id") as? String
            let url = Constant.baseURL + Constant.URIDefaultOfferSearch + userId!
            
            
        } else{
    
    let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
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
    }
    
    @IBAction func searchBtnAction(_ sender: Any) {
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
        cell?.photo.image = UIImage(named:offerList[indexPath.row].photo!)
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
