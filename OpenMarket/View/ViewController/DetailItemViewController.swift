//
//  DetailItemViewController.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/28.
//

import UIKit

class DetailItemViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var postTitle: UILabel!
    @IBOutlet var stock: UILabel!
    @IBOutlet var discountedPrice: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var descriptions: UILabel!
    static let storyboardID = "DetailItemViewController"
    var imageDataList: [Data] = []
    var detailItemData: InformationOfItemResponse? = nil {
        didSet {
            DispatchQueue.main.async {
                self.setUpDataOfViewController()
            }
        }
    }
    private lazy var actionSheetButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = UIColor.systemBlue
        button.addTarget(self, action: #selector(showActionSheet), for: .touchDown)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        initNavigationBar()
        
    }
    
    private func setUpCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let PhotoCollectionViewCellNib = UINib(nibName: PhotoCollectionViewCell.identifier, bundle: nil)
        self.collectionView.register(PhotoCollectionViewCellNib, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    }
    private func initNavigationBar() {
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionSheetButton)
        
    }
    
    private func setUpDataOfViewController() {
        guard let detailItemData = detailItemData else { return }
        self.setUpImageData(detailItemData: detailItemData)
        self.navigationItem.title = detailItemData.title
        postTitle.text = detailItemData.title
        stock.text = "남은 수량 : " + String(detailItemData.stock)
        descriptions.text = detailItemData.descriptions
        if let discountedPrice = detailItemData.discountedPrice {
            self.discountedPrice.isHidden = false
            self.discountedPrice.text = detailItemData.currency + " " + String(discountedPrice)
            self.price.textColor = UIColor.red
            self.price.text = detailItemData.currency + " " + String(detailItemData.price)
            self.price.attributedText = self.price.text?.strikeThrough()
        } else {
            self.price.text = detailItemData.currency + " " + String(detailItemData.price)
        }
        self.collectionView.reloadData()
    }
    
    private func setUpImageData(detailItemData: InformationOfItemResponse) {
        DispatchQueue.global().async {
            for image in detailItemData.images {
                do {
                    guard let imageURL = URL(string: image) else { return }
                    let imageData = try Data(contentsOf: imageURL)
                    self.imageDataList.append(imageData)
                } catch {
                    print("Invalid URL")
                    return
                }
            }
        }
    }
    
    private func presentAlert(
                      isCancelActionIncluded: Bool = false,
                      preferredStyle style: UIAlertController.Style = .alert,
                      with actions: UIAlertAction ...) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: style)
        actions.forEach { alert.addAction($0) }
        if isCancelActionIncluded {
            let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(actionCancel)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func showActionSheet(_ sender: Any) {
        let editAction = UIAlertAction(title: "수정", style: .default) { action in
            guard let itemPostViewController = self.storyboard?.instantiateViewController(identifier: ItemPostViewController.storyboardID) as? ItemPostViewController else {
                return
            }
            guard let detailItemData = self.detailItemData else { return }
            ItemPostViewController.images = self.convertArrayToDictionary(Array: detailItemData.images)
            itemPostViewController.detailItemData = self.detailItemData
            itemPostViewController.screenMode = ScreenMode.edit
            self.navigationController?.pushViewController(itemPostViewController, animated: true)
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .default) { action in
            
        }
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        presentAlert(isCancelActionIncluded: true, preferredStyle: .actionSheet, with: editAction,deleteAction)
    }
    
    private func convertArrayToDictionary(Array: [String]) -> [Int : String] {
        var index = 0
        var dictionary : [Int : String] = [:]
        for string in Array {
            dictionary[index] = string
            index += 1
        }
        return dictionary
    }
}

extension DetailItemViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let detailItemData = detailItemData else { return 0 }
        return detailItemData.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else  {
            return UICollectionViewCell()
        }
        
        guard let detailItemData = detailItemData else { return cell }
        DispatchQueue.global().async {
            do {
                guard let imageURL = URL(string: detailItemData.images[indexPath.item]) else { return }
                let imageData = try Data(contentsOf: imageURL)
                DispatchQueue.main.async{
                    cell.itemImage.image = UIImage(data: imageData)
                }
            } catch {
                print("Invalid URL")
            }
        }
        
        
        return cell
        
    }
    
}

extension DetailItemViewController: UICollectionViewDelegate {
    
}

extension DetailItemViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
