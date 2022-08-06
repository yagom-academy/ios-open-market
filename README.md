# 오픈 마켓

<div align="center">
    <img src="https://img.shields.io/badge/swift-5.7-F05138.svg?style=flat&logo=Swift">
    <img src="https://img.shields.io/badge/14.0-000000.svg?style=flat&logo=iOS">
    <img src="https://img.shields.io/badge/Xcode-13.4.1-white.svg?style=flat&logo=XCode">
    <img src="https://img.shields.io/badge/UIKit-white.svg?style=flat&logo=UIKit">
</div>
  
<br>

> 프로젝트 기간 : 2022.07.11 월 ~ 2022.08.05 금 
팀원 : [@민쏜](https://github.com/minsson), [@예톤](https://github.com/yeeton37)
리뷰어 : [@그린](https://github.com/GREENOVER)

## 📚 목차
- 🫂 [팀 소개](#-팀-소개)
- 🎯 [핵심경험](#-핵심경험)
- 🔑 [키워드](#-키워드)
- 🔎 [STEP 1 고민한점](#-step-1)
    - [1. 네트워크 상황과 무관한 네트워킹 데이터 타입의 unit test](#1-네트워크-상황과-무관한-네트워킹-데이터-타입의-unit-test)
    - [2. 각 화면별 모델의 구성](#2-각-화면별-모델의-구성)
    - [3. json 데이터 파싱](#3-json-데이터-파싱)
    - [4. urlSessionDataTask init() Deprecated](#4-urlsessiondatatask---init-deprecated)
    - [5. 구조체 타입 내부 enum](#5-구조체-타입-내부-enum)
    
- 🔎 [STEP 1 리팩토링](#-step1-리팩토링)
    - [1. 각 화면별 모델의 구성](#1-각-화면별-모델의-구성)
    - [2. 구조체 타입 내부 enum](#2-구조체-타입-내부-enum)
    
- 🔎 [STEP 2 고민한점](#-step-2)
    - [1. 이미지의 네트워킹 지연에 따라 잘못된 이미지가 표시되는 문제](#1-이미지의-네트워킹-지연에-따라-잘못된-이미지가-표시되는-문제)
    - [2. segmentedControl로 listGrid뷰를 스위칭하기위한 구조](#2-segmentedcontrol로-listgrid-뷰를-스위칭하기-위한-구조)
    - [3. 뷰컨트롤러의 데이터를 셀로 전달해줄 때 호출순서에 대한 오류](#3-뷰-컨트롤러의-데이터를-셀로-전달해-줄-때-호출-순서에-대한-오류)
    - [4. diffableDatasource 생성과 networking의 호출 시점 문제](#4-diffable-datasource-생성과-networking의-호출-시점-문제)


## 🫂 팀 소개

|[민쏜](https://github.com/minsson)|[예톤](https://github.com/yeeton37)|
|:--------:|:--------:|
|<img src="https://i.imgur.com/ZICS3vT.jpg" width=200 height=200>|<img src = "https://i.imgur.com/TI2ExtK.jpg" width=200 height = 230>|

## 🎯 핵심경험 
- [x] 파싱한 JSON 데이터와 매핑할 모델 설계
- [x] URL Session을 활용한 서버와의 통신
- [x] CodingKeys 프로토콜의 활용
- [x] 네트워크 상황과 무관한 네트워킹 데이터 타입의 단위 테스트(Unit Test)

## 🔑 키워드 
- `URL`, `URLSession`
- `Test Doubles`, `의존성 주입`, `async method test`
- `URLSessionDataTask` 
- `Result<Success, Failure>`
- `statusCode`, `URLResponse`, `HTTPURLResponse`
- `URLComponents`, `NSLayoutConstraint`, `UICollectionViewCompositionalLayout`
- `prepareForReuse`, `Cancel`
- `UICollectionViewDiffableDataSource`, `NSDiffableDataSourceSnapshot`, `CellRegistration`
- `NSCache`
- `UISegmentedControl`
     
## 📚 참고 문서
- [URLSession](https://developer.apple.com/documentation/foundation/urlsession)
- [Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
- [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview)
- [Modern cell configuration](https://developer.apple.com/videos/play/wwdc2020/10027/)
- [Lists in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10026)
- [Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)
- [Cancelling Image Requests](https://cocoacasts.com/image-caching-in-swift-cancelling-image-requests)

<br> 

## 🔎 고민한 점 

## 🥾 STEP 1

### 1. 네트워크 상황과 무관한 네트워킹 데이터 타입의 Unit Test

#### 현재의 코드 (테스트 불가능한 코드)
```swift
struct DataManager {
    static func performRequestToAPI(with request: String, completion: @escaping ((Data) -> Void)) {
        
    let task = URLSession.shared.dataTask(with: url) { }
    task.resume()
}
```

- 모든 화면에서 각 화면 별로 네트워크와 통신하며 데이터를 가져와야 한다고 생각했습니다.
- 이러한 관점에서 데이터와 통신하는 메서드는 공통적으로 쓰일 것이므로, `DataManager` 타입을 만들고 `타입 메서드`로 구현한다면 각 화면에서 `DataManager` 객체에 의존하지 않는 장점이 있다고 생각했습니다. (최근 의존성 주입에 대한 공부를 한 영향을 받아 각 객체 내부에서 인스턴스 생성을 피하고 싶다는 마음도 있었습니다.)
- 그런데 이 코드를 바탕으로 네트워크와 무관한 네트워킹 데이터 타입의 단위 테스트를 하려고 하자 문제가 발생했습니다.

#### 네트워크와 무관한 코드를 작성하는 과정과 문제
```swift
struct DataManager {
    
    private static let session: URLSession = URLSession.shared
    
    static func performRequestToAPI(with request: String, completion: @escaping ((Data) -> Void)) {
        
        let task = session.dataTask(with: url) {  }
        task.resume()
    }
}
```

- `야곰닷넷`의 `Unit Test` 강의에서 관련 내용을 공부해 구현하려고 했는데, 기존의 `타입 메서드`를 유지하기 위해서 `session` 변수 또한 `타입 프로퍼티`로 생성해주어야 했습니다.
- `타입 프로퍼티`의 경우 클래스의 `init` 메서드에 구현할 수 없었습니다.
- `init` 메서드에 구현할 수가 없으니 `Unit Test`에서 `StubURLSession` 등으로 내용을 교체할 수가 없었습니다.

#### 테스트 가능한 코드 vs 불가능한 코드
- 결론적으로, 저희가 작성한 코드는 `테스트 불가능한 코드`라고 생각했습니다. 
- `테스트 가능한 코드`로 만드려면 `DataManager`의 `타입 메서드`를 일반적인 `인스턴스 메서드`로 변경한 후, 뷰컨트롤러에는 `DataManager`의 인스턴스만 생성해주면 됩니다.
- 테스트가 필수라면 아직 수정이 용이한 현 시점에 변경하는 것이 가장 경제적이라고 생각했습니다.
- 하지만 단순히 `제공된 Mock 데이터를 활용해 모델이 네트워크 통신의 결과 데이터를 문제 없이 표현하고 활용할 수 있는지` 테스트하기 위해 저희가 효율적이라고 생각하는 구조를 변경해야 하는 건지 의문이 들었습니다 
    - 특히, 이런 테스트는 네트워킹과는 별도로 `parse` 메서드의 정상 작동 여부를 확인하는 것으로 충분할 수 있다는 생각도 들었습니다.
    - 물론, `타입 메서드`를 이런 방식으로 활용하는 게 정말로 좋은 구조인지는 모르겠습니다. 이 부분도 궁금합니다. 
    - 사실 이런 구조를 유지하는 것의 효용성과 유닛 테스트의 효용성을 대략적이나마 비교할 수 있다면 의사결정이 용이했을 거라는 생각이 듭니다. 더 많은 공부와 시행착오가 필요할 것 같습니다.


---

### 2. 각 화면별 모델의 구성
#### 처음의 생각 (효율성 및 최적화 측면)
- 서버에서 데이터를 받아오면 `상품명`, `상품번호` 등 모든 화면에서 공용으로 사용되는 데이터가 많습니다.
- 처음에는 각 화면에서 데이터를 가져오는 게 비효율적이니, 한번 서버로부터 가져온 데이터는 일정 한도 내에서 메모리에 보관해놓고, 모든 화면에서 공유하면 좋겠다는 생각이 들었습니다.
- 테이블뷰에서 위 아래 10개씩만큼의 데이터를 미리 받아놓는 등, 어떤 데이터를 어떤 기준으로 받아놓을지 결정해야 할텐데, 이게 유의미한 고민인지 의문이 들었습니다.
- 그럼에도 구현할 수만 있다면 앱의 속도가 더욱 빨라질 수 있을 것이라고 생각했습니다.


#### 현재의 생각 (구현 용이성, 유지보수 용이성 측면)
- 위의 고민을 하며 다른 앱에서는 어떤 식으로 구현해놓았는지 궁금했고, 가장 자료가 많을 것 같은 당근마켓 앱을 살펴보았습니다.
- 그동안 당근마켓 앱에서는 아무리 스크롤을 내려도 다른 앱들과 달리 데이터 로딩에 버벅임이 없었던 경험이 있어, 저희가 위에서 서술한 내용으로 구현되어 있을 수도 있다고 생각했습니다.
- 이를 위해서 중고 물품이 테이블뷰로 나오는 화면에 들어가 일정 시간을 기다린 후, 인터넷 접속을 해제하고 물품 중 하나를 탭해 상세 글 화면으로 이동해보았습니다. 예상과 달리 네트워크 연결 오류로 다음 화면의 내용이 표시되지 않았습니다.
- 실제로 네트워크에 접속 중인 상태에서도 화면 이동시 물품 이미지 사진 로딩에 아주 약간의 지연이 발생하며, 로딩되는 동안 회색화면으로 보이는 것을 알 수 있었습니다.
- 이런 대규모 서비스도 저희가 처음 한 생각대로 구현해놓지 않는다면, 안 하는 이유가 있을 거라고 생각했습니다.
    - 기술적으로 불가능하다.
    - 기술적으로 가능하지만, 이를 통해 유저가 느낄 효용에 비해 유지보수 등의 난이도가 급격하게 상승한다
- 따라서 향후 Step에서 여러 화면을 구현할 때 각 화면 별로 필요한 데이터를 비동기로 받아오는 것이 좋겠다는 생각이 들었습니다.


---

### 3. json 데이터 파싱
#### json 데이터를 받아오는 네이밍 변경
- Mock 데이터로 사용한 "products.json"에서는 개별 항목을 `page`라고 네이밍하고 있습니다.
- 저희는 page가 상품 전체를 보여주는 이름이 더 적절해보여, 해당 데이터를 받는 타입을 `ItemListPage`라고 정의했습니다.
- 기존 `page`는 `Item`으로 변경했습니다.

#### json 데이터를 받아오는 구조
- 각 아이템의 `name`과 `currency`를 `String`으로 받을지, `Enum`으로 받을지 고민했습니다.
- `currency`의 경우 화폐의 종류가 한정되어 있어 `enum`으로 바꾸면 더 편하고 효율적이라고 생각합니다.
- `name`의 경우 오타 등을 방지하기 위해 `상품 등록` 시에 입력받은 이름을 `enum`으로 받아 서버와 앱 전체에서 공유하면 좋겠다는 생각이 들었습니다. 
    - 하지만 데이터를 서버에서 받아오다 보니 저희가 관여할 수 있는 영역이 아닐 것 같다는 생각이 들었습니다. 앱 개발자가 이러한 영역에도 관여할 수 있는지, 실무에서는 어떤지 궁금합니다.

---

### 4. URLSessionDataTask - init() deprecated 
- 야곰닷넷의 unit test강의를 보며 테스트 코드를 작성하다가 `init` 부분에서 워닝을 발견했습니다.

```swift
class StubURLSessionDataTask: URLSessionDataTask {
    var dummyData: DummyData?

    // 여기
    init(dummy: DummyData?, completionHandler: DataTaskCompletionHandler?) {
        self.dummyData = dummy
        self.dummyData?.completionHandler = completionHandler
    }

    override func resume() {
        dummyData?.completion()
    }
}
```
에러의 내용은 아래와 같습니다.
> 'init()' was deprecated in iOS 13.0: Please use -[NSURLSession dataTaskWithRequest:] or other NSURLSession methods to create instances

- 이 경고를 해결하기 위해서 여기저기 검색해보다가 `URLProtocol`을 상속받은 `MockURLProtocol`을 사용하여 init을 사용하지 않는 방법과, 혹은 `URLSessionDataTaskProtocol`을 만들어서 `URLSessionDataTask`를 `extension`해주어 init을 사용하지 않는 방법 두 가지 방법에 대해 알게되었습니다.
- 하지만 두 가지 방법 모두 이해하기가..조금 어려워서 적용하지 못했습니다. 저희가 step 1의 Mock 데이터 테스트를 추후에 구현하게 된다면 이 경고를 해결하고 싶은데 좋은 방법이 있을지 그린에게 여쭤보고 싶습니다. 


---

### 5. 구조체 타입 내부 Enum
#### Enum을 구조체 타입 내부에 넣어줄 시 장단점

- 지금까지 프로젝트할 때에는 `Name Space`를 제거하기 위해서 `Name Space`를 `Enum` 타입으로 만들어서 전역에서 사용가능하도록 해주었습니다. 
- 그러나 이번 프로젝트에서는 민쏜의 의견에 따라 클래스 타입 내부에서만 사용되는 Name Space들을 정의해주기 위해서 타입 내부에 enum을 선언해준 뒤 `private`으로 접근 제한을 걸어주었습니다.
- 이렇게 타입 내부에 필요한 enum들만 생성해주고, 나중에 뷰컨트롤러가 더 많이 생길 때 공통되는 enum을 전역으로 한번에 빼주려고 생각해서 이렇게 코드를 작성했는데, 전역으로 enum을 선언하는 것과 타입 내부에 enum을 선언하는 것의 장단점이 무엇인지 궁금합니다.


---


## 🔎 STEP1 리팩토링


### 1. 각 화면별 모델의 구성

- 저희가 고민했던 것은 당근마켓 앱을 실행하면서 화면의 테이블뷰에서 데이터를 미리 어느정도 받아놓는 것인지, 혹은 네트워킹을 통해 그때 그때 받아오는 것인지?에 대한 것이었습니다.
- 그린의 코멘트를 읽고 나서 이해한 바로는 실제 뷰를 띄울 때 모든 상품들을 다 받아온 다음 다같이 나타내게 해줄 수도 있는 것이고, 페이지네이션을 통해 조금씩 필요한 데이터를 그때그때 받아올 수도 있는데 당근마켓과 같은 대규모의 앱이라면 조금씩 필요한 데이터를 그때그때 받아오는 페이지네이션을 이용했을 것이라는 것이었습니다.
- 또한 캐싱이라는 개념에 대해 아직 정확히 공부해보진 못했지만, 기기를 끄기 전까지 임시로 저장해두는 NSCache라는 클래스를 사용하여 한번 받아온 데이터는 캐싱을 해두어 나중에 더 빠르게 불러올 수 있다는 사실도 알게되었습니다. 
- 결론적으로 그때그때 네트워킹을 통해 데이터를 불러오는 것은 그렇게 할 수는 있지만 속도 저하나 사용성에 좋지 않을 수 있고, 또 데이터를 미리 모두 받아놓는 것은 사용자가 한 개의 데이터만 보고 나가는 등의 상황을 고려했을 때 성능상 문제가 발생할 수 있다고 이해했습니다.



---

### 2. 구조체 타입 내부 Enum
- 코드 작성 당시 민쏜의 생각은 클래스 타입 내부에서만 사용되는 Name Space들을 정의해주기 위해서 타입 내부에 enum을 선언해준 뒤 private으로 접근 제한을 걸어주자는 의견이었습니다. 
- 저(예톤)는 이렇게 클래스 내부에서만 프로퍼티를 사용할 때에는 enum을 클래스 내부에 선언해줄 수 있다는 사실을 처음 알았고, 원래는 항상 네임스페이스를 정의해줄 때는 전역으로 파일을 생성해서 만들어주었었습니다. 
- 그럼에도 민쏜의 의견에 따라간 이유는 그당시 프로젝트의 모든 요구사항을 알지 못했고 프로젝트에 대한 전체적인 방향성을 알지 못했던 상황에서 일단 이미 구현해놓은 뷰컨에만 해당되도록 네임스페이스를 지정해주고, 추후에 뷰컨이 더 추가되고 프로젝트의 큰그림이 잡혔을 때 모든 중복되는 타입들을 전역으로 빼주자고 하는 민쏜의 의견에 적극 동감했기 때문입니다. 

- 타입 메서드나 프로퍼티를 사용할 시
    -  장점: 
        - 불필요한 인스턴스를 생성해주지 않아도 된다.
        - 전역적으로 사용가능하다.
    - 단점:
        - 공유자원(프로퍼티 등)이 있을 때는 공유자원도 static으로 설정해줘야 하기 때문에 다른 곳에서 공유자원을 사용할 수 있게 됨. 즉, 공유자원이 있는 경우에는 타입 메서드를 사용하는 것이 모순일 수 있다.
        - 은닉화가 불가능하다.
        - 불필요한(원하지 않는)곳에서 메서드나 프로퍼티를 호출할 수 있기 때문에 사이드 이펙트가 발생할 수 있음 *사이드 이펙트: 원래의 목적과 다르게 다른 효과 또는 부작용이 발생하는 것
        - 메모리에 전역적으로 위치
- 의존성 주입을 어느 곳에서부터 내려줘야할 지 고민한다면, 최상단에서부터 값을 집어넣어 내려줄 수 있다고 생각하면 된다. -> 사이드 이펙트 막아줄 수 있음(한곳에서 관리가 되는 것이니까)

---


## 🥾 STEP 2

### 1. 이미지의 네트워킹 지연에 따라 잘못된 이미지가 표시되는 문제
- **문제 상황**
    - 스크롤을 빠르게 내릴 시 상품 조회 뷰에서 이미지를 받아오는 네트워킹이 지연될 경우 `data task`가 쌓이게 됩니다
    - 셀이 재사용될 때마다 `data task`가 쌓여, 네트워킹이 완료될 때마다 이미 지나가서 필요하지 않는 이미지(이전 재사용 시점에 요청한 이미지)가 뒤늦게 셀에 적용되는 문제가 발생했습니다.
    - 한 페이지에 표시하는 셀이 많을수록, 스크롤 속도가 빨라질수록 심해져, 스크롤을 정지한 상태인데 하나의 셀에서 약 0.5초에 한번씩 이미지가 5-6번에 걸쳐 변경되는 것을 볼 수 있었습니다.

- **해결 방법**
    - 이미지 네트워킹시, 캐시에 해당 이미지가 있으면 사용하고, 없으면 네트워킹 `data task`를 `resume` 하고 있습니다.
    - 그 후 셀의 `prepareForReuse()` 메서드에서 해당 셀의 `data task`가 `cancel` 되도록 구현했습니다.
        - 셀이 화면에 더 이상 보이지 않게 되었을 때 `prepareForReuse()` 메서드가 실행되므로, 이미 스크롤이 옮겨져 이전에 요청했던 이미지가 불필요해지기 때문입니다.
        - 만약 스크롤이 넘어가기 전에 네트워킹이 완료된다면, 캐시에 저장 및 화면에 표시하도록 구현했습니다.

- **의문점**
    - 스크롤을 위아래로 빠르게 이동할 경우, `data task`가 의미 없이 `resume`되고 `cancel`되는 현상이 반복됩니다. 즉, `resume` 후 `cancel`되는 시점까지의 데이터 작업이 무의미한 비용이 됩니다. 이러한 점에 대해 현업에서는 어떻게 대처하는지 궁금합니다.



---


### 2. SegmentedControl로 List/Grid 뷰를 스위칭하기 위한 구조

세 가지 방법과 각 방법의 장단점에 대해 생각해보고, `결론적으로는 세 번째 방법을 선택했습니다.`

장단점은 저희가 직접 해보지 않았고, 대규모의 앱을 다뤄본 적이 없어 상황에 따른 장단점을 정확하게 추측하기 어려웠습니다.

#### 1) 컴포지셔널 레이아웃과 셀 자체의 레이아웃을 변경하는 방법

|    객체   | 개수 |                               내용                                  |
|:--------:| :--: | :----------------------------------------------------------------:|
| 뷰컨트롤러  | 1 | 상품 조회 페이지 전체를 나타내는 뷰를 관리                                      |
|  컬렉션 뷰 | 1 | - 루트 뷰 컨트롤러에 포함된 컬렉션 뷰(List/Grid 선택에 따라 컴포지셔널 레이아웃만 변경) |
|   셀 타입  | 1 | - 하나의 셀 안에서 같은 데이터를 공유                                         |
| 셀 레이아웃 | 2 | - List 컬렉션 뷰 셀의 레이아웃<br>- Grid 컬렉션 뷰 셀의 레이아웃                  |

- **장점**
    - 앱 최적화 측면에서 가장 효율적일 것으로 예상합니다.
    - 중복된 네트워킹과 코드를 모두 피할 수 있습니다.
- **단점**
    - 하나의 뷰컨트롤러가 다양한 역할을 수행합니다.
        - `segmented control` 구현 및 분기 처리
        - 셀 레이아웃에 대한 분기처리
    - 하나의 셀 안에 List/Grid 두 종류의 레이아웃이 있습니다.
    - 역할이 잘게 나뉘어있지 않으므로 추후 유지보수시 혼동이 생길 수 있어 보입니다.



#### 2) List/Grid 형태에 대해 각각의 셀을 만드는 방법
|    객체   | 개수 |                               내용                                  |
|:-----------:| :----: | :-----------------------------------------------------------:|
| 뷰컨트롤러  | 1 | - 상품 조회 페이지 전체를 나타내는 뷰를 관리                                   |
|  컬렉션 뷰 | 1 | - 루트 뷰 컨트롤러에 포함된 컬렉션 뷰(List/Grid 선택에 따라 컴포지셔널 레이아웃만 변경) |
|   셀 타입  | 2 | - List 컬렉션 뷰 셀<br>- Grid 컬렉션 뷰 셀                                 |
| 셀 레이아웃 | 2 | - List 컬렉션 뷰 셀의 레이아웃<br>- Grid 컬렉션 뷰 셀의 레이아웃                |
- **장점**
    - 최적화 측면 및 중복된 네트워킹 방지 측면에서 1번과 유사합니다.
    - 1번과 비교해 List 셀과 Grid 셀이 각자의 레이아웃을 따로 갖고 있으므로, 각 셀의 코드가 더 명료해집니다.
- **단점**
    - 하나의 셀 안에 List/Grid 두 종류의 레이아웃을 갖고 있지 않다는 점을 제외하고 1번과 유사합니다.



#### 3) 하나의 컨테이너 뷰 컨트롤러 안에 List/Grid 뷰 컨트롤러 각 하나씩을 child로 embed하는 방법
|    객체   | 개수 |                               내용                                  |
|:--------:| :----: | :-----------------------------------------------------------:|
| 뷰컨트롤러  | 3 | - 컨테이너 뷰 컨트롤러: segmented control과 2개의 차일드 뷰 컨트롤러를 가짐 <br>- List 컬렉션 뷰 컨트롤러 <br>- Grid 컬렉션 뷰 컨트롤러  |
|  컬렉션 뷰 | 2 | - List 컬렉션 뷰 컨트롤러의 컬렉션 뷰<br>- Grid 컬렉션 뷰 컨트롤러의 컬렉션 뷰       |
|   셀 타입  | 2 | - List 컬렉션 뷰 셀<br>- Grid 컬렉션 뷰 셀                                 |
| 셀 레이아웃 | 2 | - List 컬렉션 뷰 셀의 레이아웃<br>- Grid 컬렉션 뷰 셀의 레이아웃                 |
- **장점**
    - 각 객체가 자신의 역할을 명확하게 갖고 있다고 생각합니다.
        - 각 뷰에 대한 변동 사항 발생시 각 객체만 수정하면 되므로 유지보수가 용이할 것이라고 생각합니다.


- **단점**
    - 중복되는 코드는 프로토콜을 활용, 기본 구현 후 채택하는 방식으로 중복되는 코드가 거의 없을 것이며, 각 객체에는 최소한의 코드가 있어 파일별 코드 길이도 무척 짧을 것이라고 생각했었는데, 그렇지 않았습니다.
        - 실제로 해보니 거의 비슷한 코드임에도 불구하고 접근 제어 등에서 문제가 생겨 기본구현에 넣지 못하는 코드가 많았습니다.
        - 접근 제어와 프로토콜의 기본 구현을 통한 중복 코드의 제거 중 접근 제어를 선택해 중복 코드가 더 많아졌습니다.
        - 프로토콜&기본구현을 사용하면서도 평소와 같이 접근제어를 할 수 있는 방법이 있는지, 아니라면 어떤 방식을 택하는 게 좋은지 그린의 의견이 궁금합니다.
    - 유저 입장에서는 하나의 뷰로 보이겠지만, 실제로는 isHidden 프로퍼티를 이용해 List 컬렉션 뷰와 Grid 컬렉션 뷰가 동시에 사용되고 있어, 성능 측면에서 아쉬움이 있습니다.


- **채택한 이유**
    - 위에 작성한 장점을 고려했습니다.
    - 위 단점에서 서술했듯이, 실제로 코드를 완성하기 전에는 셀과 뷰컨트롤러의 중복 코드들을 프로토콜의 기본구현으로 제거해, POP 프로그래밍이 가능해질 것이라고 생각했습니다.
    - 성능 측면에서 영향을 줄 수 있는 건 두 가지로 보이는데, 두 가지가 유의미한 영향을 주지 않는다고 생각했습니다. 다만 이 부분은 특히 근거 없는 예상일 뿐이므로 검증이 필요해보입니다. (특히, 현재 규모에서 유의미하지 않다고 하더라도 규모가 커진다면 어떤 영향을 초래할지 궁금합니다.)
        - 네트워킹을 2배로 하는 문제: 실질적으로 성능에 영향을 미치는 건 이미지인데, 이미지의 경우 이미지의 URL을 key로 사용하여 캐싱합니다. 따라서 List 뷰 혹은 Grid 뷰 중 한 곳에서라도 네트워킹을 진행한 후에는 캐시에서 이미지를 불러오고, 텍스트만 새로 네트워킹하므로, 성능에 유의미한 영향을 주지 않는다고 생각했습니다.
        - 2개의 뷰를 동시에 유지하는 비용: 하나의 뷰가 표시되는 동안 다른 하나의 뷰는 보이지 않고, 해당 뷰를 스크롤하는 등 업데이트 작업을 전달하지 않기 때문에, 화면에 표시되지 않는 뷰가 차지하는 자원이 유의미하지 않을 것이라고 생각했습니다.


저희가 생각한 장단점이 맞는지, 현업에서는 어떤 방식을 선호하는지 궁금합니다.



---

### 3. 뷰 컨트롤러의 데이터를 셀로 전달해 줄 때 호출 순서에 대한 오류


#### 데이터 전달이 정상적으로 되지 않았던 코드 

**[ViewController]**
```swift
func configureListDataSource()
    ->  UICollectionViewDiffableDataSource<Section, ItemListPage.Item> {
        let registration = UICollectionView.CellRegistration<ListCollectionViewCell, ItemListPage.Item>.init { cell, _, item in
            cell.receiveData(item) // 문제 발생 지점
        }

```
**[ListCollectionViewCell]**
```swift
override init(frame: CGRect) {
    super.init(frame: frame)
        
    arrangeSubView()
    configureCell() // 문제 발생 지점
}
    
required init?(coder: NSCoder) {
    super.init(coder: coder)
}
    
func receiveData(_ data: ItemListPage.Item) {
    self.item = data
}

private func configureCell() {
    guard let item = item else {
        return
    }
        
    let imageData = item.thumbnail
    guard let url = URL(string: imageData) else { return }
    guard let imageData = try? Data(contentsOf: url) else { return }
        
    let image = UIImage(data: imageData)
        
    self.productImageView.image = image
    self.stockLabel.text = "잔여수량 : \(item.stock)"
    self.priceLabel.text = "\(item.price)"
    self.nameLabel.text = item.name
}
```
- 위와 같은 코드를 썼을 때, Cell의 configureCell() 내부의 코드에 item 데이터가 제대로 들어가지 않는 문제가 발생했습니다.

- 저희가 처음 생각했던 방향은 아래와 같았습니다.

    1\) `VC`에서 `configureListDataSource()`를 호출하면서 `Cell`을 등록
    2\) 이때 내부에서 데이터가 담겨있는 item 프로퍼티를 넘겨주는 `cell.receiveData(item)`을 실행
    3\) `VC`에 있던 item 데이터가 `Cell`의 item 프로퍼티로 전달
    4\) 바로 `Cell` 내부의 `override init()` 이 호출되면서 `configureCell()`을 실행
    5\) `configureCell()` 내부에서 `item`의 데이터로 UI 적용
 
- 하지만 cell은 형성되는 시점에서 `override init()`이 실행되므로, 2,3,4번의 순서가 틀렸다는 것을 알게 되었습니다.
    - **override init() 호출 이유**: 셀이 생성될 때, 인터페이스 빌더에서는 자동으로 셀을 초기화 해주지만, 코드에서는 인터페이스 빌더를 사용하는 것이 아니기 때문에 직접 override init()을 통해 셀을 초기화를 해줘야 합니다.

- 그렇다면 뷰컨트롤러에서 item을 넘겨주는 시점은 cell이 생성되는 시점에 호출되는 `override init()` 내부에 있는 `configureCell()`이 실행되고 나서가 될 수 있다는 뜻이고, 즉, VC에 있던 item 데이터가 미처 cell로 전달되지 않았는데 Cell 내부의 `configureCell()`이 실행될 수 있다는 것을 알게 되었습니다.
- 위 문제를 해결해주기 위해서 cell 내부 receiveData 메서드가 뷰컨에서 호출되고 나서 configureCell()이 실행되도록 호출 순서를 변경해주었습니다.

[**변경한 메서드**] 
```swift
func receiveData(_ item: ItemListPage.Item) {
    configureCell(with: item)
}
```


---

### 4. Diffable DataSource 생성과 Networking의 호출 시점 문제 

- 네트워킹을 통해 데이터를 받아오는 시점과 디퍼블 데이터 소스를 통해 셀에 데이터를 적용시켜주는 시점에 대해 고민했습니다.

**[VC의 ViewDidLoad]**
 
```swift
import UIKit

final class ItemListPageViewController: UIViewController {
    var dataSource: UICollectionViewDiffableDataSource<Section, ItemListPage.Item>!
    var snapshot = NSDiffableDataSourceSnapshot<Section, ItemListPage.Item>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getProductList()
        configureDataSource() 
    }
}
```
**[VC의 메서드 getProductList, configureDataSource 구현부]**
```swift
extension ItemListPageViewController {
    func getProductList() {
        print(#function)
        NetworkManager.performRequestToAPI(from: HostAPI.openMarket.url, with: request) { (result: Result<Data, NetworkingError>) in
            
            switch result {
            case .success(let data):
                self.itemListPage = NetworkManager.parse(data, into: ItemListPage.self)
                
                self.snapshot.appendSections([.main])
                self.snapshot.appendItems(self.itemListPage!.items)
                DispatchQueue.main.sync {
                    sleep(UInt32(5))
                }
                self.dataSource.apply(self.snapshot, animatingDifferences: false)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ItemListPage.Item> (collectionView: itemCollectionView) { [self]
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: ItemListPage.Item) -> UICollectionViewCell? in
            print(#function)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemListCollectionViewCell", for: indexPath) as? ItemListCollectionViewCell else {
                return ItemListCollectionViewCell()
            }
            
            if let item = itemListPage?.items[indexPath.item] {
                cell.receiveData(item)
            }
            
            return cell
        }
    }
}
```

- 처음에 구현했던 코드에서 뷰컨트롤러의 viewDidLoad에서 함수를 호출해주는 순서가 **getProductList -> configureDataSource** 순이었습니다. 
- `getProductList` 메서드는 네트워킹을 통해 데이터를 받아온 후에 받아온 데이터를 `snapShot`에 넣어주고 `dataSource`에 `apply`해주는 역할을 하고, `configureDataSource`는 `DiffableDataSource`를 통해 데이터를 관리하고 컬렉션뷰에 대한 셀을 제공하는 역할을 합니다.

- 그런데 위의 메서드 호출 순서에 대해 의문이 생겼습니다.
- getProductList 메서드는 내부에서 escaping 클로저를 활용하기 때문에 메서드 실행이 끝나면 클로저가 던져진 후에 언제 실행되는 지 알 수 없는데, 어떻게 데이터를 다 받아오는 것인지 확신을 하고 그 다음 메서드인 configureDataSource를 호출할 수 있을까? getProductList에서 비동기로 네트워킹을 시켜놓고, 바로 configureDataSource 메서드로 넘어가면 네트워킹 작업이 다 끝나지 않은 채로 셀의 UI를 세팅하기 때문에 셀에 아무것도 나오지 않아 오류가 생길 것이라고 생각했었습니다.
- 하지만 이 상태로 실행하자 UI가 정상적으로 나오는 것을 볼 수 있었습니다.
- 그래서 각 메서드에 break point를 찍어보았더니, 실제 호출하는 순서와 반대로 configureDataSource가 먼저 실행된 후에 getProductList가 실행되는 것을 알 수 있었습니다.
- 즉, 예상대로 비동기적으로 클로져로 던져진 네트워킹이 더 늦게 실행되는 것을 알 수 있었습니다. 그런데 어떻게 UI가 적용되는 것이었을까요?
        
- 더 확실하게 확인해보고 싶어서 아래와 같이 일시적으로 `dataSource.apply` 실행 전에 5초를 지연시키는 코드를 작성해보았습니다.
```swift
self.snapshot.appendSections([.main])
self.snapshot.appendItems(self.itemListPage!.items)
DispatchQueue.main.sync {
sleep(UInt32(5)) // 추가한 코드
}
self.dataSource.apply(self.snapshot, animatingDifferences: false)
```

- 그랬더니 5초 동안 UI가 텅 비어있다가, 5초 후에 콘솔창과 UI가 동시에 업데이트 되는 것을 확인할 수 있었습니다.
- 즉, 디퍼블데이터소스는 apply를 해주기만 하면, 비어있는 UI에 그 순간 데이터를 전달해주는 것이 가능하다는 것을 알 수 있었습니다.
- 이건 평소에 알고있던 상식(데이터가 있어야 셀을 구성할 수 있다)과 달랐는데요, 공식문서에 나와있던 '자동으로 계산해서 UI까지 업데이트한다'라는 내용이 위의 내용을 의미하는 것으로 보입니다.

---


