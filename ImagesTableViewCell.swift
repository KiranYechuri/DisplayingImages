//
//  ImagesTableViewCell.swift
//  DisplayingImages
//
//  Created by Kiran Yechuri on 16/08/20.
//  Copyright © 2020 Kiran Yechuri. All rights reserved.
//

import UIKit

class ImagesTableViewCell: UITableViewCell {

    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var labelAuthorName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.displayImageView.contentMode = .scaleAspectFill
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
