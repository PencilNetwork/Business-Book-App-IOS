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
    
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
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
    var region:[RegionBean] = []
    var filterData1:[Interest] = []
    var isSearching1 = false
    var filterData2:[Interest] = []
    var isSearching2 = false
    var filterData3:[RegionBean] = []
    var issearching3 = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
         self.navigationController?.isNavigationBarHidden = true
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        setStyle()
         setTable()
   getCity()
        getCategory()
        hideKeyboardWhenTappedAround()
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
        let lang = UserDefaults.standard.value(forKey: "lang") as!String
        if lang == "ar" {
            searchBar.semanticContentAttribute = .forceRightToLeft
            citySearchBar.semanticContentAttribute = .forceRightToLeft
            regionSearchBar.semanticContentAttribute = .forceRightToLeft
            containerView.semanticContentAttribute = .forceRightToLeft
            searchBar.placeholder = "searchForCategory".localized(lang: "ar")
            citySearchBar.placeholder = "searchFavouriteCity".localized(lang: "ar")
            regionSearchBar.placeholder = "searchForRegion".localized(lang: "ar")
            categCollectionView.semanticContentAttribute = .forceRightToLeft
            cityCollectionView.semanticContentAttribute = .forceRightToLeft
            regionCollectionView.semanticContentAttribute = .forceRightToLeft
            confirmBtn.setTitle("confirm".localized(lang: "ar"), for: .normal)
        }else{
            containerView.semanticContentAttribute = .forceLeftToRight
            categCollectionView.semanticContentAttribute = .forceLeftToRight
            cityCollectionView.semanticContentAttribute = .forceLeftToRight
            regionCollectionView.semanticContentAttribute = .forceLeftToRight
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//    override func viewWillLayoutSubviews() {
//        super.updateViewConstraints()

//    }
    //MARK:IBAction
    @IBAction func confirmbtnAction(_ sender: Any) {
        sendData()
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
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let lang = UserDefaults.standard.value(forKey: "lang") as!String
        if collectionView == categCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categ", for: indexPath) as! InterestCollectionViewCell
           cell.index = indexPath.row
            cell.changecategDelegate = self
            if lang == "ar" {
                cell.nameLBL.textAlignment = .right
            }else{
                cell.nameLBL.textAlignment = .left
            }
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
            if lang == "ar" {
                cell.nameLBL.textAlignment = .right
            }else{
                cell.nameLBL.textAlignment = .left
            }
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
            if lang == "ar" {
                cell.nameLBL.textAlignment = .right
            }else{
                cell.nameLBL.textAlignment = .left
            }
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
            let captionTextWidth = ((view.frame.width - 40 )/2)
            let size = CGSize(width:captionTextWidth,height:1000)
            let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize:15)]
            if city[indexPath.row].name != "" && city[indexPath.row].name != nil {
                let estimateFrame = NSString(string: city[indexPath.row].name!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                let height  = estimateFrame.height + 20
                return CGSize(width: (view.frame.width - 10 )/2 , height: height)
            }else{
                let estimateFrame = NSString(string: "").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                let height  = estimateFrame.height + 30
                //  return CGSize(width: 133, height: height)
                return CGSize(width: (view.frame.width - 10)/3 , height: height)
            }
//              return CGSize(width: view.frame.width/3 , height: 60)
        }else if collectionView == regionCollectionView {
            let captionTextWidth = ((view.frame.width - 40 )/3)
            let size = CGSize(width:captionTextWidth,height:1000)
            let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize:15)]
            if region[indexPath.row].name != "" && region[indexPath.row].name != nil {
                let estimateFrame = NSString(string: region[indexPath.row].name!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                let height  = estimateFrame.height + 20
                return CGSize(width: (view.frame.width - 10 )/3 , height: height)
            }else{
                let estimateFrame = NSString(string: "").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                let height  = estimateFrame.height + 30
                //  return CGSize(width: 133, height: height)
                return CGSize(width: (view.frame.width - 10)/3 , height: height)
            }
            
        }else{
            let captionTextWidth = ((view.frame.width - 40 )/3)
            let size = CGSize(width:captionTextWidth,height:1000)
            let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize:15)]
            if category[indexPath.row].name != "" && category[indexPath.row].name != nil {
                let estimateFrame = NSString(string: category[indexPath.row].name!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                let height  = estimateFrame.height + 20
                return CGSize(width: (view.frame.width - 10 )/3 , height: height)
            }else{
                let estimateFrame = NSString(string: "").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                let height  = estimateFrame.height + 30
                //  return CGSize(width: 133, height: height)
                return CGSize(width: (view.frame.width - 10)/3 , height: height)
            }
        }
        
          
        }
    //MARK: Delegate function
    func changecheckBox(index: Int, flag: Bool) { //category
          var countcateg = 0
        if isSearching1{
            if flag == true {
                for item in filterData1{
                    if item.checkbox == true{
                        countcateg = countcateg + 1
                    }
                }
                if countcateg >= 7 {
                    let alert = UIAlertController(title: "", message: "Maxium number of selected category 7 " , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    filterData1[index].checkbox = flag
                }
                categCollectionView.reloadData()
            }else{ // false
                
                filterData1[index].checkbox = flag
                categCollectionView.reloadData()
            }
            
        }else{
            if flag == true {
                for item in category{
                    if item.checkbox == true{
                        countcateg = countcateg + 1
                    }
                }
                if countcateg >= 7 {
                    let alert = UIAlertController(title: "", message: "Maxium number of selected category 7 " , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    category[index].checkbox = flag
                }
                categCollectionView.reloadData()
            }else{ // false
                
                category[index].checkbox = flag
                categCollectionView.reloadData()
            }
        }
       
    }
    
    func changeCitycheckBox(index:Int,flag:Bool){
        if isSearching2 {
            filterData2[index].checkbox = flag
            for i in 0..<filterData2.count {
                if i != index {
                    if flag == true {
                        filterData2[i].checkbox = false
                    }
                }
            }
            if flag == true {
                getRegion(cityId:filterData2[index].id!)
            }
            cityCollectionView.reloadData()
        }else{
            city[index].checkbox = flag
            for i in 0..<city.count {
                if i != index {
                    if flag == true {
                        city[i].checkbox = false
                    }
                }
            }
            if flag == true {
                getRegion(cityId:city[index].id!)
            }
            cityCollectionView.reloadData()
        }
      
    }
    func changeRegioncheckBox(index:Int,flag:Bool){
        var countRegion = 0
        if issearching3 {
            if flag == true {
                for item in filterData3{
                    if item.checkbox == true {
                        countRegion = countRegion + 1
                    }
                }
                if countRegion >= 3{
                    let alert = UIAlertController(title: "", message: "Maxium number of selected Region 3" , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    filterData3[index].checkbox = flag
                }
                regionCollectionView.reloadData()
            }else{
                filterData3[index].checkbox = flag
                regionCollectionView.reloadData()
            }
        }else{
            if flag == true {
                for item in region{
                    if item.checkbox == true {
                        countRegion = countRegion + 1
                    }
                }
                if countRegion >= 3{
                    let alert = UIAlertController(title: "", message: "Maxium number of selected Region 3" , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    region[index].checkbox = flag
                }
                regionCollectionView.reloadData()
            }else{
                region[index].checkbox = flag
                regionCollectionView.reloadData()
            }
        }
       
    }
    //MARK:Function
    func sendCondition()->Bool {
        var validFlag = true
        var countcateg = 0
         if isSearching1 {
            for item in filterData1{
                if item.checkbox == true{
                    countcateg = countcateg + 1
                }
            }
         }else{
            for item in category{
                if item.checkbox == true{
                    countcateg = countcateg + 1
                }
            }
        }
       
        if countcateg > 0 && countcateg <= 7 {
        }else{
            validFlag = false
            if countcateg == 0 {
             let alert = UIAlertController(title: "", message: "Select your category" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
           }else{ //> 7
             let alert = UIAlertController(title: "", message: "Maxium number of selected category 7 " , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
          }
    
      }
        //city
        var countCity = 0
        if isSearching2{
            for item  in filterData2{
                if item.checkbox == true{
                    countCity = countCity + 1
                }
            }
        }else{
            for item  in city{
                if item.checkbox == true{
                    countCity = countCity + 1
                }
            }
        }
        
        if countCity == 0 || countCity > 1{
            validFlag = false
            if countCity == 0 {
                let alert = UIAlertController(title: "", message: "Select your city " , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "", message: "Maxium number of selected City 1 " , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
          
        }
        
        //region
        var countRegion = 0
         if issearching3 {
            for item in filterData3{
                if item.checkbox == true {
                    countRegion = countRegion + 1
                }
            }
         }else{
            for item in region{
                if item.checkbox == true {
                    countRegion = countRegion + 1
                }
            }
        }
        
        if countRegion == 0 || countRegion > 3 {
            validFlag = false
            if countRegion == 0{
                let alert = UIAlertController(title: "", message: "Select your Region " , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "", message: "Maxium number of selected Region 3 " , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        return validFlag
    }
    func sendData(){
        let valid = sendCondition()
        if valid == true {
          activityIndicator.isHidden = false
          activityIndicator.startAnimating()
          let network = Network()
          let networkExist = network.isConnectedToNetwork()
            let user_id = UserDefaults.standard.value(forKey: "user_id") as? String
          var parameter :[String:AnyObject] = [String:AnyObject]()
        parameter["searcher_id"] = user_id as? AnyObject
            var selectedCity :Int = -1
            if isSearching2 {
                for item in filterData2{
                    if item.checkbox == true {
                        selectedCity = item.id!
                    }
                }
            }else{
                for item in city{
                    if item.checkbox == true {
                        selectedCity = item.id!
                    }
                }
            }
        parameter["city_id"] = "\(selectedCity)" as? AnyObject
            var categString = ""
//             if isSearching1 {
//                for i in 0..<filterData1.count{
//                    if filterData1[i].checkbox == true{
//                        if categString == ""{
//                            categString = categString + "\(filterData1[i].id!)"
//
//                        }else{
//                            categString = categString + "," + "\(filterData1[i].id!)"
//                        }
//
//                    }
//                }
//
//             }else{
                for i in 0..<category.count{
                     if category[i].checkbox == true{
                          if categString == ""{
                            categString = categString + "\(category[i].id!)"
                        }else{
                            categString = categString + "," + "\(category[i].id!)"
                        }
                        
                    }
                }
           // }
            print("categString\(categString)")
        parameter["categories_ids"] = categString as? AnyObject
            var regionString = ""
//            if issearching3 {
//                for i in 0..<filterData3.count{
//                    if filterData3[i].checkbox == true {
//                        if regionString == "" {
//                            regionString = regionString +  "\(filterData3[i].id!)"
//                        }else{
//                            regionString = regionString + "," +  "\(filterData3[i].id!)"
//                        }
//                    }
//                }
//            }else{
                for i in 0..<region.count{
                    if region[i].checkbox == true {
                        if  regionString == "" {
                            regionString = regionString +  "\(region[i].id!)"
                        }else{
                            regionString = regionString  + "," +  "\(region[i].id!)"
                        }
                    }
                }
          //  }
            print("regionString\(regionString)")
            parameter["regoins_ids"] = regionString as AnyObject
        if networkExist == true {
            let url = Constant.baseURL + Constant.URIInterests
            Alamofire.request(url, method:.post, parameters: parameter,encoding: JSONEncoding.default, headers:nil)
                .responseJSON { response in
                    print(response)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    switch response.result {
                    case .success:
                        if let datares = response.result.value as? [String:Any]{
                            if let flag = datares["flag"] as? String{
                                if flag == "1"{
                                    UserDefaults.standard.set(true,forKey:"interest")
                                     self.view.removeFromSuperview()
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserLeftMenuVC") as? UserLeftMenuVC
                                    self.navigationController?.pushViewController(vc!, animated: true)
                                }else{
                                    UserDefaults.standard.set(false,forKey:"interest")
                                    let alert = UIAlertController(title: "", message: " fail" , preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
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
        }else{
            
            let alert = UIAlertController(title: "Warning", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        }
    }
    func getCategory(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
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
//                                self.categConstraintHeight.constant = CGFloat(50 * (self.category.count/3))
//                                self.categConstraintHeight.constant = self.categCollectionView.collectionViewLayout.collectionViewContentSize.height
//                                self.view.setNeedsLayout()
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
//        chooseCategoryLBL.layer.masksToBounds = true
//        chooseFavRegionLBL.layer.masksToBounds = true
//        chooseFavouriteLBL.layer.masksToBounds = true
//        chooseCategoryLBL.layer.cornerRadius = 5
//        chooseFavouriteLBL.layer.cornerRadius = 5
//        chooseFavRegionLBL.layer.cornerRadius = 5

    }
    func getCity(){
        
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
                                self.city.append(city)
                            }
                            self.cityCollectionView.reloadData()
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
    func getRegion(cityId:Int){
        region = []
       
        let network = Network()
        let networkExist = network.isConnectedToNetwork()
        
        if networkExist == true {
            
            if city.count > 0  {
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
                                    let regio = RegionBean()
                                    if let id = item["id"] as? Int {
                                        regio.id = id
                                    }
                                    if let name = item["name"] as? String{
                                        regio.name = name
                                    }
                                    if let cityId = item["city_id"] as? Int{
                                        regio.cityId = cityId
                                    }
                                    self.region.append(regio)
                                }
                               
                                self.regionCollectionView.reloadData()
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
}
extension InterestPopupViewController:UISearchBarDelegate{
   
    
    
    
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
          if searchBar == self.searchBar{
            
            if searchBar.text == nil || searchBar.text == "" {
                isSearching1 = false
//                for item in category{
//                    item.checkbox = false
//                }
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
                for item in city{
                    item.checkbox = false
                }
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
//                for item in region {
//                    item.checkbox = false
//                }
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
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
