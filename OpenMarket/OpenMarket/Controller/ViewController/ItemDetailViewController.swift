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
    private var itemDetail: ItemDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setInitialView() {
        navigationItem.rightBarButtonItem = makeEditButton()
        guard let itemDetail = itemDetail else { return }
        self.title = itemDetail.name
        itemNameLabel.text = itemDetail.name
        stockLabel.text = itemDetail.stock.description
        priceLabel.text = itemDetail.price.description
        discountedPriceLabel.text = itemDetail.discountedPrice.description
        
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

