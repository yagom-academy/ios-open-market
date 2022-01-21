import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutCollectionViewCell()
    }
    
    lazy var addIndicater: UIButton = {
        var button = UIButton(type: .contactAdd)
        return button
    }()
    
    lazy var productEnrollImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .gray
        return imageView
    }()
    
//    lazy var imageStackView: UIStackView = {
//       var stackView = UIStackView(arrangedSubviews: [
//       productEnrollImageView,
//       addIndicater
//       ])
//        return stackView
//    }()
//
    private func layoutCollectionViewCell() {
        self.addSubview(addIndicater)
        self.addSubview(productEnrollImageView)
        
        addIndicater.translatesAutoresizingMaskIntoConstraints = false
        productEnrollImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productEnrollImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            productEnrollImageView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            productEnrollImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            productEnrollImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addIndicater.centerXAnchor.constraint(equalTo: productEnrollImageView.centerXAnchor),
            addIndicater.centerYAnchor.constraint(equalTo: productEnrollImageView.centerYAnchor)
        ])
    }
    
}
