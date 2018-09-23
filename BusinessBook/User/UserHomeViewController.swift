//
//  UserHomeViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/23/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Alamofire
class UserHomeViewController: UIViewController {
    //MARK:IBOUTlet
    
    @IBOutlet weak var hospitalBtn: UIButton!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var offerCollectionView: UICollectionView!
    @IBOutlet weak var regionSearchBar: UISearchBar!
    @IBOutlet weak var firstSearchBar: UISearchBar!
    @IBOutlet weak var regionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var anotherBtn: UIButton!
    @IBOutlet weak var historicPlaceBtn: UIButton!
    
    @IBOutlet weak var ineedHotelBtn: UIButton!
    @IBOutlet weak var iamHungryBtn: UIButton!
    //MARK:variable
    var offerList:[OfferBean] = [OfferBean(image: UIImage(named:"car3.png")!,caption:"yrrt"),OfferBean(image: UIImage(named:"car4.png")!,caption:"yrrt1"),OfferBean(image: UIImage(named:"car5.png")!,caption:"yrrt2")]
    override func viewDidLoad() {
        super.viewDidLoad()
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
        regionViewHeight.constant = 0
        regionSearchBar.isHidden = true
        styleBtn()
        styleSearchBar(searchBar:firstSearchBar)
        styleSearchBar(searchBar:regionSearchBar)
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0, y: 0.0, width: 20, height: 20)
        menuBtn.setImage(UIImage(named:"menu.png"), for: .normal)
        menuBtn.addTarget(self, action: #selector(MenuButtonTapped), for: UIControlEvents.touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        if #available(iOS 9.0, *) {
            let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
            currWidth?.isActive = true
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 9.0, *) {
            let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
            currHeight?.isActive = true
        } else {
            // Fallback on earlier versions
        }
        
        self.navigationItem.leftBarButtonItem = menuBarItem
//        let myimage = UIImage(named: "menu.png")?.withRenderingMode(.alwaysOriginal)
//        let barButtonItem2 = UIBarButtonItem(image: myimage, style: .plain, target: self, action: #selector(MenuButtonTapped))
//        self.navigationItem.leftBarButtonItem = barButtonItem2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:Function
    func styleSearchBar(searchBar:UISearchBar){
        for view in searchBar.subviews.last!.subviews {
            if type(of: view) == NSClassFromString("UISearchBarBackground"){
                view.alpha = 0.0
            }
        }
    }
    func styleBtn(){
        historicPlaceBtn.layer.cornerRadius = 10
        hospitalBtn.layer.cornerRadius = 10
        ineedHotelBtn.layer.borderWidth = 0.5
        ineedHotelBtn.layer.borderColor = UIColor.white.cgColor
        iamHungryBtn.layer.borderWidth = 0.5
        iamHungryBtn.layer.borderColor = UIColor.white.cgColor
        styleGradientBtn(button:ineedHotelBtn,topColor:UIColor.white.cgColor,bottom:UIColor.red.cgColor)
  styleGradientBtn(button:iamHungryBtn,topColor:UIColor.white.cgColor,bottom:UIColor.green.cgColor)
        styleGradientBtn(button:anotherBtn,topColor:UIColor.gray.cgColor,bottom:UIColor.white.cgColor)
       
       
    }
    func styleGradientBtn(button:UIButton,topColor:CGColor,bottom:CGColor){
        button.layer.cornerRadius = 10
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.colors = [topColor, bottom]
        gradientLayer.borderColor = button.layer.borderColor
        gradientLayer.borderWidth = button.layer.borderWidth
        gradientLayer.cornerRadius =  button.layer.cornerRadius
        button.layer.insertSublayer(gradientLayer, at: 0)
    }
    func getData(){
      var user_id = UserDefaults.standard.value(forKey: "user_id") as! String
        let url = Constant.baseURL + Constant.URIDefaultSearch + "\(user_id)"
        Alamofire.request(url, method:.get, parameters: nil,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
//                self.activityIndicator.stopAnimating()
//                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    if let datares = response.result.value as? [String:Any]{
                      
                        if let data  = datares["data"] as? [Dictionary<String,Any>]{
                          
                            
                            
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

    @objc func MenuButtonTapped() {
        print("Button Tapped")
        
    }
    //MARK:IBAction
    
    @IBAction func typeBtnAction(_ sender: Any) {
        typeView.isHidden = !typeView.isHidden
    }
    @IBAction func historicPlaceAction(_ sender: Any) {
    }
 
    @IBAction func hospitalBtnAction(_ sender: Any) {
    }
    @IBAction func IAMHUNGRYAction(_ sender: Any) {
    }
    
    @IBAction func INEEDHotelAction(_ sender: Any) {
    }
    
    @IBAction func segmentControlAction(_ sender: Any) {
    }
    
    @IBAction func nameBtnAction(_ sender: Any) {
        typeView.isHidden = true
        regionViewHeight.constant = 0
        regionSearchBar.isHidden = true
    }
    @IBAction func categoryBtnAction(_ sender: Any) {
         typeView.isHidden = true
        regionViewHeight.constant = 0
        regionSearchBar.isHidden = true
    }
    @IBAction func cityBtnAction(_ sender: Any) {
        regionViewHeight.constant = 72
        regionSearchBar.isHidden = false
         typeView.isHidden = true
    }
    
}
extension UserHomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offerList.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 125, height: 160)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserHomeOfferCollectionViewCell", for: indexPath)as? UserHomeOfferCollectionViewCell
        cell?.photo.image = offerList[indexPath.row].image
        cell?.caption.text  = offerList[indexPath.row].caption
        return cell!
    }
    
    
}

