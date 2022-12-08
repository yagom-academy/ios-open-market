//
//  ItemInfomationViewController.swift
//  OpenMarket
//
//  Created by leewonseok on 2022/12/08.
//

import UIKit

class ItemInfomationViewController: UIViewController {
    var item: Item?
    var itemId: Int?
    var itemImages: [UIImage] = []
    var networkManager = NetworkManager()

    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.register(ItemImageCollectionViewCell.self, forCellWithReuseIdentifier: "ItemImageCollectionViewCell")
        return collectionView
    }()
    
    let testView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let itemlabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    let itemNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchItem()

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configureItemInfo() {
        guard let item else { return }
        itemNameLabel.text = item.name
        stockLabel.text = "\(item.stock)"
        priceLabel.text = "\(item.price)"
        discountedPriceLabel.text = "\(item.price - item.discountedPrice)"
        descriptionTextView.text = item.pageDescription
    }
    
    @objc func configureNavigation() {
        self.navigationItem.title = item?.name
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .action)
    }
    
    private func fetchItem() {
        guard let itemId = itemId else { return }
        
        LoadingController.showLoading()
        networkManager.fetchItem(productId: itemId) { result in
            LoadingController.hideLoading()

            switch result {
            case .success(let item):
                self.item = item
                
                DispatchQueue.main.async {
                    self.configureNavigation()
                    self.configureItemInfo()
                    self.abc()
                    self.configureImageValue()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.retryAlert()
                }
            }
        }
    }
    
    private func retryAlert() {
        let alert = UIAlertController(title: "통신 실패", message: "데이터를 받아오지 못했습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "다시 시도", style: .default, handler: { _ in
            self.fetchItem()
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .destructive, handler: { _ in
            self.dismiss(animated: false)
        }))
        self.present(alert, animated: false)
    }

    private func configureImageValue() {
        guard let images = item?.images else { return }

        images.forEach {
            guard let url = URL(string: $0.url) else { return }
            networkManager.fetchImage(url: url) { image in
                self.itemImages.append(image)
                print("testtest")
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}
extension ItemInfomationViewController {
    func abc() {
        self.testView.backgroundColor = .red
        self.view.addSubview(collectionView)
        self.view.addSubview(itemlabelStackView)
        self.view.addSubview(descriptionTextView)
        self.itemlabelStackView.addArrangedSubview(itemNameLabel)
        self.itemlabelStackView.addArrangedSubview(priceStackView)
        self.priceStackView.addArrangedSubview(stockLabel)
        self.priceStackView.addArrangedSubview(priceLabel)
        self.priceStackView.addArrangedSubview(discountedPriceLabel)
        
        NSLayoutConstraint.activate([
//            self.testView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
//            self.testView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 30),
//            self.testView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
//            self.testView.heightAnchor.constraint(equalTo: self.testView.widthAnchor),

            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),

//            self.itemlabelStackView.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor),
//            self.itemlabelStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            self.itemlabelStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            self.itemlabelStackView.heightAnchor.constraint(equalToConstant: 100),
//
//            self.descriptionTextView.topAnchor.constraint(equalTo: self.itemlabelStackView.bottomAnchor),
//            self.descriptionTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
//            self.descriptionTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            self.descriptionTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
}

extension ItemInfomationViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("\(itemImages.count)")
        return itemImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemImageCollectionViewCell", for: indexPath) as! ItemImageCollectionViewCell

        cell.imageView?.image = itemImages[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)

    }
}
