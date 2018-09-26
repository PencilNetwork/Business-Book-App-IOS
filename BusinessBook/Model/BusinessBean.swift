//
//  BusinessBean.swift
//  BusinessBook
//
//  Created by Mac on 9/25/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import Foundation
class BusinessBean{
    var address:String?
    var average_Rating:String?
    var category:CategoryBean?
    var city:String?
    var contact_number:String?
    var description:String?
    var files:[RelatedFilesBean] = []
    var id:Int?
    var image:String?
    var lat:Double?
    var long:Double?
    var logo:String?
    var name:String?
    var offers:[OfferBean] = []
    var owner:OwnerBean?
    var region:String?
}
