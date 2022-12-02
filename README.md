# 오픈마켓 🏬

## 📖 목차

1. [소개](#-소개)
2. [프로젝트 구조](#-프로젝트-구조)
3. [구현 내용](#-구현-내용)
4. [타임라인](#-타임라인)
5. [실행 화면](#-실행-화면)
6. [트러블 슈팅 & 어려웠던 점](#-트러블-슈팅-및-어려웠던-점)
7. [프로젝트 wiki](#-프로젝트에서-배운-점-wiki)
8. [참고 링크](#-참고-링크)

## 🌱 소개


|<img src= https://i.imgur.com/ryeIjHH.png width=150>|<img src= https://i.imgur.com/RG4tpLq.jpg width=150>|
|:---:|:---:|
|[토털이](https://github.com/tottalE)|[애종](https://github.com/jonghancha)


 
## 🛠 프로젝트 구조

### 🌲 Tree
```
├── OpenMarket
│   ├── NetworkTests
│   │   ├── MockData.swift
│   │   ├── MockURLSession.swift
│   │   ├── MockURLSessionDataTask.swift
│   │   └── NetworkTests.swift
│   ├── OpenMarket
│   │   ├── Controller
│   │   │   ├── AddProductViewController.swift
│   │   │   └── ProductListViewController.swift
│   │   ├── Errors
│   │   │   └── NetworkError.swift
│   │   ├── Extensions
│   │   │   ├── Double+Extension.swift
│   │   │   ├── JSONDecoder+extension.swift
│   │   │   ├── String+Extension.swift
│   │   │   └── URLComponents+Extension.swift
│   │   ├── Model
│   │   │   └── ProductList.swift
│   │   ├── Utilities
│   │   │   ├── NetworkAPI.swift
│   │   │   └── NetworkAPIProvider.swift
│   │   └── View
│   │   │   ├── ProductGridCell.swift
│   │   │   ├── ProductListCell.swift
│   │   │   └── Base.lproj
│   │   │       └── LaunchScreen.storyboard
│   │   ├── AppDelegate.swift
│   │   ├── SceneDelegate.swift
│   │   ├── URLSessionProtocol.swift
│   │   ├── Info.plist
│   │   ├── Assets.xcassets
│   └── OpenMarket.xcodeproj
└── README.md
```

### 📊 Class Diagram

![](https://i.imgur.com/KmYPYho.jpg)

## 📌 구현 내용
### STEP 1
- 디코딩을 위한 Decodable struct `ProductList` 생성
- 네트워크 통신을 담당할 타입인 `NetworkAPIProvider` 클래스를 설계하고 구현, extension에 fetch 함수를 구현함
- `NetworkAPI` enum으로 url components를 분리하여 관리할 수 있도록 설계
- `URLComponents` extension에 `setQueryItems()`를 추가해주어 쿼리를 효율적으로 관리할 수 있도록 설계
- MockURLSession을 구현하여 테스트 할 수 있도록 설계
- Test Double를 적용하여 Mock URLsession을 만들어 네트워크와 무관하게 동작하는 테스트를 수행



### STEP 2


- segmented control 커스텀 및 구현
- 모던 컬렉션 리스트 뷰 구현
    - `CollectionViewListCell`, `UICollectionViewDiffableDataSource`, `UICellConfigurationState` 활용
- 모던 컬렉션 그리드 뷰 구현
    - `CollectionViewListCell`, `UICollectionViewDiffableDataSource` 활용
- 이미지 비동기 네트워킹 구현
    - DispatchQueue.main.async 활용
- segement control을 통한 화면 전환 구현
    - `removeFromSuperview()` 메서드 활용

## ⏰ 타임라인


<details>
<summary>Step1 타임라인</summary>
<div markdown="1">       

- **2022.11.15**
    - `DecodeManager`, `DataError` 추가
    - `DecodingTests`추가
    - 모델 `ProductList`타입 추가
    - `NetworkAPI`, extension `URLComponents` 추가
    
- **2022.11.17**
    - `NetworkAPIProvider`와 `NetworkAPI` 분리 및 리팩토링
    - `MockForTest`폴더 추가
        - `URLSessionProtocol`
        - `MockURLSessionDataTask`
        - `MockURLSession`
        - `MockData`
    - `NetworkTests`추가, `DecodingTests`삭제
    
- **2022.11.18**
    - `MockURLSession` 호출 시 sampleData 주입하도록 구현
</div>
</details>

<details>
<summary>Step2 타임라인</summary>
<div markdown="1"> 
    
- **2022.11.18**
    - JSONDecoder extension 추가
    
- **2022.11.19**
    - Network과정에서 생기는 오류 Result타입으로 처리
    - Product내 프로퍼티의 옵셔널 처리를 통해 두 가지 Product타입이 존재할 수 있도록 구현
        - Pages, Product
    
- **2022.11.22**
    - mock관련 파일 NetworkTests로 타깃 변경
    - configure 뷰
        - navigationBar 
        - segmentedControl
    - simpleList 구현
        - UICellConfiturationState
        - UIConfigurationStateCustomKey
    - UICollectionViewListCell을 상속하는 ProductListCell 추가
    
- **2022.11.23**
    - ProductListCell 파일 분리
    - ProductGridViewController 추가
        - ProductGridCell
    - segment control로 화면 전환 구현
    - attributedText를 사용한 할인가격 텍스트 구현
    - ProductGridViewController삭제, ProductListViewController로 통합
    
- **2022.11.24**
    - grid 화면 뷰 구현
        - item 내부 stackView
    - list와 grid 모두에서 사용되는 fetchImage 비동기 처리

- **2022.11.25**
    - 접근 제어자 수정
    - convention 수정

    
    
    
</div>
</details>

<details>
<summary>Step3 타임라인</summary>
<div markdown="1">       
    
</div>
</details>


## 📱 실행 화면

<img src= "https://i.imgur.com/6nwbq2c.gif" width=200>

## ❓ 트러블 슈팅 및 어려웠던 점

## STEP 1

### 1. URLSession을 사용해 웹에서 데이터 Fetching

#### **URLComponents 구현부**
`dataTask()`메서드 사용을 위해 url을 사용할 때 아래와 같이 String형태로 쓰는 것보다 
"https://openmarket.yagom-academy.kr/api/products"
   URl Components를 사용해 분리해서 관리하는 것이 더 좋다고 생각했다. 열거형NetworkAPI 와 Query를 사용해 URL을 관리했다. 
```swift
enum NetworkAPI {
    
    static let scheme = "https"
    static let host = "openmarket.yagom-academy.kr"
    
    case productList(query: [Query: String]?)
    case product(productID: Int)
    case healthCheck
}
```
step1에서 필요한 세 가지 네트워킹요소를 case로 구분하고, url구성에 더 필요한 query의 경우 매개변수를 통해 추가되도록 구현했다. 최종적으로 enum 내부의 연산프로퍼티 urlComponents 를 통해 URL Components를 완성한다.

#### **URLSession.dataTask() 구현부**
NetworkAPIProvider에서 `fetch()`라는 제너럴한 함수를 구현해서 extension에 넣어주어 각각의 api 호출에 따른 fetch 함수들을 만들때 fetch를 불러와서 쓰면 되는 형태로 설계했다. completionHandler를 계속 전달해 주는 형태로 설계를 해보았는데 흔한 설계는 아닌 것 같아 고민이 들었다.
```swift
final class NetworkAPIProvider {
    ...
    func fetchProductList(query: [Query: String]?, completion: @escaping (ProductList) -> Void) {
        fetch(path: .productList(query: query)) { data in
            guard let productList: ProductList = DecodeManger.shared.fetchData(data: data) else {
                return
            }
            completion(productList)
        }
    }
}

extension NetworkAPIProvider { 
    
    func fetch(path: NetworkAPI, completion: @escaping (Data) -> Void) {
        guard let url = path.urlComponents.url else { return }

        session.dataTask(with: url) { data, response, error in
            if let error = error {
                dump(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                self.handleServerError(response)
                return
            }
            
            guard let data = data else { return }
            
            completion(data)
        }.resume()
    }

```

### 2. Test Double
한번도 해 보지 않은 Double Test 여서 모르는게 많은 상태로 진행해 어려웠던 것 같다. 
![](https://i.imgur.com/sxaA2yl.png)

위와 같은 구조로 의존성 주입을 해주어 `NetworkAPIProvider`클래스에 대한 Stubs 테스트를 해줄 수 있었다.
## STEP 2

### 1. ~~collection view의 state~~
현재 프로젝트에는 cell상태의 변화가 없기 때문에 변화에 대응하는 state관련 코드는 없애는 것이 맞다고 판단해 state 기능을 삭제했다.
<details>
<summary>state에 관한 내용</summary>
<div markdown="1">       
configurationState란 셀의 모양에 영향을 미치는 모든 공통 상태(선택됨, 집중 또는 비활성화와 같은 보기 상태 및 편집 또는 스와이프됨과 같은 셀 상태)와 함께 특성 컬렉션을 포함한다. 
 저희는 `configurationState` 프로퍼티를 통해 state가 product를 가지고 있도록 구현했다.
 ```swift
override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.productData = self.productData
        return state
    }
```
UICellConfigurationState가 productData를 가지도록 extension을 통해 구현하였고, "product" 키 값을 통해 state의 productData에 접근할 수 있도록 했다.
```swift
private extension UIConfigurationStateCustomKey {
    
    static let product = UIConfigurationStateCustomKey("product")
}

private extension UICellConfigurationState {
    
    var productData: Product? {
        set { self[.product] = newValue }
        get { return self[.product] as? Product }
    }
}
```

#### **데이터가 리스트에 데이터가 띄워지는 과정**
1. 뷰 컨트롤러의 `configureDataSource()` 내의 `update(with: product)`를 통해 해당 셀에 보여질 product의 정보를 `ProductListCell.productData` 에게 넘겨준다.
```swift
func update(with newProduct: Product) {
        guard productData != newProduct else { return }
        self.productData = newProduct
        setNeedsUpdateConfiguration()
    }
```
2. 프로퍼티에 할당된 `productData`는 위에서 정의한 `configurationState`의 `state.productData`에 할당된다.
3. 해당 `state`는 `updateConfiguration(using: -->> State <<--)` 의 매개변수로 전해진다. 결론적으로 현재 상태의 `productData`를 토대로 cell을 구성한다. 
</div>
</details>



### 2. modern collection view 구현 방법
list와 grid `두 가지 형태`의 layout을 생성해 collectionView에서 사용해주었다.
`UICollectionViewDiffableDataSource`를 채용해 list에 들어갈 cell과 grid에 들어갈 cell을 등록해주고, datasource에서 layout의 변화에 따라 cell을 만들어주도록 구현했다. 
1. `collectionView` View controller 내에 프로퍼티로 선언

2. `CollectionViewListCell` 생성 (`gridCell`도 같은 방법으로 생성)
    2-1. cell에서 사용할 `UIListContentView`를 생성한다.
    2-2. cell내의 Layout을 잡아준다.
    2-3. updateConfiguration(with: Product) 에서 configuration을 사용해 Cell을 구성해준다. 
    
3. collectionView의 layout 생성 (첫화면은 list형태이기 때문에`UICollectionViewLayout`)
    - list는 `UICollectionViewLayout`타입, grid는 `UICollectionViewCompositionalLayout`타입이다.
    - `UICollectionViewCompositionalLayout` 은 `UICollectionViewLayout`를 상속받기 때문에 `UICollecionView`의 layout으로 할당 가능하다.
4. 레이아웃 생성하여 collectionView 프로퍼티에 주입
5. dataSource에 CellRegistration, UICollectionViewDiffableDataSource(layout에 따라 분기처리) 할당 <- ***해당 내용은 아래에서 구체적으로 설명***
6. snapshot을 dataSource에 apply
    6-1. 모델에 Hashable 프로토콜 채택
    - snapshot의 모델에 `Hashable을 채택`하는 이유: snapshot을 apply해주면 `각 hash value를 비교`하여 추가 or 삭제된 부분을 인지하고 변경점이 있는 경우에 바뀐 부분에 해당하는 UI를 자연스럽게 업데이트 해준다.

### 3. translateAutoResizingIntoConstraint = false 
왜 코드로 구현시에 이 부분을 false로 지정해 주어야 하는지 의문이 들어 공부해 보았다.
`translateAutoResizingIntoConstraint`는 Autoresizing mask를 Auto Layout constarints로 바꿀지 말지를 결정하는 Boolean 값이다.
autoresizing mask constraints는 뷰의 크기와 위치를 지정해버리기 때문에, 이후에 추가적인 constraints를 추가할 수 없습니다. 그렇기 때문에 constraints를 추가해 주기 위해서는 false로 지정해 주어야 한다.

### 4. segmented control로 화면 전환 구현
`collectionView`의 `collectionViewLayout`을 바꾸어 주면, `UICollectionViewDiffableDataSource`에 분기처리를 해 주어 특정 분기에 따라 다른 cell을 dequeue하도록 처리했다. 
```swift
self.dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: self.collectionView) { (collectionView, indexPath, product) -> UICollectionViewCell? in
            switch self.segmentItem {
            case .list:
                return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: product)
            case .grid:
                return collectionView.dequeueConfiguredReusableCell(using: gridCellRegistration, for: indexPath, item: product)
            }
        }
```
특정 트리거가 발생하면 collectionView의 viewLayout을 바꾸어 주어서 List 형태가 Grid형태로 바뀔 수 있도록 해주었다. 여기서 중요한 점은 SnapShot의 관점에서 데이터는 변하지 않았기 때문에 reloadData를 해주어야 한다는 점이다.


## 📕 프로젝트에서 배운 점 wiki
[바로가기](https://github.com/jonghancha/ios-open-market/wiki/1.-STEP-1-%EC%97%90%EC%84%9C-%EB%B0%B0%EC%9A%B4-%EC%A0%90)
1. @testable은 왜 사용해주는 걸까?
2. Test Double - Mocks, Stubs
3. URLSession에 데이터 주입

## 📖 참고 링크
- [URLSession.dataTask를 통해 데이터 Fetching하기(공식문서)](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
- [URLComponents로 URL구성하기](https://kirkim.github.io/swift/2022/08/13/urlsession.html)
- [iOS 네트워킹과 테스트](https://techblog.woowahan.com/2704/)
- [stub과 mock의 차이](https://martinfowler.com/articles/mocksArentStubs.html)
- [Grid 구현 블로그](https://leechamin.tistory.com/556?category=941561)
- [NSCache를 이용해 이미지 캐싱하기](https://ios-development.tistory.com/658)
- [Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)
- [UICellConfigurationState 공식문서](https://developer.apple.com/documentation/uikit/uicellconfigurationstate)


[🔝 맨 위로 이동하기](#오픈마켓-)
