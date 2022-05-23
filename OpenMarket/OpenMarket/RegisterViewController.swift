//
//  RegisterViewController.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/23.
//

import UIKit

class RegisterViewController: UIViewController {
    var productImageView: UIImageView = UIImageView()
    
    lazy var mainStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return stackView
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
         stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
         return stackView
    }()
    
    var collectionView: UICollectionView = {
       let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        
        return collectionView
    }()
    
    let nameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.addPadding()
        return textField
    }()
    
    let priceField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품가격"
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.addPadding()
        return textField
    }()
    
    let currencyField: UISegmentedControl = UISegmentedControl(items: ["KRW", "USD"])
    let discountedPriceField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인가격"
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.addPadding()
        return textField
    }()
    let stockField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.addPadding()
        return textField
    }()
    let descriptionField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품설명"
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.contentVerticalAlignment = .top
        textField.addPadding()
        return textField
    }()
    
    var images:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView
            .register(ImageRegisterCell.classForCoder(), forCellWithReuseIdentifier: "imageCell")
        self.navigationItem.title = "상품등록"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.hidesBackButton = true
        let backbutton = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        backbutton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.preferredFont(for: .body, weight: .semibold)], for: .normal)
        self.navigationItem.leftBarButtonItem = backbutton
        
        // Sub View Structure
        priceStackView.addArrangedSubview(priceField)
        priceStackView.addArrangedSubview(currencyField)
        
        
        mainStackView.addArrangedSubview(collectionView)
        mainStackView.addArrangedSubview(nameField)
        mainStackView.addArrangedSubview(priceStackView)
        mainStackView.addArrangedSubview(discountedPriceField)
        mainStackView.addArrangedSubview(stockField)
        mainStackView.addArrangedSubview(descriptionField)
        
        self.view.addSubview(mainStackView)
        
        // Constraints
        mainStackView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        mainStackView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        mainStackView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor).isActive = true
        //mainStackView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        priceStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25).isActive = true
        nameField.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05).isActive = true
        nameField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        nameField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        
        priceStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        priceStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        
        priceField.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05).isActive = true
        discountedPriceField.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05).isActive = true
        stockField.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05).isActive = true
        currencyField.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.25).isActive = true
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
}

extension RegisterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width * 0.4, height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageRegisterCell else {
            return ImageRegisterCell()
        }
        
        return cell
    }
    
    
}

extension UITextField {
    func addPadding() {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = padding
        self.leftViewMode = ViewMode.always
    }
}
