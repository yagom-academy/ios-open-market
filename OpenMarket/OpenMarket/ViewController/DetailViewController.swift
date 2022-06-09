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

private extension OpenMarketConstant {
    static let modify = "수정"
    static let delete = "삭제"
    static let inputPassword = "비밀번호를 입력하세요."
    static let ok = "확인"
    static let close = "닫기"
    static let password = "Password"
    static let wrongPassword = "비밀번호가 맞지 않습니다."
    static let deleteDone = "상품을 삭제하였습니다."
    static let wrongAuthority = "상품을 삭제할 권한이 없습니다."
}

final class DetailViewController: UIViewController {
    lazy var detailView = DetailView(frame: view.frame)
    var product: Product?
    let numberFormatter: NumberFormatter = NumberFormatter()
    weak var delegate: ListUpdateDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.configureContents(product: product)
        self.view = detailView
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
        guard let images = product?.images else {
                    return
                }
        detailView.pageLabel.text = "1 / \(images.count)"
        detailView.collectionView.register(DetailCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "detailCell")
    }
    
    @objc private func requestCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func requestSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: OpenMarketConstant.cancellation, style: .cancel, handler: nil)
        let modify = UIAlertAction(title: OpenMarketConstant.modify, style: .default) { [weak self] _ in
            self?.presentModifiation()
        }
        let delete = UIAlertAction(title: OpenMarketConstant.delete, style: .destructive) { [weak self] _ in
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
        let alert = UIAlertController(title: OpenMarketConstant.inputPassword, message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { field in
            field.isSecureTextEntry = true
            field.placeholder = OpenMarketConstant.password
        })
        let ok = UIAlertAction(title: OpenMarketConstant.ok, style: .default, handler: {  [weak self] _ in
            if let password = alert.textFields?.first?.text {
                self?.checkSecret(password: password)
            }
        })
        let cancel = UIAlertAction(title: OpenMarketConstant.close, style: .default)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func checkSecret(password: String) {
        guard let data = try? JSONEncoder().encode(ProductToRequest(secret: password)), let product = product else {
            return
        }
        RequestAssistant.shared.requestSecretAPI(productId: product.id, body: data, completionHandler: {  [weak self] result in
            switch result {
            case .success(let data):
                self?.deleteProduct(id: product.id, secret: data)
            case .failure(_):
                DispatchQueue.main.async {
                    self?.showAlert(title: OpenMarketConstant.wrongPassword)
                }
            }
        })
    }
    
    func deleteProduct(id: Int, secret: String) {
        RequestAssistant.shared.requestDeleteAPI(productId: id, productSecret: secret, completionHandler: {  [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.showAlert(title: OpenMarketConstant.deleteDone) { [weak self] _ in
                        self?.navigationController?.popViewController(animated: true)
                        self?.delegate?.refreshProductList()
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.showAlert(title: OpenMarketConstant.wrongAuthority)
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
        
        if let images = product?.images {
            cell.imageView.requestImageDownload(url: images[indexPath.row].url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let images = product?.images else {
            return .zero
        }
        return images.count
    }
    
    private func defineCollectionViewDelegate() {
        detailView.collectionView.delegate = self
        detailView.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let flowLayout = self.detailView.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidth = detailView.collectionView.frame.width
        let spaceBetweenCell = flowLayout.minimumLineSpacing
        let cellWidthWithSpace = cellWidth + spaceBetweenCell
        
        let contentIndex = round((targetContentOffset.pointee.x) / cellWidthWithSpace)
        let contentOffset = CGPoint(x: contentIndex * cellWidthWithSpace, y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = contentOffset
        guard let images = product?.images else {
            return
        }
        detailView.pageLabel.text = "\(String(Int(contentIndex + 1))) / \(images.count)"
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
                    self.detailView.configureContents(product: data)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert(title: OpenMarketConstant.loadFail)
                }
            }
        }
    }
    
    func refreshProduct() {
        requestProductData()
    }
}
