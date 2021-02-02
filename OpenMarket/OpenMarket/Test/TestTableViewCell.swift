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
//        onReuse()
        testImage.image = nil
        testImage.cancelImageLoad()
    }
    
//    func loadData(urlString: String) {
//        ImageLoader.shared.load(urlString: urlString) { result in
//            switch result {
//            case .success(let data):
//                DispatchQueue.main.async {
//                    self.testImage.image = UIImage(data: data)
//                }
//            case .failure(let error):
//                debugPrint("❌")
//            }
//        }
//    }
}
