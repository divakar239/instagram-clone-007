//
//  Cell.swift
//  ParseStarterProject-Swift
//
//  Created by Divakar Kapil on 2016-08-06.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {

    //MARK : IBOutlets
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var message: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
