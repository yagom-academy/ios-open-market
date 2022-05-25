//
//  RegisterProductViewController.swift
//  OpenMarket
//
//  Created by papri, Tiana on 18/05/2022.
//

import UIKit

class RegisterProductViewController: UIViewController {
    enum Section: Int, Hashable, CaseIterable, CustomStringConvertible {
        case image
        case text
        
        var description: String {
            switch self {
            case .image: return "Image"
            case .text: return "Text"
            }
        }
    }
    
    private let imagePicker = UIImagePickerController()
    private var images: [UIImage] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    private var collectionView: UICollectionView?
    private var collectionViewLayout: UICollectionViewLayout?
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        setUpNavigationItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewLayout = createLayout()
        
        configureHierarchy(collectionViewLayout: collectionViewLayout ?? UICollectionViewLayout())
        registerCell()
        setUpCollectionView()
        
        setUpImagePicker()
    }
}

extension RegisterProductViewController {
    private func setUpNavigationItem() {
        navigationItem.title = "상품등록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(touchUpDoneButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(touchUpCancelButton))
    }
    
    @objc private func touchUpDoneButton() {
        dismiss(animated: true)
    }
    
    @objc private func touchUpCancelButton() {
        dismiss(animated: true)
    }
}

extension RegisterProductViewController {
    private func setUpCollectionView() {
        collectionView?.dataSource = self
        collectionView?.delegate = self
    }
    
    private func registerCell() {
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView?.register(TextCell.self, forCellWithReuseIdentifier: "TextCell")
    }
    
    private func configureHierarchy(collectionViewLayout: UICollectionViewLayout) {
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height - 100), collectionViewLayout: collectionViewLayout)
        view.addSubview(collectionView ?? UICollectionView())
        layoutCollectionView()
    }
    
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            let section: NSCollectionLayoutSection
            
            if sectionKind == .image {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalWidth(0.4))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            } else if sectionKind == .text {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
            } else {
                fatalError("Unknown section!")
            }
            
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    private func layoutCollectionView() {
        guard let collectionView = collectionView else {
            return
        }
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

extension RegisterProductViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return images.count + 1
        } else if section == 1 {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else {
                return UICollectionViewCell()
            }
                        
            if images.count != indexPath.row {
                cell.plusButton.isHidden = true
                cell.imageView.isHidden = false
                guard let image = images[safe: indexPath.row] else {
                    return UICollectionViewCell()
                }
                cell.imageView.image = image
                return cell
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath) as? TextCell else {
                return UICollectionViewCell()
            }
            return cell
        }
    }
}

extension RegisterProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageCell else { return }
        if !cell.plusButton.isHidden {
            self.present(self.imagePicker, animated: true)
        }
    }
}

extension RegisterProductViewController {
    private func setUpImagePicker() {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
    }
}

extension RegisterProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        
        if let newImage = newImage {
            images.append(newImage)
        }
        
        picker.dismiss(animated: true)
    }
}
