//
//  MemberAdminCollectionViewCell.swift
//  Jome17Wave_iOS
//
//  Created by 洪展彬 on 2020/11/15.
//

import UIKit

class MemberAdminCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberIdLabel: UILabel!
    @IBOutlet weak var memberNameLabel: UILabel!
    
    var image: UIImage?
    
    override func prepareForReuse() {
        memberImage.image = nil
    }
}
