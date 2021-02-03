//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    private let testArray = [
        "https://wallpaperaccess.com/download/europe-4k-1369012",
        "https://wallpaperaccess.com/download/europe-4k-1318341",
        "https://wallpaperaccess.com/download/europe-4k-1379801"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        
        table.register(UINib(nibName: "TestTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    
//        MarketGoodsListModel.fetchMarketGoodsList(page: 1) { result in
//            switch result {
//            case .success(let data):
//                debugPrint("👋: \(data)")
//            case .failure(let error):
//                debugPrint("❌:\(error.localizedDescription)")
//            }
//        }
//        GoodsModel.fetchGoods(id: 1) { result in
//            switch result {
//            case .success(let data):
//                debugPrint("👋: \(data)")
//            case .failure(let error):
//                debugPrint("❌:\(error.localizedDescription)")
//            }
//        }
        let testImage = UIImage(systemName: "pencil")!
        let form = try? GoodsForm(registerPassword: "1234", title: "test-joons", descriptions: "test-joons", price: 10000, currency: "KRW", stock: 1, discountedPrice: nil, images: [testImage, testImage]).makeRegisterForm()
        GoodsModel.registerGoods(params: form!) { result in
            switch result {
            case .success(let data):
                debugPrint("👋: \(data)")
            case .failure(let error):
                debugPrint("❌:\(error.localizedDescription)")
            }
        }
        
//        let editForm = try? GoodsForm(editPassword: "1234", title: "test-test-joons", descriptions: nil, price: nil, currency: nil, stock: nil, discountedPrice: nil, images: nil).makeEditForm()
//        GoodsModel.editGoods(id: 67, params: editForm!) { result in
//            switch result {
//            case .success(let data):
//                debugPrint("👋: \(data)")
//            case .failure(let error):
//                debugPrint("❌:\(error.localizedDescription)")
//            }
//        }
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 42
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TestTableViewCell else {
            return UITableViewCell()
        }
        let token = ImageLoader.shared.load(urlString: self.testArray[indexPath.row % 3]) { result in
            switch result {
            case .failure(let error):
                debugPrint("❌:\(error.localizedDescription)")
            case .success(let image):
                DispatchQueue.main.async {
                    if let index: IndexPath = tableView.indexPath(for: cell) {
                        if index.row == indexPath.row {
                            cell.testImage.image = image
                        }
                    }
                }
            }
        }
        cell.onReuse = {
            if let token = token {
                ImageLoader.shared.cancelLoad(token)
            }
        }
        return cell
    }
    
    
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
