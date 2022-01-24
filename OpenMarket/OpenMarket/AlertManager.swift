//
//  AlertManager.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/22.
//

import UIKit

enum AlertManager {
    private enum TitleString {
        static let excessImages = "이미지가 너무 많아요"
        static let noImages = "이미지를 추가해주세요"
        static let successfulRegister = "제품등록 성공"
        static let unsuccessfulRegister = "제품등록 실패"
        static let ok = "확인"
    }
    
    private enum MessageString {
        static let excessImages = "이미지는 5개를 초과하면 안돼요."
        static let noImages = "이미지를 추가해주세요"
        static let successfulRegister = "제품등록 성공"
        static let unsuccessfulRegister = "제품등록 실패"
    }
    
    static func presentExcessImagesAlert(on viewController: ProductFormViewController) {
        let alert = UIAlertController(title: TitleString.excessImages, message: MessageString.excessImages, preferredStyle: .alert)
        let ok = UIAlertAction(title: TitleString.ok, style: .default, handler: nil)
        alert.addAction(ok)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func presentNoImagesAlert(on viewController: ProductFormViewController) {
        let alert = UIAlertController(title: TitleString.noImages, message: MessageString.noImages, preferredStyle: .alert)
        let ok = UIAlertAction(title: TitleString.ok, style: .default, handler: nil)
        alert.addAction(ok)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func presentSuccessfulRegisterAlert(on viewController: ProductFormViewController) {
        let alert = UIAlertController(title: TitleString.successfulRegister, message: MessageString.successfulRegister, preferredStyle: .alert)
        let ok = UIAlertAction(title: TitleString.ok, style: .default) { _ in
            viewController.triggerDelegateMethod()
            viewController.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func presentUnsuccessfulRegisterAlert(on viewController: ProductFormViewController) {
        let alert = UIAlertController(title: TitleString.unsuccessfulRegister, message: MessageString.unsuccessfulRegister, preferredStyle: .alert)
        let ok = UIAlertAction(title: TitleString.ok, style: .default)
        alert.addAction(ok)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
