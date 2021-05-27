//
//  ListVCCell.swift
//  OpenMarket
//
//  Created by 기원우 on 2021/05/19.
//

import UIKit

class ListVCCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var discountedPrice: UILabel!
    @IBOutlet weak var stock: UILabel!
    
    var item: Item?
    
    func setup() {
//        thumbnail.image = UIImage(named: item.thumbnails[0])
        title.text = "loading..."
        price.text = ""
        discountedPrice.text = ""
        stock.text = ""
    }
    
    func setupItem() {
        if let data: Item = self.item {
            thumbnail.downloadImage(from: data.thumbnails[0])
            title.text = data.title
            price.text = "\(data.price)"
            if let salePrice = data.discountedPrice {
                discountedPrice.text = "\(salePrice)"
            }
            stock.text = "\(data.stock)"
        } else {
            print("no item")
        }
    }
}

extension UIImageView {
   func getData(from url: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    guard let url = URL(string: url) else { return }
       URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
   }
    
   func downloadImage(from url: String) {
      getData(from: url) {
         data, response, error in
         guard let data = data, error == nil else {
            return
         }
         DispatchQueue.main.async() {
            self.image = UIImage(data: data)
         }
      }
   }
    
    
}

