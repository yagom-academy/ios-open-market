import UIKit

class ImageScrollView: UIScrollView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    enum Mode {
        case register
        case modify
    }
    
    enum LayoutAttribute {
        static let largeSpacing: CGFloat = 10
        static let smallSpacing: CGFloat = 5
        static let minimumImageCount = 1
        static let maximumImageCount = 5
        static let maximumImageBytesSize = 300 * 1024
        static let recommendedImageWidth: CGFloat = 500
        static let recommendedImageHeight: CGFloat = 500
    }

    weak var viewController: UIViewController?
    let imageStackView = UIStackView()
    let imageAddingButton = UIButton()
    
    private let imagePickerController = UIImagePickerController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init() {
        self.init(frame: CGRect())
        organizeViewHierarchy()
        configure()
    }
    
    //MARK: - Open Method
    func add(imageView: UIImageView) {
        imageStackView.insertArrangedSubview(imageView, at: 0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: imageStackView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
    
    func update(image: UIImage, at: Int) {
        guard let imageView = imageStackView.arrangedSubviews[at] as? UIImageView else { return }
        imageView.image = image
    }
     
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
              let squareImage = editedImage.croppedToSquareForm() else {
                  print(OpenMarketError.conversionFail("basic UIImage", "cropped to square form").description)
                  return
              }

        if squareImage.size.width > LayoutAttribute.recommendedImageWidth {
            let resizedImage = squareImage.resized(
                width: LayoutAttribute.recommendedImageWidth,
                height: LayoutAttribute.recommendedImageHeight
            )
            add(imageView: UIImageView(image: resizedImage))
        } else {
            add(imageView: UIImageView(image: squareImage))
        }
        
        picker.dismiss(animated: true, completion: nil)
        hideImageAddingButtonIfNeeded()
    }
}

//MARK: - Private Method
extension ImageScrollView {
    private func organizeViewHierarchy() {
        addSubview(imageStackView)
        addSubview(imageAddingButton)
    }
    
    private func configure() {
        configureImageStackView()
        configureImageAddingButton()
        configureImagePickerController()
    }
    
    private func configureImageStackView() {
        imageStackView.axis = .horizontal
        imageStackView.spacing = LayoutAttribute.largeSpacing
        
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageStackView.heightAnchor.constraint(equalTo: heightAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func configureImageAddingButton() {
        imageAddingButton.backgroundColor = .systemGray5
        imageAddingButton.setImage(UIImage(systemName: "plus"), for: .normal)
        imageAddingButton.addTarget(self, action: #selector(presentImagePickerController), for: .touchUpInside)
        
        imageAddingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageAddingButton.heightAnchor.constraint(equalTo: imageStackView.heightAnchor),
            imageAddingButton.widthAnchor.constraint(equalTo: imageAddingButton.heightAnchor)
        ])
    }
    
    private func hideImageAddingButtonIfNeeded() {
        let images = imageStackView.arrangedSubviews.compactMap {
            $0 as? UIImageView
        }
        if images.count >= LayoutAttribute.maximumImageCount {
            imageAddingButton.isHidden = true
        }
    }
    
    @objc private func presentImagePickerController() {
        viewController?.present(imagePickerController, animated: true, completion: nil)
    }
    
    private func configureImagePickerController() {
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    }
}
