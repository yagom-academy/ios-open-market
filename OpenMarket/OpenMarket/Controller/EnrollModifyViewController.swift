//
//  EnrollModifyViewController.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/10.
//

import UIKit

class EnrollModifyViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var postPatchButton: UIBarButtonItem!
    
    private let enrollModifyCollectionViewDataSource =
        EnrollModifyCollectionViewDataSource()
    private let enrollModifyCollectionViewDelegate =
        EnrollModifyCollectionViewDelegate()
    private let networkManager = NetworkManager()
    private let delegate = UIApplication.shared.delegate as? AppDelegate
    private let mainTitle = "상품"
    private var passAPI = MultipartFormData()
    var postAndPatchImpormation: Networkable?
    var topItemTitle: String = ""
    private let photoSelectButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        processCollectionView()
        initializePostAndPatchImpormation()
        setUpDataSourceContent()
        registeredIdetifier()
        decidedCollectionViewLayout()
        setUpPhotoSelectButton()
        setUpTitle()
        configureEnrollModifyDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.changeOrientation = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.changeOrientation = true
    }
    
    private func processCollectionView() {
        collectionView.dataSource = enrollModifyCollectionViewDataSource
        collectionView.delegate = enrollModifyCollectionViewDelegate
    }
    
    private func initializePostAndPatchImpormation() {
        if topItemTitle ==
            OpenMarketViewController.alertSelect.enroll {
            postAndPatchImpormation =
                PostImpormation(
                    parameter: passAPI.parameter,
                    image: enrollModifyCollectionViewDataSource.medias)
        } else {
            self.postAndPatchImpormation =
                PatchImpormation(id: passAPI.idParameter, parameter: passAPI.parameter,
                                 image: enrollModifyCollectionViewDataSource.medias)
        }
    }
    
    private func registeredIdetifier() {
        collectionView.register(
            EnrollModifyPhotoSeclectCell.self,
            forCellWithReuseIdentifier: EnrollModifyPhotoSeclectCell.identifier)
        collectionView.register(
            EnrollModifyPhotoCell.self,
            forCellWithReuseIdentifier: EnrollModifyPhotoCell.identifier)
        collectionView.register(
            EnrollModifyListCell.self,
            forCellWithReuseIdentifier: EnrollModifyListCell.identifier)
    }
    
    private func decidedCollectionViewLayout() {
        collectionView.collectionViewLayout = enrollModifyCollectionViewDataSource.createCompositionalLayout()
    }
    
    private func setUpPhotoSelectButton() {
        photoSelectButton.addTarget(self, action: #selector(movePhotoAlbum(_:)), for: .touchUpInside)
    }
    
    private func setUpTitle () {
        self.title = mainTitle + topItemTitle
        postPatchButton.title = topItemTitle
    }
    
    private func setUpDataSourceContent() {
        enrollModifyCollectionViewDataSource.placeholderList = postAndPatchImpormation?.placeholderList ?? [""]
        enrollModifyCollectionViewDataSource.photoSelectButton.append(photoSelectButton)
    }
    
    private func configureEnrollModifyDataSource() {
        enrollModifyCollectionViewDelegate.updateEnrollModifyCollectionViewDataSource(
            enrollModifyCollectionViewDataSource: enrollModifyCollectionViewDataSource)
    }
    
    @objc func movePhotoAlbum(_ sender: UIButton) {
        guard let convertPhotoAlbumViewController = storyboard?.instantiateViewController(identifier: PhotoAlbumViewController.identifier)
                as? PhotoAlbumViewController else {
            return
        }
        convertPhotoAlbumViewController.selected = { images in
            DispatchQueue.main.async {
                self.enrollModifyCollectionViewDataSource.photoAlbumImages += images
                self.enrollModifyCollectionViewDataSource.passPhotoImage(images: images)
                
                self.collectionView.reloadData()
            }
        }
        navigationController?.pushViewController(
            convertPhotoAlbumViewController, animated: true)
    }
    
    private func passParameter() {
        for (key, value) in enrollModifyCollectionViewDataSource.PassListCellData(
            collectionView: collectionView) {
            guard let number = PostAndPatchParameter(rawValue: key) else { return }
            switch number {
            case .id:
                passAPI.id = Int(value ?? "")
            case .title:
                passAPI.title = value
            case .currency:
                passAPI.currency = value
            case .price:
                passAPI.price = Int(value ?? "")
            case .discountedPrice:
                passAPI.discountedPrice = Int(value ?? "")
            case .stock:
                passAPI.stock = Int(value ?? "")
            case .descriptions:
                passAPI.descriptions = value
            case .password:
                passAPI.password =  value
            }
        }
    }
    
    @IBAction func enrollModifyButton(_ sender: Any) {
        passParameter()
        initializePostAndPatchImpormation()
        guard let essentialPublicElement =
                postAndPatchImpormation?.essentialPublicElement else {
            return
        }
        let textFieldDictionary =
        enrollModifyCollectionViewDataSource.PassListCellData(collectionView: collectionView)
        passAPI.judgeNil(
            essentialParameter: essentialPublicElement) { result in
            let stringResult = result as? String
            if result == nil || stringResult == "" {
                var keyArray: [String] = []
                textFieldDictionary.forEach { (key, value) in
                    if value != "" {
                        keyArray.append(key)
                    }
                }
                let alertArray =
                    essentialPublicElement.values.filter {!keyArray.contains($0)}
                let dialog = UIAlertController(title: "알림", message: "\(alertArray.description)을 넣어주세요", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                dialog.addAction(action)
                self.present(dialog, animated: true, completion: nil)
            }
        }
        guard let requestAPI =
                postAndPatchImpormation?.requestAPI else { return }
        networkManager.commuteWithAPI(api: requestAPI) { _ in }
        let dialog = UIAlertController(title: "알림", message: "등록되었습니다", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { _ in self.navigationController?.popViewController(animated: true)
        }
        dialog.addAction(action)
        
        self.present(dialog, animated: true, completion: nil)
    }
}
