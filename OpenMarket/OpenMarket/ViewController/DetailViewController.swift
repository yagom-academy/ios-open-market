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

        detailView.collectionView.register(DetailCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "detailCell")
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
        guard let data = try? JSONEncoder().encode(ProductToRequest(secret: password)), let product = product else {
            return
        }
        RequestAssistant.shared.requestSecretAPI(productId: product.id, body: data, completionHandler: { result in
            switch result {
            case .success(let data):
                self.deleteProduct(id: product.id, secret: data)
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert(alertTitle: "비밀번호가 맞지 않습니다.")
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
                    self.showAlert(alertTitle: "데이터 로드 실패")
                }
            }
        }
    }
    
    func refreshProduct() {
        requestProductData()
    }
}
