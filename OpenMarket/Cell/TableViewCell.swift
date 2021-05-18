//
//  TableViewCell.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/18.
//

import UIKit

protocol CellProtocol {
    func update<T: IndexPathProtocol>(data: ItemsOfPageReponse, indexPath: IndexPath, view: T)
}

protocol IndexPathProtocol {
    func indexPath(for cell: UITableViewCell) -> IndexPath?
    func indexPath(for cell: UICollectionViewCell) -> IndexPath?
}

class TableViewCell: UITableViewCell, CellProtocol {
    
    static let identifier = "TableViewCell"
    
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var itemPrice: UILabel!
    @IBOutlet var numberOfItemStock: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initCellProperty()
    }

    override func prepareForReuse() {
        initCellProperty()
    }

    func initCellProperty() {
        self.itemImage.image = UIImage(named: "indicator")
        self.itemTitle.text = ""
        self.numberOfItemStock.text = ""
        self.itemPrice.text = ""
    }
    
    func update<T>: IndexPathProtocol>(data: ItemsOfPageReponse, indexPath: IndexPath, view: T) {
        let itemIndex = indexPath.row % 20
        let imageURL = URL(string: data.items[itemIndex].thumbnails[0])
        do {
            let imageData = try Data(contentsOf: imageURL!)
            DispatchQueue.main.async {
                guard view.indexPath(for: self) == indexPath else { return }
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
