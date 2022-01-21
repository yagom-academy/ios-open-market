import UIKit

class ProductAddScrollViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissModal))
        layout()
        navigationItem.title = "재고수정"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(dismissModal))
    }
    
    @objc private func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
//    private lazy var imageCollectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: Int(view.frame.width * 0.25), height: Int(view.frame.width*0.25)), collectionViewLayout: makeImageHorizontalLayout())
//
//
//        return collectionView
//    }()
//
//    private func makeImageHorizontalLayout() -> UICollectionViewLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)
//
//        let section = NSCollectionLayoutSection(group: group)
//
//        let layout = UICollectionViewCompositionalLayout(section: section)
//
//        return layout
//    }
    
    lazy var productNameTextField: UITextField = {
        var textfield = UITextField()
        textfield.placeholder = "상품명"
        textfield.keyboardType = .default
        textfield.backgroundColor = .white
        textfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textfield
    }()
    
    lazy var productPriceTextField: UITextField = {
        var textfield = UITextField()
        textfield.placeholder = "가격"
        textfield.keyboardType = .default
        textfield.backgroundColor = .white
        textfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textfield
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let items: [String] = ["KRW","USD"]
        var segmentedControl = UISegmentedControl(items: items)
        return segmentedControl
    }()
    
    lazy var priceSegmentedStackview: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [
       productPriceTextField,
       segmentedControl
       ])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var discountedProductTextField: UITextField = {
        var textfield = UITextField()
        textfield.placeholder = "할인"
        textfield.keyboardType = .default
        textfield.backgroundColor = .white
        textfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textfield
    }()
    
    lazy var productStockTextField: UITextField = {
        var textfield = UITextField()
        textfield.placeholder = "재고"
        textfield.keyboardType = .default
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
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        return stackView
    }()
    
    let textView: UITextView = {
        var textView = UITextView(frame: .zero)
        textView.backgroundColor = .white
        textView.insertText("상품의 정보를 입력하세요", alternatives: [""], style: .none)
        return textView
    }()
    
    private func layout() {
        view.addSubview(productPriceTextField)
        view.addSubview(segmentedControl)
        view.addSubview(productNameTextField)
        view.addSubview(discountedProductTextField)
        view.addSubview(productStockTextField)
        view.addSubview(textFieldStackView)
        view.addSubview(textView)

        productPriceTextField.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        productNameTextField.translatesAutoresizingMaskIntoConstraints = false
        discountedProductTextField.translatesAutoresizingMaskIntoConstraints = false
        productStockTextField.translatesAutoresizingMaskIntoConstraints = false
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            productPriceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            productPriceTextField.trailingAnchor.constraint(equalTo: segmentedControl.leadingAnchor, constant: -10),
        ])
        NSLayoutConstraint.activate([
           segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
        NSLayoutConstraint.activate([
            textFieldStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            textFieldStackView.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -50)
        ])
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // safeArea 구하기
    // textView frame -> 삭제 -> 어차피 오토레이아웃이 잡아 주니까
    // textfield들 높이 잡아주기 -> 화면이 줄어들면서 크기가 변할 수 있으니까
    // add subview를 했나 확인하기
    // 바텀과 트레일링에는 음수 constant 주기 
    
}

