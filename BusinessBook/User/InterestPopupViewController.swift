//
//  InterestPopupViewController.swift
//  Business
//
//  Created by jackleen emil on 9/17/18.
//  Copyright © 2018 jackleen emil. All rights reserved.
//

import UIKit
import Alamofire
protocol changecategDelegate{
    func changecheckBox(index:Int,flag:Bool)
     func changeCitycheckBox(index:Int,flag:Bool)
    func changeRegioncheckBox(index:Int,flag:Bool)
}
class InterestPopupViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,changecategDelegate,UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var chooseCategoryLBL: UILabel!
    
    @IBOutlet weak var chooseFavRegionLBL: UILabel!
    @IBOutlet weak var chooseFavouriteLBL: UILabel!
    @IBOutlet weak var categConstraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var citySearchBar: UISearchBar!
    
    @IBOutlet weak var regionSearchBar: UISearchBar!
    @IBOutlet weak var regionCollectionView: UICollectionView!
    @IBOutlet weak var cityCollectionView: UICollectionView!
    @IBOutlet weak var categCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var category:[Interest] = []
    var city :[Interest] = []
    var region:[Interest] = [Interest(name: "Fashion"),Interest(name: "food"),Interest(name: "Sport"),Interest(name: "Hospital"),Interest(name: "Medical"),Interest(name: "Restaurants"),Interest(name: "Toys"),Interest(name: "others"),Interest(name: "Bags"),Interest(name: "Cafes")]
    var filterData1:[Interest] = []
    var isSearching1 = false
    var filterData2:[Interest] = []
    var isSearching2 = false
    var filterData3:[Interest] = []
    var issearching3 = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
         self.navigationController?.isNavigationBarHidden = true
        
        setStyle()
         setTable()
   getCity()
        getCategory()
