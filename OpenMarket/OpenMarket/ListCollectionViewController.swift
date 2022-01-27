import UIKit

class ListCollectionViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Product>!
    weak var viewTransitionDelegate: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        create()
        organizeViewHierarchy()
        configure()
    }
    
    func applySnapShot(products: [Product]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(products)
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func create() {
        createCollectionView()
        createDataSource()
    }
    
    private func configure() {
        configureCollectionView()
        configureCollectionViewDelegate()
    }
    
    private func organizeViewHierarchy() {
        view.addSubview(collectionView)
    }
}

//MARK: - CollectionView
extension ListCollectionViewController {

    private func createCollectionView() {
        let layout =  UICollectionViewCompositionalLayout { (section, layoutEnvironment) in
            let appearance = UICollectionLayoutListConfiguration.Appearance.plain
            let configuration = UICollectionLayoutListConfiguration(appearance: appearance)
            
            return NSCollectionLayoutSection.list(using: configuration,
                                                  layoutEnvironment: layoutEnvironment)
        }
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
    }
    
    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - DataSoruce
extension ListCollectionViewController {
    
    typealias Product = NetworkingAPI.ProductListQuery.Response.Page

    private enum Section: Hashable {
        case main
    }

    private func createDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CollectionViewListCell, Product> {
            (cell, indexPath, item) in
        }
      
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
            cell.update(from: item)
            
            return cell
        }
    }
}

//MARK: - Delegate
extension ListCollectionViewController: UICollectionViewDelegate {
    
    private func configureCollectionViewDelegate() {
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let id = dataSource.itemIdentifier(for: indexPath)?.id else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        NetworkingAPI.ProductDeleteSecretQuery.request(session: URLSession.shared,
                                                       productId: id,
                                                       identifier: Vendor.identifier,
                                                       secret: Vendor.secret) {
            
            result in
            
            switch result {
            case .success(let data):
                print(String(decoding: data, as: UTF8.self))
                DispatchQueue.main.async {
                    self.viewTransitionDelegate?.navigationController?.pushViewController(ProductDetailViewController(), animated: true)
                }
            case .failure(let error):
                print(error.description)
            }
        }
        
        
    }
}
