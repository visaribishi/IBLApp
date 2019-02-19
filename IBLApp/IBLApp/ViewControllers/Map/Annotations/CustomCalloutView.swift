//
//  CustomCalloutView.swift
//  IBLApp
//
//  Created by Visar on 2/19/19.
//  Copyright © 2019 Visar. All rights reserved.
//

import UIKit

class CustomCalloutView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var details: Bank!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
