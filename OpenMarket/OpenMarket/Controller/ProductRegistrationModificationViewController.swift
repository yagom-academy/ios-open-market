//
//  ProductRegistrationModificationViewController.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/19.
//

import UIKit

private enum Section: Hashable {
  case images
}

class ProductRegistrationModificationViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var imageAdditionButton: UIButton!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var fixedPriceTextField: UITextField!
  @IBOutlet weak var bargainPriceTextField: UITextField!
  @IBOutlet weak var stockTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var currencySegmentControl: UISegmentedControl!
  
  private var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>? = nil
  private var images: [UIImage] = []
  private var imageAddition: [UIImage] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageDataSource()
    collectionView.delegate = self
  }
  
  @IBAction func imageAdditionButtonDidTap(_ sender: Any) {
    presentAlbum()
  }
  func presentAlbum(){
    let vc = UIImagePickerController()
    vc.sourceType = .photoLibrary
    vc.delegate = self
    vc.allowsEditing = true
    
    present(vc, animated: true, completion: nil)
  }
}

extension ProductRegistrationModificationViewController {
  func imageDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, UIImage>(collectionView: collectionView) {
      (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell in
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ProductImageRegistrationCell.reuseIdentifier,
        for: indexPath
      ) as? ProductImageRegistrationCell else {
        return UICollectionViewCell()
      }
      cell.imageView.image = itemIdentifier
      
      return cell
    }
    var snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>()
    snapshot.appendSections([.images])
    snapshot.appendItems(images)
    dataSource?.apply(snapshot, animatingDifferences: false)
  }

}

extension ProductRegistrationModificationViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let height = collectionView.frame.height
    let size = CGSize(width: height, height: height)
    
    return size
  }
}

extension ProductRegistrationModificationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[.editedImage] as? UIImage {
      images.append(image)
      imageDataSource()
    }
    dismiss(animated: true, completion: nil)
  }
}
