//
//  ItemCell.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/06/14.
//

import UIKit

class ItemCell: UITableViewCell {
    
    
    @IBOutlet var itemName: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var stockAmount: UILabel!
    @IBOutlet var thumbnail: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
