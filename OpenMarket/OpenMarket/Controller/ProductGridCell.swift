//  Created by Aejong, Tottale on 2022/11/22.

import UIKit

class ProductGridCell: UICollectionViewCell {
    static let identifier = "cell"

    let nameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.textAlignment = .right
        lb.numberOfLines = 0
        return lb
    }()

    let productImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func layout() {
        [productImage, nameLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        layer.masksToBounds = true
        layer.cornerRadius = 10

        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }

    func configCell(with product: Product) {
        
        self.productImage.image = urlToImage(product.thumbnail)
        

        let attrString = NSAttributedString(
            string: product.name,
            attributes: [
                NSAttributedString.Key.strokeColor: UIColor.black,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.strokeWidth: -2.0,
                NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 30)
            ]
        )

        nameLabel.attributedText = attrString
    }
    
    func urlToImage(_ urlString: String) -> UIImage? {
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return nil
        }
        
        return image
    }
}
