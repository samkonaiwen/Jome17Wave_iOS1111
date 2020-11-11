//
//  MapListTableViewCell.swift
//  Jome17Wave_iOS
//
//  Created by SAM on 2020/11/5.
//

import UIKit

class MapListTableViewCell: UITableViewCell {
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbSide: UILabel!
    @IBOutlet weak var ivMap: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
