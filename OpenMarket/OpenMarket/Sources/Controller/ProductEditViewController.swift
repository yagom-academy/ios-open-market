//
//  OpenMarket - ProductEditViewController.swift
//  Created by Zhilly, Dragon. 22/12/07
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class ProductEditViewController: UIViewController {
    var productID: Int? = nil
    private var imageArray: [URL?] = []
    private var keyHeight: CGFloat = 0
    @IBOutlet private weak var mainView: ProductEditView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        
        configureCollectionView()
        checkKeyboard()
        requestProduct(id: productID)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
    }
    
    private func requestProduct(id: Int?) {
        guard let id = id else { return }
        
        getProduct(id: id) { data in
            DispatchQueue.main.async { [self] in
                guard let images = data.images else { return }
                
                for item in images {
                    imageArray.append(URL(string: item.url))
                }
                
                mainView.configure(name: data.name,
                                   price: data.price,
                                   currency: data.currency,
                                   bargainPrice: data.bargainPrice,
                                   stock: data.stock,
                                   description: data.description)
                mainView.collectionView.reloadData()
            }
        }
    }
    
    private func checkKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func configureCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
        registerCellNib()
    }
    
    private func configureTextComponent() {
        mainView.productsContentTextView.delegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textFieldDidChange(_:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
    }
    
    private func registerCellNib() {
        let collectionViewCellNib = UINib(nibName: ImageCollectionViewCell.stringIdentifier(),
                                          bundle: nil)
        
        mainView.collectionView.register(collectionViewCellNib,
                                         forCellWithReuseIdentifier: ImageCollectionViewCell.stringIdentifier())
    }
    
    private func checkRequirements() throws {
        if let nameLength = mainView.productNameTextField.text?.count, nameLength < 3 {
            throw ProductPostRequirementError.productNameError
        }
        
        if mainView.productPriceTextField.hasText == false {
            throw ProductPostRequirementError.priceError
        }
        
        if let bargainPrice = mainView.productBargainTextField.text,
           let originPrice = mainView.productPriceTextField.text,
           bargainPrice > originPrice {
            throw ProductPostRequirementError.bargainPriceError
        }
        
        if mainView.productsContentTextView.text.count < 10 ||
            mainView.productsContentTextView.textColor == .lightGray {
            throw ProductPostRequirementError.descriptionError
        }
    }
    
    private func getProduct(id: Int, completion: @escaping ((Product) -> Void)) {
        let session: URLSessionProtocol = URLSession.shared
        let networkManager: NetworkRequestable = NetworkManager(session: session)
        
        networkManager.request(from: URLManager.product(id: id).url, httpMethod: .get, dataType: Product.self) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(_):
                break
            }
        }
    }
    
    private func patchProduct() {
        let session: URLSessionProtocol = URLSession.shared
        let networkManager: NetworkPatchable = NetworkManager(session: session)
        
        guard let name = mainView.productNameTextField.text,
              let description = mainView.productsContentTextView.text,
              let priceString = mainView.productPriceTextField.text,
              let price = Double(priceString) else { return }
        let currency = mainView.currencySelector.selectedSegmentIndex == 0 ? Currency.KRWString : Currency.USDString
        var param: ParamsProduct = ParamsProduct(name: name,
                                                  description: description,
                                                  price: price,
                                                  currency: currency,
                                                  secret: "rzeyxdwzmjynnj3f")
        
        if let bargainPriceString = mainView.productBargainTextField.text,
           let bargainPrice = Double(bargainPriceString),
           let stockString = mainView.productStockTextField.text,
           let stock = Int(stockString) {
            param.discountedPrice = bargainPrice
            param.stock = stock
        }
        
        if let productID = productID {
            networkManager.patch(to: URLManager.product(id: productID).url, params: param) { data in
            }
        }
    }
    
    @objc
    private func keyboardWillShow(_ sender: Notification) {
        guard let senderUserInfo = sender.userInfo else { return }
        let userInfo: NSDictionary = senderUserInfo as NSDictionary
        
        if let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            var keyboardHeight = keyboardRectangle.height
            
            if keyHeight == 0 {
                keyHeight = keyboardHeight
                view.frame.size.height -= keyboardHeight
            } else if keyHeight > keyboardHeight {
                keyboardHeight = keyboardHeight - keyHeight
                keyHeight = keyHeight + keyboardHeight
                view.frame.size.height -= keyboardHeight
            }
        }
    }
    
    @objc
    private func keyboardWillHide(_ sender: Notification) {
        view.frame.size.height += keyHeight
        keyHeight = 0
    }
    
    @objc
    private func textFieldDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            switch textField {
            case mainView.productNameTextField:
                if mainView.productNameTextField.text?.count ?? 0 > 100 {
                    mainView.productNameTextField.deleteBackward()
                }
            default:
                return
            }
        }
    }
}

extension ProductEditViewController: ProductDelegate {
    func tappedDismissButton() {
        self.dismiss(animated: true)
    }
    
    func tappedDoneButton() {
        do {
            try checkRequirements()
            patchProduct()
            let alert: UIAlertController = UIAlertController(title: "상품수정 완료",
                                                             message: nil,
                                                             preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "확인", style: .default) { _ in
                self.dismiss(animated: true)
            }
            
            alert.addAction(okAction)
            present(alert, animated: true)
        } catch {
            var errorMessage: String = .init()
            
            switch error {
            case ProductPostRequirementError.productNameError:
                errorMessage = "상품이름은 최소 3자, 최대 100자 입니다."
            case ProductPostRequirementError.priceError:
                errorMessage = "상품가격은 필수 입력입니다."
            case ProductPostRequirementError.descriptionError:
                errorMessage = "상품설명은 최소 10자, 최대 1000자 입니다."
            case ProductPostRequirementError.bargainPriceError:
                errorMessage = "할인가격은 상품가격을 넘을 수 없습니다."
            default :
                errorMessage = "\(error.localizedDescription)"
            }
            
            let alert: UIAlertController = UIAlertController(title: "상품수정 정보를 확인해주세요",
                                                             message: errorMessage,
                                                             preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "확인", style: .default)
            
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }
}


extension ProductEditViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainView.collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCollectionViewCell.stringIdentifier(),
            for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureImage(url: imageArray[indexPath.item])
        
        return cell
    }
}

extension ProductEditViewController: UICollectionViewDelegate {
    
}

extension ProductEditViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if mainView.productsContentTextView.hasText == false {
            mainView.productsContentTextView.text = "상품 설명을 입력해주세요.(1000글자 제한)"
            mainView.productsContentTextView.textColor = .lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if mainView.productsContentTextView.textColor == .lightGray {
            mainView.productsContentTextView.text = nil
            mainView.productsContentTextView.textColor = .black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = mainView.productsContentTextView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return changedText.count <= 1000
    }
}

extension ProductEditViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
