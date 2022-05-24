# 🏬 오픈마켓
> 프로젝트 기간: 2022.05.09 ~ 2022.05.20 <br>
> 팀원: [Donnie](https://github.com/westeastyear), [우롱차](https://github.com/dnwhd0112)
> 리뷰어: [또치](https://github.com/TTOzzi)

## 🔎 프로젝트 소개
**"서버에서 제공하는 `API`를 받아와서 사용자에게 원하는 형식(LIST, GRID)으로 뷰를 그려 상품의 정보를 제공하는 프로젝트"**

## 📺 프로젝트 실행화면
<img src="https://user-images.githubusercontent.com/74251593/168963325-a33f1326-5568-4af6-a77d-455475d7e042.gif" width="60%">

## 👀 PR

[STEP 1](https://github.com/yagom-academy/ios-open-market/pull/140)

[STEP 2]()

## 🛠 개발환경 및 라이브러리
- [![swift](https://img.shields.io/badge/swift-5.0-orange)]()
- [![xcode](https://img.shields.io/badge/Xcode-13.1-blue)]()
- [![iOS](https://img.shields.io/badge/iOS-15.0-red)]()

## 🔑 키워드

- `JSONDecoder`
- `CodingKeys`
- `URLSession`
- `URLSessionDataTask`
- `LocalizedError`
- `UISegmentedControl`
- `UICollectionView`
    - `UICollectionViewFlowLayout`
    - `UICollectionLayoutListConfiguration`
    - `UICollectionViewCompositionalLayout` 
    - `setCollectionViewLayout`
    - `reloadData`
- `Modern cell configuration`
    - `UICollectionViewDiffableDataSource`
    - `NSDiffableDataSourceSnapshot` 
- `Lists in UICollectionView`
    - `UIListContentConfiguration` 
    - `UIListContentView`
- `UIActivityIndicatorView`
- `NSMutableAttributedString`
- `prepareForReuse`
- `activityIndicator`


## 📑 구현내용

- `Modern cell configuration` 방식으로 `List` 구현
- `session`을 이용하여 페이지 정보를 불러와서 `snapshot`에 저장 및 `dataSource`에 적용
- 화면에 보여줄 `collectionView`에서 셀을 생성한뒤 `dataSource`에 있는 정보들을 할당
- `Storyboard`없이 코드를 이용하여 `UI`구현
- `Mock`객체를 사용하여 `Network` UnitTest 진행 
- `NSMutableAttributedString`을 확장하여 원하는 부분에만 변경된 색상적용
- `CodingKeys`와 `init(from: decoder)`을 사용하여 디코딩
- `session`과 `networkable`을 프로토콜로 선언하여 활용 `session.dataTask`를 활용하여 서버와 통신하고 `completeHandler`와 `errorHandler`를 사용하여 비동기로 통신
- `completeHandler`와 `errorHandler`에 `Mock Session`으로부터 특정값을 전달하는 방식으로 진행


## 📖 학습내용
- `Mock` 테스트 방식에 대한 이해
- `Session`을 활용한 네트워크 통신 방식 및 `completeHandler`를 사용하여 얻어온 데이터를 처리하는 방식에 대한 이해
- `CollectionView` 및 `CollectionViewListCell`을 구현 및 설계하는 방식에 대한 이해
- `activityIndicator`를 활용하여 로딩중을 표시하는 방법에 대한 이해
- `CollectionViewCell`에서 `prepareForReuse()`를 오버라이드 하여 재사용 셀을 초기화

## 🧐 STEP별 고민한 점 및 해결한 방법

## [STEP 1]
### 1. `requestData` 구현시 어디까지 `escaping Handler`에서 처리할것이고, 어디까지 함수 내부에서 처리를 한 뒤 `Handler`에게 넘겨줄지를 고민하였습니다.
> - 의논 결과 전부 다 `Handler`에서 처리하도록 하자고하여 `data`, `response`, `error`를 전부 다 넘겼습니다.
```swift
func requestData(url: String, completeHandler: @escaping (Data?, URLResponse?, Error?) -> Void ) {
        let configure = URLSessionConfiguration.default
        let session = URLSession(configuration: configure)
        
        let urlComponents = URLComponents(string: url)
        
        guard let requestURL = urlComponents?.url else { return }
        let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
            guard error == nil else { return }
            completeHandler(data, response, error)
        }
```

<br>

### 2. `URL` 주소를 관리하는 방법에 대해
> - 처음엔 함수에서 `query` 매개변수를 받아 `URLQueryItem`으로 `URL`를 관리하는 방법을 채택했었는데, 어떤 `query` 파라미터를 사용해야 하는지 알기 어려워져서 다른 방법을 사용하게 되었습니다.
*(아무 String 값이 들어갈 수 있어서 새로 작성하는 입장에서는 어떤 값이 들어가는지 모르고 오류가 나기 쉽기 때문에 `enum`으로 관리하도록 변경하였습니다.)*
```swift
func inquireProductList(url: String, query: [(String, String)], completeHandler: @escaping (Data?, URLResponse?, Error?) -> Void ) {
    
------중략------
    
    var urlComponents = URLComponents(string: url)
    for item in query {
        let urlQueryItem = URLQueryItem(name: item.0, value: item.1)
        urlComponents?.queryItems?.append(urlQueryItem)
    }
}
```

> - 팀원과 `URL` 주소를 관리하는 법에 대하여 고민하였고, `enum`으로 관리해주기로 결정하였습니다.
```swift
enum OpenMarketApi {
    private static let hostUrl = "https://market-training.yagom-academy.kr/"
    
    case pageInformation(pageNo: Int, itemsPerPage: Int)
    case productDetail(productNumber: Int)
    
    var string: String {
        switch self {
        case .pageInformation(let pageNo, let itemsPerPage):
            return Self.hostUrl + "api/products?page_no=\(pageNo)&items_per_page=\(itemsPerPage)"
        case .productDetail(let productNumber):
            return Self.hostUrl + "api/products/\(productNumber)"
        }
    }
}
```

---

<br>

## [STEP 2]

### 1. `ListCell`을 구현하기 위해 `customCell`을 만들어 등록하는 방식과, `Modern cell configuration` 방식중에 어떤것을 사용할지 고민하였습니다.
> - `customCell`을 만들어 등록하는 방식이 익숙하여 자주 사용했었는데, 이번에는 `default`로 지원되는 값들이 있고 구현되는 코드가 적은 `Modern cell configuration`방식을 사용하였습니다. 
> - 하지만 세세한 부분을 커스텀하기까지는 난이도가 있었고 자유도가 적어 사용하기 어려웠습니다. 러닝커브가 있어서 저희를 고생하게 만든 녀석입니다.

<br>

### 2. 통신해서 얻은 객체가 이미지 `url`을 가지고 있는데, 이러한 이미지를 다시 다운로드를 어느시점에 할것인지에 대하여 고민이 있었습니다. 
> - `init` 메서드를 변경하여 디코딩할때 이미지값도 같이 가져오도록 변경하였습니다.

```swift
init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        vendorId = try container.decode(Int.self, forKey: .vendorId)
        name = try container.decode(String.self, forKey: .name)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        currency = try container.decode(String.self, forKey: .currency)
        price = try container.decode(Double.self, forKey: .price)
        bargainPrice = try container.decode(Double.self, forKey: .bargainPrice)
        discountedPrice = try container.decode(Double.self, forKey: .discountedPrice)
        stock = try container.decode(Int.self, forKey: .stock)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        issuedAt = try container.decode(String.self, forKey: .issuedAt)
        thumbnailImage = convertImage()
    }
```

<br>

### 3. 재사용되는 `Cell`로 인한 레이블의 `Color`변화를 초기화 하기 위해 고민하였습니다.
> - `GridCell`에서 의도치 않은 `textLabel`의 색상변화가 있었습니다. 할인이 있을때만 색깔이 빨간색이되어야 하는대 셀이 재사용되면서 빨간색이 남아있는 경우가 있었습니다.
> - `GridCollectionViewCell` 클래스 내부에 아래와 같이 초기화하는 코드를 작성해주어 해결하였습니다.

```swift
override func prepareForReuse() {
        super.prepareForReuse()
        productPrice.attributedText = nil
    }
```
---

<br>



