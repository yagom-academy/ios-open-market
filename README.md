# 🛒 오픈마켓 프로젝트 저장소

<br/>

## 🎯 STEP 01

<br/>

- 주어진 주소에서 JSON 데이터를 받아와 처리할 모델 타입을 구현하고 그에 맞는 테스트를 작성해보겠습니다.

  <br/>

- 📂 모델 타입 구현하기:

  우선 받아온 JSON 데이터를 처리하기 위한 모델을 구현합니다. GET 뿐만 아니라 POST 등의 추가 작업도 필요하기 때문에 JSON을 decode하는 작업 뿐만 아니라 encode하는 작업도 필요합니다. 그래서 프로토콜 Codable(Encodable & Decodable)을 conform하도록 구현하겠습니다.

  🧐 타입의 이름에 VO를 추가?

  받아오는 모델 정보는 맥 미니 등 컴퓨터 판매 정보입니다. 판매되는 아이템의 정보인데다가 JSON 파일에서도 items라는 아이템의 목록으로 정보를 받아오므로 개개별 정보는 Item이라는 이름으로, 받아오는 아이템 리스트는 ItemList로 받아올 생각입니다.

  비슷한 종류의 예시를 구현할 때 Value Object라는 의미로 ItemVO, ItemListVO같은 네이밍을 해주는 경우가 있었습니다. Value Object의 의미를 한 번 살펴보겠습니다.

  <br/>

  >Value Object: 
  >
  >- 값을 위해 사용하는 오브젝트
  >- 읽기를 하기 위해 사용하는 객체
  >- 값이 같으면 동일한 오브젝트라고 볼 수 있음
  >- 불변성
  >- ...

  <br/>

  VO와 대부분 함께 이야기 하는 것이 DTO인데 이런 자세한 구분은 여기서 중요한 포인트가 아니므로 넘기도록 하겠습니다. 여기서 중요한 선택지는 **그래서 네이밍에 VO를 붙일 것인가** 입니다. 

  제가 구현할 객체가 데이터를 받아오는 것에 사용이 되고, 더 정확히는 요청을 보낼 때에도 사용될 예정이므로 DTO에 가깝다고 할 수 있습니다. 하지만 굳이 이 역할을 하는 것을 Swift 네이밍에 사용할 이유는 없다고 생각합니다. 왜냐하면 Swift Naming이 추구하는 바가 영어 문장처럼 자연스럽게 읽히는 것인데 VO/DTO라는 네이밍은 역할에 가깝기 때문에 여기서는 굳이 사용해주지 않겠습니다. 대신 이 타입들을 가진 파일명을 DTO라고 명명해주었습니다. 가장 이 타입들의 역할을 잘 표현해줄 수 있기 때문입니다.

  <br/>

  🧐 타입을 구현할 때 extension으로 구분지어 구현?

  우선 이 개념을 참고한 글은 아래와 같습니다.

  >I recently read an article that recommends [keeping model types decoupled from data decoding](https://medium.com/better-programming/why-model-objects-shouldnt-implement-swift-s-decodable-or-encodable-protocols-1249cb44d4b3). The rationale is that it makes your model types and business logic independent from the underlying data. While that’s a valid point, that approach doubles the types in your project and introduces a lot of boilerplate code.
  >
  >In my experience, that is rarely necessary. Most of the time, in iOS apps, model types and data coincide. As much as I like to keep responsibilities separate in my code, there is no need to over-engineer it for its own sake. But keep that approach in the back of your mind, since it might be useful someday.
  >
  >출처: https://matteomanferdini.com/network-requests-rest-apis-ios-swift/

  그리고 이 글에 나오는 링크에 들어가 [keeping model types decoupled from data decoding](https://medium.com/better-programming/why-model-objects-shouldnt-implement-swift-s-decodable-or-encodable-protocols-1249cb44d4b3) 를 읽고 이 프로젝트에 어떤 것이 더 적합한지 고민했습니다. 

  DTO의 구조를 나누어야한다는 글의 요지는 다음과 같습니다.

  단순히 DTO를 하나의 타입으로 선언하고 사용하면 JSON파일 구조의 단순한 변경만 발생해도 문제가 생길 수 있습니다. 예를 들면

  <br/>

  ```swift
  struct User: Decodable { 
    let firstName: String
    let lastName: String
    let email: String
    let dayOfBirth: Int
  }
  
  /*
  {
     "first_name":"Jay",
     "last_name":"B",
     "mail":"anyaddress@anycompany.com",
     "day_of_birth":7026198104
  }
  */
  ```

  <br/>

  이런 구조의 타입에 들어가는 JSON 파일의 형식이

  <br/>

  >{
  >   **"name"**:{
  >      **"first"**:"Jay",
  >      **"last"**:"B"
  >   },
  >   **"email"**:"anyaddress@anycompany.com",
  >   **"day_of_birth"**:7026198104
  >}

  <br/>

  로 변경된다면 User타입과 관련된 모든 코드에 에러가 발생합니다. 구조가 바뀌어 대응되는 값이 없기 때문입니다. 이것을 분리하여

  <br/>

  ```swift
  struct User {
    let firstName: String
    let lastName: String
    let email: String
    let dateOfBirth: Date
  }
  
  struct UserDTO: Decodable {
    let name: NameDTO
    let email: String
    let dateOfBirth: Int
    
    struct NameDTO: Decodable {
      let first: String
      let last: String
    }
  }
  ```

  <br/>

  로 구현하고 이것을 

  <br/>

  ```swift
  struct UserDTOMapper {
    
    static func map(_ dto: UserDTO) -> User {
      
      return User(firstName: dto.name.first, 
                  lastName: dto.name.last, 
                  dateOfBirth: Date(timeIntervalSince1970: dto.dateOfBirth))
    }
  }
  ```

  <br/>

  로 매핑한다면 더 유연한 구조로 사용가능하며 domain 모델인 User가 data 모델에서 decoupled, 즉 결합도가 낮아져서 더 좋은 모델이 될 수 있다는 것입니다.

  이에 반하여 발췌한 블로그 글은 이런 과정은 결국 구현해야할 타입의 양을 2배로 만들고, 무의미한 반복이 증가한다고 보고 있습니다. 그래서 필요하지 않다는 주장입니다. 

  이 프로젝트의 경우 필요한 타입이 많지 않아 사실 구현해야할 타입의 개수가 늘어난다는 것은 조금 다른 문제이지만, 결국 API에서 받아온 JSON을 다시 static한 메소드인 map을 거쳐 타입으로 매핑을 해야하는 것은 괜히 로직을 복잡하게 만드는 것이라고 판단되어 단순히 Codable로 구현하게 되었습니다. 하지만 이 지점에 대한 생각은 다음 질문과 연관하여 조금 더 해볼 필요가 있을 것 같습니다.

  <br/>

  🧐 타입을 HTTP Method마다 만들어야하나, 혹은 한개를 만들어 필요한 정보만 매칭이 되게 해야하나?

  1. 우선 HTTP 메소드별로 URI가 다른 구조로 제공되고, 각각에서 전달되는 JSON의 내용이 조금씩 다르기 때문에 모든 경우의 수를 DTO로 구성할 수 있을 것 같습니다. 

     Pros: 타입에 따른 정보의 내용이 명확합니다. 내용을 모르는 개발자가 코드를 보더라도 넘어오는 JSON 데이터가 무엇인지 DTO를 통해 명확하게 유추 가능합니다. 특정 부분에 문제가 발생하거나 일부 HTTP Method에 필요한 JSON의 구조가 변경될 경우 수정이 용이합니다.

     Cons: 무의미하게 중복되는 부분이 많은 데이터 타입이 과도하게 많아진다고 생각합니다. 구조적으로 보면 결국 판매되는 하나의 컴퓨터는 단 하나 존재하며, id 값이 유일한 식별자인 이유는 그 대상이 한 개이기 때문입니다. 물론 그 컴퓨터를 나타내는 객체를 구현하는 것이 아니라 정보를 받아오는 타입을 구현하는 것이므로 이와 무관하다고 생각할 수 있지만 결국 그 정보가 불필요하게 중첩될 경우 코스트가 발생한다고 생각했습니다. 예를 들어, PATCH에서 일부 수정이 발생할 경우, JSON으로 변환할 때 각 경우의 수를 모두 타입화 해주진 않습니다.

  2. 받아올 데이터 타입은 옵셔널로 모든 정보를 가지고 있고, 각 메소드에 따라 필요한 부분을 받아와 처리하고 그 처리 과정에서 유효성 검사를 통해 오류를 막아주는 방법을 생각했습니다.

     이 생각은 사실 위의 Pros와 Cons의 정반대가 될 것 같습니다. 

     Pros: 타입내 정보의 중첩이 최소화되고 추가적인 메소드가 발생할 때에도 새로운 타입의 추가 없이 구현 가능하다는 점에서 유리합니다.

     Cons: 반대로 유지 보수의 입장에서는 이 DTO를 통해서 각 메소드별 JSON 데이터의 내용을 알기 어렵고 옵셔널 값이 많아질 수 있는 구조이기 때문에 검사가 확실하지 않다면 오류를 일으킬 가능성이 있습니다.

  3.  사실 이 생각은 위에서 언급했던 블로그를 보며 든 생각인데 메소드마다 JSON이 다르고 복잡하기 때문에 Domain Model로 Item을 만들고 각 메소드 별로 DTO만 따로 만들어 매핑을 하는 방식을 생각해봤습니다. 그런데 이 아이디어는 구체화가 잘 안되서 아이디어로만 생각해 보았습니다.

  <br/>

- 🛠 Test 구현하기

  Test를 구현하기 위해 중요한 전제조건은 오프라인 상황에서도 가능한 테스트인지였습니다. 그래서 크게 구현하고자 하는 테스트는 **"로컬 JSON 파일에서 데이터를 가져와 DTO로 정상적인 변환을 하는지"** 입니다.

  🧐 로컬 JSON파일을 읽는 메소드를 어느 위치에 정의할 것인가?

  로컬 JSON파일로 테스트를 하기 위해 readLocalFile이라는 메소드를 활용했습니다. 이 메소드를 활용할 때 어느위치에 정의해줄지가 굉장히 고민되는 포인트였습니다. 

  옵션1. JSONParser 객체 안에 정의:

  JSON 파일에 관련된 내용이기 때문에 JSONParser 객체 안에 넣을까 생각했지만 객체의 정체성을 보면 파싱해주는 것이기 때문에 단순히 정보를 가져오는 기능이 맞을까에 대한 우려가 있었습니다. 거기에 단순히 테스트를 위한 메소드이므로 프로젝트 자체의 코드에 포함되는 것이 맞을까? 하는 고민이 있었습니다. 그래서 테스트 안에 작성했습니다.

  옵션2. 테스트 코드의 setUpWithError()에 작성:

  이 부분은 제가 잘못 생각한 것 같은데 저는 setUp메소드가 각 테스트 실행 전에 셋업을 시켜주는 부분이라 여기에 작성한 정보가 테스트를 하는 동안 그 Scope안에서 동작할거라고 판단했습니다. 하지만 생각해보면 단순한 메소드이므로 이 안에 변수를 선언해봤자 지역변수이므로 당연히 작동하지 않습니다. 또 테스트를 위한 코드인데 이것을 굳이 활용하기위해 static으로 선언하면 메모리에 낭비가 발생하므로 그것도 옵션에서 제외했습니다.

  옵션3. 테스트 케이스 안에 작성하기:

  이 부분이 정말 애매한 부분인데 테스트를 위한 메소드들이 작성되어야한다는 측면에서 객체에 포함되는 개념일 수도 있지만 테스트 메소드는 아니기때문에 조금 망설여집니다. 만약 테스트 세팅을 위한 객체를 선언해서 활용한다면 결국 코스트가 발생하는 것인데 테스트 클래스 안에 포함되어야하는 개념의 범위가 아직 감이 잡히지 않아 옵션3으로 정의하게 되었습니다.

  🧐 어떤식으로 테스트를 구현할 것인가?

  사실 STEP1은 HTTP에서 데이터를 받아오는 것을 구현하지 않은 상태이기 때문에 결국 구현한 JSON 데이터가 올바르게 매칭될 타입을 구현했는지 밖에 확인할 수 없습니다. 그래서 데이터를 파싱한 결과가 에러 없이 정상적으로 받아와졌다면 nil이 아닐 것이므로 XCTAssertNotNil을 활용했습니다.

  🧐 더 생각해볼 점?

  Item 타입을 파싱하는 것과 ItemList타입을 파싱하는 것 때문에 

  

 

