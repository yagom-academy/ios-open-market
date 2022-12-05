//  Created by Aejong, Tottale on 2022/12/05.

import UIKit

class ImageAddButton: UIButton {
    
    let plusImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "plus")
        image.tintColor = .systemBlue
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        clipsToBounds = true
        self.backgroundColor = .systemGray4
        self.addSubview(plusImage)
        NSLayoutConstraint.activate([
            self.plusImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.plusImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.plusImage.widthAnchor.constraint(equalToConstant: 25),
            self.plusImage.heightAnchor.constraint(equalTo: self.plusImage.widthAnchor, multiplier: 1)
        ])
    }
}
