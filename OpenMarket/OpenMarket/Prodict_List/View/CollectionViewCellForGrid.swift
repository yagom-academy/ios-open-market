//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/06/09.
//

import UIKit

class CollectionViewCellForGrid: UICollectionViewCell {

    static let identifier = "gridCell"
    var item: Item!

    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.backgroundColor = .white

        return stackView
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage.init(named: "yagom")

        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    var productLabel: UILabel = {
        var textLabel = UILabel()
        textLabel.text = "야곰아카데미"
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        return textLabel
    }()

    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.backgroundColor = .white

        return stackView
    }()

    var discountedPriceLabel: UILabel = {
        var textLabel = UILabel()
        textLabel.text = "USD 1,000"
        textLabel.textColor = .lightGray
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        return textLabel
    }()

    var originalPriceLabel: UILabel = {
        var textLabel = UILabel()
        textLabel.text = "USD 2,000"
        textLabel.textColor = .lightGray
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        return textLabel
    }()

    var stockLabel: UILabel = {
        var textLabel = UILabel()

        textLabel.textColor = .orange
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        return textLabel
    }()

    func configure(indexPath: IndexPath) {
        
        let clientRequest = GETRequest(page: 1, id: 1, descriptionAboutMenu: .목록조회)
        let networkManager = NetworkManager<Items>(clientRequest: clientRequest, session: URLSession.shared)

        networkManager.getServerData(url: clientRequest.urlRequest.url!){ result in
            switch result {
            case .failure: return
            case .success(let data):
                DispatchQueue.global().async {
                    guard let image = try? Data(contentsOf: URL(string: data.items[indexPath.row].thumbnailURLs[0])!) else { return }

                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: image)
                        self.productLabel.text = data.items[indexPath.row].title
                        self.originalPriceLabel.text = "\(data.items[indexPath.row].currency) \(data.items[indexPath.row].price)"
                        
                        if data.items[indexPath.row].discountedPrice != nil {
                            self.discountedPriceLabel.text = "\(data.items[indexPath.row].currency) \(data.items[indexPath.row].discountedPrice!)"
                            self.originalPriceLabel.textColor = UIColor.systemRed
                            self.originalPriceLabel.attributedText = self.originalPriceLabel.text?.strikeThrough()
                        } else {
                            self.discountedPriceLabel.text = nil
                            self.discountedPriceLabel.isHidden = true
                        }

                        if data.items[indexPath.row].stock == 0 {
                            self.stockLabel.text = "품절"
                            self.stockLabel.textColor = .orange
                        } else if data.items[indexPath.row].stock > 99 {
                            self.stockLabel.text = "잔여수량: 99↑"
                            self.stockLabel.textColor = .systemGray2
                        } else {
                            self.stockLabel.text = "잔여수량: \(data.items[indexPath.row].stock)"
                            self.stockLabel.textColor = .systemGray2
                        }
                    }
                }
            }
        }

        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(mainStackView)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray2.cgColor
        self.layer.cornerRadius = 5

        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(productLabel)
        mainStackView.addArrangedSubview(priceStackView)
        mainStackView.addArrangedSubview(stockLabel)

        priceStackView.addArrangedSubview(originalPriceLabel)
        priceStackView.addArrangedSubview(discountedPriceLabel)

        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2),
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),

            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            priceStackView.heightAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.25)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.productLabel.text = "야곰 아카데미"
        self.imageView.image = UIImage(named: "yagom")
        self.discountedPriceLabel.text = ""
        self.stockLabel.text = "품절"
        discountedPriceLabel.isHidden = false
        originalPriceLabel.attributedText = nil
        originalPriceLabel.textColor = UIColor.systemGray2
    }
}
