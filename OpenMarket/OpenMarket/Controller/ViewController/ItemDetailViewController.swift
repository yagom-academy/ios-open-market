//
//  ItemDetailViewController.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/06/01.
//

import UIKit

final class ItemDetailViewController: UIViewController {
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
        navigationItem.rightBarButtonItem = makeEditButton()
        guard let itemDetail = itemDetail else { return }
        self.title = itemDetail.name
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
// MARK: - about View
extension ItemDetailViewController {
    private func makeEditButton() -> UIBarButtonItem {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(touchEditButton))
        
        return barButton
    }
}

