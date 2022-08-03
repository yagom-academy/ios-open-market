import UIKit

class ProductsDetailView: UIView {

    // MARK: - Properties
    
    var imageCollectionView: UICollectionView?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>?
    
    let itemImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    let itemImageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    let currentPage: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "1/5"
        return label
    }()
    
    let itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = "상품 이름"
        return label
    }()
    
    let itemStockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .right
        label.textColor = .systemGray
        label.text = "상품 재고"
        return label
    }()
    
    let itemNameAndStockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "상품 가격"
        return label
    }()
    
    let itemSaleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "상품 할인금액"
        return label
    }()
    
    let itemPriceAndSaleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fill
        return stackView
    }()
    
    let itemDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.text = """
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        """
        return textView
    }()
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        congifureCollectionView()
        addSubviews()
        configureLayout()
        configureDataSoure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 1)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func congifureCollectionView() {
        imageCollectionView = UICollectionView(frame: bounds, collectionViewLayout: createLayout())
        imageCollectionView?.isPagingEnabled = true
        imageCollectionView?.alwaysBounceVertical = false
    }
    
    private func configureDataSoure() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, UIImage> { (cell, indexPath, item) in
            let imageView = UIImageView(image: item)
            cell.contentView.addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.heightAnchor.constraint(equalTo: cell.contentView.heightAnchor).isActive = true
            imageView.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor).isActive = true
            
            cell.backgroundColor = .systemRed
        }
        
        guard let imageCollectionView = imageCollectionView else { return }
        dataSource = UICollectionViewDiffableDataSource<Section, UIImage>(collectionView: imageCollectionView)
        { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    func applySnapshot(using imagesUrl: [Images]) {
        self.snapshot.appendSections([.main])
        var images: [UIImage] = []
        imagesUrl.forEach {
            guard let imageUrl = URL(string: $0.url),
                  let imageData = try? Data(contentsOf: imageUrl),
                  let image = UIImage(data: imageData) else { return }
            images.append(image)
        }
        
        self.snapshot.appendItems(images)
        dataSource?.apply(snapshot)
    }
    
    func addSubviews() {
        addSubview(mainScrollView)
        
        mainScrollView.addSubview(mainStackView)
                
        mainStackView.addArrangedSubview(itemImageScrollView)
        mainStackView.addArrangedSubview(imageCollectionView!)
        mainStackView.addArrangedSubview(currentPage)
        mainStackView.addArrangedSubview(itemNameAndStockStackView)
        mainStackView.addArrangedSubview(itemPriceAndSaleStackView)
        mainStackView.addArrangedSubview(itemDescriptionTextView)
        
        itemImageScrollView.addSubview(itemImageStackView)
        
        itemNameAndStockStackView.addArrangedSubview(itemNameLabel)
        itemNameAndStockStackView.addArrangedSubview(itemStockLabel)
        
        itemPriceAndSaleStackView.addArrangedSubview(itemPriceLabel)
        itemPriceAndSaleStackView.addArrangedSubview(itemSaleLabel)
    }
    
    func configureLayout() {
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            mainScrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            mainStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageCollectionView!.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3)
        ])
        
        
        NSLayoutConstraint.activate([
            itemImageScrollView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3)
        ])
        
        NSLayoutConstraint.activate([
            itemImageStackView.topAnchor.constraint(equalTo: itemImageScrollView.topAnchor),
            itemImageStackView.bottomAnchor.constraint(equalTo: itemImageScrollView.bottomAnchor),
            itemImageStackView.leadingAnchor.constraint(equalTo: itemImageScrollView.leadingAnchor),
            itemImageStackView.trailingAnchor.constraint(equalTo: itemImageScrollView.trailingAnchor),
            itemImageStackView.heightAnchor.constraint(equalTo: itemImageScrollView.heightAnchor)
        ])
    }
    
    func makeimageView(url: String) {
        guard let url = URL(string: url),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else { return }
        let imageView = UIImageView(image: image)
        itemImageStackView.addArrangedSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: itemImageScrollView.widthAnchor).isActive = true
    }
    
    func setProductInfomation(data: Page) {
        guard let priceText = numberFormatter.string(for: data.price),
              let saleText = numberFormatter.string(for: data.price - data.discountedPrice),
              let images = data.images else { return }
        
        images.forEach { image in
            makeimageView(url: image.url)
        }
        currentPage.text = "\(1)/\(itemImageStackView.arrangedSubviews.count)"
        itemNameLabel.text = data.name
        if data.discountedPrice <= 0 {
            itemPriceLabel.text = "\(data.currency) \(priceText)"
        } else {
            let salePrice = "\(data.currency) \(priceText)".strikeThrough()
            itemPriceLabel.attributedText = salePrice
            itemPriceLabel.textColor = .systemRed
            itemSaleLabel.text = "\(data.currency) \(saleText)"
        }
        itemStockLabel.text = "\(data.stock)"
        guard let description = data.description else { return }
        itemDescriptionTextView.text = "\(description)"
    }
}
