import UIKit

class OpenMarketTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(placeholder: String, keyboardType: UIKeyboardType = .default, hasToolBar: Bool) {
        super.init(frame: .zero)
        self.borderStyle = .roundedRect
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.font = .preferredFont(forTextStyle: .subheadline)
        if hasToolBar {
            self.inputAccessoryView = createToolBar()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("스토리보드 안써서 fatalError를 줬습니다.")
    }
    
    private func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        let leftSpcae = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneButton))
        
        toolBar.items = [leftSpcae, doneButton]
        toolBar.sizeToFit()
        return toolBar
    }
    
    @objc func didTapDoneButton() {
        self.resignFirstResponder()
    }
}
