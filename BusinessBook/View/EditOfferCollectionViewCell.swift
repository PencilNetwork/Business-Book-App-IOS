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
    @IBOutlet weak var captionTxt: UITextField!
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var editOffer: UIButton!
    @IBAction func addBtn(_ sender: Any) {
        changeImageDelegate?.addImage(index: index!)
    }
    @IBAction func minBtn(_ sender: Any) {
        changeImageDelegate?.minusImage(index: index!, imageId: imageId!)
    }
    @IBAction func editOfferAction(_ sender: Any) {
        changeImageDelegate?.editOffer(index:index!,imageId:imageId!,caption:captionTxt.text!)
    }
    
}
