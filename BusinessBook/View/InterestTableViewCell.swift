//
//  InterestTableViewCell.swift
//  BusinessBook
//
//  Created by Mac on 9/20/18.
//  Copyright © 2018 pencil. All rights reserved.
//

import UIKit

class InterestTableViewCell: UITableViewCell {

    @IBOutlet weak var regionName: UILabel!
 
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var categName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
