import UIKit

class ProductDetailViewController: UIViewController {
    
    private var backButtonItem: UIBarButtonItem!
    private var modificationButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        create()
        organizeViewHierarchy()
        configure()
    }
    
    private func create() {
        createBackButtonItem()
        createModificationButtonItem()
    }
    
    private func organizeViewHierarchy() {
        navigationItem.setLeftBarButton(backButtonItem, animated: false)
        navigationItem.setRightBarButton(modificationButtonItem, animated: false)
    }
    
    private func configure() {
        configureMainView()
        configureBackButtonItem()
        configureModificationButtonItem()
    }

    private func configureMainView() {
        view.backgroundColor = .systemBackground
    }
}

//MARK: - BackButtonItem
extension ProductDetailViewController {
    
    private func createBackButtonItem() {
        backButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(dismissProductDetailViewController))
    }
    
    @objc private func dismissProductDetailViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configureBackButtonItem() {
        
    }
}

//MARK: - ModificationButtonItem
extension ProductDetailViewController {
    
    private func createModificationButtonItem() {
        modificationButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(modifyOrDeleteProduct))
    }
    
    @objc private func modifyOrDeleteProduct() {
        
    }
    
    private func configureModificationButtonItem() {
        
    }
}

