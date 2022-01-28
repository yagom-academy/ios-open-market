import UIKit

class AddImageHeaderView: UICollectionReusableView {
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(addButton)
        self.backgroundColor = .systemGray4
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: self.topAnchor),
            addButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            addButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        modifyButtonTitle(for: 0)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func modifyButtonTitle(for number: Int) {
        self.addButton.setTitle("\(number) / 5", for: .normal)
    }

    func addTargetToButton(selector: Selector) {
        self.addButton.addTarget(nil, action: selector, for: .touchUpInside)
    }
}
