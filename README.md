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

***개발 기간 : 2022-11-14 ~ 2022-11-25***

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

<br>

## 📊 UML

### Model

<img src="https://i.imgur.com/YSomJuD.jpg" width="500">

### URLSession Protocol

<img src="https://i.imgur.com/oVURD58.jpg">

<br>

## 💻 실행 화면



|List|Grid|
|:---:|:---:|
|<img src="https://i.imgur.com/zbf016U.gif" width="400">|<img src="https://i.imgur.com/OmFmQEU.gif" width="400">|

|LIST GRID 전환|
|:---:|
|<img src="https://i.imgur.com/sm69aR6.gif" width="400" height = "450">|

<br>

## 🎯 트러블 슈팅 및 고민

### Decodable Model Property Optional
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

### API 통신 기능별 Protocol화
- URLSession에 API 통신과 관련된 기능을 extension을 통해 구현했었습니다. POP의 관점에서 구현해 보고자하여 기능별로 프로토콜을 만들어서 `URLSession` 이 채택하도록 구현했습니다.

<details>
<summary>코드 보기</summary>
<div markdown="1">
    
```swift
    extension URLSession: OpenMarketURLSessionProtocol { }
    extension URLSession: OpenMarketHealthFetchable { }
    extension URLSession: OpenMarketPageFetchable { }
    extension URLSession: OpenMarketProductFetchable { }
```
    
</div>
</details>

<br>

### 중복된 Guard문

- URLSessionDataTask의 CompletionHandler에서 data, response, error에 따른 분기처리를 해주지 않고 data를 처리하는 로직에서 guard문을 이용해 분기처리를 해줌으로써 중복된 코드가 발생하는 부분이 있었습니다.
- URLSessionDataTask의 CompletionHandler에서 if let을 이용하여 분기 처리를 해주어 중복된 코드를 줄일 수 있었습니다.

<details>
<summary>코드 보기</summary>
<div markdown="1">
    
```swift
    // 수정 전
    private func fetchOpenMarketAPIDataTask(query: String,
                                            completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        guard let hostURL = URL(string: "https://openmarket.yagom-academy.kr"),
              let url = URL(string: query, relativeTo: hostURL) else {
            fatalError()
        }
        
        return self.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil, response, error)
                return
            }
            completion(data, response, nil)
        }
    }

    func checkHealthTask(completion: @escaping (Bool) -> Void) {
        let query: String = "healthChecker"
        fetchOpenMarketAPIDataTask(query: query) { (_, response, error) in
            // 중복된 코드 발생 구간
            guard error == nil, let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                completion(false)
                return
            }
            // 모든 로직에서 해당 코드가 존재.
            completion(true)
        }.resume()
    }

    // 수정 후
    func fetchOpenMarketDataTask(query: String,
                                 completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask? {
        guard let hostURL = URL(string: host),
              let url = URL(string: query, relativeTo: hostURL) else {
            return nil
        }
        
        return self.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
            } else if (response as? HTTPURLResponse)?.statusCode != 200 {
                completion(nil, OpenMarketError.badStatus)
            } else if let data = data {
                completion(data, nil)
            } else {
                completion(nil, nil)
            }
        }
    }


    func fetchHealth(completion: @escaping (OpenMarketHealth) -> Void) {
        let query: String = "healthChecker"
        
        fetchOpenMarketDataTask(query: query) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.bad)
            } else if data != nil {
                completion(.ok)
            } else {
                completion(.bad)
            }
        }?.resume()
    }

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
