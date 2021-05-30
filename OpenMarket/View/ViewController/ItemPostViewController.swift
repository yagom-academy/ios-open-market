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
    static var images: [Int : String] = [:]
    var requestData: Request?
    var screenMode: ScreenMode?
    var detailItemData: InformationOfItemResponse?
    var detailViewController: DetailItemViewController?
    static let storyboardID = "ItemPostViewController"
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitle("취소", for: .normal)
        button.addTarget(self, action: #selector(cancelItemPost), for: .touchDown)
        return button
    }()
    private lazy var compeleteButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        switch screenMode {
        case .register:
            button.addTarget(self, action: #selector(postItem), for: .touchDown)
        case . edit:
            button.addTarget(self, action: #selector(editItem), for: .touchDown)
        case .none:
            return button
        }
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptions.delegate = self
        setUpCollectionView()
        initNavigationBar()
        setUpTextFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ModalPhotoViewController.selectedImageCount = 0
        ItemPostViewController.images = [:]
    }
    
    private func initNavigationBar() {
        switch screenMode {
        case .register:
            compeleteButton.setTitle("등록", for: .normal)
            self.navigationItem.title = "상품등록"
        case .edit:
            compeleteButton.setTitle("수정", for: .normal)
            self.navigationItem.title = "상품수정"
        case .none:
            return
        }
        cancelButton.setTitle("취소", for: .normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: compeleteButton)
    }
    
    private func setUpCollectionView() {
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        registerCollectionViewCellNib()
    }
    
    private func setUpTextFields(){
        guard let detailItemData = detailItemData else { return }
        itemPostTitle.text = detailItemData.title
        currency.text = detailItemData.currency
        price.text = String(detailItemData.price)
        if let discountedPrice = detailItemData.discountedPrice {
            self.discountedPrice.text = String(discountedPrice)
        }
        descriptions.textColor = .black
        descriptions.text = detailItemData.descriptions
        stock.text = String(detailItemData.stock)
    }
    
    private func registerCollectionViewCellNib() {
        let PhotoCollectionViewCellNib = UINib(nibName: PhotoCollectionViewCell.identifier, bundle: nil)
        let PlusPhotoCollectionViewCellNib = UINib(nibName: PlusPhotoCollectionViewCell.identifier, bundle: nil)
        self.imageCollectionView.register(PhotoCollectionViewCellNib, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        self.imageCollectionView.register(PlusPhotoCollectionViewCellNib, forCellWithReuseIdentifier: PlusPhotoCollectionViewCell.identifier)
    }
    
    private func convertDictionaryToArray(_ dictionary:[Int:String]) -> [String]{
        var array: [String] = []
        guard dictionary.count > 0 else { return [] }
        for key in 0...dictionary.count-1 {
            guard let value = dictionary[key] else { return [] }
            array.append(value)
        }
        return array
    }
    
    @objc private func cancelItemPost(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func postItem(_ sender: Any) {
        do {
            requestData = try Request(path: Path.item, httpMethod: HTTPMethod.POST, title: itemPostTitle.text, descriptions: descriptions.text, price: Int(price.text!), currency: currency.text, stock: Int(stock.text!), discountedPrice: Int(discountedPrice.text!), images: convertDictionaryToArray(ItemPostViewController.images), password: password.text)
        } catch {
            print("Input Error")
        }
        guard let itemPostInformation = requestData else { return }
        NetworkManager.shared.postItem(requestData: itemPostInformation)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func editItem(_ sender: Any) {
        do {
            requestData = try Request(path: Path.Item.id,
                                      httpMethod: HTTPMethod.PATCH,
                                      title: itemPostTitle.text,
                                      descriptions: descriptions.text,
                                      price: Int(price.text!),
                                      currency: currency.text,
                                      stock: Int(stock.text!),
                                      discountedPrice: Int(discountedPrice.text!),
                                      images: convertDictionaryToArray(ItemPostViewController.images),
                                      password: password.text)
        } catch {
            print("Input Error")
        }
        guard let itemEditInformation = requestData else { return }
        guard let detailItemData = detailItemData else { return }
        NetworkManager.shared.patchEditItemData(requestData: itemEditInformation, postId: detailItemData.id) { [weak self] data in
            do {
                let data = try JSONDecoder().decode(InformationOfItemResponse.self, from: data!)
                guard let detailViewController = self?.detailViewController else { return }
                detailViewController.detailItemData = data
                detailViewController.isItemPostEdited = true
            } catch {
                print("Failed to decode")
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

extension ItemPostViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        setUpTextView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            setUpTextView()
        } else if textView.text != "", textView.text != "제품 상세 설명" {
            requestData?.descriptions = textView.text
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func setUpTextView() {
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
        viewContorller.modalPresentationStyle = .pageSheet
        self.present(viewContorller, animated: anitmated, completion: nil)
    }
}

extension ItemPostViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ItemPostViewController.images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlusPhotoCollectionViewCell.identifier, for: indexPath) as? PlusPhotoCollectionViewCell else  {
                return UICollectionViewCell()
            }
            cell.modalPresentDelegate = self
            cell.imageCollectionView = self.imageCollectionView
            cell.currentPhotoCount.text = "\(ItemPostViewController.images.count)/5"
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else  {
                return UICollectionViewCell()
            }
            
            guard let imageName = ItemPostViewController.images[indexPath.item-1] else { return cell }
            if let uiImage = UIImage(named: imageName) {
                cell.itemImage.image = uiImage
                return cell
            }
            DispatchQueue.global().async {
                do {
                    guard let imageURL = URL(string: imageName) else { return }
                    let imageData = try Data(contentsOf: imageURL)
                    DispatchQueue.main.async {
                        cell.itemImage.image = UIImage(data: imageData)
                    }
                } catch {
                    print("ItemPostViewController Invalid URL")
                    return
                }
            }
            
            return cell
        }
        
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
