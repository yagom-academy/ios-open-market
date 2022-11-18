# 🏪 Open Market 🏪

## 📜 목차
1. [소개](#-소개)
2. [개발환경 및 라이브러리](#-개발환경-및-라이브러리)
3. [팀원](#-팀원)
4. [타임라인](#-타임라인)
5. [UML](#-UML)
6. [실행화면](#-실행-화면)
7. [트러블 슈팅 및 고민](#-트러블-슈팅-및-고민)
8. [참고링크](#-참고-링크)

<br>

## 🗣 소개

추후 작성 예정

<br>

## 💻 개발환경 및 라이브러리
[![iOS](https://img.shields.io/badge/iOS_Deployment_Target-13.2-blue)]()
[![swift](https://img.shields.io/badge/Xcode_Compatible-9.3-orange)]()

<br>

## 🧑 팀원
|Ayaan|준호|
|:---:|:---:|
|<img src= "https://i.imgur.com/Unq1bdd.png" width ="200"/>|<img src = "https://camo.githubusercontent.com/a482a55a5f5456520d73f6c2debdd13375430060d5d1613ca0c733853dedacc0/68747470733a2f2f692e696d6775722e636f6d2f436558554f49642e706e67" width=200 height=200>|

<br>

## 🕖 타임라인

### Step 1

- 2022.11.14
    - Page Type 구현
    - Product Type 구현
    - Currency Type 구현
- 2022.11.15
    - Page Unit Test
    - OpenMarket API와 네트워크 구현
        - OpenMarket API Health 조회
        - OpenMarket API 상품 리스트 조회
        - OpenMarket API 상품 상세 조회
    - ProductImage Type 구현
    - Vendor Type 구현
- 2022.11.16
    - 네트워크 기능 프로토콜화
    - Test Double을 통해 구현된 네트워크 Test
        - RequestedDummyData 구현
        - StubURLSession 구현
        - StubURLSessionDataTask 구현
        - FakeURLSession 구현


## 📊 UML

### Model

<img src="https://i.imgur.com/YSomJuD.jpg" width="500">

### URLSession Protocol

<img src="https://i.imgur.com/oVURD58.jpg">

## 💻 실행 화면

- 추후 작성 예정

## 🎯 트러블 슈팅 및 고민****

### Decodable Model Property Optional
|상품 리스트 조회시 아이템|상품 상세 조회시 아이템|
|:---:|:---:|
|![](https://i.imgur.com/mnpGzkb.png)|![](https://i.imgur.com/GfPoqcb.png)|

- OpenMarket API에서 상품 리스트 조회시 전달되는 아이템과 와 상품 상세 조회시 전달되는 아이템의 프로퍼티가 서로 달라서 하나의 Model로는 데이터를 불러올 수 없는 문제가 있었습니다.
- 구현된 Model에서 서로 상이한 부분을 Optional로 지정해 줌으로써 해당 문제를 해결했습니다.

<details>
<summary>코드 보기</summary>
<div markdown="1">
    
```swift
    struct Product: Decodable {
        let id, vendorID: Int
        let name, thumbnail: String
        let description: String? // 옵셔널 타입
        let currency: Currency
        let price, bargainPrice, discountedPrice: Double
        let stock: Int
        let createdAt, issuedAt: String
        let images: [ProductImage]? // 옵셔널 타입
        let vendor: Vendor? // 옵셔널 타입
```
    
</div>
</details>

### API 통신 기능별 Protocol화
- URLSession에 API 통신과 관련된 기능을 extension을 통해 구현했었습니다. POP의 관점에서 구현해 보고자하여 기능별로 프로토콜을 만들어서 `URLSession` 이 채택하도록 구현했습니다.

<details>
<summary>코드 보기</summary>
<div markdown="1">
    
```swift
    extension URLSession: OpenMarketURLSessionProtocol { }
    extension URLSession: OpenMarketHealthFetchable { }
    extension URLSession: OpenMarketPageFetchable { }
    extension URLSession: OpenMarketProductFetchable { }
```
    
</div>
</details>

### 중복된 Guard문

- URLSessionDataTask의 CompletionHandler에서 data, response, error에 따른 분기처리를 해주지 않고 data를 처리하는 로직에서 guard문을 이용해 분기처리를 해줌으로써 중복된 코드가 발생하는 부분이 있었습니다.
- URLSessionDataTask의 CompletionHandler에서 if let을 이용하여 분기 처리를 해주어 중복된 코드를 줄일 수 있었습니다.

<details>
<summary>코드 보기</summary>
<div markdown="1">
    
```swift=
    // 수정 전
    private func fetchOpenMarketAPIDataTask(query: String,
                                            completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        guard let hostURL = URL(string: "https://openmarket.yagom-academy.kr"),
              let url = URL(string: query, relativeTo: hostURL) else {
            fatalError()
        }
        
        return self.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil, response, error)
                return
            }
            completion(data, response, nil)
        }
    }

    func checkHealthTask(completion: @escaping (Bool) -> Void) {
        let query: String = "healthChecker"
        fetchOpenMarketAPIDataTask(query: query) { (_, response, error) in
            // 중복된 코드 발생 구간
            guard error == nil, let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                completion(false)
                return
            }
            // 모든 로직에서 해당 코드가 존재.
            completion(true)
        }.resume()
    }

    // 수정 후
    func fetchOpenMarketDataTask(query: String,
                                 completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask? {
        guard let hostURL = URL(string: host),
              let url = URL(string: query, relativeTo: hostURL) else {
            return nil
        }
        
        return self.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
            } else if (response as? HTTPURLResponse)?.statusCode != 200 {
                completion(nil, OpenMarketError.badStatus)
            } else if let data = data {
                completion(data, nil)
            } else {
                completion(nil, nil)
            }
        }
    }


    func fetchHealth(completion: @escaping (OpenMarketHealth) -> Void) {
        let query: String = "healthChecker"
        
        fetchOpenMarketDataTask(query: query) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.bad)
            } else if data != nil {
                completion(.ok)
            } else {
                completion(.bad)
            }
        }?.resume()
    }

```
    
</div>
</details>

## 📚 참고 링크
[Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
[URLSession](https://developer.apple.com/documentation/foundation/urlsession)
