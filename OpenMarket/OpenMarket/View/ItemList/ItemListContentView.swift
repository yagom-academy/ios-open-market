//
//  ItemContentView.swift
//  OpenMarket
//
//  Created by 윤재웅 on 2021/05/26.
//

import UIKit

@available(iOS 14.0, *)
class ItemListContentView: UIView, UIContentView, Contentable {
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var ItemImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var stock: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    
    var currentConfiguration: ItemConfiguration!
    var configuration: UIContentConfiguration {
        get {
            return currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? ItemConfiguration else { return }
            apply(newConfiguration)
        }
    }
    
    init(configuration: ItemConfiguration) {
        super.init(frame: .zero)
        loadNib()
        apply(configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@available(iOS 14.0, *)
extension ItemContentView {
    private func loadNib() {
        Bundle.main.loadNibNamed("\(ItemContentView.self)", owner: self, options: nil)
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
        ])
    }
    
    private func apply(_ configuration: ItemConfiguration) {
        guard currentConfiguration != configuration else { return }
        currentConfiguration = configuration
        fetchImage(configuration)
        cancelTextLine(configuration)
        setSoldOutText(configuration)
        self.title.text = configuration.title
    }
}
