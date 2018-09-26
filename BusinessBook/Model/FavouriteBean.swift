//
//  FavouriteBean.swift
//  BusinessBook
//
//  Created by Mac on 9/26/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import Foundation
class FavouriteBean{
    var id:Int?
    var image:String?
    var favourite:Bool?
    init(image:String,favourite:Bool){
        self.image = image
        self.favourite = favourite
    }
}
