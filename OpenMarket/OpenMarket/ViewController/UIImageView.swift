//
//  UIImageView.swift
//  OpenMarket
//
//  Created by ysp on 2021/06/11.
//

import UIKit

extension UIImageView {
    func getData(from url: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) throws {
        guard let url = URL(string: url) else { throw invalidError.invalidURL }
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: String) {
        do {
            let _ = try getData(from: url) {
                data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                DispatchQueue.main.async() {
                    self.image = UIImage(data: data)
                }
            }
        } catch {
            print("DownloadImageError")
        }
    }
}
