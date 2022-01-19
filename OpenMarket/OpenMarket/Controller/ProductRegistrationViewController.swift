import UIKit

class ProductRegistrationViewController: UIViewController, UINavigationControllerDelegate {
    private let imagePickerController = UIImagePickerController()
    private var images = [UIImage]()
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesCollectionView.dataSource = self
        setUpImagePicker()
        setupNavigationBar()
    }

    @objc private func dismissProductRegistration() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func presentImagePicker() {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(dismissProductRegistration)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: nil
        )
        navigationItem.title = "상품등록"
    }
    
    private func setUpImagePicker() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
    }
}

extension ProductRegistrationViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let newImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            images.append(newImage)
            imagesCollectionView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ProductRegistrationViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return images.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UICollectionViewCell.reuseIdentifier,
            for: indexPath
        )
        cell.contentView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        if indexPath.section == 0 {
            let image = images[indexPath.item]
            let imageView = UIImageView(frame: cell.contentView.frame)
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            cell.contentView.addSubview(imageView)
        } else {
            let button = UIButton(type: .system)
            let image = UIImage(systemName: "plus")
            button.setTitle(nil, for: .normal)
            button.setImage(image, for: .normal)
            button.addTarget(self, action: #selector(presentImagePicker), for: .touchUpInside)
            button.backgroundColor = .opaqueSeparator
            cell.contentView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
            button.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
            button.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
        }
        return cell
    }
}
