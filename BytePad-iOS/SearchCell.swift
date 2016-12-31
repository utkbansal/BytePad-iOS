//
//  SearchCell.swift
//  BytePad-iOS
//
//  Created by Utkarsh Bansal on 31/12/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var examTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
