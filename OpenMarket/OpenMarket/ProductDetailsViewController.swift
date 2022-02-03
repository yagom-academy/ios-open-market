//
//  AViewController.swift
//  OpenMarket
//
//  Created by 권나영 on 2022/01/26.
//

import UIKit

final class ProductDetailsViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Properties
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.isHidden = false

        self.view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        return loadingIndicator
    }()
    
    private var product: ProductDetails?
    private var images: [ImageData] = []
    private var isUpdated = false

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        postNotification(name: Notification.Name.productUpdated)
    }
    
    // MARK: - Internal Methods
    
    func fetchDetails(of productID: Int) {
        startLoadingIndicator()
        MarketAPIService().fetchProduct(productID: productID) { [weak self] result in
            guard let self = self else {
                return
            }
            self.stopLoadingIndicator()
            switch result {
            case .success(let product):
                self.configureUI(with: product)
            case .failure(_):
                DispatchQueue.main.async {
                    self.presentAlert(
                        alertTitle: "데이터를 가져오지 못했습니다",
                        alertMessage: "죄송해요"
                    ) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}

// MARK: - Private Methods

extension ProductDetailsViewController {
    private func postNotification(name: Notification.Name) {
        NotificationCenter.default.post(
            name: name,
            object: nil,
            userInfo: ["isUpdated": isUpdated]
        )
    }
    
    private func setLabels(with product: ProductDetails) {
        let presentation = getPresentation(
            product: product,
            identifier: ProductDetailsViewController.identifier
        )
        
        setProductNameLabel(with: presentation)
        setStockLabel(with: presentation)
        setPriceLabel(with: presentation)
        setDiscountedPriceLabel(with: presentation)
        descriptionLabel.text = product.description
    }
    
    private func setProductNameLabel(with presentation: ProductUIPresentation) {
        productNameLabel.text = presentation.productNameLabelText
        productNameLabel.font = presentation.productNameLabelFont
    }
    
    private func setStockLabel(with presentation: ProductUIPresentation) {
        stockLabel.text = presentation.stockLabelText
        stockLabel.textColor = presentation.stockLabelTextColor
    }
    
    private func setPriceLabel(with presentation: ProductUIPresentation) {
        priceLabel.text = presentation.priceLabelText
        priceLabel.textColor = presentation.priceLabelTextColor
        if presentation.priceLabelIsCrossed {
            priceLabel.attributedText = priceLabel.convertToAttributedString(from: priceLabel)
        }
    }
    
    private func setDiscountedPriceLabel(with presentation: ProductUIPresentation) {
        discountedPriceLabel.text = presentation.discountedLabelText
        discountedPriceLabel.textColor = presentation.discountedLabelTextColor
        discountedPriceLabel.isHidden = presentation.discountedLabelIsHidden
    }
    
    private func setNavigationTitle(with product: ProductDetails) {
        let button = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(barButtonTapped)
        )
        navigationItem.title = product.name
        navigationItem.setRightBarButton(button, animated: true)
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = flowLayout
    }
    
    private func setPageControl() {
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .gray
    }
    
    private func startLoadingIndicator() {
        loadingIndicator.startAnimating()
    }
    
    private func stopLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
        }
    }
    
    private func showEditController() {
        guard let controller = storyboard?.instantiateViewController(
            identifier: ProductFormViewController.identifier,
            creator: { coder in
                ProductFormViewController(
                    delegate: self,
                    pageMode: .edit,
                    coder: coder
                )
            }
        ) else {
            assertionFailure("init(coder:) has not been implemented")
            return
        }
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
        
        guard let product = product else {
            return
        }
        controller.configureView(with: product)
    }
    
    private func deleteProduct(productID: Int, secret: String) {
        MarketAPIService().deleteProduct(
            productID: productID,
            productSecret: secret
        ) { result in
            switch result {
            case .success(_):
                self.isUpdated = true
                DispatchQueue.main.async {
                    self.presentAlert(
                        alertTitle: "삭제 완료",
                        alertMessage: "제품을 삭제했습니다"
                    ) { [weak self] _ in
                        guard let self = self else {
                            return
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.presentAlert(
                        alertTitle: "삭제 실패",
                        alertMessage: "유감입니다"
                    ) { [weak self] _ in
                        guard let self = self else {
                            return
                        }
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    private func configureUI(with product: ProductDetails) {
        self.product = product
        self.images = product.images
        
        DispatchQueue.main.async {
            self.setLabels(with: product)
            self.setNavigationTitle(with: product)
            self.setPageControl()
            self.collectionView.reloadData()
        }
    }
    
    @objc private func barButtonTapped() {
        presentActionSheet(actionTitle: "수정", cancelTitle: "삭제") { action in
            if action.title == "수정" {
                self.showEditController()
            } else {
                let password = Password(secret: "password")
                guard let product = self.product else {
                    return
                }
                MarketAPIService().getSecret(
                    productID: product.id,
                    password: password
                ) { result in
                    switch result {
                    case .success(let secret):
                        self.deleteProduct(productID: product.id, secret: secret)
                    case .failure(_):
                        DispatchQueue.main.async {
                            self.presentAlert(
                                alertTitle: "삭제 실패",
                                alertMessage: "자신의 제품만 삭제할 수 있습니다"
                            ) { [weak self]_ in
                                guard let self = self else {
                                    return
                                }
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProductDetailsViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return images.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductDetailsImageCell.identifier,
            for: indexPath
        ) as? ProductDetailsImageCell else {
            return UICollectionViewCell()
        }
        let imageURL = images[indexPath.row].url
        cell.configure(with: imageURL)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        
        return CGSize(width: width, height: height)
    }

    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        targetContentOffset.pointee = scrollView.contentOffset
        let sortedIndexes = collectionView.indexPathsForVisibleItems.sorted()
        guard var firstIndex = sortedIndexes.first,
              let cell = collectionView.cellForItem(at: firstIndex) else {
                  return
              }
        let position = collectionView.contentOffset.x - cell.frame.origin.x
        if position > cell.frame.size.width / 2 {
            firstIndex.row = firstIndex.row + 1
        }
        self.collectionView.scrollToItem(
            at: firstIndex,
            at: .left,
            animated: true
        )
        pageControl.currentPage = firstIndex.row
    }
}

//MARK: - DoneButtonTappedDelegate

extension ProductDetailsViewController: DoneButtonTappedDelegate {
    func registerButtonTapped() {
        guard let product = product else {
            return
        }
        MarketAPIService().fetchProduct(productID: product.id) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let product):
                self.product = product
                self.isUpdated = true
                DispatchQueue.main.async {
                    self.setNavigationTitle(with: product)
                    self.setLabels(with: product)
                }
            case .failure(_):
                self.presentAlert(
                    alertTitle: "로딩 실패",
                    alertMessage: "상품의 상세를 가져올 수 없습니다",
                    handler: nil
                )
            }
        }
    }
}

// MARK: - ProductUIPresentable

extension ProductDetailsViewController: ProductUIPresentable {}

// MARK: - IdentifiableView

extension ProductDetailsViewController: IdentifiableView {}
