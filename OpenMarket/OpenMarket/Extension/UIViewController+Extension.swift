//
//  AlertError.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/26.
//

import UIKit

extension UIViewController {
    func alertError(_ error: Error) {
        let alert = UIAlertController(title: "에러 발생", message: "\(error)", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        
        alert.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func goToPreviousView(title: String, _ message: String) {
        let alert = UIAlertController(title: "title", message: "\(message)", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
            
        }
        
        alert.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}

