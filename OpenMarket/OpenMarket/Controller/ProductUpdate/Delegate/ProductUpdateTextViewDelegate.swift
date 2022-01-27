//
//  ProductUpdateTextViewDelegate.swift
//  Pods
//
//  Created by JeongTaek Han on 2022/01/22.
//

import UIKit

class ProductUpdateTextViewDelegate: NSObject {
    
}

extension ProductUpdateTextViewDelegate: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.removePlaceholderText()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let message = "여기에 상품 상세 정보를 입력해주세요!"
        textView.configurePlaceholderText(with: message)
    }
    
}
