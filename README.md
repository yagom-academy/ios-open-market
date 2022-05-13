# 🛍 오픈 마켓
> 프로젝트 기간 2022.05.09 ~ 2022-05-20
팀원 : [mmim](https://github.com/JoSH0318) [cathy](https://github.com/cathy171)


- [프로젝트 목표](#프로젝트-목표)
- [실행화면](#실행화면)
- [UML](#uml)
- [STEP 1 기능 구현](#step-1-기능-구현)
    + [고민했던 것들(트러블 슈팅)](#고민한-점트러블-슈팅)
    + [배운 개념](#배운-개념)
    + [PR 후 개선사항](#pr-후-개선사항)
- [Ground Rules](#ground-rules)

---

## 프로젝트 목표

---

## 실행화면

---

## UML

<image width="500" src="https://i.imgur.com/isTPzq2.jpg"/>


---

## STEP 1 기능 구현

### 고민한 점(트러블 슈팅)
1️⃣ 서버와 통신하지 않고 Mock 데이터로 통신하기
- **URLSessionProvider**구조체에선 URLSession과 request를 만들어 서버에 보내고 **get()** 메서드를 통해 **dataTask(with:)** 를 호출하고 data를 받는 역할을 한다.
- 이 구조체는 서버와의 통신을 위해 만든 타입이고, 때문에 서버와 통신하지 않은 Mock 테스트를 하는 방법에 대해서 고민했다.
- **URLSessionProvider** 구조체는 `session: URLSession` 프로퍼티를 갖는다.
- 때문에 **URLSessionProvider**와 **URLSession**의 결합도가 높다.
> 결합도가 높아서 재활용성이 낮고, 유지/보수가 힘들고, 단위 테스트가 어렵다.
- 결합도를 낮추기 위해서 **URLSession** 타입과 테스트를 위한 **MockURLSession** 에 **URLSessionProtocol**을 채택하였고, `session: URLSessionProtocol`로 변경하였다.
- 이를 통해 URLSessionProvider 초기화할 때, 필요한 URLSession을 의존성 주입할 수 있게 됐다. 
- ex) URLSessionProvider(session: MockURLSession())
    
2️⃣ DummyData 만들기
- 서버에서 받을 수 있는 똑같은 형태의 JSON 파일을 Dummy 데이터로 활용하여 테스트하는 방법에 대해서 고민했다.
- 서버에서는 dataTask()를 통해 `Data, URLResponse, Error`을 받아온다.
- 따라서 우리가 활용할 Dummy data 또한 Data 타입이어야 한다는 것을 알 수 있다.
- JSON파일을 Asset에 추가하고, Asset으로부터 NSDataAsset() 메서드를 통해 JSON파일을 로드했다. 
- NSDataAsset의 data 연산프로퍼티를 통해 Data 타입으로 변경하여 Dummy data로 활용했다.
    
3️⃣ dataTask(with: URL) vs dataTask(with: URLRequest) 
- URLSession의 dataTask 메서드를 호출할 때, 파라미터로 request 또는 url을 넣어준다.
- httpMethod의 기본값은 "GET" 이기 때문에 `request.httpMethod`에 "GET"을 명시할 필욘없다.
- 하지만 이후에 POST, PATCH 등 다양한 요구사항의 생길 것을 예상하여 `dataTask(with: URLRequest)`을 사용하고 `request.httpMethod`에 "GET"을 명시하는 것을 선택했다.

4️⃣ query값 입력받기
- 이번 프로젝트엔 `{{api_host}}/api/products?page_no=1&items_per_page=10`에서 본 것처럼 `?` 이후에 있는 쿼리값이 존재한다.
- 따라서 쿼리값을 입력받아 원하는 경로, 쿼리에 맞는 정보를 얻을 수 있도록 구현하는 것을 고민했다.
- **URLComponents** 타입은 URL을 구성하는 구조로써 `queryItems`라는 배열형태의 프로퍼티를 갖는다.
- 이 프로퍼티에 쿼리스트링을 주입할 수 있다.
```swift
// URLComponents을 초기화해준다.
guard var urlComponents = URLComponents(string: hostApi + path) else {
    return
}
// 여러개의 쿼리스트링이 존재할 수 있음. 
// 따라서 파라미터로 입력받은 딕셔너리 타입의 값을 mapping하여 [URLQueryItem]로 만들어준다.
let query = parameters.map {
    URLQueryItem(name: $0.key, value: $0.value)
}
//queryItems에 [URLQueryItem]을 할당
urlComponents.queryItems = query
//URL 타입으로 변환
guard let url = urlComponents.url else {
    return
}
```
- 위와 같은 방법으로 URL에 호스트 API와 path, 쿼리스트링을 주입할 수 있다.


4️⃣ escaping closure
```swift
    func get(completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        ...
       guard let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode)
       else {
           completionHandler(.failure(.statusCodeError))
           return
      }
    }
```
`get()`메서드에서 `completion closure`는 서버에 URL요청 후 비동기로 실행되기 때문에 `@escaping`을 선언해줘서 네트워크 요청 처리가 끝난 후 실행해야할 것을 `completion handler`에 작성해주었다.
위와 같이 `statusCode`가 200대라는 조건이 충족되지 않으면 실패했을 때의 `escaping closure`를 실행시켜준다.

5️⃣ 비동기로 테스트하기
`dataTask` 메서드가 비동기적으로 작업을 처리하기 때문에 `expectation(description:)`, `fulfull()`, `wait(for:timeout:)` 메서드를 사용하여 테스트하였다.
```swift
let promise = expectation(description: "")
    sut = URLSessionProvider<ProductsList>(path: "/api/products",
                                           parameters: ["page_no": "1", "items_per_page": "20"])
    let data = 69
    sut.get { result in
      switch result {
      case .success(let products):
        XCTAssertEqual(products.lastPage, data)
      case .failure(_):
        XCTFail()
      }
      promise.fulfill()
    }
    wait(for: [promise], timeout: 10)
```
- `expectation(description:)` : 수행되어야 하는 내용을 description으로 정해준다.
- `fulfull()` : 정의한 expectation가 충족될 때 호출한다.
- `wait(for:timeout:)` : expectation을 배열로 전달해서 배열의 모든 요소가 `fulfill`될 때까지 기다린다.

### 질문사항
1️⃣ JSON과 매칭할 모델타입을 구현할 때...
아래와 같이 오픈마켓API에서는 `상품 상세 조회`에 images와 venders가 존재합니다.  
<image width="400" src="https://i.imgur.com/2xlfBr2.png"/>  
하지만 `상품 리스트 조회`에서는 각각 pages 내에 있는 항목과 위의 내용과 다릅니다.  
<image width="400" src="https://i.imgur.com/vaEaC10.png"/>  

저희는 JSON과 매칭할 모델타입에 images와 venders를 위한 타입도 만들었지만
테스트할 때, 오류가 생겼습니다.
예상하건데, `상품 리스트 조회`에서 받을 수 있는 Data에는 images와 venders가 없어서 매칭할 수 없어 생기는 오류로 예상했습니다.

이부분은 이후 STEP에서 진행하는 추가적인 부분인가요? 아니면 저희의 실수였을까요 😭?

2️⃣ 전체적인 설계 구조?
저희가 서버와의 통신이 처음이라서 많이 힘들었는데요 😭 
특히 어떠한 구조로 코딩해야할 것 인지에 대한 부분이 가장 어려웠습니다.
저희 코드의 설계 구조(?)적인 부분에서 조언을 받고 싶습니다.

3️⃣ URLSessionDataTask의 init() ❗️deprecated???
저희가 Mock 테스트를 위해서 MockURLSession에서 URLSessionDataTask을 초기화해야 합니다.
그런데 아래와 같이 `init() ❗️deprecated`됐다는 경고가 뜹니다.  
![](https://i.imgur.com/LGCjARc.png)  
추천 방법이나 대체되는 방법을 제시하지 않아... 어떤 대안책이 있을지 모르겠습니다 😭

### 배운 개념
- 파싱한 JSON 데이터와 매핑할 모델 설계
- URL Session을 활용한 서버와의 통신
- CodingKeys 프로토콜의 활용
- 네트워크 상황과 무관한 네트워킹 데이터 타입의 단위 테스트(Unit Test)
- URL 
- URLSession 
- URLComponents
- URLQueryItem 
- URLRequest
- escaping closure

### PR 후 개선사항
