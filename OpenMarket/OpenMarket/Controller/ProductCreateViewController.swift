//
//  ProductCreateViewController.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/18.
//

import UIKit

final class ProductCreateViewController: UIViewController {
    
    private var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func imageAddbuttonClicked(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "사진을 불러옵니다",
            message: "어디서 불러올까요?",
            preferredStyle: .actionSheet
        )
        alert.addAction(title: "카메라", style: .default)
        alert.addAction(title: "앨범", style: .default)
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - AlertController Utilities
fileprivate extension UIAlertController {
    
    func addAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        self.addAction(action)
    }
    
}
