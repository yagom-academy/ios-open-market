# 🛒 OPEN MARKET
>프로젝트 기간 2022.04.25 ~ 2022.05.06 
>
> 팀원: [Mino](https://github.com/Mino777), [Red](https://github.com/cherrishRed) / 리뷰어 :  [엘림](https://github.com/lina0322)

## 목차

- [프로젝트 소개](#프로젝트-소개)
- [키워드](#키워드)
- [STEP 1](#step-1)
- [STEP 2](#step-2)


## 프로젝트 소개


## 개발환경 및 라이브러리

[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-13.3.1-blue)]()

## 키워드
- `Network`
- `URLSession Mock Test`
- `Json Decoding Strategy`
- `XCTestExpection`
- `completionHandler`
- `Escaping Closure`
- `URLSession`
- `Test Double`

## 자세한 고민 보기
[STEP 1 PR](https://github.com/yagom-academy/ios-open-market/pull/137)
[STEP 2 PR]()

## [STEP 1]

### 🚀 trouble shooting
- sessionDataTask 의 init 이 deprecated 된 문제
 
#### sessionDataTask 의 init 이 deprecated 된 문제 
`문제`
![](https://i.imgur.com/UbpFa0A.png)
```swift
final class StubURLSessionDataTask: URLSessionDataTask {
    var completion: (() -> ())?
    
    override func resume() {
        completion?()
    }
}
```
`URLsessionDataTask` `init` 이 `deprecated` 되어서 `URLSessionDataTask` 를 상속받은 `StubURLSessionDataTask` 를 초기화 해줄 수 없는 문제가 발생했습니다.

`해결`
```swift
protocol URLSessionDataTaskProtocol {
    func resume()
}
```
```swift
final class StubURLSessionDataTask: URLSessionDataTaskProtocol {
    var resumeHandler: () -> Void
    
    init(resumeHandler: @escaping () -> Void) {
        self.resumeHandler = resumeHandler
    }
    
    func resume() {
        resumeHandler()
    }
}
```
`URLSessionDataTaskProtocol` 이라는 것을 생성해서 `StubURLSession` 이 `URLSession` 의 상속을 받는 것이라 아니라
URLSessionDataTaskProtocol 를 채택하도록 만들어 주어서 `URLsessionDataTask`의 `init` 을 사용하지 않도록 하여 문제를 해결했습니다.

#### getter 메서드 네이밍
`문제`
get으로 시작하는 경우 불필요한 단어를 생략하라 라는 규칙을 어겼습니다.
```swift
static func getProductsDetail(id: String) -> EndPoint
```
`해결`
리턴해주는 타입의 이름을 메서드명으로 변경했습니다.
```swift
static func productsList(id: String) -> EndPoint
```

[공식 문서](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CodingGuidelines/Articles/NamingMethods.html)

#### view 의 교체 시기
MainViewController 에 원래 있던 view 가 아니라 커스텀 view 를 사용하였습니다. 
`문제`
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    view = mainView
    }
 }
```
뷰가 로드 되고 나서 `viewDidLoad()` 메서드를 통해서 뷰를 변경해 주었습니다.

`해결`
```swift
override func loadView() {
        super.loadView()
        view = mainView
    }
```
뷰가 로드 될 때 뷰를 바꿔줌으로써 불필요한 view 가 생성되는 것을 막아주었습니다. 



### ✏️ 배운 개념
#### Unit Test 를 위한 의존성 주입, 프로토콜 활용 
실제 네트워크 통신과 무관한 테스트를 작성하기 위해 TestDouble 을 활용했습니다.
TestDouble 의 활용을 위해 객체 간의 분리를 진행하였고 의존성 주입과 프로토콜을 적극 활용했습니다. 
    
#### URL Session을 활용한 네트워크 통신

URLsession 은 싱글톤인 shared 를 가지고 있습니다.
shared 사용하지 않으면 Configuration 을 사용해 커스텀 URLsession 을 만들 수 있습니다. 

<URlsession 에서 사용할 수 있는 task의 종류>
* Data Tasks
NSData를 사용하여 데이터를 보내고 받는다. 짧고 통신이 자주 있을 때 사용한다.
```swift
URLSession.shared.dataTask(with: completionHandler:)
```
* Upload Tasks
데이터를 파일형태로 보낸다. 백그라운드 업로드를 지원한다.
```swift
URLSession.shared.uploadTask(with:from:completionHandler:)
```

* Download Tasks
데이터를 파일형태로 받는다. 백그라운드 다운로드를 지원한다.
```swift
URLSession.shared.downloadTask(with:completionHandler:)
```
> `completionHandler` 부분의 parameter 에는 data, response, error 값이 내려옵니다.
> 기본적으로 `URLSession` 멈추기 때문에 `resume` 을 해줘야 작동합니다.

* Web Socket
```swift
URLSession.shared.webSocketTask(with:)
```
SwiftCopy
RFC 6455 로 지정된 웹소켓 프로토콜을 사용해서 TCP, TLS 로 메세지를 주고 받는다고 한다.
아직은 잘 모르겠다…

#### @escaping closure 및 Result Type
비동기로 메서드가 끝난 이후에 데이터를 전달받기 위해 @escaping closure를 사용하면 된다는 것을 알았습니다.

#### Result Type
Result는 제네릭을 이용해 error 가 나는 상황에서 throw 를 사용하지 않고, Success 와 Failure 를 이용해 오류와 성공을 처리해 줄 수 있는 객체 입니다. 
```swift
@frozen enum Result<Success, Failure> where Failure : Error
```
Result Type을 활용해 성공과 실패에 따른 정상적인 결과및 에러를 반환해 줄 수 있도록 했습니다.

#### POSTMAN 사용법 
Postman을 활용하여 API를 테스트하고, API에 대한 문서를 확인하며 개발했습니다.

## [STEP 2]
### 🚀 trouble shooting

### ✏️ 배운 개념
- collection View 
- modern collection View

