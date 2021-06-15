//
//  CollectionViewCellForList.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/06/11.
//

import UIKit

class CollectionViewCellForList: UICollectionViewCell {

    static let identifier = "listCell"
    var item: Item!
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.backgroundColor = .white
        stackView.spacing = 5

        return stackView
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "yagom")

        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    let contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.backgroundColor = .white
        stackView.spacing = 5

        return stackView
    }()

    let productLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "야곰아카데미"
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        return textLabel
    }()

    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.backgroundColor = .white
        stackView.spacing = 5

        return stackView
    }()

    let discountedPriceLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "KRW 1,000"
        textLabel.textColor = .lightGray
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        return textLabel
    }()

    let originalPriceLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "USD 2,000"
        textLabel.textColor = .lightGray
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        return textLabel
    }()

    let stockLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "품절"
        textLabel.textColor = .orange
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        return textLabel
    }()
    
    let chevronButton: UIButton = {
        var button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .systemGray2
        
        return button
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

                    DispatchQueue.main.async { [self] in
                        self.imageView.image = UIImage(data: image)
                        
                        self.productLabel.text = data.items[indexPath.row].title
                        self.originalPriceLabel.text = "\(data.items[indexPath.row].currency) \(data.items[indexPath.row].price)"
                        
                        if data.items[indexPath.row].discountedPrice != nil {
                            self.discountedPriceLabel.text = "\(data.items[indexPath.row].currency) \(data.items[indexPath.row].discountedPrice!)"
                            self.originalPriceLabel.textColor = UIColor.systemRed
                            self.originalPriceLabel.attributedText = self.originalPriceLabel.text?.strikeThrough()
                        } else {
                            self.discountedPriceLabel.text = nil
                            discountedPriceLabel.isHidden = true
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

        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(contentsStackView)
        mainStackView.addArrangedSubview(stockLabel)
        mainStackView.addArrangedSubview(chevronButton)

        contentsStackView.addArrangedSubview(productLabel)
        contentsStackView.addArrangedSubview(priceStackView)

        priceStackView.addArrangedSubview(originalPriceLabel)
        priceStackView.addArrangedSubview(discountedPriceLabel)

        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2),
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),

            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.18),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.productLabel.text = "야곰 아카데미"
        self.imageView.image = UIImage(named: "yagom")
        self.originalPriceLabel.text = "USD 100"
        self.discountedPriceLabel.text = nil
        self.stockLabel.text = "품절"
    }
}
