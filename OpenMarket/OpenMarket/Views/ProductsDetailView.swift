import UIKit

class ProductsDetailView: UIView {

    // MARK: - Properties
    
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
        
        addSubviews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func addSubviews() {
        addSubview(mainScrollView)
        
        mainScrollView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(itemImageScrollView)
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
