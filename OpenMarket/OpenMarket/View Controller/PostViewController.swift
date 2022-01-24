//
//  PostViewController.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/21.
//

import UIKit

class PostViewController: UIViewController {
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var currencySelectButton: UISegmentedControl!
    @IBOutlet weak var bargainPriceTextField: UITextField!
    @IBOutlet weak var stockTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUpImageStack() {
        let addImageButton = UIButton()
        
        imageStackView.axis = .horizontal
        imageStackView.alignment = .leading
        imageStackView.distribution = .equalCentering
        imageStackView.spacing = 10
        
        imageStackView.addArrangedSubview(addImageButton)
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            addImageButton.widthAnchor.constraint(equalToConstant: 170),
            addImageButton.heightAnchor.constraint(equalToConstant: 170)
        ] )
        
        addImageButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addImageButton.titleLabel?.textAlignment = .center
        addImageButton.backgroundColor = .systemGray2
    }
}
