//
//  OfferBean.swift
//  BusinessBook
//
//  Created by Mac on 9/6/18.
//  Copyright © 2018 pencil. All rights reserved.
//
import UIKit
import Foundation
class OfferBean{
    var bussines_id:Int?
    var photo:String?
    var image:UIImage?
    var caption:String?
    var id :Int?
    init(photo:String,caption:String,id:Int){
        self.photo = photo
        self.caption = caption
        self.id = id
    }
    init(){
        
    }
    init(image:UIImage,caption:String){
        self.image = image
        self.caption = caption
    }
}
