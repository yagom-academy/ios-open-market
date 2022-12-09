//
//  ProductManagingViewController.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/12/09.
//

import UIKit

protocol ProductManagingViewController: UIViewController {
    var navigationBarHeight: CGFloat { get set }
    var networkManager: NetworkManager { get }
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! { get set }
    var snapshot: NSDiffableDataSourceSnapshot<Int, Int> { get set }
    
    var backgroundScrollView: UIScrollView { get }
    var backView: UIView { get }
    var leftButton: UIBarButtonItem { get }
    var rightButton: UIBarButtonItem { get }
    var imageCollectionView: UICollectionView { get }
    var nameTextField: UITextField { get }
    var priceTextField: UITextField { get }
    var discountedPriceTextField: UITextField { get }
    var stockTextField: UITextField { get }
    var segmentedControl: UISegmentedControl { get }
    var priceStackView: UIStackView { get }
    var productStackView: UIStackView { get }
    var descriptionTextView: UITextView { get }
    
    func configureDelegate()
    func addTarget()
    func tapCancelButton()
    func tapDoneButton()
    func configureDataSource()
    func configureSnapshot()
    func setKeyboardDoneButton()
}

extension ProductManagingViewController {
    func configureNavigationBar(title: String) {
        navigationItem.title = title
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func showAlert(title: String? = nil, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            if let completion = completion {
                completion()
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func configureSubViews() {
        priceStackView.addArrangedSubview(priceTextField)
        priceStackView.addArrangedSubview(segmentedControl)
        [nameTextField, priceStackView, discountedPriceTextField, stockTextField].forEach {
            productStackView.addArrangedSubview($0)
        }
        view.addSubview(backgroundScrollView)
        backgroundScrollView.addSubview(backView)
        backView.addSubview(imageCollectionView)
        backView.addSubview(productStackView)
        backView.addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
            backgroundScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backView.topAnchor.constraint(equalTo: backgroundScrollView.contentLayoutGuide.topAnchor),
            backView.leadingAnchor.constraint(equalTo: backgroundScrollView.contentLayoutGuide.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: backgroundScrollView.contentLayoutGuide.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: backgroundScrollView.contentLayoutGuide.bottomAnchor),
            
            backView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            backView.widthAnchor.constraint(equalTo: backgroundScrollView.frameLayoutGuide.widthAnchor),
            
            imageCollectionView.topAnchor.constraint(equalTo: backView.topAnchor,
                                                     constant: 10),
            imageCollectionView.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
            imageCollectionView.heightAnchor.constraint(equalTo: backView.widthAnchor,
                                                        multiplier: 0.4),
            
            productStackView.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor,
                                                  constant: 10),
            productStackView.leadingAnchor.constraint(equalTo: backView.leadingAnchor,
                                                      constant: 10),
            productStackView.trailingAnchor.constraint(equalTo: backView.trailingAnchor,
                                                       constant: -10),
            segmentedControl.widthAnchor.constraint(equalToConstant: 90),
            
            descriptionTextView.topAnchor.constraint(equalTo: productStackView.bottomAnchor,
                                                     constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: backView.leadingAnchor,
                                                         constant: 10),
            descriptionTextView.trailingAnchor.constraint(equalTo: backView.trailingAnchor,
                                                          constant: -10),
            descriptionTextView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -10),
        ])
    }
}

extension ProductManagingViewController {
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let section: NSCollectionLayoutSection = {
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.4),
                    heightDimension: .fractionalHeight(1.0)
                ),
                subitem: item,
                count: 1
            )
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            
            return section
        }()
        section.orthogonalScrollingBehavior = .continuous
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureCollectionView() {
        imageCollectionView.collectionViewLayout = createCollectionViewLayout()
    }
    
    func addImageForCell(indexPath: IndexPath, image: UIImage) {
        guard let cell = imageCollectionView.cellForItem(at: indexPath) as? ImageCell else { return }
        cell.updateImage(image: image)
    }
    
    @discardableResult
    func checkCanRequest() -> Bool {
        if let nameCount = nameTextField.text?.count,
           !((3...100) ~= nameCount) {
            highlightTextBounds(nameTextField)
        } else {
            nameTextField.layer.borderWidth = .zero
        }
        
        if let textCount = descriptionTextView.text?.count,
           !((10...1000) ~= textCount) {
            highlightTextBounds(descriptionTextView)
        } else {
            descriptionTextView.layer.borderWidth = .zero
        }
        
        if let price = Double(priceTextField.text ?? ""),
           !price.isZero {
            priceTextField.layer.borderWidth = .zero
        } else {
            highlightTextBounds(priceTextField)
        }
        
        if let price = Double(priceTextField.text ?? ""),
           let discountPrice = Double(discountedPriceTextField.text ?? ""),
           discountPrice > price {
            highlightTextBounds(discountedPriceTextField)
        } else {
            discountedPriceTextField.layer.borderWidth = .zero
        }
        
        let components = [nameTextField, priceTextField, discountedPriceTextField, descriptionTextView]
        return components.filter { $0.layer.borderWidth == 0 }.count == 4
    }
    
    func highlightTextBounds(_ view: UIView) {
        let highlightedBorderWidth: CGFloat = 1.0
        let cornerRadius: CGFloat = 5
        
        view.layer.borderWidth = highlightedBorderWidth
        view.layer.borderColor = UIColor.systemRed.cgColor
        view.layer.cornerRadius = cornerRadius
    }
    
    func setNavigationBarHeight() {
        if navigationBarHeight.isZero {
            navigationBarHeight = -(backgroundScrollView.contentOffset.y)
        }
    }
}
