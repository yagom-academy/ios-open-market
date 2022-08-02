# 오픈마켓

## 프로젝트 소개
오픈마켓을 창설하여 상품을 관리해본다.

> 프로젝트 기간: 2022-07-25 ~ 2022-08-05</br>
> 팀원: [수꿍](https://github.com/Jeon-Minsu), [데릭](https://github.com/derrickkim0109) </br>
리뷰어: [제이슨](https://github.com/ehgud0670)</br>


## 📑 목차

- [🧑🏻‍💻🧑🏻‍💻 개발자 소개](#-개발자-소개)
- [⏱ TimeLine](#-TimeLine)
- [💡 키워드](#-키워드)
- [🤔 핵심경험](#-핵심경험)
- [📱 실행 화면](#-실행-화면)
- [🗂 폴더 구조](#-폴더-구조)
- [📝 기능설명](#-기능설명)
- [🚀 TroubleShooting](#-TroubleShooting)
- [📚 참고문서](#-참고문서)


## 🧑🏻‍💻🧑🏻‍💻 개발자 소개

|수꿍|데릭|
|:---:|:---:|
|<image src = "https://i.imgur.com/6HkYdmp.png" width="250" height="250">|<image src = "https://avatars.githubusercontent.com/u/59466342?v=4" width="250" height="250">
|[수꿍](https://github.com/Jeon-Minsu)|[데릭](https://github.com/derrickkim0109)|

### Week 1
    
> 2022.7.25 ~ 2022.7.29
    
- 2022.07.25 
    - MDN을 기반으로 HTTP POST 공부
- 2022.07.26 
    - HTTP Post 기능구현
    - Delete secret(POST) 기능구현
    - Builder 패턴 URLComponents 타입 구현
    - HTTPMethod enum
    - APIConfiguration(url, mimetype, path, parameters) 타입 구현

- 2022.07.27
    - ProductModificationAPIManager를 통행 patch 기능 구현
    - ProductSecretRetrievalAPIManager를 바탕으로 secret 조회 기능 추가
    - ProductDeleteAPIManager를 통한 delete 기능 구현
    
- 2022.07.28
    - TextField, ImagePicker 기능 구현
    - ProductEnrollmentViewController로의 화면 전환 방식 Navigation에서 Modal로 변경
    - Autolayout
    
- 2022.07.29
    - Keyboard 줄바꿈 시 TextView 라인 자동 생성 및 View 높이에 맞게 Keyboard 설정
    - UIScrollView 내에서의 UITextField Autolayout 설정
    

## 💡 키워드

- `UICollectionViewDelegate`
- `HTTP`, `Header`, `Body`
- `HTTPMethod`, `GET`, `POST`, `PATCH`, `DELETE`
- `UIImagePickerController`, `editedImage`, `originalImage`
- `UITextField`, `placeholder`, `keyboardType`
- `Keyboard`, `keyboardFrameEndUserInfoKey`
- `UIScrollView`, `contentInset`, `scrollIndicatorInsets`
- `UITextView`, `UITextViewDelegate`
- `URLComponents`
- `MIMEType`, `applicaetionJSON`, `multipart/form-data`
- `Content-Type`, `Content-Disposition`, `boundary`, `name`, `filename`, `carriage return`, `line feed`
    
## 🤔 핵심경험

- [x] multipart/form-data의 구조 파악
- [x] URLSession을 활용한 multipart/form-data 요청 전송
- [x] 사용자 친화적인 UI/UX 구현 (적절한 입력 컴포넌트 사용, 알맞은 키보드 타입 지정)
- [x] UIAlertController 액션의 completion handler 활용
- [x] UIAlertController의 textFields 활용
- [ ] UICollectionView 를 통한 좌우 스크롤 기능 구현
- [x] 상속 혹은 프로토콜 기본구현을 통해 (수정/등록 과정의) 공통기능 구현


## 📱 실행 화면

|상품 등록 화면|글자수 부족 유효성 검사|상품명 미작성 유효성 검사|글자수 초과 유효성 검사|
|:--:|:--:|:--:|:--:|
|![상품 등록 화면](https://i.imgur.com/qO0Yk43.gif)|![상품명 글자 유효성 검사](https://i.imgur.com/RLLoKJY.gif)|![상품명 미작성 유효성 검사](https://i.imgur.com/Bi8BfHR.gif)|![글자수 초과 유효성 검사](https://i.imgur.com/qQyghFE.gif)|


|글자수 초과 유효성 검사(2)|이미지 초과 유효성 검사|상품 등록 요건 부족|상품 등록 요건 충족|
|:--:|:--:|:--:|:--:|
|![글자수 초과 유효성 검사(2)](https://i.imgur.com/b9SStmM.gif)|![이미지 초과 유효성 검사](https://i.imgur.com/p3W1Iww.gif)|![상품 등록 요건 부족](https://i.imgur.com/QVwSAqK.gif)|![상품 등록 요건 충족](https://i.imgur.com/d6Yd1dx.gif)|

## 🗂 폴더 구조

```
└── OpenMaket
    ├── Application
    │   ├── AppDelegate
    │   ├── SceneDelegate
    │   ├── Presentation
    │   │   ├── ViewModel
    │   │   │   └── MarketProductsViewModel
    │   │   │       ├── MarketProductsViewDelegate
    │   │   │       └── MarketProductsViewModel
    │   │   ├── View/
    │   │   │   └── MarketProducts
    │   │   │       ├── MarketProductsView
    │   │   │       ├── ListCollectionCell
    │   │   │       └── GridCollectionCell
    │   │   └── ViewController
    │   │       ├── ProductDetail
    │   │       │   └── ProductDetailViewController
    │   │       ├── ProductEnrollment
    │   │       │   └── ProductEnrollmentViewController
    │   │       └── MarketProducts
    │   │           └── MarketProductsViewController
    │   └── Domain
    │       └── Model
    │           ├── AlertSetting
    │           ├── AlertMessage
    │           ├── SegmentedControlItem
    │           ├── Manager
    │           │   ├── ProductListAPIManager
    │           │   ├── ProductDetailsAPIManager
    │           │   ├── ProductEnrollmentAPIManager
    │           │   ├── ProductModificationAPIManager
    │           │   ├── ProductDeleteAPIManager
    │           │   └── ProductSecretRetrievalAPIManager
    │           └── Entities
    │               ├── ProductList
    │               │   ├── ProductList
    │               │   └── ProductListEntity
    │               ├── ProductDetails
    │               │   ├── ProductDetails
    │               │   └── ProductDetailsEntity
    │               ├── EnrollProductEntity
    │               └── ModifiedProductEntity
    ├── Networking
    │   ├── API
    │   │   ├── APIConfiguration
    │   │   ├── APIProtocol
    │   │   ├── APIClient
    │   │   └── APIError
    │   └── ProductURLUtilities
    │       ├── HTTP
    │       │   ├── HTTPMethod
    │       │   ├── RequestName
    │       │   └── MIMEType
    │       ├── User
    │       ├── URLComponentsBuilder
    │       └── ProductURLQueryItem
    ├── Extensions
    │   ├── String+Extensions
    │   ├── Double+Extensions
    │   └── UIViewController+Extensions
    └── Resource
        ├── Info
        ├── Assets
        └── LaunchScreen
```

    
## 📝 기능설명
    
- 서버 통신 기능 구현
    ```
    - APIProtocol
        - 각각의 HTTPMethod에 따른 서버와 통신하는 메서드 구현
    - APIConfiguration
        - HTTPMethod에 따른 URL을 생성하는 Configuration 타입 구현
    - URLComponetsBuilder
        - Builder Pattern을 활용하여 dynamic하게 URL 생성
    ```

- 상품등록 UI 구현
    ```
    - UIImagePickerController
    - ScrollView
    - StackView
    - TextField
    - TextView
    ```
    
네트워크 통신을 담당할 타입을 설계하고 구현
- ProductList, Product
    - 서버 API 데이터 형식을 고려하여 모델 타입 구현
- NetworkProvider
    - 서버로부터 데이터를 받아오는 기능을 수행
    - 기능을 수행한 위한 protocol, extension 별도 생성
- NetworkError
    - 서버로부터 데이터를 받아오는 도중 발생하는 에러 표현
CollectionView Cell을 각 Layout 별로 분리하여 구현
- GridCollectionCell, ListCollectionCell
    - CollectionView의 Cell 타입 구현 
- ProductEntity
    - 서버 매핑 타입 중 Cell에 필요한 타입들 별도 구현
Utilities
- String+Extensions
    - String 자료형을 확장시켜 필요 메서드 관리
        * strikeThrough - 해당 문자열의 처음부터 입력 받은 수의 인덱스까지 strikethroughStyle 적용.
- Int+Extensions
    - Int 자료형을 확장시켜 필요 메서드 관리
        * numberFormatter - 10진수로 변환하고 String 타입으로 변환 후 반환
    
## 🚀 TroubleShooting
    
### STEP 1

#### T1. URLRequest 통합 관리 방법
    
- URLRequest 방법에는 HTTPMethod부터 GET, POST, PATCH, PUT, DELETE 등 다양하게 존재합니다. 또한, 이에 따라 URL 구성에도 차이를 보인고, 심지어는 POST 경우에는 body를 통하여 서버에 전달하고자 하는 데이터를 입력하여야 합니다. 이를 각각 하나하나 설정하기 보다는, 전체적으로 이를 관리할 수 있는 객체를 만들 필요성을 느꼈습니다. 
    
- 아래의 APIConfiguration 하나의 객체를 통하여, 사용자는 각각의 HTTPMethod에 따라 원하는 방법을 선택하면, 그에 맞는 url과 parameters를 넣을 수 있게 만들었습니다.


- 코드
    
    ```swift
    typealias Parameters = [String: String]
    
    struct APIConfiguration {
        let method: HTTPMethod
        let url: URL
        let parameters: Parameters?
        
        init(method: HTTPMethod,
             url: URL,
             parameters: Parameters? = nil) {
            
            self.method = method
            self.url = url
            self.parameters = parameters
        }
    }
    ```

- 물론, APIConfiguration 만으로 url과 parameters가 자동으로 들어갈 수는 없습니다. 추가적인 작업이 필요합니다. 먼저, URL을 동적으로 생성할 수 있도록 빌더 패턴을 활용하여 URLComponetBuilder를 생성하였습니다. 각각의 HTTPMethod에 따라 필요로하는 URLComponent가 상이하므로, scheme, host(domain), path, queryItem으로 각각 분리하여 필요로하는 부분만을 추출하여 URLComponets를 구성하고, 마지막에 build를 URLComponents 타입을 반환한 이후, 해당 타입의 프로퍼티인 url을 사용하면 동적인 url을 생성할 수 있습니다.


- 코드
    
    ```swift
    import Foundation
    
    final class URLComponentsBuilder {
        private var urlComponents = URLComponents()
        
        init() { }
        
        func build() -> URLComponents {
            return urlComponents
        }
        
        func setScheme(_ scheme: String) -> URLComponentsBuilder {
            urlComponents.scheme = scheme
            
            return self
        }
        
        func setHost(_ host: String) -> URLComponentsBuilder {
            urlComponents.host = host
            
            return self
        }
        
        func setPath(_ path: String) -> URLComponentsBuilder {
            urlComponents.path = path
            
            return self
        }
        
        func addQuery(items: [String: String]) -> URLComponentsBuilder {
            urlComponents.addQuery(items)
            
            return self
        }
    }
    
    extension URLComponents {
        fileprivate mutating func addQuery(_ items: [String: String]) {
            var newQueryItems = [URLQueryItem]()
            
            for (key, value) in items.sorted(by: { $0.key < $1.key }) {
                newQueryItems.append(URLQueryItem(name: key,
                                                  value: value))
            }
            
            if self.queryItems == nil {
                self.queryItems = newQueryItems
            } else {
                self.queryItems?.append(contentsOf: newQueryItems)
            }
        }
    }
    ```

- 다음으로, HTTPMethod에 따라 생성된 URL을 바탕으로 원하는 파라미터를 활용한 메서드를 구현하였습니다. 이를 위하여 APIProtocol을 생성하여 APIConfiguration 인스턴스를 프로퍼티로 받게 하였고, 서버로부터 데이터를 post하는 enrollData란 메서드를 구현하였습니다.

- 코드
    
    ```swift
    protocol APIProtocol {
        var configuration: APIConfiguration { get }
    }
    
    extension APIProtocol {
        func enrollData(using client: APIClient = APIClient.shared,
                    postEntity: EnrollProductEntity,
                    completion: @escaping (Result<Data,APIError>) -> Void) {
    
        var request = URLRequest(url: configuration.url)
    
        let dataBody = createDataBody(withParameters: postEntity.parameter,
                                      media: postEntity.images,
                                      boundary: MIMEType.generateBoundary())
    
        request.httpMethod = configuration.method.rawValue
        request.httpBody = dataBody
        request.setValue(MIMEType.multipartFormData.value,
                         forHTTPHeaderField: MIMEType.contentType.value)
        request.addValue(User.identifier.rawValue,
                         forHTTPHeaderField: RequestName.identifier.key)
            ...
    }
    ```

- 마지막으로 위 메서드를 호출할 수 있도록 APIProtocol을 채택한 ProductEnrollmentAPIManager란 구조체를 생성하여 데이터를 보내고자 하는 서버의 URL 주소와 HTTPMethod를 선택할 수 있었습니다. 이를 응용하여 각각의 Request 방법에 따른 APIManager를 만들어보았습니다. 위의 방법을 이용한다면, 사용자의 의도에 맞는 Request 방법을 사용할 수 있습니다.

- 코드
    
    ```swift
    struct ProductEnrollmentAPIManager: APIProtocol {
        var configuration: APIConfiguration
        var urlComponent: URLComponents
        
        init?() {
            urlComponent = URLComponentsBuilder()
                .setScheme("https")
                .setHost("market-training.yagom-academy.kr")
                .setPath("/api/products")
                .build()
            
            guard let url = urlComponent.url else {
                return nil
            }
            
            configuration = APIConfiguration(method: .post, url: url)
        }
    }
    ```
    
#### T2-1. ScrollView 안의 TextView 설정

- 최상위에 존재하는 ScrollView의 스크롤 기능만 on하기 위해 ScrollView 내에 TextView를 넣으면 TextView의 스크롤 기능을 false로 처리합니다. 
    
```swift 
    textView.isScrollEnabled = false
```

- TextView의 길이 자동설정
```swift 
   
extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}
 
```
- ScrollView와 별개로 TextView의 동적 사이즈 설정이 필요할 것으로 예상하여 위의 코드를 작성하였으나 따로 설정할 필요가 없었습니다.

    
#### T2-2. 텍스트 입력 시 Keyboard 위로 View 올림 설정
-  NotificationCenter를 통해서 Keyboard가 나타나고 사라짐을 알리기 위해 사용하였습니다.

- NotificationCenter 선언
```swift 
func registerNotificationForKeyboard() {
    NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillShow),
        name: UIResponder.keyboardWillShowNotification,
        object: nil)
    NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillHide),
        name: UIResponder.keyboardWillHideNotification,
        object: nil)
}
```

- Keyboard Show/Hide에 맞춰 RootView인 ScollView의 content와 scrollIndicator의 길이를 맞춥니다. 
```swift 
@objc private func keyboardWillShow(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
        return
    }

    let contentInset = UIEdgeInsets(
        top: 0.0,
        left: 0.0,
        bottom: keyboardFrame.size.height,
        right: 0.0)

    rootScrollView.contentInset = contentInset
    rootScrollView.scrollIndicatorInsets = contentInset
}

@objc private func keyboardWillHide() {
    let contentInset = UIEdgeInsets.zero
    rootScrollView.contentInset = contentInset
    rootScrollView.scrollIndicatorInsets = contentInset
}
```
- 이렇게 설정하고 나온 문제는 텍스트뷰 내 텍스트의 행의 수가 많지 않다면, 키보드가 화면에 등장함에 있어서 서로의 영역을 침범하지는 않지만, 만약 텍스트의 줄바꿈 횟수가 일정범위를 넘어간다면, 화면의 밖으로 텍스트 뷰의 길이가 길어져 텍스트를 확인할 수 없게 됩니다. 이러한 문제는 텍스트 뷰의 bottom anchor가 최상위 뷰의 bottom anchor가 constraint 관계를 설정해주지 않아 발생한 문제였습니다. 이를 해결하기 위하여, 아래의 코드와 같이 제약을 설정해줌으로써 텍스트 뷰의 길이가 길어져도 화면 내에 표시할 수 있게 되었습니다.

```swift 
productDescriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
```

## 📚 참고문서

- [Data Entry - iOS - Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/patterns/entering-data/)
- [UIAlertController](https://developer.apple.com/documentation/uikit/uialertcontroller)
--- 
    
## 1️⃣ STEP 1

### STEP 1 Questions & Answers

#### Q1. ScrollView AutoLayout 관련 질문
    
- rootScrollView 내에 rootStackView를 삽입하는 코드를 아래와 같이 추가해보았습니다.

- 코드

    ```swift
    NSLayoutConstraint.activate([
        rootStackView.topAnchor.constraint(equalTo: rootScrollView.topAnchor),
        rootStackView.leadingAnchor.constraint(equalTo: rootScrollView.leadingAnchor),
        rootStackView.trailingAnchor.constraint(equalTo: rootScrollView.trailingAnchor),
        rootStackView.bottomAnchor.constraint(equalTo: rootScrollView.bottomAnchor)
    ])
    ```


- rootStackView의 top, bottom, trailng, leading constraint을 설정함에 있어서 rootScrollView를 기준으로 설정해보았습니다. 시뮬레이터와 view hierachy를 통해 UI 구현 결과를 확인해보니, rootScrollView.contentLayoutGuide를 바탕으로 제약을 설정했을 때와 동일하게 constraint가 잡힌 것이란 생각이 들었습니다.

- 코드

    ```swift
    rootStackView.widthAnchor.constraint(equalTo: rootScrollView.widthAnchor).isActive = true
    ```

- 반면, rootStackView의 width constraint를 설정할 때는 rootScrollView 기준을 설정할 때의 UI 구현 결과를 확인해보니, rootScrollView.contentLayoutGuide이 아닌 rootScrollView.frameLayoutGuide를 바탕으로 제약을 설정했을 때와 동일한 결과를 보여주었습니다.

- 정리해보자면, top, bottom, leading, trailing의 경우 rootScrollView에 제약을 설정할 때는, rootScrollView.contentLayoutGuide를 사용하여 제약을 설정하고, width의 경우 rootScrollView에 제약을 설정할 때는, rootScrollView.frameLayoutGuide를 사용하여 제약을 설정한다고 판단하였습니다.

- 이에, 저희의 판단이 맞는 것인지 궁금하고, 만일 그러하다면, 왜 default 값이 frameLayoutGuide, contentLayoutGuide로 서로 다르게 설정되어 있는지 여쭈어보고 싶습니다.
