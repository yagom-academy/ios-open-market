import UIKit

class ProductRegistrationViewController: UIViewController, UINavigationControllerDelegate {
    private let imagePickerController = UIImagePickerController()
    private var images = [UIImage]()
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesCollectionView.dataSource = self
        setUpImagePicker()
        setupNavigationBar()
        setupTextView()
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
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
    }
    
    private func setupTextView() {
        descriptionTextView.delegate = self
        descriptionTextView.text = "상품설명"
        descriptionTextView.textColor = .placeholderText
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.borderColor = CGColor(
            srgbRed: 0.8,
            green: 0.8,
            blue: 0.8,
            alpha: 1.0
        )
    }
    
    private func cropSquare(_ image: UIImage) -> UIImage? {
        let imageSize = image.size
        let shortLength = imageSize.width < imageSize.height ? imageSize.width : imageSize.height
        let origin = CGPoint(
            x: imageSize.width / 2 - shortLength / 2,
            y: imageSize.height / 2 - shortLength / 2
        )
        let size = CGSize(width: shortLength, height: shortLength)
        let square = CGRect(origin: origin, size: size)
        guard let squareImage = image.cgImage?.cropping(to: square) else {
            return nil
        }
        return UIImage(cgImage: squareImage)
    }
    
    @IBAction func tapBackground(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension ProductRegistrationViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard var newImage = info[.editedImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        let isSquare = newImage.size.width == newImage.size.height
        if isSquare == false {
            if let squareImage = cropSquare(newImage) {
                newImage = squareImage
            }
        }
        images.append(newImage)
        imagesCollectionView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ProductRegistrationViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if images.count < 5 {
            return 2
        } else {
            return 1
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if section == 0 {
            return images.count
        } else {
            return 1
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
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
            let constraints = [
                button.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                button.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                button.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
        }
        return cell
    }
}

extension ProductRegistrationViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "상품설명"
            textView.textColor = .placeholderText
        }
    }
}
