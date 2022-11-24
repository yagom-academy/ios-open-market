//
//  CustomCollectionViewCell.swift
//  OpenMarket
//
//  Created by 서현웅 on 2022/11/22.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bargainPrice: UILabel!
    @IBOutlet weak var stock: UILabel!
    
    let networkCommunication = NetworkCommunication()
    
    override func prepareForReuse() {
        self.thumbnail.image = nil
        self.name.text = nil
        self.price.attributedText = nil
        self.price.text = nil
        self.bargainPrice.text = nil
        self.stock.text = nil
    }
    
    func configureCell(imageSource: String,
                       name: String,
                       currency: Currency,
                       price: Double,
                       bargainPrice: Double,
                       stock: Int
    ) {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let fileManager = FileManager()
        
        guard let imageUrl = URL(string: imageSource) else { return }
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else { return }
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent(imageUrl.lastPathComponent)
        
        if fileManager.fileExists(atPath: filePath.path) != true {
            networkCommunication.requestImageData(url: imageUrl) { data in
                switch data {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.thumbnail.image = UIImage(data: data)
                    }
                    fileManager.createFile(atPath: filePath.path,
                                           contents: data,
                                           attributes: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            guard let loadedImageData = try? Data(contentsOf: filePath) else { return }
            self.thumbnail.image = UIImage(data: loadedImageData)
        }
        
        guard let priceText = numberFormatter.string(for: price),
              let bargainPriceText = numberFormatter.string(for: bargainPrice) else { return }
        
        self.name.text = name
        self.price.text = "\(currency) \(priceText)"
        
        if bargainPrice <= 0 || price <= bargainPrice {
            self.bargainPrice.text = ""
            self.price.textColor = UIColor.systemGray
        } else {
            guard let priceText = self.price.text else { return }
            let attributeText = NSMutableAttributedString(string: priceText)
            attributeText.addAttribute(.strikethroughStyle,
                                       value: NSUnderlineStyle.single.rawValue,
                                       range: NSMakeRange(0, attributeText.length))
            self.price.attributedText = attributeText
            self.bargainPrice.text = "\(currency) \(bargainPriceText)"
            self.price.textColor = UIColor.systemRed
        }
        
        if stock > 0 {
            self.stock.text = "잔여수량 : \(stock)"
            self.stock.textColor = UIColor.systemGray
        } else {
            self.stock.text = "품절"
            self.stock.textColor = UIColor.systemYellow
        }
    }
}
