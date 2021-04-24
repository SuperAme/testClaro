//
//  MoviesTableViewCell.swift
//  testClaro
//
//  Created by IDS Comercial on 24/04/21.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var moviesImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
