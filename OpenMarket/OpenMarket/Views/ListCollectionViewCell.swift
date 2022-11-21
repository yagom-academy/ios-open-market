//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by 스톤, 로빈 on 2022/11/21.
//

import UIKit

extension UIConfigurationStateCustomKey {
    static let item = UIConfigurationStateCustomKey("item")
}

extension UICellConfigurationState {
    var item: Item? {
        set { self[.item] = newValue }
        get { return self[.item] as? Item }
    }
}

class ListCollectionViewCell: UICollectionViewCell {
    private var item: Item?

       private func defaultListContentConfiguration() -> UIListContentConfiguration {
           return .sidebarSubtitleCell()
       }

       private lazy var itemListContentView = UIListContentView(configuration: defaultListContentConfiguration())

       private let stockLabel = UILabel()

       private var stockConstraints: (leading: NSLayoutConstraint, trailing: NSLayoutConstraint)?


       func updateWithItem(_ newItem: Item) {
           guard item != newItem else { return }
           item = newItem
           setNeedsUpdateConfiguration()
       }

       override var configurationState: UICellConfigurationState {
           var state = super.configurationState
           state.item = self.item
           return state
       }
   }

   extension ListCollectionViewCell {

       func setupViewsIfNeeded() {
           guard stockConstraints == nil else { return }
           contentView.addSubview(itemListContentView)
           contentView.addSubview(stockLabel)
           itemListContentView.translatesAutoresizingMaskIntoConstraints = false
           stockLabel.translatesAutoresizingMaskIntoConstraints = false

           let constraints = (leading:
                               stockLabel.leadingAnchor.constraint(greaterThanOrEqualTo: itemListContentView.trailingAnchor),
                              trailing:stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))

           NSLayoutConstraint.activate([
               itemListContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
               itemListContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
               itemListContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
               stockLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
               constraints.leading,
               constraints.trailing
           ])

           stockConstraints = constraints
       }
       override func updateConfiguration(using state: UICellConfigurationState) {
           setupViewsIfNeeded()

           guard let url = URL(string: state.item?.thumbnail ?? "") else { return }

           URLSession.shared.dataTask(with: url) { data, response, error in
               if let data = data {
                   DispatchQueue.main.async { [self] in
                       var content = defaultListContentConfiguration().updated(for: state)
                       content.image = UIImage(data: data)
                       content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
                       content.text = state.item?.name
                       content.textProperties.font = .preferredFont(forTextStyle: .headline)
                       content.secondaryText = "\(item!.currency.rawValue) \(item!.price)"

                       itemListContentView.configuration = content

                       stockLabel.text = "잔여 수량:\(state.item!.stock)"
                   }
               }
           }.resume()
       }

}
