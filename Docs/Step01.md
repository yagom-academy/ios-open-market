## 1️⃣ STEP 1

### STEP 1 Questions & Answers

#### Q1. Unit Test 시 실제 서버로부터 데이터를 가져오지 못하는 이슈.
- 추가로, URLDataTests 파일 내 `func test_fetchData_메서드가_실제_홈페이지에서_data를_가져오는지_테스트()`에서 실제 서버에서 데이터를 받는 작업을 진행 해보았는데, fetchData 메서드가 호출되는 부분에서는 `Grand Central Dispatch queue`에서 진행되어, global 스레드에서 진행되는 것으로 알고 있습니다. 이때문에, test 함수가 끝난 이후에 fetchData 메서드가 진행될 수 있기 때문에, expectation, fulfill, wait을 통해 함수가 미리 종료되는 것을 방지하고 있습니다. 현재 적용되어 있는 코드는 timeout을 10초로 설정해두었습니다. 하지만 만약 서버에서 전송하는 시각이 10초 이후에 이뤄진다면 저희의 코드는 정상적으로 작동할 수 없다는 것을 확인 하였습니다. 이를 해결할 수 있는 좋은 방법이 있을지 여쭈어보고 싶습니다!!
    
#### A1. Unit Test 시 실제 서버로부터 데이터를 가져오지 못하는 이슈.

- UnitTest 시 Mock 데이터를 사용하는 이유에 대하여 다음과 같이 분리하여 설명하고자 합니다.
1) 가장 먼저 Network 작업은 어떻게 동작하는지와 어떻게 처리해야 할지
>  네트워킹이란 서버와 앱 간의 데이터를 주고받는 것입니다. Networking은 서버와 앱 간의 데이터를 주고받기 위하여 HTTP 방식으로 REST API를 이용해서 JSON 데이터를 주고받습니다. HTTP 방식을 이용해서 REST API를 구성하는데, HTTP는 모바일과 서버 간의 메시지를 주고받는 규칙입니다. 즉, 서버와 클라이언트(앱) 간의 메시지를 주고받는 통신 규약을 의미합니다. HTTP를 통해 클라이언트는 서버에게 URL을 통해서 요청(Request)하고 서버는 요청에 대한 응답(Response)을 주는데 대부분 JSON 형식으로 응답을 줍니다.

2) Task 작업은 왜 global 스레드에서 동작하는지

> 앱을 실행하는 동안에 Networking 기능이 많이 작동하는데 동시성을 제공하지 않는다면 사용자는 Networking 기능을 전부 작동하는 동안은 사용자가 해당 작업이 완료될 때까지 기다려야 합니다. 이에 동시성 프로그래밍 필요(다중 스레드)합니다. 컴퓨터는 네트워킹이 되는 동안에도 사용자와 인터렉션이 돼서 즉각적인 반응을 보여줘야 하는데, 그렇게 되지 못할 때 사용자는 불편함을 느끼기 때문에 동시성을 제공해줘야 합니다.

3) 왜 @escaping 키워드를 사용하는지

> 먼저 URLSession에 대한 이해가 선행되어야 합니다. 앱과 서버 간의 데이터를 주고받기 위해서는 HTTP 프로토콜을 이용해서 데이터를 주고받는데 앱에서 서버와 통신하기 위해 애플이 제공하는 API가 바로 URLSession입니다. URLSession의 사용 순서는 Configuration을 결정,  Session 생성, Request에 사용할 url 설정, Task 결정 및 작성 순으로 진행됩니다. URLTask 중 하나인 DataTask는 Data를 받는 작업으로, Response 데이터를 메모리 상에서 처리합니다. URL 요청을 실시하고 완료 시 핸들러를 호출하는 Task 형식으로, Task가 실행된 후 핸들러가 실행되기 때문에 @escaping closure 형태로 받아와야 합니다. 
    
> 클로저가 함수에 인자로 전달됐지만 함수가 종료된 뒤 실행되는 것을 escape(탈출) 합니다. @escaping closure를 사용함으로서, 외부 변수/상수에 저장 가능 및 해당 함수가 실행이 끝나도 클로저 실행이 가능합니다. 이에 escaping 클로저는 completion handler, 즉 함수의 결과에 따라 다르게 동작하도록 비동기적 처리를 요구하는 함수에서 활용이 가능합니다. 서버 통신은 비동기 방식으로 작동하기에, `response`를 받아오기 전에 함수가 먼저 종료되어 빈 `response`가 나올 가능성 존재합니다. 따라서 `escaping closure`를 통해 서버에서 `response`를 다 가져오지 못한 상태로 함수가 종료되어도, 후에 서버 작업이 완료되면 `escaping closure`를 호출할 수 있기 때문에 `response`를 안전하게 전달받을 수 있습니다.

