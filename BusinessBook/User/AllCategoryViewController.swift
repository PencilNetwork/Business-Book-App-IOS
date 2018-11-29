//
//  AllCategoryViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/26/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
class AllCategoryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    var categoryList:[CategoryBean] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        activityIndicator.isHidden = true
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        getCategory()
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//     //   layout.sectionInset = UIEdgeInsets(top: 20, left: 5, bottom: 10, right: 0)
//    //    layout.itemSize = CGSize(width: view.frame.width/3, height: 150)
//        layout.minimumInteritemSpacing = 1
//        layout.minimumLineSpacing = 1
//        collectionView!.collectionViewLayout = layout
        // Do any additional setup after loading the view.
        let lang = UserDefaults.standard.value(forKey: "lang") as!String
        if lang == "ar" {
            collectionView.semanticContentAttribute = .forceRightToLeft
        }else{
            collectionView.semanticContentAttribute = .forceLeftToRight
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getCategoryDataBaseIOS(){
        if #available(iOS 10.0, *) {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appdelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Category")
            request.returnsObjectsAsFaults = false // to return data as way as you saved it
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject]{
                            var category = CategoryBean()
                        if let name = result.value(forKey: "name") as? String {
                            print("name:\(name)")
                            category.name = name
                        }
                        if let id = result.value(forKey: "id") as? Int {
                            
                            category.id =  id
                        }
                        
                        self.categoryList.append(category)
                    }
                      self.collectionView.reloadData()
                }
               
            }catch{
                print("error to retrieve category ")
            }
        }else{
            
            let context = Storage.shared.context
            let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Category")
            request.returnsObjectsAsFaults = false // to return data as way as you saved it
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    
                    
                    for result in results as! [NSManagedObject]{
                            var category = CategoryBean()
                        if let name = result.value(forKey: "name") as? String {
                            print("name:\(name)")
                            category.name = name
                        }
                        if let id = result.value(forKey: "id") as? Int {
                            
                            category.id =  id
                        }
                        
                        self.categoryList.append(category)
                    }
                    self.collectionView.reloadData()
                }
               
            }catch{
                print("error to retrieve category ")
            }
        }
    }
    func getCategory(){
        categoryList = []
        if UserDefaults.standard.value(forKey: "StoreCategory") as? Bool == true  { // sql
            getCategoryDataBaseIOS()
            
        }else {
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
                               self.collectionView.reloadData()
                                
                            }
                            
                        }
                    case .failure(let error):
                        print(error)
                        
                        self.networkFail()
                        
                    }
            }
        }else{
            
           networkNotFound()
        }
    }
    }
    func networkFail(){
        let lang = UserDefaults.standard.value(forKey: "lang") as!String
        if lang == "ar" {
            let alert = UIAlertController(title: "", message: "خطأ في الشبكة" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "", message: "Network fail" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func networkNotFound(){
        let lang = UserDefaults.standard.value(forKey: "lang") as!String
        if lang == "ar" {
            let alert = UIAlertController(title: "تحذير", message:"لا يوجد شبكة", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    //MARK:COllectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categoryList.count > 0{
            return categoryList.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let captionTextWidth = ((view.frame.width - 10)/4)
        let size = CGSize(width:captionTextWidth,height:1000)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize:15)]
        if categoryList[indexPath.row].name != "" && categoryList[indexPath.row].name != nil {
            let estimateFrame = NSString(string: categoryList[indexPath.row].name!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            let height  = estimateFrame.height + 20
            return CGSize(width: (view.frame.width - 10 )/4 , height: height)
        }else{
            let estimateFrame = NSString(string: "").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            let height  = estimateFrame.height + 10
            //  return CGSize(width: 133, height: height)
            return CGSize(width: (view.frame.width - 10)/4 , height: height)
        }
    //    return CGSize(width: (view.frame.width - 15)/4, height: 150)
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllCategoryCollectionViewCell", for: indexPath) as! AllCategoryCollectionViewCell
      cell.name.text = categoryList[indexPath.row].name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserHomeViewController") as! UserHomeViewController
        vc.searchCategory = true
        vc.ShortCutCategory = true 
        vc.categoryId = categoryList[indexPath.row].id!
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
    }
}
