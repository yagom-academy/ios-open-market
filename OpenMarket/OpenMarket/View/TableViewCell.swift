//
//  TableViewCell.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/20.
//

import UIKit

class TableViewCell: UITableViewCell {
    let containerStackView = UIStackView()
    let infoStackView = UIStackView()
    let priceStackView = UIStackView()
    let stockStackView = UIStackView()
    
    var productImageView = UIImageView()
    var productNameLabel = UILabel()
    var bargainPriceLabel = UILabel()
    var priceLabel = UILabel()
    var stockLabel = UILabel()
    var showDescriptionButton = UIButton()
    
    let imageWidth = CGFloat(75)
    let infoStackWidth = CGFloat(178)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCell()
    }
    
    func setUpCell() {
        contentView.addSubview(containerStackView)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 2),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 4)
        ] )
        containerStackView.clipsToBounds = true
        containerStackView.axis = .horizontal
        containerStackView.alignment = .fill
        containerStackView.distribution = .fill
        containerStackView.spacing = 5
                
        containerStackView.addArrangedSubview(productImageView)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            productImageView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: imageWidth)
        ] )
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        
        containerStackView.addArrangedSubview(infoStackView)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            infoStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: imageWidth + 10),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: imageWidth + infoStackWidth + 10)
        ] )
        infoStackView.clipsToBounds = true
        infoStackView.axis = .vertical
        infoStackView.alignment = .leading
        infoStackView.distribution = .fill
        infoStackView.spacing = 10
        
        infoStackView.addArrangedSubview(productNameLabel)
        
        infoStackView.addArrangedSubview(priceStackView)
        priceStackView.axis = .horizontal
        priceStackView.spacing = 5
        
        priceStackView.addArrangedSubview(bargainPriceLabel)
        priceStackView.addArrangedSubview(priceLabel)
        
        containerStackView.addArrangedSubview(stockStackView)
        stockStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            stockStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stockStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stockStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7)
        ] )
        stockStackView.axis = .horizontal
        stockStackView.alignment = .top
        stockStackView.distribution = .fill
        stockStackView.spacing = 7
        
        stockStackView.addArrangedSubview(stockLabel)
        
        stockStackView.addArrangedSubview(showDescriptionButton)
        showDescriptionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            showDescriptionButton.widthAnchor.constraint(equalToConstant: 18)
        ] )
    }
    
    func updateCell(data: ProductPreview) {
        productNameLabel.text = data.name
        productNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        productNameLabel.textAlignment = .left
        
        bargainPriceLabel.attributedText = ("\(data.currency) \(data.bargainPrice.addDemical())").strikeThroughStyle()
        bargainPriceLabel.textColor = .systemRed
        bargainPriceLabel.textAlignment = .left
        
        priceLabel.text = "\(data.price.addDemical())"
        priceLabel.textAlignment = .left
        
        switch data.stock {
        case 0:
            stockLabel.text = "품절"
            stockLabel.textColor = .systemOrange
            stockLabel.textAlignment = .right
        default:
            stockLabel.text = "잔여 수량: \(data.stock)"
            stockLabel.textAlignment = .right
        }
        
        showDescriptionButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        showDescriptionButton.titleLabel?.textAlignment = .right
        
        guard let url = URL(string: data.thumbnail) else {
            return
        }
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async {
                self.productImageView.image = UIImage(data: data)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
    }
    
    override func prepareForReuse() {
        
    }
}
