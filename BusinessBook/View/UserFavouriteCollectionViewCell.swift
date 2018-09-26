//
//  UserFavouriteCollectionViewCell.swift
//  BusinessBook
//
//  Created by Mac on 9/26/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class UserFavouriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var photo: UIImageView!
    var favouriteDelegate:FavouriteDelegate?
    var index:Int?
    @IBAction func favouriteBtnAction(_ sender: Any) {
       favouriteDelegate?.changeFavourite(index: index!)
    }
}
