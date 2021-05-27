//
//  ItemPostViewController.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/26.
//

import UIKit

class ItemPostViewController: UIViewController {
    
    @IBOutlet var imageCollectionView: UICollectionView!
    @IBOutlet var itemPostTitle: UITextField!
    @IBOutlet var currency: UITextField!
    @IBOutlet var price: UITextField!
    @IBOutlet var discountedPrice: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var descriptions: UITextView!
    @IBOutlet var stock: UITextField!
    var images: [String] = [""]
    
    
    var itemPostInformation: Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptions.delegate = self
    }
    
    
    @IBAction func postItem(_ sender: Any) {
//        do {
//            itemPostInformation = try Request(path: Path.item, httpMethod: HTTPMethod.POST, title: itemPostTitle.text, descriptions: descriptions.text, price: Int(price.text!), currency: currency.text, stock: Int(stock.text!), discountedPrice: Int(discountedPrice.text!), images: images, password: password.text)
//        } catch {
//            print("Input Error")
//        }
//        guard let itemPostInformation = itemPostInformation else { return }
//        NetworkManager.shared.postItem(requestData: itemPostInformation) {[weak self] data in
            NetworkManager.shared.postItem{[weak self] data in
            do {
                print("data : \(data)")
                let data = try JSONDecoder().decode(InformationOfItemResponse.self, from: data!)
                Cache.shared.detailItemInformationList[data.id] = data
                return
            } catch {
                print("Failed to decode")
            }
            
            do {
                let message = try JSONDecoder().decode(Message.self, from: data!)
                print("message : ",message)
            } catch {
                print("Failed to decode")
            }
            
        }
    }
}

extension ItemPostViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewSetupView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print(textView.text)
        
        if textView.text == "" {
            textViewSetupView()
        }
        
        if textView.text != "", textView.text != "제품 상세 설명" {
            itemPostInformation?.descriptions = textView.text
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewSetupView() {
        if descriptions.text == "제품 상세 설명" {
            descriptions.text = ""
            descriptions.textColor = UIColor.black
        } else if descriptions.text == "" {
            descriptions.text = "제품 상세 설명"
            descriptions.textColor = UIColor.systemGray4
        }
    }
    
}
