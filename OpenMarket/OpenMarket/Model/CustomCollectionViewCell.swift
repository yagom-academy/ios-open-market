//
//  CustomCollectionViewCell.swift
//  OpenMarket
//
//  Created by Mangdi, Woong on 2022/11/15.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bargainPrice: UILabel!
    @IBOutlet weak var stock: UILabel!
    
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.style = .medium
        return indicator
    }()
    var networkCommunication = NetworkCommunication()
    
    override func prepareForReuse() {
        networkCommunication.imageTask?.cancel()
        thumbnail.image = nil
        name.text = nil
        price.attributedText = nil
        price.text = nil
        bargainPrice.text = nil
        stock.text = nil
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
        
        thumbnail.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: thumbnail.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: thumbnail.centerYAnchor).isActive = true
        loadingIndicator.startAnimating()
        configureImage(imageSource: imageSource)
        
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
    
    func configureImage(imageSource: String) {
        let fileManager = FileManager()
        let imageCacheKey = NSString(string: imageSource)
        
        guard let imageUrl = URL(string: imageSource) else { return }
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else { return }
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent(imageUrl.lastPathComponent)
        
        if let imageCacheValue = ImageCacheManager.shared.object(forKey: imageCacheKey) {
            thumbnail.image = imageCacheValue
        } else if let loadedImageData = try? Data(contentsOf: filePath) {
            guard let image = UIImage(data: loadedImageData) else { return }
            ImageCacheManager.shared.setObject(image, forKey: imageCacheKey)
            thumbnail.image = image
        } else {
            networkCommunication.requestImageData(url: imageUrl) { [weak self] data in
                switch data {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.loadingIndicator.stopAnimating()
                        self?.loadingIndicator.removeFromSuperview()
                        self?.thumbnail.image = UIImage(data: data)
                    }
                    guard let image = UIImage(data: data) else { return }
                    ImageCacheManager.shared.setObject(image, forKey: imageCacheKey)
                    fileManager.createFile(atPath: filePath.path,
                                           contents: data,
                                           attributes: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
