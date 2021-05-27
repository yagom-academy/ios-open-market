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
    static var images: [String] = []
    var itemPostInformation: Request?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptions.delegate = self
        setUpCollectionView()
    }
    
    private func setUpCollectionView() {
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        registerCollectionViewCellNib()
    }
    
    private func registerCollectionViewCellNib() {
        let PhotoCollectionViewCellNib = UINib(nibName: PhotoCollectionViewCell.identifier, bundle: nil)
        let PlusPhotoCollectionViewCellNib = UINib(nibName: PlusPhotoCollectionViewCell.identifier, bundle: nil)
        self.imageCollectionView.register(PhotoCollectionViewCellNib, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        self.imageCollectionView.register(PlusPhotoCollectionViewCellNib, forCellWithReuseIdentifier: PlusPhotoCollectionViewCell.identifier)
    }
    
    @IBAction func postItem(_ sender: Any) {
        do {
            itemPostInformation = try Request(path: Path.item, httpMethod: HTTPMethod.POST, title: itemPostTitle.text, descriptions: descriptions.text, price: Int(price.text!), currency: currency.text, stock: Int(stock.text!), discountedPrice: Int(discountedPrice.text!), images: ItemPostViewController.images, password: password.text)
        } catch {
            print("Input Error")
        }
        guard let itemPostInformation = itemPostInformation else { return }
        NetworkManager.shared.postItem(requestData: itemPostInformation) {[weak self] data in
      
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

extension ItemPostViewController: ModalPresentDelegate {
    func presentModalViewController(_ viewContorller: UIViewController, anitmated: Bool) {
        print("push2")
        viewContorller.modalPresentationStyle = .pageSheet
        self.present(viewContorller, animated: anitmated, completion: nil)
    }
}

extension ItemPostViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ItemPostViewController.images.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlusPhotoCollectionViewCell.identifier, for: indexPath) as? PlusPhotoCollectionViewCell else  {
            return UICollectionViewCell()
        }
        cell.modalPresentDelegate = self
        
        return cell
    }
    
}

extension ItemPostViewController: UICollectionViewDelegate {
    
}

extension ItemPostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: imageCollectionView.frame.height, height: imageCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
