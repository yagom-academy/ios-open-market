import UIKit

class ProductModifyViewController: ProductManageViewController {
    private var productDetail: ProductDetail
    
    init(productDetail: ProductDetail) {
        self.productDetail = productDetail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("스토리보드 안써서 fatalError를 줬습니다.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        productRegisterManager.fetchRegisteredProductDetail(from: productDetail)        
    }
    
    private func configNavigationBar() {
        self.navigationItem.title = "상품수정"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didTapCancelButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneButton))
    }
    
    @objc private func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapDoneButton() {
        if !checkValidInput() {
            return
        }
        
        productRegisterManager.update(productId: productDetail.id)
        self.dismiss(animated: true, completion: nil)
    }
}
