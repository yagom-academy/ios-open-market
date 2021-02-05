
import UIKit

class ListViewController: UIViewController {
    let tableView = UITableView()
    var productList = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OpenMarketAPIManager.shared.requestProductList(of: 7) { (result) in
            switch result {
            case .success (let product):
                self.productList.append(contentsOf: product.items)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        self.tableView.register(ProductListTableViewCell.self, forCellReuseIdentifier: ProductListTableViewCell.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let safeLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor)
        ])
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = productList[indexPath.row]
        let price = product.price
        let stock = product.stock
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductListTableViewCell.identifier, for: indexPath) as? ProductListTableViewCell else {
            debugPrint("CellError")
            return UITableViewCell()
        }
        cell.productNameLabel.text = product.title
        cell.productStockLabel.text = "잔여수량 : \(stock.addComma())"
        cell.productDiscountedPriceLabel.text = "\(product.currency) \(price.addComma())"
        
        if let discountedPrice = product.discountedPrice {
            let originalPriceText = "\(product.currency) \(price.addComma())"
            let attributeText = NSMutableAttributedString(string: originalPriceText)
            let range = originalPriceText.checkRange(of: originalPriceText)
            attributeText.addAttribute(.strikethroughStyle, value:1,  range: range)
            cell.productPriceLabel.attributedText = attributeText
            cell.productDiscountedPriceLabel.text = "\(product.currency) \((price - discountedPrice).addComma())"
        }
        
        cell.accessoryType = .disclosureIndicator
        
        if stock == 0 {
            cell.productStockLabel.text = "품절"
            cell.productStockLabel.textColor = .systemOrange
        }
        
        DispatchQueue.global().async {
            guard let imageURLText = product.thumbnails?.first, let imageURL = URL(string: imageURLText), let imageData: Data = try? Data(contentsOf: imageURL)  else {
                return
            }
            DispatchQueue.main.async {
                if let index: IndexPath = tableView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.productThumbnailImageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
        return cell
    }
}
extension String {
    func checkRange(of value : String) -> NSRange {
        let string : NSString = NSString(string: self)
        return string.range(of: value)
    }
}
