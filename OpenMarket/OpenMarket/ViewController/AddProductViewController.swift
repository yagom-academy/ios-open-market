//
//  AddProductViewController.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/29.
//

import UIKit

class AddProductViewController: UIViewController {
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var pickerImageStackView: UIStackView!
    @IBOutlet weak var pikerImageView: UIView!
    
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var discountPrice: UITextField!
    @IBOutlet weak var inventoryQuantity: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private let imagePicker = UIImagePickerController()
    var imageArray: [UIImage] = []
    private var segmentMemonyType: String = CurrencyType.krw
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImagePicker()
    }
    
    @IBAction private func back(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction private func addImageClick(_ sender: Any) {
        pickImage()
    }
    
    @IBAction func selectMoneyType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            segmentMemonyType = CurrencyType.krw
        case 1:
            segmentMemonyType = CurrencyType.usd
        default:
            break
        }
    }
    
    @IBAction func doneClick(_ sender: Any) {
        guard let productName = productName.text,
              let productPrice = Int(productPrice.text!),
              let inventoryQuantity = Int(inventoryQuantity.text!),
              let descriptionTextField = descriptionTextView.text else {
            return
        }
        
        postRequest(image: imageArray,
                    name: productName,
                    price: productPrice,
                    stock: inventoryQuantity,
                    currency: segmentMemonyType,
                    discountPrice: Int(discountPrice.text ?? "0") ?? 0,
                    secret: VendorInfo.secret,
                    descriptions: descriptionTextField)
        
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc private func pickImage() {
        self.present(self.imagePicker, animated: true)
    }
    
    private func fetchImagePicker() {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
    }
    
    private func fetchPickerImageView(image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: pikerImageView.frame.width),
            imageView.heightAnchor.constraint(equalToConstant: pikerImageView.frame.height)
        ])
        
        let imageSize = image.logImageSizeInKB(scale: image.scale)
        
        if imageSize >= 300 {
            imageArray.append(resizeImage(image: image, height: pikerImageView.frame.height))
        } else {
            imageArray.append(image)
        }
         
        
        if imageArray.count == 5 {
            pikerImageView.isHidden = true
        }
        
        return imageView
    }
    
    func postRequest(image: [UIImage], name: String, price: Int, stock: Int, currency: String, discountPrice: Int, secret: String, descriptions: String) {
        let parmtersValue = ["name": name,
                             "price": price,
                             "stock": stock,
                             "currency": currency,
                             "discounted_price": discountPrice,
                             "secret": secret,
                             "descriptions": descriptions] as [String : Any]
        
        guard let jsonParams = try? JSONSerialization.data(withJSONObject: parmtersValue, options: .prettyPrinted) else {
            return
        }
        
        guard let url = URL(string: URLCollection.hostURL + URLCollection.productPost.string) else {
            return
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        
        request.addValue(VendorInfo.identifier, forHTTPHeaderField: "identifier")
        request.addValue("multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = HTTPMethod.post
        
        let body = createBody(paramaeters: ["params": jsonParams], boundary: boundary)
        let imageBody = createImageBody(images: image, boundary: boundary)
        
        request.httpBody = body + imageBody
        
        print(String(decoding: request.httpBody!, as: UTF8.self))
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("data",String(describing: error))
                return
            }
            print("result", String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func createBody(paramaeters: [String: Any], boundary: String) -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in paramaeters {
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n".data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
            body.append("\(String(data: value as! Data, encoding: .utf8) ?? "")\r\n".data(using: .utf8)!)
        }
        return body
    }
    
    func createImageBody(images: [UIImage]?, boundary: String) -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        if let images = images {
            for image in images {
                let imageData = image
                let imageFile = ImageFile(key: "images",
                                          src: (imageData.jpegData(compressionQuality: 0.1)!),
                                          type: "file")
                
                body.append(boundaryPrefix.data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(imageFile.key)\"; filename=\"\(arc4random())\".jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageFile.src)
                body.append("\r\n".data(using: .utf8)!)
            }
        }
        body.append("--\(boundary)--".data(using: .utf8)!)
        return body
    }
    
    func resizeImage(image: UIImage, height: CGFloat) -> UIImage {
        let scale = height / image.size.height
        let width = image.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension AddProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        let imageView = fetchPickerImageView(image: editedImage)
        pickerImageStackView.insertArrangedSubview(imageView, at: .zero)
        dismiss(animated: true, completion: nil)
    }
}

extension UIImage {
    func logImageSizeInKB(scale: CGFloat) -> Int {
        let data = self.jpegData(compressionQuality: scale)!
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useKB
        formatter.countStyle = ByteCountFormatter.CountStyle.file
        let imageSize = formatter.string(fromByteCount: Int64(data.count))
        print("ImageSize(KB): \(imageSize)")
        
        return Int(Int64(data.count) / 1024)
    }
}
