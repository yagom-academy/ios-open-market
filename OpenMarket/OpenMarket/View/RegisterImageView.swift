import UIKit

class RegisterImageView: UIView {
    //MARK: property
    let addIndicaterButton: UIButton = {
        var button = UIButton(type: .contactAdd)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let productEnrollImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray
        return imageView
    }()
    //MARK: Initalize
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutCollectionViewCell()
    }
    //MARK: Layout 
    private func layoutCollectionViewCell() {
        self.addSubview(productEnrollImageView)
        self.addSubview(addIndicaterButton)
        
        NSLayoutConstraint.activate([
            productEnrollImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            productEnrollImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            productEnrollImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            productEnrollImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addIndicaterButton.centerXAnchor.constraint(equalTo: productEnrollImageView.centerXAnchor),
            addIndicaterButton.centerYAnchor.constraint(equalTo: productEnrollImageView.centerYAnchor)
        ])
    }
}
