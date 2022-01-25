import UIKit

class ManageProductViewController: UIViewController {
    private var keyboardHeight: CGFloat?
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    let stackView = ProductRegisterView()
    private lazy var initialHeight: CGFloat = {
        let initialHeight = UIScreen.main.bounds.height -
            self.view.safeAreaLayoutGuide.layoutFrame.origin.y
        return initialHeight
    }()
    private lazy var frameLayoutHeight: NSLayoutConstraint = NSLayoutConstraint(
        item: self.scrollView.frameLayoutGuide,
        attribute: .height,
        relatedBy: .equal,
        toItem: nil,
        attribute: .height,
        multiplier: 0,
        constant: 753)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureHierarchy()
        setDelegate()
        configureConstraint()
        configureNavigationBar()
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardAppear),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardDisappear),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

// MARK: View Configuration
    func configureHierarchy() {
        scrollView.addSubview(stackView)
        self.view.addSubview(scrollView)
    }

    func setDelegate() {
        stackView.setTextViewDelegate(delegate: self)
        stackView.setTextFieldDelegate(delegate: self)
    }

    private func configureConstraint() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(
                greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            frameLayoutHeight
        ])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.leadingAnchor,
                constant: 5
            ),
            stackView.trailingAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.trailingAnchor,
                constant: -5
            )
        ])
    }

    func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "완료",
            style: .done,
            target: self,
            action: #selector(touchUpDoneButton)
        )
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(touchUpCancelButton)
        )
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

// MARK: Target Method
    @objc func touchUpDoneButton() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func touchUpCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }

// MARK: Other Method
    func reduceFrameLayoutGuide() {
        frameLayoutHeight.constant = initialHeight - keyboardHeight!
    }

    func increaseFrameLayoutGuide() {
        frameLayoutHeight.constant = initialHeight
    }
}

// MARK: Text Field Delegate
extension ManageProductViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Text View Delegate
extension ManageProductViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .systemGray
            textView.text = "상품설명을 작성해 주세요. (최대 1000글자)"
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        guard let start = textView.selectedTextRange?.start else {
            return
        }
        let offset = textView.caretRect(for: start)
        let cursorOffsetY = offset.origin.y + textView.frame.origin.y + 22
        let targetOffsetY =
            offset.origin.y - frameLayoutHeight.constant + textView.frame.origin.y + 22

        if cursorOffsetY >= scrollView.frameLayoutGuide.layoutFrame.height {
            scrollView.contentOffset.y = targetOffsetY
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray {
            textView.textColor = .black
            textView.text = ""
        }

        guard let start = textView.selectedTextRange?.start else {
            return
        }

        let offset = textView.caretRect(for: start)
        let cursorOffsetY = offset.origin.y + textView.frame.origin.y + 22
        let targetOffsetY =
            offset.origin.y - frameLayoutHeight.constant + textView.frame.origin.y + 22

        if cursorOffsetY >= scrollView.frameLayoutGuide.layoutFrame.height {
            scrollView.contentOffset.y = targetOffsetY
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.textStorage.length + text.count > 1000 {
            return false
        }
        return true
    }

    @objc func keyboardAppear(_ sender: Notification) {
        if let keyboardFrame: NSValue =
            sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keboardRect = keyboardFrame.cgRectValue
            keyboardHeight = keboardRect.height
            reduceFrameLayoutGuide()
        }
    }

    @objc func keyboardDisappear() {
        increaseFrameLayoutGuide()
    }
}
