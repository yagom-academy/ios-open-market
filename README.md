# 🏪 Open Market 🏪
<br>

## 📜 목차
1. [소개](#-소개)
2. [개발환경 및 라이브러리](#-개발환경-및-라이브러리)
3. [팀원](#-팀원)
4. [타임라인](#-타임라인)
5. [UML](#-UML)
6. [실행화면](#-실행-화면)
7. [트러블 슈팅 및 고민](#-트러블-슈팅-및-고민)
8. [참고링크](#-참고-링크)

<br>

## 🗣 소개
[Ayaan🦖](https://github.com/oneStar92), [준호](https://github.com/junho15) 의 간단한 마켓기능을 이용할 수 있는 프로젝트 입니다.
Mordern Collection View 활용하여 LIST와 GRID 형태로 상품 목록 화면을 보여줍니다.

***개발 기간 : 2022-11-14 ~ 2022-12-02***

<br>

## 💻 개발환경 및 라이브러리
[![iOS](https://img.shields.io/badge/iOS_Deployment_Target-14.0-blue)]()
[![swift](https://img.shields.io/badge/Xcode_Compatible-9.3-orange)]()

<br>

## 🧑 팀원
|Ayaan|준호|
|:---:|:---:|
|<img src= "https://i.imgur.com/Unq1bdd.png" width ="200"/>|<img src = "https://camo.githubusercontent.com/a482a55a5f5456520d73f6c2debdd13375430060d5d1613ca0c733853dedacc0/68747470733a2f2f692e696d6775722e636f6d2f436558554f49642e706e67" width=200 height=200>|

<br>

## 🕖 타임라인

### Step 1

- 2022.11.14
    - Page Type 구현
    - Product Type 구현
    - Currency Type 구현
- 2022.11.15
    - Page Unit Test
    - OpenMarket API와 네트워크 구현
        - OpenMarket API Health 조회
        - OpenMarket API 상품 리스트 조회
        - OpenMarket API 상품 상세 조회
    - ProductImage Type 구현
    - Vendor Type 구현
- 2022.11.16
    - 네트워크 기능 프로토콜화
    - Test Double을 통해 구현된 네트워크 Test
        - RequestedDummyData 구현
        - StubURLSession 구현
        - StubURLSessionDataTask 구현
        - FakeURLSession 구현
- 2022.11.19
    - OpenMarketError Type에 errorDescription 기능 
    
### Step 2 

- 2022.11.22
    - ProductListCell 구현
    - OpenMarketCollectionView 구현
    - ProductGridCell 구현
    - SegmentedControl 구현
    - Image Cache 구현
    - 상품 등록 버튼 구현
    - 로딩창 구현
- 2022.11.23
    - Image Cache 구현
    - 상품 등록 버튼 구현
    - 로딩창 구현
- 2022.11.25
    - GridLayout 가변 높이 구현

### Step 3

- 2022.11.29
    - ProductInformationView 구현
    - UpdateViewController 구현
- 2022.11.30
    - ItemPickerCollectionView 구현
    - ViewContainer 구현
    - ImagePickerController 구현
- 2022.12.02
    - OpenMarketAPI 구현
    - NetworkManager 구현

<br>

## 📊 UML

### Model

<img src="https://i.imgur.com/omNAx4w.jpg" width="500">

### Network

<img src="https://i.imgur.com/ZpuPL5o.jpg" width="500px">

<br>

## 💻 실행 화면

|List|Grid|
|:---:|:---:|
|<img src="https://i.imgur.com/zbf016U.gif" width="400">|<img src="https://i.imgur.com/OmFmQEU.gif" width="400">|

|LIST GRID 전환|등록 화면|수정 화면|
|:---:|:---:|:---:|
|<img src="https://i.imgur.com/sm69aR6.gif" width="200">|추후 작성|추후 작성|

|삭제|페이지 네이션|리스트 새로고침|
|:---:|:---:|:---:|
|추후 작성|추후 작성|추후 작성|

<br>

## 🎯 트러블 슈팅 및 고민

### Decodable Model
|상품 리스트 조회시 아이템|상품 상세 조회시 아이템|
|:---:|:---:|
|![](https://i.imgur.com/mnpGzkb.png)|![](https://i.imgur.com/GfPoqcb.png)|

- OpenMarket API에서 상품 리스트 조회시 전달되는 아이템과 와 상품 상세 조회시 전달되는 아이템의 프로퍼티가 서로 달라서 하나의 Model로는 데이터를 불러올 수 없는 문제가 있었습니다.
- 구현된 Model에서 서로 상이한 부분을 Optional로 지정해 줌으로써 해당 문제를 해결했습니다.

<details>
<summary>코드 보기</summary>
<div markdown="1">
    
```swift
    struct Product: Decodable {
        let id, vendorID: Int
        let name, thumbnail: String
        let description: String? // 옵셔널 타입
        let currency: Currency
        let price, bargainPrice, discountedPrice: Double
        let stock: Int
        let createdAt, issuedAt: String
        let images: [ProductImage]? // 옵셔널 타입
        let vendor: Vendor? // 옵셔널 타입
```
    
</div>
</details>

<br>

### Encodable Model
- OpenMarket API에 POST, PATCH 작업을 수행할 때 JSON Data에 `secret` 또한 입력해 줘야 하는 문제가 생겼습니다.
- `Product`에 `secret`을 프로퍼티로 소유하는 것은 `Product`의 역활이 아니라고 생각되었습니다. 
- POST, PATCH만을 위한 Model을 만들어서 해당 문제를 해결하고자 했으나, 이러한 방향성은 올바른 설계가 아니라고 생각되어, `Product`의 `encode(to:)`를 직접 구현해 secret을 같이 encode할 수 있도록해 해당 문제를 해결하였습니다.

<details>
<summary>코드 보기</summary>
<div markdown="1">
    
```swift
    extension Product: Encodable {
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.name, forKey: .name)
            try container.encodeIfPresent(self.description, forKey: .description)
            try container.encode(self.currency, forKey: .currency)
            try container.encode(self.price, forKey: .price)
            try container.encode(self.discountedPrice, forKey: .discountedPrice)
            try container.encode(self.stock, forKey: .stock)
            try container.encode("xwxdkq8efjf3947z", forKey: .secret)
        }
    }
```

</div>
</details>

<br>

### NetWork 통신 역할
- URLSession에 API 통신과 관련된 기능을 extension을 통해 구현했었습니다. POP의 관점에서 구현해 보고자하여 기능별로 프로토콜을 만들어서 `URLSession` 이 채택하도록 구현했습니다.
- 하지만, URLSession이 OpenMarketAPI의 작업들을 메서드로 가지고 있는 것은 URLSession의 역할이 아니라고 생각했습니다.
- NetworkManager Type이 URLSession을 이용해 네트워크 통신을 하도록 구현했습니다.
- NetworkManager는 생성될 때 OpenMarketAPI를 주입받으며 그에 따른 네트워크 작업을 수행합니다.

<details>
<summary>코드 보기</summary>
<div markdown="1">
    
```swift
    // 수정 전
    extension URLSession: OpenMarketURLSessionProtocol { }
    extension URLSession: OpenMarketHealthFetchable { }
    extension URLSession: OpenMarketPageFetchable { }
    extension URLSession: OpenMarketProductFetchable { }
    
    // 수정 후
    struct NetworkManager {
        let openMarketAPI: OpenMarketAPI
```
    
</div>
</details>

<br>

### List Cell AutoLayout
|Before|After|Before|After|
|:---:|:---:|:---:|:---:|
|<img src= "https://i.imgur.com/1tkjlgI.png" width ="200"/>|<img src= "https://i.imgur.com/Mat0GIj.png" width ="200"/>|<img src= "https://i.imgur.com/HXruN8b.png" width ="200"/>|<img src= "https://i.imgur.com/Md9GgSX.png" width ="200"/>|

- View가 최초로 로드됐을 때 CollectionView Auto Layout이 뭉게지는 현상과 가로 세로 모드 전환시 뷰의 크기가 변함에 따라 Cell의 크기가 자동적으로 변화하지 않는 경우가 발생했습니다.
- `collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]`와 Constraint의 `priority` 및 `StackView`를 이용해서 해당 문제를 해결했습니다.

<br>

### 하나의 Collection View에 두가지 Layout과 Cell사용
- 두 개의 Collection View에 각각의 Layout과 Cell을 등록하고 Segmented Control을 통해서 CollectionView를 감췃다 보여줫다를 하려고 했으나 이러한 구현보다 한개의 Collection View에서 두개의 Layout과 Cell을 이용하기 위해 많은 고민이 있었습니다.
- 하나의 Collection View에 두 개의 Cell을 등록하고 dequeue할때 현재 어떤 layout을 그려야 하는지를 담은 프로퍼티를 이용해서 한 개의 Collection View에서 두 개의 스타일을 사용할 수 있도록 구현했습니다.

<details>
<summary>코드 보기</summary>
<div markdown="1">
    
```swift
    // Layout 설정
    func updateLayout(of layout: CollectionViewLayout) {
        setCollectionViewLayout(LayoutMaker.make(of: layout), animated: false)
        currentLayout = layout
    }

    // Cell 등록
    private func registerCell() {
        listCellRegistration = UICollectionView.CellRegistration { (cell, indexPath, product) in
            cell.updateWithProduct(product)
            cell.accessories = [.disclosureIndicator()]
        }
        
        gridCellRegistration = UICollectionView.CellRegistration { (cell, indexPath, product) in
            cell.updateWithProduct(product)
        }
    }

    // cell 재사용
        openMarketDataSource = UICollectionViewDiffableDataSource(collectionView: self) { (collectionView: UICollectionView, indexPath: IndexPath, product: Product) -> UICollectionViewCell? in
            switch self.currentLayout {
            case .list:
                return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: product)
            case .grid:
                return collectionView.dequeueConfiguredReusableCell(using: gridCellRegistration, for: indexPath, item: product)
            }
        }
```

</div>
</details>

<br>

### 로딩화면
- Collection View Section의 Footer를 이용하여 로딩할때 보여질 View를 구현하려고 했으나, UICollectionViewDataSource Protocol을 이용하지 않기 때문에 Footer를 사용하는데 많은 문제가 있었습니다.
- 데이터 로딩 시 전체 View에 임의의 View를 그려주고 모든 데이터를 로드하게 되면 임의의 View를 제거하는 방법으로 구현했습니다.

<details>
<summary>스크린샷 보기</summary>
<div markdown="1">
    
<img src= "https://i.imgur.com/CmLs9R4.png" width ="200"/>

</div>
</details>

<br>

### Grid Layout 동적 높이
|Before|After|
|:---:|:---:|
|<img src= "https://i.imgur.com/HTKg16N.jpg" width ="200"/>|<img src= "https://i.imgur.com/3Gu961u.jpg" width ="200"/>|

- GridLayout의 Item과 Group의 높이를 `.fractionalHeight()`로 지정해 주게 되면서 모든 Cell의 높이가 동일하게 설정되었습니다. 하지만 텍스트의 길이가 길어지게되면 텍스트에 줄임말 표시가 생기는 문제가 발생했습니다.
- Item과 Group의 높이를 `.estimated()`로 지정해 줌으로 해당 문제를 해결했습니다.

### ImagePicker
- 제품 등록 및 수정에서 이미지를 등록하고, 보여주는 View를 `CollectionView`와 `ScrollView`중 어떤 것을 사용해서 구현할지에 대한 고민을 했습니다.


- `CollectionView`
    - `CollectionView`의 마지막에 `ImagePicker`를 띄어주는 Button이 위치해야 함으로 `footerView`를 이용해 구현하려고 했습니다.
    - `Section`의 `footerView`는 가로의 끝이 아닌 세로의 끝에만 위치될 수 있는 문제가 있었습니다.
    - 해당 문제를 해결하고자 마지막 Cell에 `StackView`에 Content에 해당하는 `View`를 담아줌으로써 해당 문제를 해결했습니다.

<details>
<summary>스크린샷 보기</summary>
<div markdown="1">

|문제 발생|해결|
|:---:|:---:|
|<img src="https://i.imgur.com/iwMdsUD.png" width="200">|<img src="https://i.imgur.com/hhafwQN.png" width="200">|
    
</div>
</details>
<br>

- `ScrollView`
    - `ScrollView`에 `StackView`를 위치시키고 `StackView`에 `ImageView`와 `Button`을 `addArrangedSubview()`해주었습니다.
    - 하지만 `ImageView`와 `Button`에 고유크기를 지정해 주어도 `StackView`에 `addArrangedSubview()`하게되면 지정해준 크기는 무시되고 `StackView`의 정렬기준에 의해 크기가 변경되는 문제가 발생했습니다.
    - `ImageView`와 `Button`을 `StackView`에 `addArrangedSubview()`해줄때 `Constraint`를 직접 작성해주어 해당 문제를 해결했습니다.
- `CollectionView`와 `StackView` 중에서 어떤 것을 사용할지 고민하다 두개 다 구현해 봤으며, 최종적으로는 `CollectionView` 를 사용해서 구현했습니다.

<details>
<summary>스크린샷 보기</summary>
<div markdown="1">

|문제 발생|해결|
|:---:|:---:|
|<img src="https://i.imgur.com/7anNkVz.png" width="200">|<img src="https://i.imgur.com/gKUfwHK.png" width="200">|
    
</div>
</details>

<br>

### Ambiguous Height, Width
- Cell의 크기가 정적이고 Cell의 content를 StackView에 담게되면 StackView의 subView들 중 어떤 View를 줄이고 늘려야 되는지 모르는 문제가 발생했습니다.
- `setContentCompressionResistancePriority`와 `setContentHuggingPriority`를 이용해서 Hugging 및 Compression Priority를 조정해여 해결했습니다.

<br>

## 📚 참고 링크

- [Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
- [URLSession](https://developer.apple.com/documentation/foundation/urlsession)
- [Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)
- [UICollectionView.CellRegistration](https://developer.apple.com/documentation/uikit/uicollectionview/cellregistration)
- [UICollectionViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource)
- [NSDiffableDataSourceSnapshot](https://developer.apple.com/documentation/uikit/nsdiffabledatasourcesnapshot)
- [UICollectionViewCompositionalLayout](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout)
- [NSCache](https://developer.apple.com/documentation/foundation/nscache)
- [UIActivityIndicatorView](https://developer.apple.com/documentation/uikit/uiactivityindicatorview)
- [UIAlertController](https://developer.apple.com/documentation/uikit/uialertcontroller)
- [UIImagePickerController](https://developer.apple.com/documentation/uikit/uiimagepickercontroller")
- [MDN](https://developer.mozilla.org/ko/docs/Web/HTTP/Methods/POST)
