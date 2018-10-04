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
    var bussines_id :Int?
    var searcher_id:Int?
    var name:String?
    init(image:String,favourite:Bool){
        self.image = image
        self.favourite = favourite
    }
    init(){
        
    }
}
