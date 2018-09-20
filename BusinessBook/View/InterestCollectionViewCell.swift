//
//  InterestCollectionViewCell.swift
//  Business
//
//  Created by jackleen emil on 9/17/18.
//  Copyright © 2018 jackleen emil. All rights reserved.
//

import UIKit

class InterestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cityCheckBox: UIButton!
    @IBOutlet weak var checkBoxBtn: UIButton!
    
    @IBOutlet weak var regionCheckBox: UIButton!
    @IBOutlet weak var nameLBL: UILabel!
    var changecategDelegate:changecategDelegate?
    var index:Int?
    var selectedCheckBox:Bool?
    @IBAction func checkBoxAction(_ sender: Any) {
        selectedCheckBox = !selectedCheckBox!
        changecategDelegate?.changecheckBox(index: index!, flag: selectedCheckBox!)
    }
    
    @IBAction func cityCheckboxAction(_ sender: Any) {
        selectedCheckBox = !selectedCheckBox!
        changecategDelegate?.changeCitycheckBox(index: index!, flag: selectedCheckBox!)
    }
    
    @IBAction func regionCheckBoxAction(_ sender: Any) {
        selectedCheckBox = !selectedCheckBox!
        changecategDelegate?.changeRegioncheckBox(index: index!, flag: selectedCheckBox!)
        
    }
}
