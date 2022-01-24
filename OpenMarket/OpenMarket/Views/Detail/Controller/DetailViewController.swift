//
//  DetailViewController.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/19.
//

import UIKit

class DetailViewController: UIViewController {
    var data: Product?
    private var images = [UIImage]()
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var bargainPriceLabel: UILabel!
    @IBOutlet private weak var stockLabel: UILabel!
    @IBOutlet private weak var createdAtLabel: UILabel!
    @IBOutlet private weak var vendorLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNotification()
        setUpNavigationItem()
        setUpPageControl()
        setUpCollectionView()
    }
    
    func setUpTitle(_ title: String) {
        navigationItem.title = title
    }
    
    @IBAction func tappedPageControl(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    func requestDetail(productId: UInt) {
        let networkManager: NetworkManager = NetworkManager()
        guard let request = networkManager.requestDetailSearch(id: UInt(productId)) else {
            showAlert(message: Message.badRequest)
            return
        }
        networkManager.fetch(request: request, decodingType: Product.self) { result in
            switch result {
            case .success(let product):
                self.setUpViews(product: product)
                self.setUpImages()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func setUpViews(product: Product) {
        data = product
        DispatchQueue.main.async {
            self.nameLabel.text = product.name
            self.priceLabel.text = product.price.description
            self.bargainPriceLabel.text = product.bargainPrice.description
            self.stockLabel.text = product.stock.description
            self.createdAtLabel.text = product.createdAt
            self.vendorLabel.text = product.createdAt
            self.descriptionLabel.text = product.description
        }
    }
    
    private func setUpImages() {
        guard let newImages = data?.images else {
            return
        }
        let dispatchGroup = DispatchGroup()
        newImages.forEach { newImage in
            if let cachedImage = ImageManager.shared.loadCachedData(for: newImage.url) {
                self.images.append(cachedImage)
            } else {
                dispatchGroup.enter()
                ImageManager.shared.downloadImage(with: newImage.url) { image in
                    ImageManager.shared.setCacheData(of: image, for: newImage.url)
                    self.images.append(image)
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                self.collectionView.dataSource = self
                self.collectionView.delegate = self
                self.pageControl.numberOfPages = self.images.count
                self.pageControl.isHidden = false
                self.pageControl.hidesForSinglePage = true
            }
        }
    }
    
    private func setUpNavigationItem() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func setUpPageControl() {
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.isHidden = true
    }
    
    private func setUpCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        let nibName = UINib(nibName: ImageDetailCell.nibName, bundle: .main)
        collectionView.register(nibName, forCellWithReuseIdentifier: ImageDetailCell.identifier)
    }
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateDetailView),
            name: .updateDetail,
            object: nil)
    }
    
    @objc private func updateDetailView() {
        guard let data = data else {
            return
        }
        requestDetail(productId: UInt(data.id))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationViewController = segue.destination as? UINavigationController,
              let nextViewController = navigationViewController.topViewController as? EditViewController,
              let (product, secret) = sender as? (Product, String) else {
                  return
              }
        nextViewController.setUpModifyMode(product: product, secret: secret, images: self.images)
    }
    
    @IBAction func tappedEditButton(_ sendor: UIButton) {
        showActionSheet { _ in
            self.showAlertPasswordInput { secret in
                self.requestModification(secret: secret) { isSuccess in
                    if isSuccess {
                        DispatchQueue.main.async {
                            self.performSegue(
                                withIdentifier: SegueIdentifier.modifiyView,
                                sender: (self.data, secret)
                            )
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert(message: AlertMessage.wrongPassword)
                        }
                    }
                }
            }
        } deleteHandler: { _ in
            self.showAlertPasswordInput { secret in
                self.requestDelete(secret: secret) { isSuccess in
                    if isSuccess {
                        DispatchQueue.main.async {
                            self.showAlert(message: "삭제처리가 완료되었습니다.") {
                                NotificationCenter.default.post(name: .updateMain, object: nil)
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert(message: AlertMessage.wrongPassword)
                        }
                    }
                }
            }
        }
    }
    
    private func requestDelete(secret: String, complection: @escaping (Bool) -> Void) {
        guard let request = requestSecretSearch(secret: secret) else {
            return
        }
        let network = Network()
        network.execute(request: request) { result in
            switch result {
            case .success(let value):
                guard let value = value,
                      let password = String(data: value, encoding: .utf8) else {
                    return
                }
                self.delete(password: password) { isSuccess in
                    if isSuccess {
                        complection(true)
                    } else {
                        complection(false)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                complection(false)
            }
        }
    }
    
    private func delete(password: String, complection: @escaping (Bool) -> Void) {
        guard let data = self.data else {
            return
        }
        let networkManager = NetworkManager()
        guard let requestDelete = networkManager.requestDelete(id: UInt(data.id), secret: password) else {
            return
        }
        networkManager.fetch(request: requestDelete, decodingType: Product.self) { result in
            switch result {
            case .success:
                complection(true)
            case .failure(let error):
                print(error.localizedDescription)
                complection(false)
            }
        }
    }
    
    private func requestSecretSearch(secret: String) -> URLRequest? {
        guard let data = data else {
            return nil
        }
        let networkManager = NetworkManager()
        let requestResult = networkManager.requestSecretSearch(data: ProductSecret(secret: secret), id: UInt(data.id))
        switch requestResult {
        case .success(let request):
            return request
        case .failure:
            return nil
        }
        
    }
    
    private func requestModification(secret: String, completion: @escaping (Bool) -> Void) {
        guard let request = requestModify(secert: secret) else {
            showAlert(message: Message.badRequest) {
                self.dismiss(animated: true)
            }
            return
        }
        let networkManager = NetworkManager()
        networkManager.fetch(request: request, decodingType: Product.self) { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    private func requestModify(secert: String) -> URLRequest? {
        guard let data = data else {
            return nil
        }
        let parmas = ProductModification(secert: secert)
        let networkManager = NetworkManager()
        let requestResult = networkManager.requestModify(data: parmas, id: UInt(data.id))
        switch requestResult {
        case .success(let request):
            return request
        case .failure:
            return nil
        }
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageDetailCell.identifier,
            for: indexPath
        ) as? ImageDetailCell else {
            return UICollectionViewCell()
        }
        
        cell.imageView.image = images[indexPath.item]
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: collectionView.frame.height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        pageControl.currentPage = indexPath.item
    }
    
}