4) 마지막으로 네트워크 통신을 통해 얻어진 response data를 어떻게 사용해야할지 고민해보시면 좋겠습니다.

> 네트워크로부터 얻어진 response data를 completion handler에 전달하는 data task을 만들면 해결이 가능할 것으로 보입니다. completion handler는 task를 생성한 것과 다른 Grand Central Dispatch queue에서 호출되어 response data를 받았을 때 비동기적으로 실행됩니다. dataTask 메서드를 실행하고, resume() 메서드를 통해 데이터를 요청하고, 이를 받으면, completion handler는 실행되기 때문에, 해당 클로저 내부에서 response data에 대한 처리하고자 하는 작업을 수행하면 될 것으로 판단됩니다. 이제 Response data가 수신 완료된다면, delegate, notification, 새로운 tableView 생성, property observer 등을 통하여 해당 이벤트가 발생하였음을 전달해주면 Response data를 사용이 가능할 것으로 보입니다.

#### Q2. 폴더 및 파일 관리 고민
    
- 이번 오픈마켓 프로젝트를 진행하면서 저희는 크게 `Common`, `Resource`, `Model`, `View`, `Controller`, `Mock`을 기준으로 폴더 작업을 해주었고, 그에 따라 파일 분류를 해보았는데, 저희의 분류작업이 괜찮은 방법인지 확인을 받고 싶습니다.
    
#### A2. 폴더 및 파일 관리 고민
    
- 피드백 내용
```   
└── OpenMarket
    ├── View
    │   ├── ViewController
    │   ├── View
    │   └── Model
    ├── Network
    ├── Extension
    └── Mockup
```    

- 적용한 부분
```
└── OpenMarket                  
    ├── Application         
    │   ├── Presentation
    │   │   ├── ViewController
    │   │   └── View
    │   └── Domain
    │         └── Model
    ├── Networking               
    │   └── Protocol
    ├── Extensions
    └── Resources
```

- View안에 다시 View가 들어가 있는 부분에 의문이 들어 Clean Architecture 구조를 찾아 보았습니다.
- Clean Architecture 구조는 각 계층이 명확하게 분리되어있기 때문에 테스트와 유지 보수가 용이해지는 장점이 있어 채택하게 되었습니다. 




---
### STEP 1 TroubleShooting

#### T1. 주고 받는 모델 타입의 불일치로 인한 통신 실패 해결.
- URLSession와 GET Method를 테스트를 했을때 값을 제대로 받아오지 못하는 문제를 만났습니다. 예를들어 서버에서는 Product 모델 타입의 정보를 주는데 클라이언트에서 받는 모델 타입이 WebPage이면 제대로된 통신이 이뤄질 수 없다는것을 확인하였습니다. 이후 서버에서 주는 형식이 클라이언트에서 받는 형식과 동일 해야 정상적으로 받아올 수 있는것을 확인하였습니다. 

    
#### T2. 하나의 파라미터에 서로 다른 두개의 타입 사용 고민 해결.
- fetchData메서드와 dataTask(with:) 메서드의 매개변수로 URL 타입과 URLRequest 타입을 모두 사용하기 위해 메서드 오버로딩을 생각했었습니다. protocol 선언후 두 타입이 채택하는 방법이 많은 양의 코드를 반복하는 오버로딩 방식보다 가독성과 효율적인 측면에서 낫다고 판단해 들어갈수있는 모든 타입이 특정 프로토콜을 채택하는 방식으로 문제를 해결했습니다.

---
    
### STEP 1 Concepts

- `POP`, `protocol`, `extension`
- `URL`, `URLSession`, `URLDataTask`
- `dataTask`, `completion` 
- `Data`
- `URLResponse`, `HTTPURLResponse`, `statusCode`
- `Error`
- `resume`
- `Result Type`, `escaping closure`
- `JSONDecoder`
- `Generics`
- `Codable`, `CodingKeys`
    
---
### STEP 1 Reviews And Updates
    
[STEP 1 Pull Request](https://github.com/yagom-academy/ios-open-market/pull/181)

---
