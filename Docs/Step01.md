## 1️⃣ STEP 1

### STEP 1 Questions

#### Q1. Unit Test 시 실제 서버로부터 데이터를 가져오지 못하는 이슈.
- 추가로, URLDataTests 파일 내 `func test_fetchData_메서드가_실제_홈페이지에서_data를_가져오는지_테스트()`에서 실제 서버에서 데이터를 받는 작업을 진행 해보았는데, fetchData 메서드가 호출되는 부분에서는 `Grand Central Dispatch queue`에서 진행되어, global 스레드에서 진행되는 것으로 알고 있습니다. 이때문에, test 함수가 끝난 이후에 fetchData 메서드가 진행될 수 있기 때문에, expectation, fulfill, wait을 통해 함수가 미리 종료되는 것을 방지하고 있습니다. 현재 적용되어 있는 코드는 timeout을 10초로 설정해두었습니다. 하지만 만약 서버에서 전송하는 시각이 10초 이후에 이뤄진다면 저희의 코드는 정상적으로 작동할 수 없다는 것을 확인 하였습니다. 이를 해결할 수 있는 좋은 방법이 있을지 여쭈어보고 싶습니다!!

#### Q2. 폴더 및 파일 관리 고민
    
- 이번 오픈마켓 프로젝트를 진행하면서 저희는 크게 `Common`, `Resource`, `Model`, `View`, `Controller`, `Mock`을 기준으로 폴더 작업을 해주었고, 그에 따라 파일 분류를 해보았는데, 저희의 분류작업이 괜찮은 방법인지 확인을 받고 싶습니다.
    
### STEP 1 Answers



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
    
[STEP 1 Pull Request]()

---
