//
//  MainTableCell.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 12/28/15.
//  Copyright © 2015 0x384c0. All rights reserved.
//

import UIKit

class MainTableCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: UI
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
}
