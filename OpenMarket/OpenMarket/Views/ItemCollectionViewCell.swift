import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    let itemNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "아이폰 12 mini"
        label.numberOfLines = 0
        return label
    }()

    
    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ItemCollectionViewCell {
    private func configureLayout() {
        addSubview(itemNameLabel)
        
        NSLayoutConstraint.activate([
            itemNameLabel.topAnchor.constraint(equalTo: topAnchor),
            itemNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            itemNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
