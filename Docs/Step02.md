## 2️⃣ STEP 2

### STEP 2 Questions & Answers

#### Q1. 한개의 Cell을 사용하여 두개의 CollectionLayout 생성시 발생하는 오토레이아웃 문제 
    

**기존 CollectionViewCell**
- 먼저 초기 화면이 구성이 되면, 컬렉션 뷰의 레이아웃을 ListLayout으로 설정하였습니다. 
- 하나의 CellRegistration 만을 바탕으로, Semented Control을 통해 ListLayout와 GridLayout를 전환하는 방식을 사용하였습니다.
    - segemented Control 전환시 List와 Grid 뷰의 axis를 변경해 주었습니다. 
    - 기본 Custom Cell은 UICollectionViewListCell을 채택한 UI입니다.
        - List의 accessory 설정을 활용하기 위해서 사용하였습니다.
    
**문제점**
- ListLayout을 위해 Cell 안의 UI 요소인 imageView의 width와 height의 Constraint를 설정해 두었습니다. 하지만 Grid Layout 화면으로의 전환시 이전에 설정한 Constraint가 그대로 남아 있어 Autolayout이 정상적으로 실행되지 않아 에러가 발생하였습니다. 
    
**시도한점**
- ListLayout 구현 과정에서 설정된 Constraint가 Grid Layout 화면으로의 전환시에 필요하지 않다면 제거하는 방법을 생각하였습니다. Segmented Control을 클릭시`collectionView.visibleCells.forEach` 코드를 통하여 forEach문 안에서 Constraint를 제거하려고 하였으나 Cell이 생성된 후에 Constraint를 제거하고자 하여 imageView에 설정된 constraint을 제거할 수 없었습니다.

**해결한점** 
- List와 Grid를 위한 View를 각각 두개로 만들어서 따로 Autolayout를 처리할 수 있도록 하였습니다. 

**궁금한점**
- Segmented Control을 클릭시에 Constraint를 다르게 적용하여 Auto-layout이 안전하게 처리될 방법이 있을까요?
- 똑같은 UIElement를 사용하는데 하나의 Cell로 Layout을 처리하는 것은 비효율적인 것일까요?
    
```swift
   @objc func segmentedValueChanged(_ sender:UISegmentedControl!) {
        let items = sender.selectedSegmentIndex
        
        switch items {
        case 0 :
            collectionView.setCollectionViewLayout(createListLayout(), animated: true)
            collectionView.visibleCells.forEach { cell in
                guard let cell = cell as? CustomCollectionViewCell else {
                    return
                }
            
                cell.contentView.layer.borderColor = .none
                cell.contentView.layer.borderWidth = 0
                cell.accessories = [.disclosureIndicator()]

                cell.configureStackView(of: .horizontal, textAlignment: .left)
            }
        case 1:
            collectionView.setCollectionViewLayout(createGridLayout(), animated: true)
            collectionView.visibleCells.forEach { cell in
                guard let cell = cell as? CustomCollectionViewCell else {
                    return
                }
                
                isSelected = true
                cell.accessories = [.delete()]
                cell.contentView.layer.borderColor = UIColor.black.cgColor
                cell.contentView.layer.borderWidth = 1
                
                cell.configureStackView(of: .vertical, textAlignment: .center)
            }
            
            collectionView.scrollToItem(at: IndexPath(item: -1, section: 0), at: .init(rawValue: 0), animated: false)
        default:
            break
        }
    }
    
    private func createListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 4, leading: 8, bottom: 4, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
```
    
#### A1. 

#### Q2. ListConfiguration이 아닐 때 separator 생성 방법
    
- list 형식의 CollectionView를 생성하는 가운데, list layout을 구성하는 방법은 listConfiguration을 통하여 간단하게 생성하는 방법 1과 compositional layout의 기본적인 형태로 item, group, section을 각각 설정하여, layout에 section을 넣어주어 이를 반환하는 방법 2가 있습니다.
    
- 코드
```swift
// 방법 1
private func createListLayout() -> UICollectionViewLayout {
    let config = UICollectionLayoutListConfiguration(appearance: .plain)
    
    return UICollectionViewCompositionalLayout.list(using: config)
}

// 방법 2
func createListLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
    let section = NSCollectionLayoutSection(group: group)
    let layout = UICollectionViewCompositionalLayout(section: section)
    
    return layout
}
```
    
- 이에 따라, 셀을 등록하는 방법에 있어서 listConfiguration을 사용한 방법1의 경우에는 UICollectionViewListCell을 사용하였습니다. 방법2에서는 커스텀 셀인 ListCollectionCell을 사용하여 직접 cell 내 UI들의 오토레이아웃을 잡아주어야 했습니다. 저희는 방법 2에 따라 진행하였는데, 방법 1인listConfiguration의 경우에는 셀 간의 구분선을 separatorLayoutGuide을 통하여 설정해줄 수 있는데, 방법 2의 경우에는 구분선을 그려주기 위한 메서드를 찾지 못하였습니다. 혹시 제이슨께서 이를 해결하는 방법을 알고 있으신지 질문드리고 싶습니다!

