import UIKit

final class CenterAlignedTextField: UITextField {
    
    enum LayoutAttribute {
        static let inset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: LayoutAttribute.inset)
    }
    
    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: LayoutAttribute.inset)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: LayoutAttribute.inset)
    }
    
    private func configure() {
        layer.borderColor = UIColor.systemGray4.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        font = .preferredFont(forTextStyle: .callout)
        adjustsFontForContentSizeCategory = true
    }
}
