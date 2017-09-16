//
//  MovieCell.swift
//  MovieViewer
//
//  Created by Rajat Bhargava on 9/12/17.
//  Copyright © 2017 Rajat Bhargava. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var postView: UIImageView!
    @IBOutlet weak var lblBody: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
