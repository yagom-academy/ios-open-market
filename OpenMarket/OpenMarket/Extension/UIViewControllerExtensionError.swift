//
//  UIViewControllerExtensionError.swift
//  OpenMarket
//
//  Created by Yeon on 2021/02/02.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(with error: OpenMarketError) {
        let alert = UIAlertController(title: "오류 발생", message: "\(String(describing: error.localizedDescription)) 앱을 다시 실행시켜주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func errorHandling(error: OpenMarketError) {
        switch error {
        case .failFetchData:
            DispatchQueue.main.async {
                self.showAlert(with: .failFetchData)
            }
        case .failUploadData:
            DispatchQueue.main.async {
                self.showAlert(with: .failUploadData)
            }
        case .failDeleteData:
            DispatchQueue.main.async {
                self.showAlert(with: .failDeleteData)
            }
        case .failTransportData:
            DispatchQueue.main.async {
                self.showAlert(with: .failTransportData)
            }
        case .failGetData:
            DispatchQueue.main.async {
                self.showAlert(with: .failGetData)
            }
        case .failDecode:
            DispatchQueue.main.async {
                self.showAlert(with: .failDecode)
            }
        case .failMatchMimeType:
            DispatchQueue.main.async {
                self.showAlert(with: .failMatchMimeType)
            }
        case .failEncode:
            DispatchQueue.main.async {
                self.showAlert(with: .failEncode)
            }
        case .failSetUpURL:
            DispatchQueue.main.async {
                self.showAlert(with: .failSetUpURL)
            }
        case .failMakeURLRequest:
            DispatchQueue.main.async {
                self.showAlert(with: .failMakeURLRequest)
            }
        case .imageFileOverSize:
            DispatchQueue.main.async {
                self.showAlert(with: .imageFileOverSize)
            }
        case .imageFileOverRegistered:
            DispatchQueue.main.async {
                self.showAlert(with: .imageFileOverRegistered)
            }
        case .passwordNotMatched:
            DispatchQueue.main.async {
                self.showAlert(with: .passwordNotMatched)
            }
        case .unknown:
            DispatchQueue.main.async {
                self.showAlert(with: .unknown)
            }
        }
    }
}
