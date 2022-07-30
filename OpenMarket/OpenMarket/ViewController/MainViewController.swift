//
//  OpenMarket - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit


final class MainViewController: UIViewController {
    @IBOutlet weak var segmentSwitch: UISegmentedControl!
    @IBOutlet weak var collectionListView: UIView!
    @IBOutlet weak var collectionGridView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentSwitch.selectedSegmentTintColor = .systemBlue
        segmentSwitch.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentSwitch.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        segmentSwitch.layer.borderWidth = 1
        segmentSwitch.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    @IBAction private func switchView(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            collectionListView.alpha = 1
            collectionGridView.alpha = 0
        case 1:
            collectionListView.alpha = 0
            collectionGridView.alpha = 1
        default:
            break
        }
    }
    
    func postRequest() {
        let imageData = UIImage(named: "TestImage.jpeg")
        let dummyImaage = ImageFile(key: "images", src: (imageData?.jpegData(compressionQuality: 1.0)!)!, type: "file")
        let parmtersValue = ["name": "백곰Product", "price":15000, "stock": 1000, "currency": "KRW", "secret": VendorInfo.secret, "descriptions": "비쌈"] as [String : Any]
        
        guard let jsonParams = try? JSONSerialization.data(withJSONObject: parmtersValue, options: .prettyPrinted) else {
            return
        }
        
        guard let url = URL(string: "https://market-training.yagom-academy.kr/api/products") else {
            return
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        
        request.addValue(VendorInfo.identifier, forHTTPHeaderField: "identifier")
        request.addValue("multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = HTTPMethod.post

        let body = createBody(paramaeters: ["params": jsonParams], boundary: boundary, images: dummyImaage)
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("data",String(describing: error))
                return
            }

            print("result", String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func createBody(paramaeters: [String: Any], boundary: String, images: ImageFile) -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"

        for (key, value) in paramaeters {
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n".data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
            body.append("\(String(data: value as! Data, encoding: .utf8) ?? "")\r\n".data(using: .utf8)!)
        }
 
        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(images.key)\"; filename=\"\(images.key)\"\r\n\r\n".data(using: .utf8)!)
        body.append(images.src)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--".data(using: .utf8)!)
        return body
    }
}

