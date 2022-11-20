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

## 👀 Diagram

|<img width=900, src="https://i.imgur.com/MvE46x5.png">|
|---|



## 🗂 폴더 구조
```
├── OpenMarket
│   ├── OpenMarket
│   │   ├── Assets.xcassets
│   │   ├── Controller
│   │   │   ├── AppDelegate.swift
│   │   │   ├── SceneDelegate.swift
│   │   │   └── ViewController.swift
│   │   ├── Model
│   │   │   ├── DTO
│   │   │   │   ├── ImageData.swift
│   │   │   │   ├── ProductData.swift
│   │   │   │   ├── ProductListData.swift
│   │   │   │   └── VendorData.swift
│   │   │   ├── Error
│   │   │   │   └── NetworkError.swift
│   │   │   └── Network
│   │   │       ├── NetworkManager.swift
│   │   │       ├── NetworkRequest.swift
│   │   │       └── URLSessionProtocol.swift
│   │   ├── Test Double
│   │   │   ├── DummyData.swift
│   │   │   ├── StubURLSession.swift
│   │   │   └── StubURLSessionDataTask.swift
│   │   └── View
│   │       └── Base.lproj
│   │           ├── LaunchScreen.storyboard
│   │           └── Main.storyboard
│   └── OpenMarketTests
│       ├── ProductListDataTest.swift
│       └── StubURLSessionTest.swift
└── README.md
```

## ⏰ 타임라인

### 👟 Step 1
|날짜|구현 내용|
|--|--|
|22.11.15|`ProductData`, `ProductListData`, `VendorData`, `ImageData` `DTO`타입 구현, 네트워킹을 담당할 `NetworkManager`타입 구현, `UnitTest`작성 |
|22.11.16|`OpenMarketError`타입 구현, `TestDouble`을 위한 `Dummuy`,`Stub`구현|
|22.11.17|`StubURLSessionTest`작성, 접근제어 및 파일분리|

<details>
<summary>Details - 구현 내용과 기능 설명 </summary>

#### 1️⃣ `DTO`
- 데이터를 전달받을 타입들을 구현했습니다. 각 타입의 이름 뒤에는 데이터를 전달받을 목적임을 명시하기 위해 `Data`를 포함합니다.
    - `ProductListData`
    - `ProductData`
    - `VendorData`
    - `ImageData`

#### 2️⃣ `DummyData`, `StubURLSession`
- 네트워크와 무관한 테스트를 작성하기 위해 Test Double을 작성
  
</details>


## ✅ 프로젝트에서 경험하고 배운 것
- `URLSession`과 메서드를 이용한 네트워킹 방법 </br>

    ☑️ `URLSession` </br>
    ☑️ `URLSessionDataTask` </br>
    ☑️ `HTTPURLResponse` </br>
    ☑️ `dataTask(with: completionHandler)` </br>
- 클로저를 이용한 데이터 전달 방법 </br>

    ☑️ Result Type </br>
    ☑️ Escaping closure </br>
    ☑️ Closure capture value </br> 
- 네트워킹과 무관한 테스트 작성방법과 Test Double </br>

    ☑️ `Test Double`</br>
    ☑️ `Dummy` </br>
    ☑️ `Stub` </br>

    
## 🚀 트러블 슈팅
### 1️⃣ 로컬의 JSON (테스트할때 사용할)키 값과 API문서 상의 키 값이 다른 문제
|<img src="https://i.imgur.com/4Kl6HGR.png" width="300px"/> | <img src="https://i.imgur.com/cpGzC9E.png" width=500px/>|
|:-:|:-:|
|`API문서의 키 값`|`로컬 JSON파일의 키값`|

서버(pageNo)와 JSON(page_no)의 현재 페이지 번호의 key값이 일치하지 않는 문제점이 있었습니다. 
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

## 🔗 참고 링크

[공식문서]
- [📎 Closure](https://docs.swift.org/swift-book/LanguageGuide/Closures.html)
- [📎 URLSession](https://developer.apple.com/documentation/foundation/urlsession)
- [📎 URLSessionDataTask](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory/)
- [📎 dataTask(with:completionHandler:)](https://developer.apple.com/documentation/foundation/urlsession/1410330-datatask/)
- [📎 Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)

[그 외 참고문서] 

- [📎 개발자 소들이 - closure와 @escaping 이해하기](https://babbab2.tistory.com/164)
- [📎 jessesquires - why optional closures in Swift are escaping](https://www.jessesquires.com/blog/2018/06/10/why-optional-swift-closures-are-escaping/)
- [📎 클로저 정복하기(3/3)](https://babbab2.tistory.com/83)
- [📎 Mock을 이용한 UnitTest](https://sujinnaljin.medium.com/swift-mock-%EC%9D%84-%EC%9D%B4%EC%9A%A9%ED%95%9C-network-unit-test-%ED%95%98%EA%B8%B0-a69570defb41)
- [📎 xUnit Patterns.com - Test Double](http://xunitpatterns.com/Test%20Double.html)
- [📎 Steven Curtis - Stubbing, Mocking or Faking](https://medium.com/swlh/stubbing-mocking-or-faking-5674a07bc3db)
