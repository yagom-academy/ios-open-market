//
//  ItemAddViewController.swift
//  OpenMarket
//
//  Created by leewonseok on 2022/11/25.
//

import UIKit

class ItemAddViewController: UIViewController {
    
    let imageAddButton: UIButton = {
        let button = UIButton()
        button.setTitle("이미지 클릭ㅋ르릭", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        self.view.addSubview(imageAddButton)
        imageAddButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageAddButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageAddButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageAddButton.addTarget(self, action: #selector(presentAlbum), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = .systemBackground
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.view.backgroundColor = .systemBackground
    }
    
    
    private func configureNavigation() {
        self.navigationItem.title = "상품등록"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func doneButtonTapped() {
        print("Button Tapped")
    }
}

extension ItemAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func presentAlbum(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        
        present(vc, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            
        }
        dismiss(animated: true, completion: nil)
    }
}
