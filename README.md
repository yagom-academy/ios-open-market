# 오픈 마켓

<div align="center">
    <img src="https://img.shields.io/badge/swift-5.7-F05138.svg?style=flat&logo=Swift">
    <img src="https://img.shields.io/badge/14.0-000000.svg?style=flat&logo=iOS">
    <img src="https://img.shields.io/badge/Xcode-13.4.1-white.svg?style=flat&logo=XCode">
    <img src="https://img.shields.io/badge/UIKit-white.svg?style=flat&logo=UIKit">
</div>
  
<br>

> 프로젝트 기간 : 2022.07.11 월 ~ 2022.07.15 금

팀원 : 민쏜, 예톤
리뷰어 : 그린

<br>

## 📚 목차
- [🫂 팀 소개](#-팀-소개)
- [🎯 핵심경험](#-핵심경험)
- [🔑 키워드](#-키워드)
- [🔎 고민한 점](#-고민한-점)


## 🫂 팀 소개

|[민쏜](https://github.com/minsson)|[예톤](https://github.com/yeeton37)|
|:--------:|:--------:|
|<img src="https://i.imgur.com/ZICS3vT.jpg" width=200 height = 200>|<img src = "https://i.imgur.com/TI2ExtK.jpg" width=200 height = 200>|

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
