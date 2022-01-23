import UIKit

class CustomNavigationBar: UIView {
    
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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(leftButtonTitle: String?, mainLabelTitle: String?, rightButtonTitle: String?) {
        self.init(frame: CGRect())
        
        create(leftButtonTitle: leftButtonTitle, mainLabelTitle: mainLabelTitle, rightButtonTitle: rightButtonTitle)
        organizeViewHierarchy()
        configure(leftButtonTitle: leftButtonTitle, mainLabelTitle: mainLabelTitle, rightButtonTitle: rightButtonTitle)
    }
    
    private func create(leftButtonTitle: String?, mainLabelTitle: String?, rightButtonTitle: String?) {
        if leftButtonTitle != nil {
            createLeftButton()
        }
        
        if mainLabelTitle != nil {
            createMainLabel()
        }
        
        if rightButtonTitle != nil {
            createRightButton()
        }
    }
    
    private func organizeViewHierarchy() {
        if let leftButton = leftButton {
            addSubview(leftButton)
        }
        
        if let mainLabel = mainLabel {
            addSubview(mainLabel)
        }
        
        if let rightButton = rightButton {
            addSubview(rightButton)
        }
    }
    
    private func configure(leftButtonTitle: String?, mainLabelTitle: String?, rightButtonTitle: String?) {
        configureMainView()
        
        if let leftButtonTitle = leftButtonTitle {
            configureLeftButton(title: leftButtonTitle)
        }
        
        if let mainLabelTitle = mainLabelTitle {
            configureMainLabel(title: mainLabelTitle)
        }
        
        if let rightButtonTitle = rightButtonTitle {
            configureRightButton(title: rightButtonTitle)
        }
    }
    
    private func configureMainView() {
        backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: topAnchor, constant: LayoutAttribute.navigationBarHeight)
        ])
    }
}

//MARK: - LeftButton
extension CustomNavigationBar {
    
    private func createLeftButton() {
        self.leftButton = UIButton()
    }
    
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
    
    func setLeftButtonAction(action: Selector) {
        leftButton?.addTarget(nil, action: action, for: .touchUpInside)
    }
}

//MARK: - MainLabel
extension CustomNavigationBar {
    
    private func createMainLabel() {
        self.mainLabel = UILabel()
    }
    
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
extension CustomNavigationBar {

    private func createRightButton() {
        self.rightButton = UIButton()
    }
    
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
    
    func setRightButtonAction(action: Selector) {
        rightButton?.addTarget(nil, action: action, for: .touchUpInside)
    }
}
