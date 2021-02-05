
import UIKit

class GridViewController: UIViewController {
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    var productList = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OpenMarketAPIManager.shared.requestProductList(of: 7) { (result) in
            switch result {
            case .success (let product):
                self.productList.append(contentsOf: product.items)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        setUpCollectionView()
    }
    private func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView.register(ProductGridViewCell.self, forCellWithReuseIdentifier: ProductGridViewCell.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        
        let safeLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor)
        ])
    }
}

extension GridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = productList[indexPath.row]
        let price = product.price
        let stock = product.stock
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductGridViewCell.identifier, for: indexPath) as? ProductGridViewCell else {
            debugPrint("CellError")
            return UICollectionViewCell()
        }
        cell.backgroundColor = .white
        cell.productNameLabel.text = product.title
        cell.productPriceLabel.text = "\(product.currency) \(price.addComma())"
        if let discountedPrice = product.discountedPrice {
            let attrRedStrikethroughStyle = [
                NSAttributedString.Key.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue)
            ]
            
            let text = NSAttributedString(string: "\(product.currency) \(price.addComma())", attributes: attrRedStrikethroughStyle)
            
            cell.productPriceLabel.attributedText = text
            cell.productPriceLabel.textColor = .red
            cell.productDiscountedPriceLabel.text = "\(product.currency) \(discountedPrice.addComma())"
            
        }
        cell.productStockLabel.text = "잔여수량 : \(stock.addComma())"
        if stock == 0 {
            cell.productStockLabel.text = "품절"
            cell.productStockLabel.textColor = .systemOrange
        }
        DispatchQueue.global().async {
            guard let imageURLText = product.thumbnails?.first, let imageURL = URL(string: imageURLText), let imageData: Data = try? Data(contentsOf: imageURL)  else {
                return
            }
            DispatchQueue.main.async {
                cell.productThumbnailImageView.image = UIImage(data: imageData)
            }
        }
        return cell
    }
}

extension GridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width - 30) / 2
        let height: CGFloat = width * 1.5
        return CGSize(width: width, height: height)
    }
}
