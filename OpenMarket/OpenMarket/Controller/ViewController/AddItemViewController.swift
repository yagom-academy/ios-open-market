//
//  AddItemViewController.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/24.
//

import UIKit

struct ItemComponents {
    let name: String
    let price: Int
    let currency: String
    let discountedPrice: Int
    let stock: Int
    let descriptions: String
    let imageArray: [UIImage]
}

final class AddItemViewController: UIViewController {
    @IBOutlet private weak var itemImageCollectionView: UICollectionView!
    @IBOutlet private weak var curruncySegment: UISegmentedControl!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var discountPriceTextField: UITextField!
    @IBOutlet private weak var stockTextField: UITextField!
    @IBOutlet private weak var discriptinTextView: UITextView!
    @IBOutlet private weak var myScrollView: UIScrollView!
    private let networkHandler = NetworkHandler()
    private let maxImageCount = 5
    private let imagePicker = UIImagePickerController()
    private var imageArray: [UIImage] = [] {
        didSet {
            itemImageCollectionView.reloadData()
        }
    }
    private var currencyType: CurrencyType = .KRW
    
    private enum CurrencyType: String {
        case KRW
        case USD
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
    }
    
    private func setInitialView() {
        navigationItem.setLeftBarButton(makeBarButton(title: "Cancel",selector: #selector(touchCancelButton)), animated: true)
        navigationItem.setRightBarButton(makeBarButton(title: "Done", selector: #selector(touchDoneButton)), animated: true)
        itemImageCollectionView.dataSource = self
        itemImageCollectionView.delegate = self
        imagePicker.delegate = self
        itemImageCollectionView.register(UINib(nibName: "\(ItemImageCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(ItemImageCell.self)")
        setSegmentTextFont()
        setLayout()
        addKeyboardToolbar()
        addKeyboardObserver()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alert.addAction(yesAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func checkComponents() throws {
        if imageArray.count == 0 {
            throw PostItemError.imageError
        }
        
        if let name = nameTextField.text, name.replacingOccurrences(of: " ", with: "").count < 3 {
            throw PostItemError.nameError
        }
        
        guard let price = priceTextField.text else { return }
        guard let discountPrice = discountPriceTextField.text else { return }
        guard let priceInt = Int(price), priceInt > 0 else {
            throw PostItemError.priceError
        }
        
        if let discountPriceInt = Int(discountPrice) {
            if discountPriceInt > priceInt {
                throw PostItemError.discountPriceError
            }
            
            if discountPriceInt < 0 {
                throw PostItemError.discountPriceError
            }
            
        } else if !discountPrice.isEmpty {
            throw PostItemError.discountPriceError
        }
        
        guard let stock = stockTextField.text else { return }
        
        if let stockInt = Int(stock) {
            if stockInt < 0 {
                throw PostItemError.stockError
            }
        } else if !stock.isEmpty {
            throw PostItemError.stockError
        }
    }
    
    private func makeComponents() -> APIable {
        let name = nameTextField.text ?? ""
        let price = Int(priceTextField.text ?? "") ?? 0
        let currency = currencyType.rawValue
        let discountedPrice = Int(discountPriceTextField.text ?? "") ?? 0
        let stock = Int(stockTextField.text ?? "") ?? 0
        let descriptions = discriptinTextView.text
        let httpDescription = descriptions?.replacingOccurrences(of: "\n", with: "\\n") ?? ""
        
        let item = ItemComponents(name: name, price: price, currency: currency, discountedPrice: discountedPrice, stock: stock,  descriptions: httpDescription, imageArray: imageArray)
        
        return PostItemAPI(itemComponents: item)
    }
    
    @objc private func touchCancelButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func touchDoneButton() {
        do {
            try checkComponents()
            networkHandler.request(api: makeComponents()) { _ in }
            showAlert(message: "상품 등록이 완료되었습니다", action: popViewController)
        } catch {
            switch error {
            case PostItemError.imageError:
                showAlert(message: "이미지는 최소 1장 이상\n 등록 되어야 합니다", action: nil)
            case PostItemError.nameError:
                showAlert(message: "상품명을 3글자 이상 입력해주세요", action: nil)
            case PostItemError.priceError:
                showAlert(message: "상품 가격을 정확히 입력해 주세요", action: nil)
            case PostItemError.discountPriceError:
                showAlert(message: "할인 가격을 정확히 입력해 주세요", action: nil)
            case PostItemError.stockError:
                showAlert(message: "상품 수량을 정확히 입력해 주세요", action: nil)
            default:
                showAlert(message: "알 수 없는 오류", action: nil)
            }
        }
    }
    
    @IBAction private func changeCurrencySegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.currencyType = .KRW
        } else {
            self.currencyType = .USD
        }
    }
}
// MARK: - aboutCell
extension AddItemViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageArray.count < maxImageCount {
            return imageArray.count + 1
        } else {
            return maxImageCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ItemImageCell.self)", for: indexPath) as? ItemImageCell else {
            return ItemImageCell()
        }
        
        if indexPath.row == imageArray.count {
            cell.setPlusLabel()
        } else {
            cell.setItemImage(image: imageArray[indexPath.row])
        }
        
        return cell
    }
}

extension AddItemViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if imageArray.count < maxImageCount && indexPath.row == imageArray.count {
            let alert = UIAlertController(title: "", message: "사진 추가", preferredStyle: .actionSheet)
            let albumAction = UIAlertAction(title: "앨범", style: .default){_ in
                self.selectPhoto(where: .photoLibrary)
            }
            let cameraAction = UIAlertAction(title: "카메라", style: .default){_ in
                if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                    self.selectPhoto(where: .camera)
                } else {
                    self.showAlert(message: "카메라를 사용할 수 없습니다")
                }
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(cameraAction)
            alert.addAction(albumAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
        }
    }
}

//MARK: - imagePicker
extension AddItemViewController: UIImagePickerControllerDelegate {
    private func selectPhoto(where: UIImagePickerController.SourceType) {
        imagePicker.sourceType = `where`
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        guard let image = image?.resizeImage(kb: 300) else { return }
        
        imageArray.append(image)
        dismiss(animated: true)
    }
}

extension AddItemViewController: UINavigationControllerDelegate { }

//MARK: - aboutView
extension AddItemViewController {
    private func makeBarButton(title: String, selector: Selector) -> UIBarButtonItem {
        let barButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: selector)
        barButton.title = title
        return barButton
    }
    
    private func addKeyboardToolbar() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"), style: .plain, target: self, action: #selector(hideKeyboard))
        barButton.tintColor = .darkGray
        let emptySpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.setItems([emptySpace, barButton], animated: false)
        
        nameTextField.inputAccessoryView = toolBar
        priceTextField.inputAccessoryView = toolBar
        discountPriceTextField.inputAccessoryView = toolBar
        stockTextField.inputAccessoryView = toolBar
        discriptinTextView.inputAccessoryView = toolBar
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    private func setSegmentTextFont() {
        let font = UIFont.preferredFont(forTextStyle: .caption1)
        curruncySegment.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
    }
    
    private func setLayout() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: itemSize.widthDimension, heightDimension: itemSize.heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        itemImageCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
        myScrollView.contentInset = contentInset
        myScrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        myScrollView.contentInset = contentInset
        myScrollView.scrollIndicatorInsets = contentInset
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
