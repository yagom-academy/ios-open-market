//
//  TableViewCell.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/18.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let identifier = "TableViewCell"
    
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var itemPrice: UILabel!
    @IBOutlet var numberOfItemStock: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(data: ItemsOfPageReponse, indexOfItems: Int) {
        
        let imageURL = URL(string: data.items[indexOfItems].thumbnails[0])
        do {
            let imageData = try Data(contentsOf: imageURL!)
            DispatchQueue.main.async {
                self.itemImage.image = UIImage(data: imageData)
                self.itemTitle.text = data.items[indexOfItems].title
                self.numberOfItemStock.text = String(data.items[indexOfItems].stock)
                self.itemPrice.text = data.items[indexOfItems].currency + " " + String(data.items[indexOfItems].price)
            }
            
        } catch {
            print("Invalid URL")
        }
    
    }
    
}
