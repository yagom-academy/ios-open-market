## iOS 커리어 스타터 캠프

### 오픈마켓 I 프로젝트 저장소
> 프로젝트 기간: 2022-05-09 ~ 2022-05-20
> 프로젝트 팀원: [@티아나](https://github.com/Kim-TaeHyun-A), [@파프리](https://github.com/papriOS), 리뷰어: [@올라프](https://github.com/1Consumption)


## 구현 화면
![](https://i.imgur.com/JElqAPE.gif) ![](https://i.imgur.com/Vn8Zb8g.gif) 
![](https://i.imgur.com/8lylxba.gif)



## 목차

- [STEP 1](#STEP-1)
    + [고민한 점 및 질문](#고민한_점_및_질문)
- [STEP 2](#STEP-2)
    + [고민한 점 및 질문](#고민한_점_및_질문)
- [그라운드 룰](#그라운드-룰)
    + [스크럼](#스크럼)
    + [코딩 컨벤션](#코딩-컨벤션) 


---

### PR 바로가기
- [STEP 1](https://github.com/yagom-academy/ios-open-market/pull/138)
- [STEP 2](https://github.com/yagom-academy/ios-open-market/pull/152)


### 키워드
`URLSession`
`test double` 
`modern collectionView`


## STEP 1


### 구현내용

* Product, OpenMarketProductList
: 서버에서 받아올 Data에 매칭하기 위한 모델, 각각

* HTTPManager.swift
: 서버와 네트워크 통신을 담당하기 위한 모델

* OpenMarketTests
: Product, OpenMarkerProductList로 JSON 형태의 데이터가 디코딩 되는지 테스트
: HTTPManager의 loadData(), listenHealthChecker() 호출 시 completionHandler가 수행되는지 테스트

* StubURLSessionTests
: 네트워크 통신 없이 의존성 주입을 활용해 테스트 케이스 작성

---

### 고민한 점 및 질문

#### test double

test double이란 테스트를 진행하기 어려운 경우 대신하여 테스트를 진행할 수 있도록 만들어주는 객체라고 합니다. 따라서, 네트워크 통신을 직접하지 않고(외부적인 요인에 영향을 받지 않는 상태로) 테스트할 수 있습니다.

mock과 stub의 가장 큰 차이는 mock은 behavior verification을 진행하고, stub은 status verification을 진행하는 것이 있음을 알았습니다.

status verification 은 다른 타입에 의존적이지만 behavior verifation은 그렇지 않고, 너무 오래걸리거나 다른 것에 영향을 받는 경우에도 간단하게 테스트를 진행할 수 있습니다.

Mock 객체는 expectation을 부여하고 미리 프로그래밍된 object입니다.
여기서 말하는 expectation은 mock 객체가 받을 것이라고 예상되는 call들로 이해하였습니다.
Mock객체는 expectation이 충족되었는지, 즉 불려야할 method(MockURLProtocol의 경우 dataTask 메서드)가 불렸는지를 verify해야하고, 이것이 behavior verification을 진행하는 것이라고 이해했습니다.

* Dummy: 매개변수 만들 때만 사용되는 객체
* Fake: 실제와 유사, but 간단하게 구현된 객체
* Stub: 준비된 결과를 반환, 외부 요인에 따라 응답 않는 객체
* Spy: stub의 일종으로 호출 어떻게 됐는지 기록하는 객체
* Mock: expectation에 대응하는 결과 확인하는 객체

![](https://i.imgur.com/bG73Xdv.png)


```swift
import XCTest
import Foundation

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func stopLoading() { }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
}
```

```swift
func test_loadData_호출하면_productList_GET하는지_확인() {
        // given
        var products: [Product] = []
        
        MockURLProtocol.requestHandler = {request in
            let exampleData = self.dummyProductListData
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type" : "application/json"])!
            return (response, exampleData)
        }
        
        let expectation = XCTestExpectation(description: "It gives productList")
        
        // when
        httpManager.loadData(targetURL: HTTPManager.TargetURL.productList(pageNumber: 2, itemsPerPage: 10)) { data in
            switch data {
            case .success(let data):
                let decodedData = try! JSONDecoder().decode(OpenMarketProductList.self, from: data)
                products = decodedData.products
            default:
                break
            }
            
            // then
            XCTAssertEqual(products.first?.name, "Test Product")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
}
```


#### 비동기 테스트 
HTTPManager의 listenHealthChecker()와 loadData() 메소드는 비동기적으로 동작하는 URLSession.shared.dataTask()를 호출하기 때문에 비동기적으로 작업을 처리합니다.
이러한 비동기 메소드를 테스트하기 위해 expectation(description:), fulfill(), wait(for: timeout:) 라는 세가지 테스트 메소드를 활용했습니다.
* expectation(description:) 으로 어떤 것이 수행되어야하는가에 대한 description을 지정하고,
* fulfill()를 정의된 expectation이 충족되는 시점에 호출하여 동작이 수행되었음을 알립니다.
* wait(for: timeout:)은 for: 에 expectation을 배열로 담을 수 있습니다. 배열에 들어간 expectation이 모두 timeout으로 지정해둔 시간 동안 fulfill되길 기다립니다.
    
#### 서버에서 데이터 fetch
competionHandler를 사용하는 방식과 delegate를 사용하는 방식 중에 전자를 사용해서 구현했습니다.
product 목록(2.5. 상품 리스트 조회)과 product 상세내용(GET2.4. 상품 상세 조회)을 가져오는 경우 url을 제외한 내부 구현이 동일해서 둘 다 loadData 메서드를 사용해서 GET 합니다.
현재 API 서비스의 동작여부 및 Listen을 확인하는 Application HealthChekcer의 경우 따로 받아오는 데이터가 없어서 별도의 메서드(listenHealthChecker)로 구현했습니다. statusCode를 통해 성공여부를 확인합니다.

#### result type
네트워크 성공과 실패를 명확하게 보여주기 위해서 Result type을 사용했습니다.
dataTask의 completionHandler가 throws가 아니라서 에러를 던져서 처리하는 것을 불가능합니다. 따라서 completionHandler에 실패한 결과나 성공한 결과를 담도록 구현했습니다.


---

## STEP 2

### 구현 내용

#### IPHONEOS_DEPLOYMENT_TARGET
modern collection view를 활용하면서
> setNeedsUpdateConfiguration()
UICellConfigurationState
UIConfigurationStateCustomKey
UICollectionLayoutListConfiguration
UICollectionViewCompositionalLayout.list(using: configuration)
UICollectionView.CellRegistration<ProductListCell, Product> { }
collectionView.dequeueConfiguredReusableCell(using: listCellRegisteration, for: indexPath, item: itemIdentifier)

메소드와 타입을 활용하여 target 버전 14이상으로 구현했습니다

#### UI
* 스토리보드를 제거하고 코드로 UI를 구현하였습니다
* 하나의 collectionView의 layout이 List Layout 과 Grid Layout 두가지 모두로 보일 수 있도록 구현하였습니다

#### CollectionView

* Layout object
`applyGridLayout()`, `applyListLayout()` 매서드를  통해 layout object에 대한 설정이 가능합니다


* DataSource
`UICollectionViewDiffableDataSource` 을 활용하였습니다
snapshot에 section은 최초 한 번만 추가합니다.
snapshot으로 셀에 데이터를 넣습니다.
`registerCell()`: ProductListCell과 ProductGridCell의 registration을 진행합니다
`configureDataSource()`: segmentedControl의 변화에 따라 dequeue하는 reusable한 cell이 변경됩니다



#### collectionViewCell
list와 grid에서 공통적으로 사용되는 요소를 한 파일(CellUIComponent)이 구현했습니다.
list와 gird에서 각각 구현하려는 레이아웃에 맞게 stackview 내부 뷰에 요소를 배치했습니다.
state에 값에 대한 상태를 추가하기 위해 `configurationState`를 오버라이딩하고 `updateConfiguration` 매서드를 통해 셀 값이 세팅되도록 구현했습니다.

---

### 고민한 점 및 질문 사항

#### 중복요청에 대한 처리
DataProvider 타입에서 isLoading이라는 플래그를 사용해서 로딩이 진행 중이지 않을 때만 요청을 보낼 수 있도록 구현했습니다. viewcontroller에서는 불필요한 매개변수 없이 단순히 해당 메서드의 호출만으로 데이터를 가져올 수 있습니다.

#### 목록을 로드할 때, 빈 화면을 대신할 무언가  
각 cell의 `prepareForReuse()` 메소드에
기본제공 이미지가 삽입되도록 수정하여, 이미지가 아직 로드되지 않았을때 빈화면 대신 swift 이미지가 보입니다


#### loadView() vs viewDidLoad()
기본 view를 커스텀하기 위해서는 loadView에 구현하고 뷰가 생성된 이후의 설정하기 위해서는 viewDidLoad에 구현합니다. 따라서, viewController에서 제공하는 기본 view를 교체하는 경우는 loadView에서 구현합니다.

#### 클로저 내부의 함수 구현
segmented control을 생성하는 경우 여러 속성을 설정해야 합니다. 가독성을 위해 클로저 내부에 설정과 관련된 함수를 구현하고 이를 호출하는 식으로 구현했습니다.

#### lazy 키워드
프로퍼티의 생성하는 과정에서 다른 프로퍼티를 사용해야 하는 경우나 해당 프로퍼티가 사용될 때 생성됐으면 하는 경우가 아니면 let으로 프로퍼티를 선언하도록 구현했습니다.

#### prepareForReuse
cell을 재사용하는 경우 이전에 설정된 label의 attribute이나 이미지를 초기화하고 올바른 데이터를 cell에 할당할 수 있도록 prepareForReuse 메서드를 오버라이딩했습니다.
cell이 재활용되기 이전에 로딩 중이던 이미지 task가 있으면 취소합니다.

#### datasource의 분기문
분기문이 안에 위치하는 경우 indexPath, itemIdentifier, section을 활용해서 더 세밀하게 datasource를 처리할 수 있기 때문에 더 유연한 코드가 됩니다.

```swift
dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) { [self] (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
             if baseView.segmentedControl.selectedSegmentIndex == 0 {
                 return collectionView.dequeueConfiguredReusableCell(using: listCellRegisteration, for: indexPath, item: itemIdentifier)
             } else {
                 return collectionView.dequeueConfiguredReusableCell(using: gridCellRegisteration, for: indexPath, item: itemIdentifier)
             }
```

#### UUID
서버에서 가져오는 데이터(Product)의 identifier로 UUID를 사용하는 경우 매번 새로운 아이디를 생성하기 때문에 서버의 데이터와 일치하지 않을 수 있습니다. diffable은 identifier로 데이터를 식별하기 때문에 animation에서 문제가 생길 수 있습니다. 따라서, 서버에서 가져오는 값을 사용해서 identifier 지정하도록 구현했습니다. 만약, 서버에서 identifier를 제공하지 않으면 서버에서 제공하는 데이터들의 조합으로 identifier를 구성하게 됩니다.

---

## 그라운드 룰
### 활동시간
오전: 10시 ~ 12시
오후: 2시 ~ 6시(활동학습 있으면 10분 쉬고 만나기)
저녁: 7시반 ~ 상황에 따라(12시 이전까지)

### 커밋 Title 규칙
feat: 새로운 기능의 생성
add: 라이브러리 추가
fix: 버그 수정
docs: 문서 수정
refactor: 코드 리펙토링
test: 테스트 코트, 리펙토링 테스트 코드 추가
chore: 빌드 업무 수정, 패키지 매니저 수정(ex .gitignore 수정 같은 경우)

### 커밋 Body 규칙
title로 설명 끝내기