//        self.searchBar.layer.borderColor = UIColor.red.cgColor
//        self.searchBar.layer.borderWidth = 1
        styleSearchBar(searchBar:searchBar)
        styleSearchBar(searchBar:citySearchBar)
        styleSearchBar(searchBar:regionSearchBar)
        for subView in citySearchBar.subviews {

            for subViewOne in subView.subviews {

                if let textField = subViewOne as? UITextField {

                   // subViewOne.backgroundColor = UIColor.white

                    //use the code below if you want to change the color of placeholder
                    let textFieldInsideUISearchBarLabel = textField.value(forKey: "placeholderLabel") as? UILabel
                   
                    textFieldInsideUISearchBarLabel?.font = UIFont.systemFont(ofSize: 12.0)
                }
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//    override func viewWillLayoutSubviews() {
//        super.updateViewConstraints()
//        //         cerealsHeight.constant = cerealsTableView.contentSize.height
//        categConstraintHeight.constant = CGFloat(50 * (category.count/3))
//    }
    
    @IBAction func confirmbtnAction(_ sender: Any) {
    }
    //MARK: collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categCollectionView{
            if isSearching1 {
                return filterData1.count
            }
            return category.count
        }else if collectionView == cityCollectionView{
            if isSearching2 {
                return filterData2.count
            }
            return city.count
        }else{
            if issearching3 {
                return filterData3.count
            }
            return region.count 
        }
      
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categ", for: indexPath) as! InterestCollectionViewCell
           cell.index = indexPath.row
            cell.changecategDelegate = self
            if isSearching1 {
                cell.nameLBL.text = filterData1[indexPath.row].name
                
                cell.selectedCheckBox = filterData1[indexPath.row].checkbox
                
                if filterData1[indexPath.row].checkbox == false{
                    cell.checkBoxBtn.setImage(UIImage(named: "checkBox.png"), for: .normal)
                }else{
                    cell.checkBoxBtn.setImage(UIImage(named: "greenCheckbox.png"), for: .normal)
                }
            }else{
                cell.nameLBL.text = category[indexPath.row].name
                
                cell.selectedCheckBox = category[indexPath.row].checkbox
                
                if category[indexPath.row].checkbox == false{
                    cell.checkBoxBtn.setImage(UIImage(named: "checkBox.png"), for: .normal)
                }else{
                    cell.checkBoxBtn.setImage(UIImage(named: "greenCheckbox.png"), for: .normal)
                }
               
            }
            return cell
        }else if collectionView == cityCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "city", for: indexPath) as! InterestCollectionViewCell
            cell.index = indexPath.row
            cell.changecategDelegate = self
             if isSearching2 {
               cell.nameLBL.text = filterData2[indexPath.row].name
           
               cell.selectedCheckBox = filterData2[indexPath.row].checkbox
            
               if filterData2[indexPath.row].checkbox == false{
                cell.cityCheckBox.setImage(UIImage(named: "radioGray.png"), for: .normal)
              }else{
                cell.cityCheckBox.setImage(UIImage(named: "radioGreen.png"), for: .normal)
               }
             }else{
                cell.nameLBL.text = city[indexPath.row].name
                
                cell.selectedCheckBox = city[indexPath.row].checkbox
                
                if city[indexPath.row].checkbox == false{
                    cell.cityCheckBox.setImage(UIImage(named: "radioGray.png"), for: .normal)
                }else{
                    cell.cityCheckBox.setImage(UIImage(named: "radioGreen.png"), for: .normal)
                }
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "region", for: indexPath) as! InterestCollectionViewCell
              cell.index = indexPath.row
            cell.changecategDelegate = self
            if issearching3{
                cell.nameLBL.text = filterData3[indexPath.row].name
                
                cell.selectedCheckBox = filterData3[indexPath.row].checkbox
                
                if filterData3[indexPath.row].checkbox == false{
                    cell.regionCheckBox.setImage(UIImage(named: "checkBox.png"), for: .normal)
                }else{
                    cell.regionCheckBox.setImage(UIImage(named: "greenCheckbox.png"), for: .normal)
                }
            }else{
                cell.nameLBL.text = region[indexPath.row].name
                
                cell.selectedCheckBox = region[indexPath.row].checkbox
                
                if region[indexPath.row].checkbox == false{
                    cell.regionCheckBox.setImage(UIImage(named: "checkBox.png"), for: .normal)
                }else{
                    cell.regionCheckBox.setImage(UIImage(named: "greenCheckbox.png"), for: .normal)
                }
            }
           
            return cell
        }
        
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == cityCollectionView{
              return CGSize(width: view.frame.width/3 , height: 60)
        }
        
            return CGSize(width: view.frame.width/4 , height: 50)
        }
    //MARK: Delegate function
    func changecheckBox(index: Int, flag: Bool) {
        category[index].checkbox = flag
        categCollectionView.reloadData()
    }
    func changeCitycheckBox(index:Int,flag:Bool){
        city[index].checkbox = flag
        cityCollectionView.reloadData()
    }
    func changeRegioncheckBox(index:Int,flag:Bool){
        region[index].checkbox = flag
        regionCollectionView.reloadData()
    }
    //MARK:Function
    func getCategory(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
            var url = Constant.baseURL + Constant.URICateg
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
                                    var category = Interest()
                                    if let id = item["id"] as? Int {
                                        category.id = id
                                    }
                                    if let name = item["name"] as? String{
                                        category.name = name
                                    }
                                    self.category.append(category)
                                }
                              self.categCollectionView.reloadData()
                                self.categConstraintHeight.constant = CGFloat(50 * (self.category.count/3))
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
    func setTable(){

//
        categCollectionView.delegate = self
        categCollectionView.dataSource = self
        cityCollectionView.delegate = self
        cityCollectionView.dataSource = self
        regionCollectionView.delegate = self
        regionCollectionView.dataSource = self
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        citySearchBar.delegate = self
        citySearchBar.returnKeyType = UIReturnKeyType.done
        regionSearchBar.delegate = self
        regionSearchBar.returnKeyType = UIReturnKeyType.done
    }
    func styleSearchBar(searchBar:UISearchBar){
        for view in searchBar.subviews.last!.subviews {
            if type(of: view) == NSClassFromString("UISearchBarBackground"){
                view.alpha = 0.0
            }
        }
    }
    func setStyle(){
        chooseCategoryLBL.layer.masksToBounds = true
        chooseFavRegionLBL.layer.masksToBounds = true
        chooseFavouriteLBL.layer.masksToBounds = true
        chooseCategoryLBL.layer.cornerRadius = 5
        chooseFavouriteLBL.layer.cornerRadius = 5
        chooseFavRegionLBL.layer.cornerRadius = 5

    }
    func getCity(){
     
        let header: HTTPHeaders = [
           "X-Mashape-Key": "DaeEw2QYHHmshJn6SyKcjLvwtzHcp1bKHTkjsnh6ap7T73swhn",
            "Accept": "application/json"
        ]
     
        Alamofire.request("https://andruxnet-world-cities-v1.p.mashape.com/?query=Egypt&searchby=country", method:.get, parameters: nil,encoding: JSONEncoding.default, headers:header)
                    .responseJSON { response in
                        print("response\(response)")
                        if let data = response.result.value as? [[String:Any]]{
                            for item in data{
                            
                                if let citys = item["city"] as? String{
                                    self.city.append(Interest(name: citys))
                                }
                            }
                            self.cityCollectionView.reloadData()
                        }
                }
        
        
        

    }
    
}
extension InterestPopupViewController:UISearchBarDelegate{
   
    
    
    
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
          if searchBar == self.searchBar{
            
            if searchBar.text == nil || searchBar.text == "" {
                isSearching1 = false
                view.endEditing(true)
                categCollectionView.reloadData()
            }else{
               
                isSearching1 = true
                
                //  filterData = foodList.filter({$0.name == searchBar.text!})
                filterData1 = []
                for item in category {
                    
                    if let name = item.name {
                        
                        //  if (name.range(of: searchBar.text!) != nil){
                        if  name.range(of: searchBar.text!, options: .caseInsensitive) != nil {
                            print("found")
                            filterData1.append(item)
                        }else{
                            print("not found")
                        }
                    }
                    
                }
                categCollectionView.reloadData()
            }
          }else if searchBar == citySearchBar{
            if searchBar.text == nil || searchBar.text == "" {
                isSearching2 = false
                view.endEditing(true)
                cityCollectionView.reloadData()
            }else{
                isSearching2 = true
                
                
                filterData2 = []
                for item in city {
                    
                    if let name = item.name {
                        
                        
                        if  name.range(of: searchBar.text!, options: .caseInsensitive) != nil {
                            print("found")
                            filterData2.append(item)
                        }else{
                            print("not found")
                        }
                    }
                    
                }
                cityCollectionView.reloadData()
            }
            
          }else{ // region
            
            if searchBar.text == nil || searchBar.text == "" {
                issearching3 = false
                view.endEditing(true)
                regionCollectionView.reloadData()
            }else{
                issearching3 = true
             
                filterData3 = []
                for item in region {
                    
                    if let name = item.name {
                        if  name.range(of: searchBar.text!, options: .caseInsensitive) != nil {
                            print("found")
                            filterData3.append(item)
                        }else{
                            print("not found")
                        }
                    }
                    
                }
                regionCollectionView.reloadData()
            }
            
        }
    }
    
}
