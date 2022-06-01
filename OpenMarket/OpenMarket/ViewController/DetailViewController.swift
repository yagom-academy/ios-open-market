//
//  DetailViewController.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/31.
//

import UIKit

protocol ProductUpdateDelegate: NSObject {
    func refreshProduct()
}

class DetailViewController: UIViewController {
    var product: Product?
    let numberFormatter: NumberFormatter = NumberFormatter()
    weak var delegate: ListUpdateDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviewStructures()
        setupLayoutConstraints()
        configureContents()
        defineCollectionViewDelegate()
        guard let productName = product?.name else {
            return
        }
        self.navigationItem.title = "\(productName)"
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(requestCancel))
        self.navigationItem.leftBarButtonItem = backButton
        let sheetButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(requestSheet))
        self.navigationItem.rightBarButtonItem = sheetButton


        collectionView.register(DetailCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "detailCell")
    }
    
    let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return scrollView
    }()
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return stackView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(for: .title3, weight: .semibold)
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .systemGray
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(for: .body, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    
    let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = .preferredFont(for: .body, weight: .semibold)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.decelerationRate = .fast
        collectionView.contentInsetAdjustmentBehavior = .never
        
        return collectionView
    }()
    
    func setupSubviewStructures() {
        
        informationStackView.addArrangedSubview(nameLabel)
        informationStackView.addArrangedSubview(stockLabel)
        
        mainStackView.addArrangedSubview(collectionView)
        mainStackView.addArrangedSubview(informationStackView)
        
        mainStackView.addArrangedSubview(priceLabel)
        mainStackView.addArrangedSubview(bargainPriceLabel)
        mainStackView.addArrangedSubview(descriptionLabel)
        mainScrollView.addSubview(mainStackView)
        self.view.addSubview(mainScrollView)
        
    }
    
    func setupLayoutConstraints() {
        mainScrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mainScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        mainScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        mainScrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mainScrollView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        mainStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor).isActive = true
        mainStackView.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor).isActive = true
        
        collectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.45).isActive = true
        
        informationStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor).isActive = true
        informationStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: informationStackView.leadingAnchor).isActive = true
        stockLabel.trailingAnchor.constraint(equalTo: informationStackView.trailingAnchor).isActive = true
        
        priceLabel.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true
        bargainPriceLabel.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true
    }
    
    func configureContents() {
        guard let product = product else {
            return
        }
        
        guard let currency = product.currency?.rawValue else {
            return
        }
        
        nameLabel.text = product.name
        stockLabel.text = "남은 수량 : \(numberFormatter.numberFormatString(for: Double(product.stock)))"
        priceLabel.text = "\(currency) \(numberFormatter.numberFormatString(for:product.price))"
        
        if product.discountedPrice != .zero {
            guard let price = priceLabel.text else {
                return
            }
            priceLabel.textColor = .red
            priceLabel.attributedText = setTextAttribute(of: price, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            bargainPriceLabel.text = "\(currency) \(numberFormatter.numberFormatString(for:product.bargainPrice))"
        }
        
        
        descriptionLabel.text = product.description
    }
    
    private func setTextAttribute(of target: String, attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: target)
        attributedText.addAttributes(attributes, range: (target as NSString).range(of: target))
        
        return attributedText
    }
    
    @objc private func requestCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func requestSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let modify = UIAlertAction(title: "수정", style: .default) { [weak self] _ in
            self?.presentModifiation()
        }
        let delete = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.requestDelete()
        }
        alert.addAction(cancel)
        alert.addAction(modify)
        alert.addAction(delete)
        
        present(alert, animated: true)
    }
    
    func presentModifiation() {
        guard let modifyViewController = self.storyboard?.instantiateViewController(withIdentifier: "ModifyViewController") as? ModifyViewController else {
            return
        }
        modifyViewController.delegate = self
        modifyViewController.product = product
        self.navigationController?.pushViewController(modifyViewController, animated: true)
    }
    
    func requestDelete() {
        let alert = UIAlertController(title: "비밀번호를 입력하세요.", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { field in
            field.isSecureTextEntry = true
            field.placeholder = "Password"
        })
        let ok = UIAlertAction(title: "확인", style: .default, handler: { _ in
            if let password = alert.textFields?.first?.text {
                self.checkSecret(password: password)
            }
        })
        let cancel = UIAlertAction(title: "닫기", style: .default)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func checkSecret(password: String) {
        guard let data = try? JSONEncoder().encode(ProductToModify(secret: password)), let product = product else {
            return
        }
        RequestAssistant.shared.requestSecretAPI(productId: product.id, body: data, completionHandler: { result in
            switch result {
            case .success(let data):
                self.deleteProduct(id: product.id, secret: data)
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert(alertTitle: "비밀번호 실패")
                }
            }
        })
    }
    
    func deleteProduct(id: Int, secret: String) {
        RequestAssistant.shared.requestDeleteAPI(productId: id, productSecret: secret, completionHandler: { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.showAlert(alertTitle: "상품을 삭제하였습니다.") { [weak self] _ in
                        self?.navigationController?.popViewController(animated: true)
                        self?.delegate?.refreshProductList()
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert(alertTitle: "상품을 삭제할 권한이 없습니다.")
                }
            }
        })
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as? DetailCollectionViewCell else {
            return DetailCollectionViewCell()
        }
        guard let images = product?.images else {
            return DetailCollectionViewCell()
        }
        cell.imageView.requestImageDownload(url: images[indexPath.row].url)
        cell.pageLabel.text = "\(String(indexPath.row + 1)) / \(images.count)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let images = product?.images else {
            return .zero
        }
        return images.count
    }
    
    private func defineCollectionViewDelegate() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidth = collectionView.frame.width
        let spaceBetweenCell = flowLayout.minimumLineSpacing
        let cellWidthWithSpace = cellWidth + spaceBetweenCell
        
        let contentIndex = round((targetContentOffset.pointee.x) / cellWidthWithSpace)
        let contentOffset = CGPoint(x: contentIndex * cellWidthWithSpace, y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = contentOffset
    }
}

extension DetailViewController: ProductUpdateDelegate {
    func requestProductData() {
        guard let id = product?.id else {
            return
        }
        product = nil
        RequestAssistant.shared.requestDetailAPI(productId: id) { result in
            switch result {
            case .success(let data):
                self.product = data
                DispatchQueue.main.async {
                    self.configureContents()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert(alertTitle: "데이터 로드 실패")
                }
            }
        }
    }
    
    func refreshProduct() {
        requestProductData()
    }
}
