import UIKit

class ProductAddScrollViewController: UIViewController {
    
    let button: UIButton = {
        var butoon = UIButton()
        butoon.tintColor = .black
        butoon.sizeToFit()
        butoon.setTitle("클릭되면 뒤로가용", for: .normal)
        return butoon
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        view.backgroundColor = .green
    }
    
    @objc private func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func didButtonTouched() {
        button.addTarget(nil, action: #selector(dismissModal), for: .touchUpInside)
    }
    
    private func autolayout() {
        button.translatesAutoresizingMaskIntoConstraints = false
        
    }
}

