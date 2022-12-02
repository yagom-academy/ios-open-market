//  Created by Aejong, Tottale on 2022/11/22.

import UIKit

final class AddProductViewController: UIViewController {
    
    let addView = ProductAddView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        configureNavigationBar()
        configureDoneButton()
        configureCancelButton()
        configureView()
    }
    
    private func configureView() {
        self.view = addView
    }
    
    private func configureNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.shadowColor = .clear
        self.navigationItem.title = "상품등록"
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func configureDoneButton() {
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                      action: nil)
        self.navigationItem.rightBarButtonItem = doneItem
    }
    
    private func configureCancelButton() {
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
                                         action: #selector(cancelButtonPressed))
        self.navigationItem.leftBarButtonItem = cancelItem
    }
    
    @objc private func cancelButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}
