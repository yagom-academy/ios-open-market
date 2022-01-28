//
//  PostViewController.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/21.
//

import UIKit

class PostViewController: UIViewController {
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var currencySelectButton: UISegmentedControl!
    @IBOutlet weak var bargainPriceTextField: UITextField!
    @IBOutlet weak var stockTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    let picker = UIImagePickerController()
    var images = [UIImage]()
    var tryAddImageCount = 0
    let textViewPlaceHolder = "등록하실 제품의 상세정보를 입력해주세요"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButtonImage()
        
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        self.imageCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "PostCollectionViewCell")
        picker.delegate = self
    }
    
    func addButtonImage() {
        guard let image = UIImage(named: "buttonImage") else {
            return
        }
        
        images.append(image)
    }
    
    func addPlaceHolderToTextView() {
        descriptionTextView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: Image Scroll View
extension PostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: imageCollectionView.frame.height, height: imageCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: imageCollectionView.frame.height, height: imageCollectionView.frame.height)
    }
}

// MARK: Collection View Data Source, Delegation
extension PostViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath)
        
        guard let typeCastedCell = cell as? PostCollectionViewCell else {
            return cell
        }
        
        cell.layer.borderColor = UIColor.systemGray3.cgColor
        cell.layer.borderWidth = 1.5
        
        typeCastedCell.image.image = images[indexPath.item]
        if tryAddImageCount < 5 {
            let tapToAddImage = UITapGestureRecognizer(target: self, action: #selector(self.pickImage(_:)))
            typeCastedCell.addGestureRecognizer(tapToAddImage)
        }
        
        let layout = imageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = .zero
        layout.scrollDirection = .horizontal
        
        return cell
    }
}
