//
//  TableViewCell.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/13.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var number: UILabel!
    
    @IBOutlet var image00: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpDataOfCell() {
        
    }
    override func prepareForReuse() {
    }
}
