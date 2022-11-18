# 오픈마켓 

## 목차
1. [소개](#1-소개)
2. [타임라인](#2-타임라인)
3. [UML](#3-다이어그램)
4. [실행 화면](#4-실행화면)
5. [고민했던 점](#5-고민했던-점)
6. [트러블 슈팅](#6-트러블-슈팅)
7. [참고 링크](#7-참고-링크)

## 1. 소개
### 📱 앱 소개
- URLSession을 활용해 API 서버와 통신해서 JSON 형식의 데이터를 받아와 각 Model 타입으로 변환합니다.
- URLSession, Generics, POP, JSON 개념을 활용해 진행되었습니다.

### 💻 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-13.2.1-blue)]()

### 👩🏻 팀원
| SummerCat | bella |
| --- | --- |
|<img src=https://i.imgur.com/TVKv7PD.png width="155" height="150" > |<img src=https://i.imgur.com/Ux3OvW7.jpg width="155" height="150" > |
| [@SummerCat](https://github.com/dev-summer) |  [@hyhy0429](https://github.com/hyhy0429) |

</br>

---

## 2. 타임라인

### [STEP-1]
**22.11.15**
- Model 구현
- ProductList JSON 데이터 파싱 테스트 구현
- NetworkManager 타입 구현
- 네트워킹 요소 메서드 구현 (checkAPIHealth, fetchProductList, fetchProductDetail)

**22.11.18**
- Endpointable 프로토콜 구현
- OpenMarketAPI 열거형 구현
- NetworkManager 타입 리팩토링

</br>

---

## 3. UML
![UML](https://i.imgur.com/Qv3H1PG.png)

---

## 4. 실행화면

**데이터 요청**
<img src=https://i.imgur.com/bk31glQ.png width="550">

**요청 결과**
<img src=https://i.imgur.com/LZt7fxf.png width="550">

</br>

---

## 5. 고민했던 점

### 1️⃣ Boilerplate Code (중복되는 코드) 최소화하기 (제네릭 활용)
#### 요구사항에 명시된 네트워킹 요소
1. Application HealthChecker
2. 상품 리스트 조회
3. 상품 상세 조회

#### 최초에 작성한 코드
- 1~3번의 네트워킹 요소 메서드를 구현하는 과정에서, 데이터를 받아와 공통적으로 사용하기 위한 `dataTask`라는 커스텀 메서드를 구현하였습니다.
- 1~3번 요구사항을 처리하는 메서드를 커스텀 `dataTask` 메서드를 사용해 `checkAPIHealth`, `fetchProductList`, `fetchProductDetail` 를 각각 구현하였습니다.
- 각 메서드에서 중복되는 코드가 많다는 문제점을 발견했고, 그 원인을 두 가지로 파악했습니다.
    1. 각 메서드에서 받아온 데이터를 디코딩 해줄 타입이 다르다.
    2. URL이 하드코딩 되어 있다.

```swift
func dataTask(request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
    let task = session.dataTask(with: request) { data, urlResponse, error in

        guard let httpResponse = urlResponse as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
                  return completion(.failure(.statusCodeError))
              }

        guard let data = data else {
            return completion(.failure(.noData))
        }

        return completion(.success(data))
    }

    task.resume()
}

func checkAPIHealth() {
    guard let url = URL(string: baseUrl + "/healthChecker") else { return }
    let request = URLRequest(url: url)

    dataTask(request: request, completion: { result in
        switch result {
        case .success(_):
            print("OK")
        case .failure(let error):
            print(error.localizedDescription)
        }
    })
}

func fetchProductList(pageNumber: Int, itemsPerPage: Int) {
    guard let url = URL(string: baseUrl + "/api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)") else { return }

    let request = URLRequest(url: url)

    dataTask(request: request, completion: { result in
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            do {
                let productList = try decoder.decode(ProductList.self, from: data)
                print(productList.lastIndex)
            } catch {
                print(error)
            }
        case .failure(let error):
            print(error)
        }
    })
}


func fetchProductDetail(for id: Int) {
    guard let url = URL(string: baseUrl + "/api/products/\(id)") else { return }

    let request = URLRequest(url: url)

    dataTask(request: request, completion: { result in
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            do {
                let product = try decoder.decode(Product.self, from: data)
                print(product.name)
            } catch {
                print(error)
            }
        case .failure(let error):
            print(error)
        }
    })
}
```

#### 1. 제네릭을 활용한 데이터 디코딩 타입 일반화

위의 코드에서는 아래의 로직이 중복되고 있습니다.
- URL 생성
- URLRequest 생성
- 커스텀 `dataTask` 메서드 호출 및 JSONData 디코딩

중복되는 부분을 줄이기 위해서는 JSONData가 디코딩 될 타입(`ProductList`, `Product`)을 공통된 하나의 타입으로 일반화해야 합니다. 디코딩을 위한 프로토콜인 `Decodable` 을 `ProductList`, `Product`가 모두 채택하고 있기 때문에, `<Model: Decodable>`과 같이 `Decodable`을 제네릭 타입으로 채택해서 하나의 메서드로 합칠 수 있었습니다.

#### 2. 프로토콜, enum 활용해 URL을 하드코딩 하지 않도록 변경

URL을 하드코딩할 경우, 각 URL마다 메서드를 따로 작성하거나 enum의 case에 각각의 URL을 직접 작성하는 방법으로 작성할 수 있을 것 같습니다.

```swift
// enum을 사용해 URL을 하드코딩한 예시
enum OpenMarketURL: String {
    case healthChecker = "https://openmaket.yagom-academy.kr/checkHealth"
    case productList = "https://openmarket.yagom-academy.kr/api/productList?page_no=1&items_per_page=100"
    case product = "https://openmarket.yagom-academy.kr/api/product/32"
}
```

하지만 위와 같이 작성할 경우 `page_no`, `items_per_page`와 같은 Query Parameter나 `id`에 원하는 입력값을 받을 수 없어 모든 경우의 수를 각 case로 작성해야 하는 재사용성 및 확장성이 굉장히 떨어지는 코드가 됩니다.

이를 해결하기 위해 구글링을 통해 여러 네트워크 구조 예시를 참조했고, 프로토콜과 enum을 사용해 URL을 만드는 구조를 설계할 수 있다는 것을 알게 되었습니다.

`Enpointable` 프로토콜에 URL을 구성하는 요소인 `baseURL`, `path`, `queries` 프로퍼티를 추가하고, 이 요소들을 필요에 따라 조합한 최종 URL을 반환해주는 `createURL` 메서드를 구현했습니다.  그리고 해당 프로토콜을 `enum OpenMarketAPI` 에 채택해주어, 각 네트워크 요소에 따라 필요한 `path` 와 `queries` 의 값이 들어갈 수 있도록 구현하였습니다.

`NetworkManager`에서 요청을 보내는 `request()` 메서드에서 `Endpointable`에 구현된 `createURL()`을 호출함으로써 입력받은 Query Parameter를 사용해 자동으로 URL을 생성해줄 수 있게 되어 재사용성과 확장성이 개선되었습니다.
</br>

---

## 6. 트러블 슈팅

### 1️⃣ `request` 메서드를 통해 `checkHealth`의 응답을 받아올 수 없는 문제
네트워크에 응답을 요청하는 메서드를 아래와 같이 `request`라는 하나의 메서드로 구현했는데, `checkHealth`의 경우에는 요청 시 디코딩 에러가 발생했습니다. `request` 메서드는 JSON 데이터를 디코딩 하도록 작성되어 있지만 `checkHealth`의 응답 형식이 JSON 데이터가 아닌 text/plain이기 때문입니다.

```swift!
func request<Model: Decodable>(endpoint: Endpointable, dataType: Model.Type, completion: @escaping (Result<Model, NetworkError>) -> Void) {
    guard let url = endpoint.createURL() else {
        return completion(.failure(.URLError))
    }

    let request = URLRequest(url: url)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            return completion(.failure(.URLError))
        }

        guard let response = response as? HTTPURLResponse,
              (200..<300).contains(response.statusCode) else {
                  return completion(.failure(.statusCodeError))
        }

        guard let data = data else {
            return completion(.failure(.noData))
        }

        do {
            let result = try JSONDecoder().decode(dataType, from: data)
            completion(.success(result))
        } catch {
            completion(.failure(.decodingError))
        }
    }

    task.resume()
}
```

`checkHealth`가 반환하는 text/plain 형식의 데이터를 String으로 변환해주는 별도의 메서드를 작성해 해결했습니다.

```swift!
func checkAPIHealth(endpoint: Endpointable, completion: @escaping (Result<String, NetworkError>) -> Void) {
    guard let url = endpoint.createURL() else {
        return completion(.failure(.URLError))
    }
        
    let request = URLRequest(url: url)
        
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            return completion(.failure(.URLError))
        }
            
        guard let response = response as? HTTPURLResponse,
            (200..<300).contains(response.statusCode) else {
            return completion(.failure(.statusCodeError))
        }
            
        guard let data = data else {
            return completion(.failure(.noData))
        }
            
        completion(.success(String(decoding: data, as: UTF8.self)))
    }
        
    task.resume()
}
```

---

## 7. 참고 링크
- Apple Developer 
    - [Fetch Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
    - [URLSessionTask](https://developer.apple.com/documentation/foundation/urlsessiontask)
    - [dataTask](https://developer.apple.com/documentation/foundation/urlsession/1407613-datatask)
    - [URLComponents](https://developer.apple.com/documentation/foundation/urlcomponents)
- 블로그
    - [URLSession과 사용법](https://greatpapa.tistory.com/66)
    - [네트워크 구조 참고](https://malcolmkmd.medium.com/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908)
    - [@escaping 이해하기](https://babbab2.tistory.com/164)
    - [String - Data 형변환](https://kkh0977.tistory.com/1394)
    - [Type, Metatype](https://sujinnaljin.medium.com/swift-self-type-protocol-self%EA%B0%80-%EB%AD%94%EB%94%94%EC%9A%94-7839f6aacd4)

---
[🔝 맨 위로 이동하기](#오픈마켓)
