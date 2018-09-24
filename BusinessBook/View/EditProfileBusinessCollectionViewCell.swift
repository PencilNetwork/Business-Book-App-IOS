//
//  EditProfileBusinessCollectionViewCell.swift
//  BusinessBook
//
//  Created by Mac on 9/9/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit
import Alamofire
class EditProfileBusinessCollectionViewCell: UICollectionViewCell {
    var index:Int?
    var changeImageDelegate:ChangeImageDelegate?
    var imageId:Int?
    @IBOutlet weak var photo: UIImageView!
    
    
    @IBAction func addBtnAction(_ sender: Any) {
        changeImageDelegate?.addImage(index: index!)
    }
    
    @IBAction func minBtnAction(_ sender: Any) {
        changeImageDelegate?.minusImage(index: index!,imageId:imageId!)
    }
    
   
}
