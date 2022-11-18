# 오픈마켓 🏬

## 📖 목차

1. [소개](#-소개)
2. [구현 내용](#-구현-내용)
3. [타임라인](#-타임라인)
4. [트러블 슈팅 & 어려웠던 점](#-트러블-슈팅-및-어려웠던-점)
5. [프로젝트 wiki](#-프로젝트에서-배운-점-wiki)
6. [참고 링크](#-참고-링크)

## 🌱 소개


|<img src= https://i.imgur.com/ryeIjHH.png width=150>|<img src= https://i.imgur.com/RG4tpLq.jpg width=150>|
|:---:|:---:|
|토털이|애종


 
<!-- ## 🛠 프로젝트 구조 -->
<!-- ### 📊 Class Diagram -->



### 🌲 Tree
```
 OpenMarket
 ├── NetworkTests
 │   └── NetworkTests.swift
 ├── OpenMarket
     ├── MockForTest
     │   ├── MockData.swift
     │   ├── MockURLSession.swift
     │   ├── MockURLSessionDataTask.swift
     │   └── URLSessionProtocol.swift
     ├── Errors
     │   └── DataError.swift
     ├── Extensions
     │   └── URLComponents+Extension.swift
     ├── Model
     │   └── ProductList.swift
     ├── Utilities
     │   ├── DecodeManager.swift
     │   ├── NetworkAPI.swift
     │   └── NetworkAPIProvider.swift
     ├── View
     │   └── Main.storyboard
     │       
     └── ViewController.swift


```
## 📌 구현 내용
### STEP 1
- 디코딩을 위한 Decodable struct `ProductList` 생성
- 네트워크 통신을 담당할 타입인 `NetworkAPIProvider` 클래스를 설계하고 구현, extension에 fetch 함수를 구현함
- `NetworkAPI` enum으로 url components를 분리하여 관리할 수 있도록 설계
- `URLComponents` extension에 `setQueryItems()`를 추가해주어 쿼리를 효율적으로 관리할 수 있도록 설계
- MockURLSession을 구현하여 테스트 할 수 있도록 설계
- Test Double를 적용하여 Mock URLsession을 만들어 네트워크와 무관하게 동작하는 테스트를 수행




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
    
    
    
</div>
</details>

<details>
<summary>Step3 타임라인</summary>
<div markdown="1">       
    
</div>
</details>


<!-- ## 📱 실행 화면 -->


## ❓ 트러블 슈팅 및 어려웠던 점

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

위와 같은 구조로 의존성 주입을 해주어 `NetworkAPIProvider`클래스에 대한 Stubs 테스트를 해줄 수 있었다. 그 과정에서 `@escaping`에 대한 이해가 필요했었다. 


## 📕 프로젝트에서 배운 점 wiki
[바로가기](https://github.com/jonghancha/ios-open-market/wiki/1.-STEP-1-%EC%97%90%EC%84%9C-%EB%B0%B0%EC%9A%B4-%EC%A0%90)

## 📖 참고 링크
- [URLSession.dataTask를 통해 데이터 Fetching하기(공식문서)](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
- [URLComponents로 URL구성하기](https://kirkim.github.io/swift/2022/08/13/urlsession.html)
- [iOS 네트워킹과 테스트](https://techblog.woowahan.com/2704/)
- [stub과 mock의 차이](https://martinfowler.com/articles/mocksArentStubs.html)



[🔝 맨 위로 이동하기](#오픈마켓-)
