//
//  ItemDetailViewController.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/06/01.
//

import UIKit

final class ItemDetailViewController: UIViewController {
    @IBOutlet private weak var itemImageCollectionView: UICollectionView!
    @IBOutlet private weak var imageNumberLabel: UILabel!
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var stockLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var discountedPriceLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var myActivityIndicator: UIActivityIndicatorView!
    private let networkHandler = NetworkHandler()
    private var delegate: UpdateDelegate?
    private var itemDetail: ItemDetail? {
        didSet {
            DispatchQueue.main.async {
                self.setInitialView()
            }
        }
    }
    private var secret: String? {
        didSet {
            deleteItem(secret: secret)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getItem(id: Int) {
        let itemDetailAPI = ItemDetailAPI(id: id)
        networkHandler.request(api: itemDetailAPI) { data in
            switch data {
            case .success(let data):
                guard let itemDetail = try? DataDecoder.decode(data: data, dataType: ItemDetail.self) else { return }
                self.itemDetail = itemDetail
            case .failure(_):
                let alert = UIAlertController(title: "데이터로드 실패", message: nil, preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "확인", style: .default) {_ in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(yesAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func setDelegate(target: UpdateDelegate) {
        delegate = target
    }
    
    private func setInitialView() {
        itemImageCollectionView.dataSource = self
        itemImageCollectionView.delegate = self
        itemImageCollectionView.register(UINib(nibName: "\(ItemDetailImageCell.self)", bundle: nibBundle), forCellWithReuseIdentifier: "\(ItemDetailImageCell.self)")
        navigationItem.rightBarButtonItem = makeEditButton()
        setCollectionviewLayout()
        setViewComponents()
        myActivityIndicator.stopAnimating()
    }
    
    private func getSecret(password: String?) {
        guard let id = itemDetail?.id else { return }
        let secretAPI = SecretAPI(id: id, password: password)
        
        networkHandler.request(api: secretAPI) { data in
            switch data {
            case .success(let data):
                guard let data = data else { return }
                self.secret = String(data: data, encoding: .utf8)
            case .failure(_):
                let alert = UIAlertController(title: "비밀번호가 틀렸습니다", message: nil, preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(yesAction)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    private func deleteItem(secret: String?) {
        guard let secret = secret else { return }
        guard let id = itemDetail?.id else { return }
        let deleteAPI = DeleteAPI(id: id, secret: secret)
        
        networkHandler.request(api: deleteAPI) { _ in
            DispatchQueue.main.async {
                self.delegate?.upDate()
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    @objc private func touchEditButton() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "수정", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            let inAlert = UIAlertController(title: "비밀번호를 입력해주세요", message: nil, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "확인", style: .default) { _ in
                self.getSecret(password: inAlert.textFields?[0].text)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            inAlert.addTextField()
            inAlert.addAction(yesAction)
            inAlert.addAction(cancelAction)
            
            self.present(inAlert, animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

// MARK: - collectionView cell
extension ItemDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemDetail?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let ItemDetailImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ItemDetailImageCell.self)", for: indexPath) as? ItemDetailImageCell else { return ItemDetailImageCell() }
        ItemDetailImageCell.configureImage(url: itemDetail?.images[indexPath.row].url ?? "")
        return ItemDetailImageCell
    }
}
extension ItemDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        
        imageNumberLabel.text = "\(visibleIndexPath.row + 1)/\(itemDetail?.images.count ?? 0)"
    }
}

// MARK: - about View
extension ItemDetailViewController {
    private func setViewComponents() {
        guard let itemDetail = itemDetail else { return }
        self.title = itemDetail.name
        imageNumberLabel.text = "1/\(itemDetail.images.count)"
        itemNameLabel.text = itemDetail.name
        if itemDetail.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        } else {
            stockLabel.text = "남은 수량 : " + itemDetail.stock.description
            stockLabel.textColor = .systemGray
        }
        
        if itemDetail.price == 0 {
            priceLabel.isHidden = true
        } else {
            let price = "\(itemDetail.currency) \(itemDetail.price.description)"
            priceLabel.attributedText = price.strikethrough()
        }
        
        discountedPriceLabel.text = "\(itemDetail.currency) \(itemDetail.discountedPrice.description)"
        descriptionTextView.text = itemDetail.description
    }
    
    private func makeEditButton() -> UIBarButtonItem {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(touchEditButton))
        
        return barButton
    }
    
    private func setCollectionviewLayout() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: itemSize.widthDimension, heightDimension: itemSize.heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        itemImageCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
}