```swift
// 방법 1
private func configureListDataSource() {
    let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ProductEntity> { (cell, indexPath, item) in
        var content = cell.defaultContentConfiguration()
        
        content.image = item.thumbnailImage
        content.text = item.name
        content.secondaryText = String(item.originalPrice)
        content.imageProperties.maximumSize = CGSize(width: 60, height: 60)
        cell.contentConfiguration = content
        
        cell.separatorLayoutGuide.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        
        cell.accessories = [.disclosureIndicator()] 
    }
    
    listDataSource = UICollectionViewDiffableDataSource<Section2, ProductEntity>(collectionView: listCollectionView) {
        (collectionView: UICollectionView, indexPath: IndexPath, identifier: ProductEntity) -> UICollectionViewCell? in
        
        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
    }

    ...
}

// 방법 2
func configureListDataSource() {
    let cellRegistration = UICollectionView.CellRegistration<ListCollectionCell, ProductEntity> { (cell, indexPath, item) in
        cell.updateUI(item)
        cell.accessories = [.disclosureIndicator()]
    }
    
    listDataSource = UICollectionViewDiffableDataSource<Section, ProductEntity>(collectionView: listCollectionView) {
        (collectionView: UICollectionView, indexPath: IndexPath, identifier: ProductEntity) -> UICollectionViewCell? in
        
        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
    }
    
    ...
}
```
    
#### A2. 

#### Q3. 페이지 수에 따른 ListConfiguration cell과 custom cell의 오토레이아웃 에러 발생 유무
    `URL = "https://market-training.yagom-academy.kr/api/products?page_no=1&items_per_page=50"`

ListConfiguration Cell을 사용해 URL이 위의 코드(page 당 50개의 아이템을 불러오기)와 같이 주어졌을때 콘솔창에 수 많은 오토레이아웃 에러를 마주쳤습니다. 하지만 custom cell로 구현했을때는 오토레이아웃 문제 없이 사용할 수 있었는데, 이와 같은 차이가 발생하는 이유를 여쭈어보고 싶습니다.

    
#### A3. 

---
### STEP 2 TroubleShooting

#### T1. AutoLayout
    
- 하나의 Cell을 통하여 List에서 Grid로 전환 시의 AutoLayout을 설정하기 위한 방법을 고민하였습니다. 이에 이전에 설정한 List Layout의 Constraints을 제거한 후, Grid의 Constraints를 설정하려 하였습니다. 하지만, 이미 Cell이 생성된 이후에 Constraint를 제거하기 위한 시도를 하기 때문에 오토레이아웃이 정상적으로 설정되지 않는 문제가 발생되었습니다. 이에 notification 등을 통해 알림을 바탕으로 해결할 수 있을까도 고민해보았으나, 해당 방법은 오히려 과하다고 판단하여, 위의 문제를 해결하기 위하여 list, grid 레이아웃을 위한 각각의 셀을 만든 다음, 서로 다른 오토레이아웃을 적용해 문제를 해결하였습니다.

#### T2. Server Mapping Model - Entity - ViewModel
    
- 서버로부터 데이터를 요청하여, 이에 대한 응답을 받은 다음, 이를 JSON 데이터 형식으로 변환하여, 해당 데이터를 저장 및 관리하는 데이터의 집합을 만들어야 했습니다. 이에, 서버로부터 데이터를 요청하는 부분은 NetworkProvider 인스턴스를 생성하여 URL을 입력받아 requestAndDecode 메서드를 실행하였습니다. 다음으로, 응답을 받은 다음, 이를 JSON 데이터 형식으로 변환하는 부분은 아래와 같이 구현해보았습니다.

    - 서버로부터의 응답을 바탕으로 성공, 실패 케이스를 분기 처리
        - 서버로부터 성공적으로 응답을 받을시, STEP1에서 구현한 서버 매핑 모델인 ProductList 구조체에 담기
        - 서버로부터 응답을 받는데 실패할시, alert을 통해 에러 메세지를 present
    - ProductList로부터 필요한 데이터를 추출, 저장 및 관리하기 위해 ProductEntity 구조체를 생성
- 위의 방법들을 통하여 '서버 매핑 모델 - Entity - ViewModel'의 구조를 구현하였습니다.

---
    
### STEP 2 Concepts

- `Server Mapping Model`, `Entity`, `ViewModel`, `Hashable`
- `String`, `NSAttributedString`, `strikethroughStyle`
- `Int`, `NumberFormatter`
- `UISegmentedControl`, `addTarget`, `selectedSegmentIndex`
- `UICollectionView`, `UICollectionViewDiffableDataSource`
- `UICollectionViewCompositionalLayout`, `NSCollectionLayoutSize`, `NSCollectionLayoutItem`, `NSCollectionLayoutGroup`, `NSCollectionLayoutSection`
- `CellRegistration`, `dequeueConfiguredReusableCell`
- `layer`, `borderColor`, `borderWidth`, `cornerRadius`
- `NSDiffableDataSourceSnapshot`, `appendSections`, `appendItems`, `apply`
- `AutoLayout`, `prepareForReuse`
    
---
### STEP 2 Reviews And Updates
    
[STEP 2 Pull Request]()

---
