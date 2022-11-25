# README(6) 오픈 마켓

# 🏪 오픈 마켓

- 서버와 네트워킹하여 마켓의 상품들을 받아와 보여주는 어플입니다.

## 📖 목차
1. [팀 소개](#-팀-소개)
2. [기능 소개](#-기능-소개)
3. [Diagram](#-diagram)
4. [폴더 구조](#-폴더-구조)
5. [타임라인](#-타임라인)
6. [프로젝트에서 경험하고 배운 것](#-프로젝트에서-경험하고-배운-것)
7. [트러블 슈팅](#-트러블-슈팅)
8. [참고 링크](#-참고-링크)

## 🌱 팀 소개
 |[inho](https://github.com/inho-98)|[Hamo](https://github.com/lxodud)|[Jeremy](https://github.com/yjjem)|
 |:---:|:---:|:---:|
| <img width="180px" src="https://user-images.githubusercontent.com/71054048/188081997-a9ac5789-ddd6-4682-abb1-90d2722cf998.jpg">| <img width="180px" src="https://i.imgur.com/ydRkDFq.jpg">|<img width="180px" src="https://i.imgur.com/RbVTB47.jpg">|

## 🛠 기능 소개
> step2에서 업데이트할 예정입니다✨

|<img src="https://i.imgur.com/wqyWvRe.gif" width=180px>|<img src="https://i.imgur.com/gyog05D.gif" width=180px>| <img width="180px" src="https://i.imgur.com/G0zbobk.gif">|
|:-:|:-:|:-:|
|리스트 스크롤 화면|리스트와 그리드 화면 전환|그리드 스크롤 화면|

## 👀 Diagram

|<img width=900, src="https://i.imgur.com/eu4XEmd.png">|
|---|

## 🗂 폴더 구조
```
OpenMarket
├─ Model
│  ├─ Error
│  │  └─ NetworkError.swift
│  ├─ Network
│  │  └─ NetworkRequest.swift
│  └─ DTO
│     ├─ ProductData.swift
│     ├─ ProductListData.swift
│     ├─ VendorData.swift
│     └─ ImageData.swift
├─ View
│  ├─ GridCell.swift
│  └─ ListCell.swift
├─ Controller
│  ├─ AppDelegate.swift
│  ├─ SceneDelegate.swift
│  ├─ ProductRegistrationViewController.swift
│  └─ OpenMarketViewController.swift
├─ Info.plist
└─ README.md
```


## ⏰ 타임라인

### 👟 Step 1
|날짜|구현 내용|
|--|--| 
|22.11.15|<`step1` 시작>`ProductData`, `ProductListData`, `VendorData`, `ImageData` `DTO`타입 구현, 네트워킹을 담당할 `NetworkManager`타입 구현, `UnitTest`작성 |
|22.11.16|`OpenMarketError`타입 구현, `TestDouble`을 위한 `Dummuy`,`Stub`구현|
|22.11.17|`StubURLSessionTest`작성, 접근제어 및 파일분리|
|22.11.18|`NetworkManager`열거형에 연관값 적용 및 url에 매개변수 전달, 테스트 코드에 강제언래핑 제거|
|22.11.22|<`step2` 시작> 뷰에 `segemented control` 추가, `ProductCell`클래스 구현 및 `CollectionView`구현|
|22.11.23|이미지를 가져올 네트워킹 메서드 구현, 셀 높이를 수동을 지정하는 `preferredLayoutAttributesFitting`메서드 재정의, `cell`의 텍스트에 `attributedString` 적용, `GridCell`클래스 구현, 컬렉션뷰에 grid레이아웃 추가, 셀을 구성하는 메서드의 기능 분리|
|22.11.24|상품 추가 뷰를 보여주는 버튼과 액션 구현, `cell`에 이미지 로드 전 로딩 이미지 추가, 클래스에 `final` 적용 및 접근제어 추가|

<details>
<summary>Details - 구현 내용과 기능 설명 </summary>

### step1 
#### 1️⃣ `DTO`
- 데이터를 전달받을 타입들을 구현했습니다. 각 타입의 이름 뒤에는 데이터를 전달받을 목적임을 명시하기 위해 `Data`를 포함합니다.
    - `ProductListData`
    - `ProductData`
    - `VendorData`
    - `ImageData`

#### 2️⃣ `DummyData`
- 네트워크와 무관한 테스트를 작성하기 위해 Test Double을 작성

#### 3️⃣ `StubURLSession`
 
### step2
#### 1️⃣ `UICollectionViewCompositionalLayout`
- 컬렉션뷰의 레이아웃을 구성할때, `CompositionLayout`객체를 이용하여 구현했습니다.
- 리스트 형식에 `ListConfiguration`와 그리드 형식에 `CompositionalLayout`과 섹션을 이용해서 구현하였습니다.

#### 2️⃣ `ListCell & GridCell`
- `ListCell`은 `UICollectionViewListCell`을 상속받아 `UIListContentView`에서 제공하는 기본 셀 타입의 구성을 이용합니다.
- `GridCell`은 커스텀 셀로 필요한 뷰들을 요구사항과 일치하게 구성합니다.

#### 3️⃣ `UICollectionView.CellRegistration`
- `CellRegistration`을 이용하여 컬렉션뷰에 셀을 등록하고, 각 셀을 구성하는 역할을 수행합니다. 제네릭타입으로 전달한 셀과 데이터 타입으로 셀을 구성하고, `registration`핸들러에서 셀의 프로퍼티에 값을 지정합니다.

#### 4️⃣ `UICollectionViewDiffableDataSource`
- 컬렉션뷰의 데이터 소스 객체로는 `DiffableDataSource`를 이용하였습니다.

</details>


## ✅ 프로젝트에서 경험하고 배운 것
- CompositionalLayout을 이용한 리스트 구현  
    ☑️ UICollectionLayoutListConfiguration  
    ☑️ UICollectionViewListCell  
    ☑️ preferredLayoutAttributesFitting  
    ☑️ UICollectionViewDiffableDataSource  
- CompositionalLayout을 이용한 그리드 구현  
    ☑️ UICollectionViewCell  
    ☑️ UICollectionViewCompositionalLayout  
    ☑️ UICollectionViewDiffableDataSource  
- Segmented Control 적용과 활용  
    ☑️ UISegmentedControl  
    ☑️ addTarget  
    
## 🚀 트러블 슈팅
## Step-1
### 1️⃣ 로컬의 JSON (테스트할때 사용할)키 값과 API문서 상의 키 값이 다른 문제
|<img src="https://i.imgur.com/4Kl6HGR.png" width="300px"/> | <img src="https://i.imgur.com/cpGzC9E.png" width=500px/>|
|:-:|:-:|
|`API문서의 키 값`|`로컬 JSON파일의 키값`|

- 서버(pageNo)와 JSON(page_no)의 현재 페이지 번호의 key값이 일치하지 않는 문제점이 있었습니다. 
코딩키를 `pageNO`로 작성하면 `JSON`파일을 디코딩할 수 없었습니다.
이를 해결하기 위해 서버의 키와 JSON키 모두 `camelCase`로 변환하는 프로퍼티를 사용했습니다.

    ```swift
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase                 
    ```
해당 프로퍼티를 사용함으로써 아래와 같이 들어오는 `vendor_id` 키 값을 카멜케이스로 변환하여 원하는 케이스 네임으로 수정할 수 있었습니다.
|||
|--|--|
|API문서의 키|![](https://i.imgur.com/gFcg0AL.png)|
|코드로 구현한 키|`case vendorIdentifier = "vendorId"`|

### 2️⃣ 같은 상품 상세에 대해서 요구하는 키값이 서로 다른 문제
- 서버에 상품 리스트 조회, 상품 상세 조회 두 가지 요청을 보낼 때 받아오는 JSON파일의 키가 일치하지 않아서 ProductData DTO를 중복으로 사용하였을 때 디코딩이 되지 않는 문제가 있었습니다.
- `ProductList`에서는 `Product`의 `description`과 `vendorName`을 요구하고,
`Product`상세에서는 `images`와 `vendors`를 요구하는 부분을 어떻게 해결할지 고민후에 겹치지 않는 키에 해당하는 프로퍼티를 옵셔널 처리하여 해결하였습니다.

  ```swift
  struct ProductData: Decodable {    
      ...
      let vendorName: String?
      let description: String?
      let images: [ImageData]?
      let vendors: VendorData?
  }
  ```

### 3️⃣ 비동기로 동작하는 `dataTask`가 끝난 시점에 데이터를 받는 방법
- `NetworkManager`의 `loadData`메서드 내부에서 호출하는 `dataTask` 메서드는 파라미터인 `completionHandler`를 이용하여 `data, response, error`를 받을 수 있는데 비동기적으로 동작하기 때문에 끝나는 시점을 알수없어서 받아온 데이터를 어떻게 전달할지 고민이었습니다.
- `loadData의` 파라미터로 `escaping closure`를 받아서 `dataTask`의 `completionHandler`가 해당 클로저를 캡처하여 비동기적으로 작업이 끝난 시점에 캡처한 클로저를 호출하는 방법으로 해결하였습니다.

    ```swift
    func loadData<T: Decodable>(of request: NetworkRequest,
                                dataType: T.Type,
                                completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = request.url else { return }

        session.dataTask(with: url) { data, response, error in
            ...

            do {
                ...
                let data = try decoder.decode(T.self, from: data)
                completion(.success(data))
            } catch {
                completion(.failure(OpenMarketError.failedToParse))
            }
        }.resume()
    }
    ```


### 4️⃣ `Test Double`에서의 코드 흐름과 테스트를 위해 구현한 타입들
- 네트워크가 없는 환경에서도 테스트를 수행하기 위해서 네트워킹을 수행하는 `URLSession`과 `URLSessionDataTask`대신하는 `Stub`객체를 구현했습니다. 그래서 `DummyData`를 만들어놓고 이를 `dataTask`의 `completionHandler`까지 전달합니다.

    ```swift
    //테스트 코드 예시
    func test_productListData를받았을때_전달받은값을_리턴해야한다() {
        //given
        guard let url = NetworkRequest.productList.url else { return }

        let expectedData = """
                        {
                            ...
                            "totalCount": 116,
                            ...
                            
                            """.data(using: .utf8)
        let response = HTTPURLResponse(url: url,
                                       statusCode: 200,
                                       ...)
        let dummyData = DummyData(data: expectedData,
                                  response: response,
                                  error: nil)
        stubUrlSession.dummyData = dummyData

        //when
        sut.loadData(of: NetworkRequest.productList,
                        dataType: ProductListData.self) { result in
            switch result {
            case .success(let productListData):
            //then
                XCTAssertEqual(productListData.totalCount, 116)
            case .failure(let error):
                XCTFail("loadData failure: \(error)")
            }
        }
    }
    ```
    
    - 위 예시에서, 받아올 것이라고 예상되는 데이터를 작성하고, 응답이 성공한다고 가정해서 성공하는`response`를 작성하였습니다. 이 정보들을 `dummyData`에 포함하여 가짜 객체인 `stubUrlSession`에 전달하고, `NetworkManager`의 `loadData`메서드를 호출해서 의도한 결과와 일치하는지 확인합니다.
## Step-2
### 1️⃣ 모던 컬렉션뷰를 이용한 컬렉션뷰 구현
- 컬렉션 뷰를 구현할때, `flowLayout`과 `dataSource` 대신, `composableLayout`과 `diffableDataSource`를 이용해서 구현하였습니다. 
- `snapshot`은 뷰의 데이터의 특정 시점의 상태를 나타내고 섹션별로 나누어서 원하는 섹션과 아이템으로 구성하고, `dataSource`의 `apply`메서드를 이용하여 `snapshot`의 데이터를 현재 `state`와 새 state를 비교하여 업데이트합니다.
- 애플의 `Implementing Modern Collection Views`를 기반으로 `Customize List Cells`를 구현하려했습니다. 
- 이때 `custom`한 `state`를 만들어서 활용할 수 있는데, 이번 프로젝트에서는 셀에서 선택, 하이라이트, 이동 등의 상태에 따른 변경이 없어서 `custom state`를 사용할 필요성이 없다고 생각하여 제외하였습니다.

### 2️⃣ `UICollectionViewListCell`의 크기를 커스텀으로 지정하는 방법
- `list`형태의 `collectionView`를 `cell`이 기본적으로 제공하는 레이아웃을 이용하여 아래 코드처럼 간편하게 만들었습니다.
그런데 셀이 `self-sizing`을 하여서 클릭되었을 때 의도치 않게 높이가 늘어나는 문제가 발생했습니다.
이를 셀이 레아이웃에 전달되기 전에 수동으로 크기를 조절할 수 있도록 하는`preferredLayoutAttributesFitting()` 메서드를 이용해서 커스텀한 `cell size`를 정해주어 해결하였습니다.
    ```swift
    let configure = UICollectionLayoutListConfiguration(appearance: .plain)
    let layout = UICollectionViewCompositionalLayout.list(using: configure)
    ```

### 3️⃣ 세그먼트 컨트롤을 이용하여 화면전환시 컬렉션뷰가 중첩되는 문제
|<img src="https://i.imgur.com/orXxNVB.jpg" width=600>|
|--|
- 세그먼트 컨트롤의 값에 따라 `grid` 레이아웃, `list` 레이아웃을 가지는 컬렉션 뷰를 다시 그려서 `viewController의` `root view`에 `addSubview`하여 화면이 전환되도록 구현했습니다.
- 이때 기존에 있던 `collectionView`가 사라지지 않고 중첩되는 문제가 있었습니다.
- `productCollectionView` 변수에 새로운 `collectionView`를 할당하기 때문에 참조가 사라져서 `deinit`될거라 생각했는데 `UIView의` `addSubView`를 사용하면 추가한 뷰를 강하게 참조하여서 `deinit`되지 않는다는 점을 확인하고, 자신을 상위 뷰로부터 해제하는 `removeFromSuperview()` 메서드를 사용하여 해결하였습니다.

### 4️⃣ 셀을 빠르게 스크롤했을때 셀의 데이터와 일치하지 않는 이미지가 로드되는 문제
- 네트워킹을 통해서 셀의 이미지를 서버에서 가져오는데 빠르게 스크롤했을 때 셀의 이미지가 여러번 바뀌는 문제가 있었습니다.
- 셀이 재사용될 때마다 이미지를 가져오는 작업이 생성되고 여러개의 작업들이 끝날때마다 셀의 이미지를 바꾸기 때문에 발생하는 문제였습니다.
- 네트워킹 작업을 생성하는 시점의 `indexPath`와 현재 `cell`의 `indexPath`를 비교하여 두 값이 같은 경우에만 이미지를 변경하여 해결하였습니다.
    ```swift
    if indexPath == self.productCollectionView.indexPath(for: cell) {
        cell.imageView.image = image
    }
    ```
### 5️⃣ `Diffable Datasource` 인스턴스를 만들 때 클로저 내부에서 `Cell Registration`을 생성할 때 발생하는 에러
![](https://i.imgur.com/OS0QY97.png)
- `CellRegistration을 diffabel datasource` 클로저 내부에서 만들면 위 그림과 같은 에러가 발생한다.
- 이 부분에 대해서 `UICollectionView.CellRegistration` 공식문서에 명시되어 있는데 아래 그림과 같다.

![](https://i.imgur.com/evOUc3i.png)
- 따라서 외부에서 `CellRegistration` 인스턴스를 생성하고 클로저 내부에서 사용하여 문제를 해결하였다.

## 🔗 참고 링크

[공식문서]
- [📎 Closure](https://docs.swift.org/swift-book/LanguageGuide/Closures.html)
- [📎 URLSession](https://developer.apple.com/documentation/foundation/urlsession)
- [📎 URLSessionDataTask](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory/)
- [📎 dataTask(with:completionHandler:)](https://developer.apple.com/documentation/foundation/urlsession/1410330-datatask/)
- [📎 Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
- [📎 Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)

[WWDC]
- [📎 Modern cell configuration](https://developer.apple.com/videos/play/wwdc2020/10027/)
- [📎 List in Collection View](https://developer.apple.com/videos/play/wwdc2020/10026)
- [📎 Advances in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10097/)
- [📎 Advances in Collection View Layout](https://developer.apple.com/videos/play/wwdc2019/215)

[그 외 참고문서] 

- [📎 개발자 소들이 - closure와 @escaping 이해하기](https://babbab2.tistory.com/164)
- [📎 jessesquires - why optional closures in Swift are escaping](https://www.jessesquires.com/blog/2018/06/10/why-optional-swift-closures-are-escaping/)
- [📎 클로저 정복하기(3/3)](https://babbab2.tistory.com/83)
- [📎 Mock을 이용한 UnitTest](https://sujinnaljin.medium.com/swift-mock-%EC%9D%84-%EC%9D%B4%EC%9A%A9%ED%95%9C-network-unit-test-%ED%95%98%EA%B8%B0-a69570defb41)
- [📎 xUnit Patterns.com - Test Double](http://xunitpatterns.com/Test%20Double.html)
- [📎 Steven Curtis - Stubbing, Mocking or Faking](https://medium.com/swlh/stubbing-mocking-or-faking-5674a07bc3db)
