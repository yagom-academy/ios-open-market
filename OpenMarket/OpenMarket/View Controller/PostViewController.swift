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
    
    let picker = UIImagePickerController()
    var images = [UIImage]()
    var tryAddCount = 0
    
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
    
    @objc func pickImage(_ sender: Any) {
        let alert = UIAlertController(title: "사진 불러오기", message: "아무래도 사진앨범이지?", preferredStyle: .actionSheet)
        
        let imageLibrary = UIAlertAction(title: "사진앨범", style: .default) { UIAlertAction in
            self.openImageLibrary()
        }
        
        let camera = UIAlertAction(title: "카메라", style: .default) { UIAlertAction in
            self.openCamera()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(imageLibrary)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func openImageLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        } else {
            let alert = UIAlertController(title: "카메라 접근 실패", message: "해당 기기로는 접근할 수 없습니다", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
        }
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
        if tryAddCount < 5 {
            let tapToAddImage = UITapGestureRecognizer(target: self, action: #selector(self.pickImage(_:)))
            typeCastedCell.addGestureRecognizer(tapToAddImage)
        }
        
        let layout = imageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = .zero
        layout.scrollDirection = .horizontal
        
        return cell
    }
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            images.insert(image, at: (images.count - 1))
            tryAddCount += 1
            
            if images.count > 5 {
                images.removeLast()
            }
            
            self.imageCollectionView.reloadData()
        }
        
        dismiss(animated: true, completion: nil)
    }
}
