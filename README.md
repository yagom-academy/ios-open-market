# 오픈마켓 프로젝트 저장소

## 목차 

- [STEP1](#step-1)
    - [고민했던 점](#고민했던-점)

---

## STEP 1

## 고민했던 점 

### 1. 네트워크 무관 테스트

프로젝트의 Step1에서 요구되는 실제 네트워크와 통신하지 않으며 진행하는 테스트를  Mock을 생성하여 구현해봤습니다.

실제 `Session`과 통신하지 않기 위해 기존 `URLSession`에 의존하는 것이 아닌 `URLSessionProtocol`을 생성하여 이에 의존하도록 했습니다. APIService내의 프로퍼티가 이제 `URLSession` 타입이 아니라, `URLSessionProtocol` 타입을 갖게 되고, 이 프로퍼티를 상황에 따라 실제/가짜 Session을 넣어주기 위해 생성자 주입 방식을 사용했습니다. 

먼저 `URLSessionDataTask`를 대체할 `MockURLDataTask` 타입을 생성했습니다. 이 또한 `URLSessionDataTask`를 상속하도록 하고, `URLSessionDataTask`의 `resume()` 메서드를 재정의하여 `MockURLDataTask`에서 정의한 클로저를 실행시켜주도록 구현했습니다. 

이후 `URLSessionProtocol`을 채택한 `MockURLSession` 타입을 구현하여 Unit Test시 `APIService` 인스턴스를 생성할 때 `MockURLSession`을 주입하였고, 해당 세션이 채택한 프로토콜에 정의되어있는 `dataTask()`를 구현해주었습니다.

생성한 task가 `resume()`될 때 앞서 `MockURLDataTask`에서 정의한 클로저가 이어서 실행되면서 사전에 만들어둔 성공/실패 결과를 반환하게 됩니다. 

이제 Unit test를 할 때, `APIService의` session에 `MockURLSession`을 넣어주어 항상 성공/실패하도록 설정해두었습니다. 이에 기대하던 데이터를 미리 디코딩해두고, `APIService`의 메서드를 실행 결과가 이와 동일한지 비교하여 네트워크와 무관한 로직 테스트를 수행했습니다. 


### 2. `URLRequest` initializer 추가 

`URLRequest` 인스턴스를 커스텀하게 생성해주기 위해 extension을 사용하여 이니셜라이저를 생성하였습니다. 생성과 함께 httpHeader/Body도 설정해주고, url도 달아주기 위해 부가적으로 `API`, `URLCreator`와 같은 타입을 생성하였습니다.

### 3. `dataTask()` 공통 사용 및 HTTPMethod 별 메서드 분리 

서버 요청에 반복적으로 사용될 수 있는 `dataTask()`를 하나로 묶어 사용하였습니다. 이 덕분에 상품 상세 조회, 상품 리스트 조회, 상품 삭제 등 여러 요청에서 해당 메서드를 재사용할 수 있었습니다.

HTTPMethod 별로 반환값 혹은 completion handler가 필요한 경우가 달라 이는 각각의 메서드로 구현해주었습니다. API문서에 따른 request들을 생성하기 위한 데이터들을 메서드의 파라미터에서 받도록 하고, 내부에서 조건에 맞는 `URLRequest`를 생성하여 성공/실패시 데이터/오류를 반환하도록 하였습니다. (데이터 반환이 필요하지 않은 경우는 에러만 반환하도록 했습니다)


### 4. `@escaping` closure 및 `Result` 타입 사용 

메서드가 리턴되더라도 추후에 데이터를 전달받기 위해 `@escaping`을 클로저에 사용해주었습니다. 이와 함께 `Result` 타입을 활용하여 성공/실패에 따른 정상적인 결과/에러를 반환해 줄 수 있도록 했습니다. 


