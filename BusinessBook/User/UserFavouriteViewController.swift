//
//  UserFavouriteViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/26/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Alamofire
protocol FavouriteDelegate{
    func changeFavourite(index:Int)
}
class UserFavouriteViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate,FavouriteDelegate{

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    var favouriteList:[FavouriteBean] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
         collectionView.delegate = self
        collectionView.dataSource = self
        getFavourite()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getFavourite(){
        favouriteList = []
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        var userId = UserDefaults.standard.value(forKey: "user_id") as? String
        let url = Constant.baseURL + Constant.URIStatusFavourite + userId!
        Alamofire.request(url , method:.get, parameters: nil,encoding: JSONEncoding.default, headers:nil)
            .responseJSON { response in
                print(response)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                switch response.result {
                case .success:
                    if let datares = response.result.value as? [String:Any]{
                        if let data = datares["data"] as? [Dictionary<String,
                            Any>]{
                            print(data)
                           for item in data{
                            var favourite = FavouriteBean()
                            if let id = item["id"] as? Int{
                                favourite.id = id
                            }
                            if let bussines_id = item["bussines_id"] as? Int{
                                favourite.bussines_id = bussines_id
                            }
                            if let searcher_id = item["searcher_id"] as? Int {
                                favourite.searcher_id = searcher_id
                            }
                            if let bussines_details = item["bussines_details"] as? Dictionary<String,Any>{
                                if let logo = bussines_details["logo"] as? String {
                                    favourite.image  = logo
                                }
                                if let name = bussines_details["name"] as? String{
                                    favourite.name = name
                                }
                            }
                            self.favouriteList.append(favourite)
                            }
                            self.collectionView.reloadData()
                        }else{
                            print("no favourite")
                        }
                    }else{
                          if let data = response.result.value as? [String:Any]{
                            if let flag = data["flag"] as? String {
                                if flag == "0"{
                                    let alert = UIAlertController(title: "", message: "fail", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
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
    //MARK:CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if favouriteList.count > 0{
            return favouriteList.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: (self.view.frame.width - 30)/2, height: 160)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserFavouriteCollectionViewCell", for: indexPath)as? UserFavouriteCollectionViewCell
        cell?.photo.sd_setImage(with: URL(string:favouriteList[indexPath.row].image!), placeholderImage: UIImage(named: "gallery.png"))
        cell?.index = indexPath.row
        cell?.favouriteDelegate = self
        cell?.name.text = favouriteList[indexPath.row].name!
        if favouriteList[indexPath.row].favourite == true {
            
        }
        return cell!
    }

    //MARK:FUNCTION
    func changeFavourite(index:Int){
        deleteFavourite(businesId:favouriteList[index].bussines_id!,index:index)
        
       
    }
    func deleteFavourite(businesId:Int,index:Int){
        var userId = UserDefaults.standard.value(forKey: "user_id") as? String
        //let url = Constant.baseURL + "favoirtes/ " + "\(userId!)/\(businesId) "
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
         let url = Constant.baseURL + Constant.URIDeleteFavourite + userId! + "/\(businesId)"
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
                                }else{
                                    self.favouriteList.remove(at: index)
                                    self.collectionView.reloadData()
                                    self.showToast(message: "success delete favourite")
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
}
