//
//  EditOfferCollectionViewCell.swift
//  BusinessBook
//
//  Created by Mac on 9/9/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class EditOfferCollectionViewCell: UICollectionViewCell {
    var index:Int?
    var imageId:Int?
    var changeImageDelegate:ChangeImageDelegate?
   
    @IBOutlet weak var captionTxt: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    
    @IBAction func addBtn(_ sender: Any) {
        changeImageDelegate?.addImage(index: index!)
    }
    @IBAction func minBtn(_ sender: Any) {
        changeImageDelegate?.minusImage(index: index!, imageId: imageId!)
    }
    
    
}
