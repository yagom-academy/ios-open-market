import UIKit

class ProductRegisterViewController: UIViewController {
    
    enum ImageSection: Hashable {
        case main
    }
    
    var imageDataSource: UICollectionViewDiffableDataSource<ImageSection,UIImage>?
    var imagePicker = UIImagePickerController()
    var registerImage = RegisterImageView()
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        imagePicker.delegate = self
        configureCellDataSource()
        addSubviews()
        configureNavigationItem()
        configureUIItemLayouts()
        layoutMainVerticalScrollView()
        touchUpRegisterImage()
    }

    
    private func configureNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissModal))
        navigationItem.title = "상품수정"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(dismissModal))
    }
    
    @objc private func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: Configure CollectionView
    private func makeImageHorizontalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
    
    private func configureCellDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ImageCollectionViewCell, UIImage> {
            (cell, indexPath, item) in
        }
        
        imageDataSource = UICollectionViewDiffableDataSource<ImageSection, UIImage>(collectionView: imageCollectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
            cell.updateImage(to: item)
            
            return cell
        }
    }
    
    private func applyImageSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<ImageSection, UIImage>()
        snapshot.appendSections([.main])
        snapshot.appendItems(images)
        self.imageDataSource?.apply(snapshot, animatingDifferences: false)
        print(snapshot.itemIdentifiers)
    }
    //MARK: UI Item Property
    private lazy var mainScrollView: UIScrollView = {
        var scrollView = UIScrollView(frame: .zero)
        scrollView.addSubview(registerImage)
        scrollView.addSubview(imageCollectionView)
        scrollView.addSubview(textFieldStackView)
        scrollView.addSubview(textView)
        return scrollView
    }()
    
    private lazy var imageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeImageHorizontalLayout())

        return collectionView
    }()

    lazy var productNameTextField: UITextField = {
        var textfield = UITextField()
        textfield.placeholder = "상품명"
        textfield.keyboardType = .default
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = .white
        textfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textfield
    }()
    
    lazy var productPriceTextField: UITextField = {
        var textfield = UITextField()
        textfield.placeholder = "가격"
        textfield.keyboardType = .default
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = .white
        textfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textfield
    }()
    
    lazy var currencySegmentedControl: UISegmentedControl = {
        let items: [String] = ["KRW","USD"]
        var segmentedControl = UISegmentedControl(items: items)
        return segmentedControl
    }()
    
    lazy var priceSegmentedStackview: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [
       productPriceTextField,
       currencySegmentedControl
       ])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var discountedProductTextField: UITextField = {
        var textfield = UITextField()
        textfield.placeholder = "할인"
        textfield.keyboardType = .default
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = .white
        textfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textfield
    }()
    
    lazy var productStockTextField: UITextField = {
        var textfield = UITextField()
        textfield.placeholder = "재고"
        textfield.keyboardType = .default
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = .white
        textfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textfield
    }()
    
    lazy var textFieldStackView: UIStackView = {
       var stackView = UIStackView(
        arrangedSubviews:[
        productNameTextField,
        priceSegmentedStackview,
        discountedProductTextField,
        productStockTextField
        ]
       )
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()
    
    let textView: UITextView = {
        var textView = UITextView(frame: .zero)
        textView.backgroundColor = .white
        textView.insertText("상품의 정보를 입력하세요", alternatives: [""], style: .none)
        return textView
    }()
    //MARK: Action Method
    func touchUpRegisterImage() {
        registerImage.addIndicaterButton.addTarget(nil, action: #selector(updateImage), for: .touchUpInside)
    }
    
    @objc private func updateImage() {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    //MARK: AutoLayout
    private func addSubviews() {
        view.addSubview(mainScrollView)
    }
    
    private func configureUIItemLayouts() {
        layoutMainVerticalScrollView()
        layoutRegisterImage()
        layoutTextFieldStackView()
        layoutTextView()
        layoutImageCollectionView()
    }
    
    private func layoutRegisterImage() {
        registerImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            registerImage.leadingAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.leadingAnchor),
            registerImage.trailingAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.trailingAnchor),
            registerImage.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor, constant: 10),
            registerImage.bottomAnchor.constraint(equalTo: textFieldStackView.topAnchor, constant: -20),
            registerImage.widthAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.widthAnchor, multiplier: 0.35),
            registerImage.heightAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.heightAnchor, multiplier: 0.25)
        ])
    }
    
    private func layoutImageCollectionView() {
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: registerImage.trailingAnchor, constant: 5),
            imageCollectionView.bottomAnchor.constraint(equalTo: textFieldStackView.topAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.trailingAnchor)
        ])
        imageCollectionView.backgroundColor = .blue
    }
    
    private func layoutTextFieldStackView() {
        productNameTextField.translatesAutoresizingMaskIntoConstraints = false
        productPriceTextField.translatesAutoresizingMaskIntoConstraints = false
        currencySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        priceSegmentedStackview.translatesAutoresizingMaskIntoConstraints = false
        discountedProductTextField.translatesAutoresizingMaskIntoConstraints = false
        productStockTextField.translatesAutoresizingMaskIntoConstraints = false
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            productPriceTextField.leadingAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.leadingAnchor, constant: 10),
            productPriceTextField.trailingAnchor.constraint(equalTo: currencySegmentedControl.leadingAnchor, constant: -10),
        ])
        NSLayoutConstraint.activate([
            currencySegmentedControl.trailingAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.trailingAnchor, constant: -10),
        ])
        NSLayoutConstraint.activate([
            textFieldStackView.topAnchor.constraint(equalTo: registerImage.bottomAnchor, constant: 20),
            textFieldStackView.leadingAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.leadingAnchor, constant: 10),
            textFieldStackView.trailingAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    private func layoutMainVerticalScrollView() {
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func layoutTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo:mainScrollView.contentLayoutGuide.bottomAnchor),
            textView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 10)
        ])
    }
}

extension ProductRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
       
       if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
           newImage = possibleImage
       } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           newImage = possibleImage
       }
           
        images.append(newImage ?? UIImage(systemName: "circle")!)
        applyImageSnapShot()
        
        imagePicker.dismiss(animated: true, completion: nil)
       }
}
    
