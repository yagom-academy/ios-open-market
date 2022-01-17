import UIKit

class ProductCellItem: Hashable {
    var title: NSAttributedString
    var price: NSAttributedString
    var stock: NSAttributedString
    var thumbnail: String
    var image: UIImage?
    let identifier = UUID()
    
    init(
        title: NSAttributedString,
        price: NSAttributedString,
        stock: NSAttributedString,
        thumbnail: String,
        image: UIImage? = nil
    ) {
        self.title = title
        self.price = price
        self.stock = stock
        self.thumbnail = thumbnail
        self.image = image
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: ProductCellItem, rhs: ProductCellItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
