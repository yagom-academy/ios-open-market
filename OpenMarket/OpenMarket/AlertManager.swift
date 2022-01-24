//
//  AlertManager.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/22.
//

import UIKit

struct AlertManager {
    static func presentExcessImagesAlert(on viewController: ProductDetailsViewController) {
        let alert = UIAlertController(title: "이미지가 너무 많아요", message: "이미지는 5개를 초과하면 안돼요.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(ok)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func presentNoImagesAlert(on viewController: ProductDetailsViewController) {
        let alert = UIAlertController(title: "이미지를 추가해주세요", message: "최소 1개의 이미지를 등록해주세요.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(ok)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func presentSuccessfulRegisterAlert(on viewController: ProductDetailsViewController) {
        let alert = UIAlertController(title: "제품등록 성공", message: "제품을 성공적으로 등록했습니다.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            viewController.delegate?.addButtonPressed()
            viewController.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
