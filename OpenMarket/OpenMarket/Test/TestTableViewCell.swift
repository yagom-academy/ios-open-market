//
//  TestTableViewCell.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/02/02.
//

import UIKit

class TestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var testImage: UIImageView!
    
    override func prepareForReuse() {
        testImage.image = nil
    }
    
    func loadData(urlString: String) {
        ImageLoader.shared.load(urlString: urlString) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.testImage.image = UIImage(data: data)
                }
            case .failure(let error):
                debugPrint("❌")
            }
        }
    }
}
