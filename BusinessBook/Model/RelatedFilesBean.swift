//
//  RelatedFilesBean.swift
//  BusinessBook
//
//  Created by Mac on 9/18/18.
//  Copyright © 2018 pencil. All rights reserved.
//
import UIKit
import Foundation
class RelatedFilesBean{
    var bussines_id:Int?
    var id:Int?
    var image:String?
    var photo:UIImage?
    init(id:Int,image:String){
      self.id = id
      self.image = image
    }
    init(){
        
    }
}
