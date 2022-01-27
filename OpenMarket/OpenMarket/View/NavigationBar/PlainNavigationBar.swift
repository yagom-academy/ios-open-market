import UIKit

class PlainNavigationBar: UIView {
    
    enum LayoutAttribute {
        static let navigationBarHeight: CGFloat = 50
        static let largeSpacing: CGFloat = 10
        static let smallSpacing: CGFloat = 5
        static let buttonTextStyle: UIFont.TextStyle = .body
        static let mainLabelTitleSize: CGFloat = 17 //body
    }
    
    private var leftButton: UIButton? = nil
    private var mainLabel: UILabel? = nil
    private var rightButton: UIButton? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureMainView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setLeftButton(title: String, action: Selector) {
        leftButton?.removeFromSuperview()
        let button = UIButton(type: .system)
        self.leftButton = button
        addSubview(button)
        configureLeftButton(title: title)
        leftButton?.addTarget(nil, action: action, for: .touchUpInside)
    }
    
    func setMainLabel(title: String) {
        mainLabel?.removeFromSuperview()
        let label = UILabel()
        self.mainLabel = label
        addSubview(label)
        configureMainLabel(title: title)
    }
    
    func setRightButton(title: String, action: Selector) {
        rightButton?.removeFromSuperview()
        let button = UIButton(type: .system)
        self.rightButton = button
        addSubview(button)
        configureRightButton(title: title)
        rightButton?.addTarget(nil, action: action, for: .touchUpInside)
    }
    
    private func configureMainView() {
        backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: topAnchor, constant: LayoutAttribute.navigationBarHeight)
        ])
    }
}

//MARK: - LeftButton
extension PlainNavigationBar {

    private func configureLeftButton(title: String) {
        guard let leftButton = leftButton else {
            return
        }
        
        leftButton.setTitle(title, for: .normal)
        leftButton.setTitleColor(.systemBlue, for: .normal)
        leftButton.titleLabel?.font = .preferredFont(forTextStyle: LayoutAttribute.buttonTextStyle)
        leftButton.titleLabel?.textAlignment = .left
        leftButton.titleLabel?.adjustsFontForContentSizeCategory = true
        leftButton.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

//MARK: - MainLabel
extension PlainNavigationBar {
    
    private func configureMainLabel(title: String) {
        guard let mainLabel = mainLabel else {
            return
        }
        
        mainLabel.text = title
        mainLabel.font = UIFont.dynamicBoldSystemFont(ofSize: LayoutAttribute.mainLabelTitleSize)
        mainLabel.adjustsFontForContentSizeCategory = true
        
        mainLabel.textAlignment = .center
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

//MARK: - RightButton
extension PlainNavigationBar {
    
    private func configureRightButton(title: String) {
        guard let rightButton = rightButton else {
            return
        }

        rightButton.setTitle(title, for: .normal)
        rightButton.setTitleColor(.systemBlue, for: .normal)
        rightButton.titleLabel?.font = .preferredFont(forTextStyle: LayoutAttribute.buttonTextStyle)
        rightButton.titleLabel?.textAlignment = .left
        rightButton.titleLabel?.adjustsFontForContentSizeCategory = true
        rightButton.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        rightButton.tintColor = .systemBlue
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
