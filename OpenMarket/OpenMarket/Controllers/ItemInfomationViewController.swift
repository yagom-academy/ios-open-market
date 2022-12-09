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
        layout.scrollDirection = .horizontal
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonTapped))
    }
    
    @objc func actionButtonTapped() {
        let actionsheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        let editItemAction = UIAlertAction(title: "수정", style: .default) { action in
            let itemEditVC = ItemEditViewController()
            itemEditVC.itemId = self.itemId
            let itemEditNavVC = UINavigationController(rootViewController: itemEditVC)
            itemEditNavVC.modalPresentationStyle = .fullScreen
            itemEditNavVC.modalTransitionStyle = .crossDissolve
            self.present(itemEditNavVC, animated: false)
        }
        
        let deleteItemAction = UIAlertAction(title: "삭제", style: .destructive) { action in
            let alertController = UIAlertController(title: "비밀번호 입력", message: "암호", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "입력", style: .destructive) { action in
                guard let password = alertController.textFields?.first?.text,
                      let itemId = self.itemId else { return }
                LoadingController.showLoading()
                self.networkManager.deleteItem(productId: itemId, password: password) { result in
                    LoadingController.hideLoading()
                    switch result {
                    case .success(_):
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    case .failure(_):
                        let failAlert = UIAlertController(title: "오류", message: "삭제 실패", preferredStyle: .alert)
                        failAlert.addAction(UIAlertAction(title: "확인", style: .default) { action in
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                        })
                        DispatchQueue.main.async {
                            self.present(failAlert, animated: true)
                        }
                    }
                }
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            alertController.addTextField()
            
            self.present(alertController, animated: true)
        }
        
        actionsheetController.addAction(editItemAction)
        actionsheetController.addAction(deleteItemAction)
        actionsheetController.addAction(cancelAction)
        
        present(actionsheetController, animated: true)
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
        let group = DispatchGroup()
        
        LoadingController.showLoading()
        guard let images = item?.images else { return }
        
        images.forEach {
            group.enter()
            guard let url = URL(string: $0.url) else { return }
            networkManager.fetchImage(url: url) { image in
                self.itemImages.append(image)
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            LoadingController.hideLoading()
            self.collectionView.reloadData()
        }
    }
}
extension ItemInfomationViewController {
    func abc() {
        self.view.addSubview(collectionView)
        self.view.addSubview(itemlabelStackView)
        self.view.addSubview(descriptionTextView)
        self.itemlabelStackView.addArrangedSubview(itemNameLabel)
        self.itemlabelStackView.addArrangedSubview(priceStackView)
        self.priceStackView.addArrangedSubview(stockLabel)
        self.priceStackView.addArrangedSubview(priceLabel)
        self.priceStackView.addArrangedSubview(discountedPriceLabel)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
                                                          constant: -20),
            self.collectionView.heightAnchor.constraint(equalTo: self.collectionView.widthAnchor),
            
            self.itemlabelStackView.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor),
            self.itemlabelStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.itemlabelStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.itemlabelStackView.heightAnchor.constraint(equalToConstant: 100),
            
            self.descriptionTextView.topAnchor.constraint(equalTo: self.itemlabelStackView.bottomAnchor),
            self.descriptionTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            self.descriptionTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.descriptionTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
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
        
        cell.imageView.image = itemImages[indexPath.item]
        return cell
    }
}

extension ItemInfomationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 40, height: collectionView.frame.height)
    }
}
