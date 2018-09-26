//
//  UserFavouriteViewController.swift
//  BusinessBook
//
//  Created by Mac on 9/26/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
protocol FavouriteDelegate{
    func changeFavourite(index:Int)
}
class UserFavouriteViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate,FavouriteDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    var favouriteList:[FavouriteBean] = [FavouriteBean(image: "car3.png",favourite:true),FavouriteBean(image: "car4.png",favourite:true),FavouriteBean(image: "car5.png",favourite:true)]
    override func viewDidLoad() {
        super.viewDidLoad()
         collectionView.delegate = self
        collectionView.dataSource = self 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell?.photo.image = UIImage(named: favouriteList[indexPath.row].image!)
        cell?.index = indexPath.row
        cell?.favouriteDelegate = self 
        if favouriteList[indexPath.row].favourite == true {
            
        }
        return cell!
    }

    //MARK:FUNCTION
    func changeFavourite(index:Int){
        favouriteList.remove(at: index)
        collectionView.reloadData()
    }
   
}
