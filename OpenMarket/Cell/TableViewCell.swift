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
        self.itemImage.image = UIImage(named: "indicator")
    }
    override func prepareForReuse() {
        self.itemImage.image = UIImage(named: "indicator")
        self.itemTitle.text = ""
        self.numberOfItemStock.text = ""
        self.itemPrice.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(data: ItemsOfPageReponse, indexPath: IndexPath, tableView: UITableView) {
        let itemIndex = indexPath.row % 20
        let imageURL = URL(string: data.items[itemIndex].thumbnails[0])
        do {
            let imageData = try Data(contentsOf: imageURL!)
            DispatchQueue.main.async {
                guard tableView.indexPath(for: self) == indexPath else { return }
                self.itemImage.image = UIImage(data: imageData)
                self.itemTitle.text = data.items[itemIndex].title
                self.numberOfItemStock.text = String(data.items[itemIndex].stock)
                self.itemPrice.text = data.items[itemIndex].currency + " " + String(data.items[itemIndex].price)
            }
            
        } catch {
            print("Invalid URL")
        }
    
    }
    
}
