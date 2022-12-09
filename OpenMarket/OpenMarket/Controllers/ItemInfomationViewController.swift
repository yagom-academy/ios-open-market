//
//  ItemInfomationViewController.swift
//  OpenMarket
//
//  Created by leewonseok on 2022/12/08.
//

import UIKit

final class ItemInfomationViewController: UIViewController {
    // MARK: Properties
    var item: Item?
    var itemId: Int?
    var itemImages: [UIImage] = []
    let networkManager = NetworkManager()
    
    private let collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.register(ItemImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: ItemImageCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let imageIndexLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let itemlabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let rightSideLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let priceLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .systemGray
        return label
    }()
    
    private let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .systemRed
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        return textView
    }()

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchItem()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: Methods
extension ItemInfomationViewController {
    private func configureItemInfo() {
        guard let item else { return }
        itemNameLabel.text = item.name
        descriptionTextView.text = item.pageDescription

        if item.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemYellow
        } else {
            stockLabel.text = "남은 수량 : \(item.stock)"
            stockLabel.textColor = .systemGray
        }

        if item.discountedPrice > 0 {
            priceLabel.attributedText = "\(item.currency.rawValue) \(item.price.formattedString!)".strikeThrough()
            bargainPriceLabel.text = "\(item.currency.rawValue) \(item.bargainPrice.formattedString!)"
        } else {
            bargainPriceLabel.text = "\(item.currency.rawValue) \(item.price.formattedString!)"
        }
    }

    @objc private func configureNavigationItem() {
        self.navigationItem.title = item?.name
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonTapped))
    }

    @objc private func actionButtonTapped() {
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
                    self.configureView()
                    self.configureNavigationItem()
                    self.configureItemInfo()
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
            self.imageIndexLabel.text = "1/\(self.itemImages.count)"
            self.collectionView.reloadData()
        }
    }
}

// MARK: configureView
extension ItemInfomationViewController {
    private func configureView() {
        self.view.addSubview(collectionView)
        self.view.addSubview(imageIndexLabel)
        self.view.addSubview(itemlabelStackView)
        self.view.addSubview(rightSideLabelStackView)
        self.view.addSubview(descriptionTextView)
        self.itemlabelStackView.addArrangedSubview(itemNameLabel)
        self.itemlabelStackView.addArrangedSubview(rightSideLabelStackView)
        self.rightSideLabelStackView.addArrangedSubview(stockLabel)
        self.rightSideLabelStackView.addArrangedSubview(priceLabelStackView)
        self.priceLabelStackView.addArrangedSubview(priceLabel)
        self.priceLabelStackView.addArrangedSubview(bargainPriceLabel)

        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.collectionView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.4),

            self.imageIndexLabel.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor),
            self.imageIndexLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.imageIndexLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),

            self.itemlabelStackView.topAnchor.constraint(equalTo: self.imageIndexLabel.bottomAnchor),
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

// MARK: CollectionView, Delegate
extension ItemInfomationViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemImageCollectionViewCell.identifier, for: indexPath) as! ItemImageCollectionViewCell
        cell.imageView.image = itemImages[indexPath.item]
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)

            guard let currentIndex = indexPath?.item else { return }
            imageIndexLabel.text = "\(currentIndex + 1)/\(self.itemImages.count)"
        }
    }
}

extension ItemInfomationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
