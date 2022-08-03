import UIKit

class ProductsDetailView: UIView {

    // MARK: - Properties
    
    private var imageCollectionView: UICollectionView?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>?
    
    let currentPage: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    let itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    let itemStockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .right
        label.textColor = .systemGray
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
        return label
    }()
    
    let itemSaleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
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
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, offset, env) in
            guard let self = self,
                  let imageCollectionView = self.imageCollectionView else { return }

            let currentPageNumber = Int(offset.x / imageCollectionView.frame.size.width) + 1
            let totalPage = self.snapshot.numberOfItems
            self.currentPage.text = "\(currentPageNumber)/\(totalPage)"
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func congifureCollectionView() {
        imageCollectionView = UICollectionView(frame: bounds, collectionViewLayout: createLayout())
        imageCollectionView?.decelerationRate = .fast
        imageCollectionView?.alwaysBounceVertical = false
    }
    
    private func configureDataSoure() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, UIImage> { (cell, indexPath, item) in
            let imageView = UIImageView(image: item)
            
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            cell.contentView.addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.heightAnchor.constraint(equalTo: cell.contentView.heightAnchor).isActive = true
            imageView.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor).isActive = true
        }
        
        guard let imageCollectionView = imageCollectionView else { return }
        dataSource = UICollectionViewDiffableDataSource<Section, UIImage>(collectionView: imageCollectionView)
        { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func applySnapshot(using imagesUrl: [Images]) {
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

        guard let imageCollectionView = imageCollectionView else { return }
        mainStackView.addArrangedSubview(imageCollectionView)
        mainStackView.addArrangedSubview(currentPage)
        mainStackView.addArrangedSubview(itemNameAndStockStackView)
        mainStackView.addArrangedSubview(itemPriceAndSaleStackView)
        mainStackView.addArrangedSubview(itemDescriptionTextView)
        
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
        
        guard let imageCollectionView = imageCollectionView else { return }
        NSLayoutConstraint.activate([
            imageCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3)
        ])
    }
    
    func setProductInfomation(data: Page) {
        guard let priceText = numberFormatter.string(for: data.price),
              let saleText = numberFormatter.string(for: data.price - data.discountedPrice),
              let images = data.images else { return }
        
        applySnapshot(using: images)
        
        currentPage.text = "\(1)/\(images.count)"
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
