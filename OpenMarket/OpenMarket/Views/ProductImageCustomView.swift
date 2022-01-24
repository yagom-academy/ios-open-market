import UIKit

class ProductImageCustomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
        let icon = UIImage(systemName: "minus.circle.fill")?.resizeImageTo(size: CGSize(width: 20, height: 20))
        button.setImage(icon, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.frame.width / 2
        button.addTarget(self, action: #selector(removeProductImageView), for: .touchUpInside)
        return button
    }()
    
    @objc func removeProductImageView() {
        self.removeFromSuperview()
        NotificationCenter.default.post(name: .imageRemoved, object: nil)
    }
    
    func fetchImage(with image: UIImage) {
        productImageView.image = image
    }
    
    func setDeleteButtonHidden(state: Bool) {
        deleteButton.isHidden = state
    }
    
    private func configUI() {
        [productImageView, deleteButton].forEach { view in
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            productImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            productImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            deleteButton.topAnchor.constraint(equalTo: self.topAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 20),
            deleteButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
