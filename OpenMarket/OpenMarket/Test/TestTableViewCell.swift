//
//  TestTableViewCell.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/02/02.
//

import UIKit

class TestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var testImage: UIImageView!
    var onReuse: () -> Void = {}
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onReuse()
        testImage.image = nil
    }
}
