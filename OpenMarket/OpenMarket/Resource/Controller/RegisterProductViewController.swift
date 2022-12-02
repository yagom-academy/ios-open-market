//
//  RegisterProductViewController.swift
//  OpenMarket
//
//  Created by baem, minii on 2022/12/02.
//

import UIKit

class RegisterProductViewController: UIViewController {
    var selectedImage = [UIImage?].init(repeating: nil, count: 5)
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            RegisterCollectionImageCell.self,
            forCellWithReuseIdentifier: RegisterCollectionImageCell.identifier
        )
        return collectionView
    }()
    
    
    let productNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "상품명"
        
        return textField
    }()
    
    let productPriceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "상품가격"
        
        return textField
    }()
    
    let discountPriceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "할인금액"
        
        return textField
    }()
    
    let stockTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "재고수량"
        
        return textField
    }()
    
    let currencySegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: Currency.allCases.map(\.rawValue))
        
        return segment
    }()
    
    let descriptionTextView: UITextView = {
        let textview = UITextView()
        textview.text = "국회는 국민의 보통·평등·직접·비밀선거에 의하여 선출된 국회의원으로 구성한다. 법률이 헌법에 위반되는 여부가 재판의 전제가 된 경우에는 법원은 헌법재판소에 제청하여 그 심판에 의하여 재판한다.\n\n법률은 특별한 규정이 없는 한 공포한 날로부터 20일을 경과함으로써 효력을 발생한다. 대통령은 헌법과 법률이 정하는 바에 의하여 국군을 통수한다. 헌법재판소 재판관은 정당에 가입하거나 정치에 관여할 수 없다."
        textview.font = .preferredFont(forTextStyle: .title3)
        
        return textview
    }()
    
    lazy var segmentStackview: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.addArrangedSubview(productPriceTextField)
        stackView.addArrangedSubview(currencySegment)
        stackView.spacing = 8
        currencySegment.widthAnchor.constraint(equalTo: productPriceTextField.widthAnchor, multiplier: 0.30).isActive = true
        
        return stackView
    }()
    
    lazy var totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        [
            productNameTextField,
            segmentStackview,
            discountPriceTextField,
            stockTextField
        ].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTappedDoneButton)
        )
        navigationController?.title = "상품등록"
        
        [collectionView, totalStackView, descriptionTextView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        view.addSubview(totalStackView)
        view.addSubview(descriptionTextView)
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.2),
            
            totalStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            totalStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            totalStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            
            descriptionTextView.topAnchor.constraint(equalTo: totalStackView.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            descriptionTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    @objc func didTappedDoneButton() {
        
    }
}

extension RegisterProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let filteredImage = selectedImage.filter { $0 != nil }
        
        if filteredImage.count < 5 {
            return filteredImage.count + 1
        }
        
        return filteredImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegisterCollectionImageCell.identifier, for: indexPath) as? RegisterCollectionImageCell else {
            return UICollectionViewCell()
        }
        
        let filteredImage = selectedImage.filter { $0 != nil }
        
        if indexPath.item == filteredImage.count {
            cell.configureButtonStyle()
        } else {
            cell.backgroundColor = .green
        }
        
        return cell
    }
}

extension RegisterProductViewController: UICollectionViewDelegateFlowLayout {
    
}

extension RegisterProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewSize = view.frame.size
        let contentWidth = viewSize.width / 3 - 10
        
        return CGSize(width: contentWidth, height: contentWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filteredImages = selectedImage.filter { $0 != nil }
        
        if filteredImages.count == 5 {
            return
        }
        
        if indexPath.item == filteredImages.count {
            selectedImage[indexPath.item] = UIImage(systemName: "applelogo")
            collectionView.reloadData()
        }
    }
}
