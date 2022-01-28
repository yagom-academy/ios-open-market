import UIKit

struct OpenMarketViewLayout {
    
    static let list: UICollectionViewCompositionalLayout = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }()
    
    static let grid: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 10)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        let halfWidth: CGFloat = UIScreen.main.bounds.width / 2.0
        layout.itemSize = CGSize(width: halfWidth - 15, height: 260)
        return layout
    }()
    
    static let productImages: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()
    
}
