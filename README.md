# Open Market ReadME
 
- Kyo와 LJ가 만든 Open Market App입니다.

## 목차
1. [팀 소개](#팀-소개)
2. [GroundRule](#ground-rule)
3. [Code Convention](#code-convention)
4. [실행 화면](#실행-화면)
5. [Diagram](#diagram)
6. [폴더 구조](#폴더-구조)
7. [타임라인](#타임라인)
8. [기술적 도전](#기술적-도전)
9. [트러블 슈팅 및 고민](#트러블-슈팅-및-고민)
10. [일일 스크럼](#일일-스크럼)
11. [참고 링크](#참고-링크)


## 팀 소개
 |[Kyo](https://github.com/KyoPak)|[LJ](https://github.com/lj-7-77)|
 |:---:|:---:|
| <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src= "https://user-images.githubusercontent.com/59204352/193524215-4f9636e8-1cdb-49f1-9a17-1e4fe8d76655.PNG" >|<img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src= "https://i.imgur.com/BHXYIyl.jpg">|

## Ground Rule

[Ground Rule 바로가기](https://github.com/KyoPak/ios-open-market/wiki/GroundRule)

## Code Convention

[Code Convention 바로가기](https://github.com/KyoPak/ios-open-market/wiki/Code-Convention)

## 실행 화면

### ▶️ Step-1 실행화면 - 네트워크 구현
<details>
<summary> 
펼쳐보기
</summary>

|**기본실행**|**Indicator적용**|**Cache적용**|
|:--:|:--:|:--:|
|<img src="https://i.imgur.com/lv84Bvd.gif" width=220> | <img src="https://i.imgur.com/h3xn3i7.gif" >|<img src="https://i.imgur.com/sOTkGBo.gif" >|

</details>


### ▶️ Step-2 실행화면 - CollectionView

|**기본실행**|**Indicator적용**|**Cache적용**|
|:--:|:--:|:--:|
|<img src="https://i.imgur.com/lv84Bvd.gif" width=220>|<img src="https://i.imgur.com/h3xn3i7.gif" width=220>|<img src="https://i.imgur.com/sOTkGBo.gif" width=220>|


## Diagram

### Class Diagram
![](https://i.imgur.com/kN8kjZe.jpg)

 
## 폴더 구조

```
OpenMarket
├── DecodeManagerTests
│   └── DecodeManagerTests.swift
├── NetworkManagerTest
│   ├── NetworkManagerTest.swift
│   └── TestData.swift
└── OpenMarket
    ├── AppDelegate.swift
    ├── SceneDelegate.swift
    ├── Common
    │   ├── NetworkError.swift
    │   └── Protocol
    │       └── ReuseIdentifierProtocol+Extension.swift
    ├── Controllers
    │   ├── AddViewController.swift
    │   ├── ImageCacheManager.swift
    │   └── MainViewController.swift
    ├── Extensions
    │   ├── Formatter+Extension.swift
    │   ├── String+Extension.swift
    │   ├── UILabel+Extension.swift
    │   └── URLComponents+Extension.swift
    ├── Models
    │   ├── DecodeManager.swift
    │   ├── Product.swift
    │   └── ProductPage.swift
    ├── Network
    │   ├── MockURLSession
    │   │   └── MockURLSession.swift
    │   ├── NetworkManager.swift
    │   ├── NetworkRequest.swift
    │   └── Protocols
    │       ├── URLSessionDataTaskProtocol.swift
    │       └── URLSessionProtocol.swift
    └── Views
        ├── AddProductView.swift
        ├── GridCollectionViewCell.swift
        ├── ListCollectionViewCell.swift
        └── MainView.swift
                
```

##  타임라인
### 👟 Step 1

- Model 구현
    - ✅ 파싱한 JSON 데이터와 매핑할 모델 설계
    - ✅ CodingKeys 프로토콜의 활용 
    - ✅ Json파일과 서버 데이터 모두 적용하기 위한 keyDecodingStrategy 사용
- UnitTest 
    - ✅ 단위 테스트(Unit Test)를 통한 설계의 검증
    - ✅ Test Double(Mock)을 이용한 네트워크 테스트 
- Network
    - ✅ URL Session을 활용한 서버와의 통신
    - ✅ Mock Test를 위한 Network 추상화
- Error Handling
    - ✅ ResultType을 적용한 에러처리

<details>
<summary> 
펼쳐보기
</summary>
    
1️⃣ NetworkRequest
    - 필요한 작업case별로 `requestURL`이라는 URL타입으로 바꿔주는 연산프로퍼티가 존재하는 타입입니다.
    
2️⃣ NetworkManager
    - 네트워크에 관련된 작업을 담당하는 클래스입니다.
    - 가장 처음에는 Singleton 패턴을 구현하였었습니다. 하지만 step1-3에서 Moct Test 구현을 위해 초기화하는 방식을 바꿨습니다.
    - `checkHealth()`는 서버에 요청이 잘 되었다는 응답값을 받기 위한 Request메서드입니다.
        - 초기에는 escaping 클로저를 사용하지 않았지만, Test 진행하며 `responseStatusCode` 값을 가져오기 위해 escaping 클로저를 사용하였습니다.
    - `fetchData()`는 서버에 데이터를 요청하는 메서드입니다.
        - productList와 productDetail 데이터를 가져오는 메서드이며 이 두가지의 요청은 각각 Decode하는 방식이 다르기 때문에 제네릭을 사용하였습니다.
        - 그리고 추후에 받아온 데이터를 사용하기 위해 escaping 클로저를 사용하였습니다.
    
3️⃣ URLSessionProtocol
    - NetworkManager에서 `MockURLSession`과 `URLSession`을 상황에 맞게 사용하게끔 추상화를 한 프로토콜입니다.
    - 내부에서 필수적으로 구현해야할 `dataTask()`메서드를 새롭게 정의하였습니다.
    
4️⃣ URLSession Extension
    - `URLSessionProtocol`을 채택한 후, 내부에서 프로토콜에서 정의한 메서드를 구현해주었습니다. Mock이 아닌 실제 사용될 `URLSession`이기 때문에 프로토콜에서 정의한 메서드의 반환값을 실제 `dataTask()`메서드를 호출하는 방식으로 구현하였습니다.
    
5️⃣ MockURLSession
    - dataTask
        - `MockURLSession`이 실행할 `dataTask()`메서드입니다.
        - 실제 네트워크에 요청을 하는 것이 아니기 때문에 곧바로 `return`이 되게끔 하였습니다.
    - makeMockSenderSession
        - 이 타입 메서드는 `MockURLSession`의 Mock응답을 만드는 메서드입니다. 실제 네트워크에 요청을 해서 응답값을 받아오는 목적이 아니기 때문에 이 메서드를 통해 Mock응답을 만들었습니다.

 
</details>


### 👟 Step 2
- CollectionView
    - ✅ Collection View의 활용
    - ✅ Custom Cell 구현 (List, Grid)
- Image Asynchronous 처리
    - ✅ Image 비동기로 처리
    - ✅ Image 표기 시 Image가 변경되는 이슈 해결
- Cache
    - ✅ NSCache 사용
- UI
    - ✅ Segmented Control 사용
    - ✅ Indicator View 사용

<details>
<summary> 
펼쳐보기
</summary>

1️⃣ MainView
    - `segmentedControl`과 `listLayout`, `gridLayout`, `collectionLayout`이 있는 view입니다.
    - segmentedControl에서 `List`와 `Grid`를 누를 때 마다, `layoutStatus`라는 Property Observer을 사용하여 필요한 메서드가 호출될수 있도록 구현하였습니다.
    - `collectionViewLayout`이 변경되는 `changeLayout()` 메서드가 호출되게 끔 구현하였습니다. 그리고 `collectionView`가 `reload`되게끔 하였습니다.
    
    
2️⃣ ListCollectionViewCell
    - List Layout을 구성할 CollectionViewCell 내부 요소와 오토레이아웃을 구현하였습니다.
    
3️⃣ GridCollectionViewCell
    - Grid Layout을 구성할 CollectionViewCell 내부 요소와 오토레이아웃을 구현하였습니다. 
    
4️⃣ AddViewController, AddProductView
    - `UIBarButtonItem`인 `+`버튼을 눌렀을 때 전환될 다음 뷰(`AddProductView`)를 담당하는 뷰컨트롤러입니다.
    
5️⃣ ImageCacheManager
    - 이미지캐싱을 위한 클래스 타입입니다.
    
6️⃣ UILabel+Extension
    - 할인 전 가격Label에 취소선을 표시해주는 메서드 `applyStrikeThroughStyle`를 구현해주었습니다.

    
</details>



## 기술적 도전
### ⚙️ Network
<details>
<summary> 
펼쳐보기
</summary>
    
- `URLSession`과 `URLSession`의 `shared` 인스턴스를 사용하여 Network 통신을 진행하였습니다.
- `URLSession`의 Task타입에는 DataTask, UploadTask, DownloadTask, StreamTask 등이 있고, STEP 1에서는 `Request`했을 때, DataTask 객체를 사용하여 데이터를 받아오는 것을 확인할 수 있었습니다.
- 💡 데이터를 앱으로 반환하는 방법에는 세가지(async, delegate, completion handler)가 있습니다. 그 중 `completion handler`를 이용하는 방법을 사용하였고, 대부분의 네트워킹API와 마찬가지로 URLSession도 비동기이기 때문에 escaping 클로저를 사용하였습니다. 
    
</details> 

### ⚙️ Test Double
    
<details>
<summary> 
펼쳐보기
</summary>
       
테스트 더블에는 Dummy, Stub, Fake, Spy, Mock 등이 있습니다. 명확히 구분해서 사용하지는 않지만, 실제와 가장 유사하게 구현된 `Mock`객체를 선택하여 구현하였습니다. `Mock`은 행위기반테스트로 예상되는 행위들에 대한 시나리오를 만들어 놓고 시나리오대로 동작했는지에 대한 여부를 확인합니다.
- 💡 `MockURLSession`과 `MockURLSessionDataTask`를 만들고, 그에 따른 요청 시 우리의 예상대로 정해놓은 Mock응답이 잘 받아지는지 확인하였습니다.
- 💡 추가적으로 `URLSessionProtocol`을 채택한 URLSession을 사용하다보니 의존성도 분리가 되지않았을까라는 생각이 들었습니다.
</details>
        
### ⚙️ Indicator View
    
<details>
<summary> 
펼쳐보기
</summary>
      
사용자에게 이미지가 로드되는 시간동안 비어있는 이미지를 보여주지 않기 위해서 사용하였습니다.
UIActivityIndicaotrView는 기본적으로 UIView를 상속하는 클래스입니다.
indicator 애니메이션을 `startAnimating()` 메서드와 `stopAnimating()` 메서드로 control할 수 있습니다.
hideWhenStopped 프로퍼티를 true로 하면 Indicator 애니메이션이 멈추면 뷰는 자동으로 hide됩니다.

    
- 💡 가장 먼저 `Indicator View`를 `productImageView`와 동일한 위치에 위치시켰습니다
- `collectionView(collectionView:, cellForItemAt indexPath:)` 메서드에서 데이터를 받아오는 `setupData()`메서드 실행 전에 `startAnimating()`을 호출하였습니다.
- 이미지 업로드하는 `uploadImage()`메서드에서 `productImageView`에 `image`를 담은 후 `stopAnimating()`으로 멈추도록 구현하였습니다.    
</details>

### ⚙️ Cache
    
<details>
<summary> 
펼쳐보기
</summary>
       
일단 Cache는 자주 접근하는 리소스에 접근하는 시간을 단축하기 위해 사용됩니다.
즉, Cache에 데이터를 미리 복사해 놓으면 계산이나 접근 시간 없이 더 빠른속도로 데이터에 접근할 수 있게 됩니다.
프로젝트에서 사용한 `NSCache`는 `Key-Value`쌍을 임시로 저장하는데 사용되는 변경가능한 Collection입니다.
NSCache는 자체적으로 메모리가 너무 많이 사용되지 않도록 제거되는 정책을 소유하고 있으며 iOS에서는 메모리 캐싱으로 사용됩니다. 때문에 앱이 종료될 경우 리소스들은 자동으로 OS에 반환됩니다.
    
- 💡 Cache를 생성하는 ImageCacheManager를 싱글톤 패턴으로 생성하였습니다. 
- 💡 이미지를 가져오기 전, 캐싱된 내용에 해당 이미지가 존재하는지 `MainViewController`에서 먼저 검사합니다.
    갖고있다면 그 이미지를 사용하고 cell을 반환하고, 갖고있지 않다면 NetworkManager 객체의 `fetchImage()`를 통해 비동기처리로 이미지를 load 합니다. 
    가져온 이미지를 `setObject(image, forKey:)` 메서드로 캐시에 저장 후 이미지를 바꿔주었습니다. 

```swift
if indexPath == collectionView.indexPath(for: cell) {
    ImageCacheManager.shared.setObject(image, forKey: cacheKey)
    // cell update
    ...
}
```
    
</details>


## 트러블 슈팅 및 고민
### 🔥 멀티 CodingKey ➡️ `keyDecodingStrategy`
    
<details>
<summary> 
펼쳐보기
</summary>

**문제 👀**

|Json|Server|
|------|------|
|![](https://i.imgur.com/3knTgMq.png)|![](https://i.imgur.com/H6GKQJy.png)|
    
- 처음에 JSON파일을 받고 해당 데이터에 대해서 `CodingKey` 프로토콜을 채택하여 구현하였습니다. 
- 하지만 JSON파일과 서버에서의 파일의 일부분의 키값이 달랐고, 모두 받아들일 수 있도록 멀티 코딩키를 사용하려했습니다. 하지만 선택적으로 초기화에서 코딩키를 선택하게 하는 것도 좋지만 다른 간단한 방법을 고민하였습니다.

**해결 🔥**
 
- 결과적으로는 `keyDecodingStrategy` 프로퍼티를 `convertFromSnakeCase`로 설정하여 사용하였습니다. 
- `json`파일의 항목명을 변환하여 모델타입의 변수와 매칭하는 방법이 더 간단하다 판단했습니다. 
- 현재 프로젝트에서는 키의 갯수가 많이 없었고, 파일이 snakeCase로 되어있었지만, 만약 `Parsing` 할 데이터의 키값이 조금 더 다양했다면 멀티 CodingKey 방법이 적합할 것이라고 생각됩니다.
- 멀티 CodingKey를 사용하여 Decode 부분에서 메서드 호출에 따라서 어떤 CodingKey를 사용할지 파라메터값으로 전달해주면 더욱 다양한 Case에서 대응이 가능할것이라고 생각합니다.
</details>

### 🔥 URLComponent 확장과 NetworkRequest enum으로 URL값 구성 
    
<details>
<summary> 
펼쳐보기
</summary>

**문제 👀**
- 초기에 사용해야할 `URL`을 String값으로 직접 할당을 하였었습니다.
- 추후에 페이지가 넘어가거나, 혹은 다른 정보를 불러오고 싶을 때는 기존의 문자열에서 다른 `QueryItem`과 `Path`가 필요하였습니다.
- 때문에 직접 하드코딩방식으로 URL을 불러오는 방식이 아닌 유동적으로 URL을 불러오는 방법이 필요하였습니다.

**해결 🔥**
- URL의 구성요소인 URLComponent 구조체를 확장하여 `createURL(path:,queryItem:)` 이라는 파라메터로 주어진 path와 QueryItem으로 URL을 Return하는 타입메서드를 구현하였습니다.
```swift 
static func createURL(path: String?, queryItem: [URLQueryItem]?) -> URL? {
    ...
}
```
- 그리고 NetworkRequest라는 enum 타입을 생성하여 작업 case에 맞는 URL들을 반환하도록 구현하였습니다.
- 내부적으로 어떻게 유동적으로 path와 queryItem에 대한 값을 전달할 것인지는 조금더 고민이 필요할 것 같습니다.


</details>


### 🔥 프로토콜에 정의한 dataTask()를 실제로 동작하게 만드는 방법
    
<details>
<summary> 
펼쳐보기
</summary>
    
```swift
protocol URLSessionProtocol {
    func dataTask(with request: ...,
                  completionHandler:
                  @escaping (...) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: ...,
                  completionHandler:
                  @escaping (...) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}
```
**문제 👀**
- Mock Test를 하기 위해 실제 사용되는 URLSession과 Test시 사용될 `MockURLSession`을 `URLSessionProtocol`이라는 프로토콜을 채택하여 사용하였습니다.
- 그리고 해당 Protocol에서 공통적으로 사용되는 메서드인 dataTask()메서드를 정의하고 반환값으로 기존의 `URLSessionDataTask`가 아닌 `URLSessionDataTaskProtocol`을 반환하게 하였습니다.
- 그리고 실제로 이 메서드를 구현해야할 때, 진짜 `URLSession`이 이 메서드를 사용할 때 어떻게 `dataTask()`기능을 동작하게할까? 라는 고민이 있었습니다. 

**해결 🔥**
- `URLSessionDataTaskProtocol`을 반환하는 프로토콜에 정의한 `dataTask()`의 return 값으로 실제 존재하는 dataTask()메서드를 호출하였습니다. 
- 그리고 `URLSessionDataTask`타입이라는 것을 업캐스팅을 통해 명시하여 해결하였습니다.
    
</details>
    
### 🔥 Image 비동기 처리 
    
<details>
<summary> 
펼쳐보기
</summary>
    
**문제 및 해결 🔥**
- Image를 로드해올때 버벅이는 현상이 있었습니다. 
- 원인은 이미지를 서버로부터 load해오는 작업과 image를 그려주는 작업이 동일한 `Main Thread`에서 동작하기 때문이었습니다.
- 때문에 이미지를 서버로부터 가져오는 작업은 `global().asnyc`로 실행을 하였고, 비동기 내부에서 image를 대입하는 작업(UI를 그리는 작업)은 다시 `Main Thread`로 보내주어서 해결할 수 있었습니다.
    
```swift

// NetworkManager.swift
DispatchQueue.global().async {
    guard let data = try? Data(contentsOf: imageURL),
        let image = UIImage(data: data) else { return }   
    completionHandler(image)
}

// MainViewController.swift
NetworkManager.fetchImage(with: data.thumbnail) { image in
    DispatchQueue.main.async {                
    if indexPath == collectionView.indexPath(for: cell) {
        ImageCacheManager.shared.setObject(image, forKey: cacheKey)    
        // ex) cell.image = image
        }
    }
}
```
    
</details>

### 🔥 Image 표기 시 Image가 변경되는 이슈
    
<details>
<summary> 
펼쳐보기
</summary>
    
**문제 👀**

- 가장 처음에 구현을 하였을때 아래와 같이 구현을 하였고, 이미지 스크롤을 빠르게 내리고 멈추었을 경우 이미지가 바뀌는 오류가 있었습니다.
```swift
// MainViewController.swift
DispatchQueue.main.async { [weak self] in
    if indexPath == collectionView.indexPath(for: cell) {
        guard let data = self?.productData[indexPath.item] else { return }
            cell.setupData(with: data)
    }
}    

// List, GridCollectionViewCell.swift
func setupData(with productData: Product) {
    if let imageURL = URL(string: productData.thumbnail) {
        productImageView.loadImage(url: imageURL)
    }
    ...
}
    
// UIImageView+Extension.swift
func loadImage(url: URL) {
    DispatchQueue.global().async { [weak self] in
        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self?.image = image                
            }
        }
    }
}
```
- 이 코드의 문제점은 `MainViewController`의 `indexPath`와 `collectionView.indexPath(for: cell)`를 비교하는 문장의 위치였습니다.

- 위와 같은 코드는 비동기이기 때문에 어떤 경우던지 저 조건문을 통과하게 됩니다. 
- 그렇기 때문에 빠르게 스크롤할 경우 재사용되는 하나의 셀에 이미지를 올리는 작업들이 쌓이게 되고 스크롤을 멈추면 셀에 그동안 쌓였던 작업들이 실행되면서 이미지들이 계속 바뀌게 됩니다. 또한 비동기이기 때문에 최종적으로 올라가야하는 이미지 또한 바뀌게 될수 있는 문제가 있었습니다.
    
**해결 🔥**
    
- 이미지을 받아오는 fetchImage()라는 메서드를 NetworkManager에 새롭게 구현하였습니다.
그리고 이미지가 모두 받아져오면 completionHandler로 image를 전달해주었습니다.
    
```swift
// NetworkManager.swift
func fetchImage(with stringURL: String, completionHandler: @escaping (UIImage) -> Void) {
    guard let imageURL = URL(string: stringURL) else { return }
        
    DispatchQueue.global().async {
        guard let data = try? Data(contentsOf: imageURL),
            let image = UIImage(data: data) else { return }
            
        completionHandler(image)
    }
}
    
// MainViewController.swift
networkManager.fetchImage(with: data.thumbnail) { image in
    DispatchQueue.main.async {
        if indexPath == collectionView.indexPath(for: cell) {
            productImageView.image = image
        }
    }
}
```    
- 이미지를 바꾸기 직전에 indexPath와 현재 collectionView의 indexPath와 비교하여 이미지를 넣어주었습니다.
- 여러 이미지들이 로드되는 동작 자체를 없앨 수는 없지만 이렇게 한다면 스크롤을 빠르게 내렸을때 이미지가 올라온 후에 이미지가 다시 바뀌는 이슈를 해결할 수 있었습니다.
    
    
</details>



### 🔥 레이블 변경 로직 
    
<details>
<summary> 
펼쳐보기
</summary>
    
**문제 👀**
    
| 할인가격Label 추가 | 정가 판매 |
|:--:|:--:| 
|![](https://i.imgur.com/y71yJPq.png)|![](https://i.imgur.com/VTfQGL3.png)|

- 위의 그림과 같이 할인하는 경우 할인된 가격`Label`을 추가해야했습니다.
- 처음의 방법은 할인률이 존재한다면 할인된 가격`Label`을 `addSubView` 하고, `prepareForReuse()`에서 해당 할인 가격 Label을 remove해주는 방식으로 구현을 했습니다. 
- 하지만 이렇게 `Cell` 마다 `View`를 그려주고 `remove` 해준다면 상당한 리소스가 요구될 것이고 앱의 동작에 부담이 갈것이라고 생각하고 다른 방안을 생각했습니다.
    
**해결 🔥** 
- 해당 뷰를 `Hidden`처리하는 방식을 선택했습니다.
- 아래 처럼 할인률이 없는 경우는 할인가격을 `Hidden`처리하고 그렇지 않은 경우은 그대로 할인 `Label`을 보여주도록 하였습니다.
```swift
private func setupPriceLabel() {
    if discountPrice == Double.zero {
        productSalePriceLabel.isHidden = true
    } else {
    ...    
}
    
private func clearPriceLabel() {
    productPriceLabel.isHidden = false
    productPriceLabel.textColor = .gray
    productPriceLabel.attributedText = .none
}
```   
</details>



    
## 일일 스크럼

[일일 스크럼 바로가기](https://github.com/KyoPak/ios-open-market/wiki/Scrum)

## 참고 링크

[공식문서]
- [Swift Language Guide - URLSession](https://developer.apple.com/documentation/foundation/urlsession)
    
- [Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
    
- [URL Loading System](https://developer.apple.com/documentation/foundation/url_loading_system)
    
- [URLSessionDataTask](https://developer.apple.com/documentation/foundation/urlsessiondatatask)
    
- [Swift Language Guide - Closure - Escaping Closures](https://docs.swift.org/swift-book/LanguageGuide/Closures.html)

- [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview/)

- [NSURLCache](https://developer.apple.com/documentation/foundation/nsurlcache/)

- [UIActivityIndicatorView](https://developer.apple.com/documentation/uikit/uiactivityindicatorview/)
