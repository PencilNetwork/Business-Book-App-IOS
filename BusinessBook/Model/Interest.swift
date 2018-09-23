//
//  Interest.swift
//  Business
//
//  Created by jackleen emil on 9/17/18.
//  Copyright © 2018 jackleen emil. All rights reserved.
//

import Foundation
class Interest{
    var name:String?
    var checkbox:Bool = false
    var id :Int?
    init(name:String){
        self.name = name 
        
    }
    init(){
        
    }
    init(name:String,id:Int){
     self.name = name
        self.id = id
    }
}
