//
//  ItemDetailViewController.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/06/01.
//

import UIKit

final class ItemDetailViewController: UIViewController {
    @IBOutlet weak var itemImageCollectionView: UICollectionView!
    @IBOutlet weak var imageNumberLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    private let networkHandler = NetworkHandler()
    private var itemDetail: ItemDetail? = nil {
        didSet {
            DispatchQueue.main.async {
                self.setInitialView()
            }
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
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setInitialView() {
        itemImageCollectionView.dataSource = self
        itemImageCollectionView.delegate = self
        itemImageCollectionView.register(UINib(nibName: "\(ItemDetailImageCell.self)", bundle: nibBundle), forCellWithReuseIdentifier: "\(ItemDetailImageCell.self)")
        setCollectionviewLayout()
        navigationItem.rightBarButtonItem = makeEditButton()
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
        myActivityIndicator.stopAnimating()
    }
    
    @objc private func touchEditButton() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "수정", style: .default, handler: nil)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            let inAlert = UIAlertController(title: "비밀번호를 입력해주세요", message: nil, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "확인", style: .default) { _ in
                print(inAlert.textFields?[0].text ?? "")
            }
            
            inAlert.addTextField()
            inAlert.addAction(yesAction)
            
            self.present(inAlert, animated: true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(edit)
        alert.addAction(delete)
        alert.addAction(cancel)
        
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

