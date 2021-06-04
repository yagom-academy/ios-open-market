# 🛒 오픈마켓 프로젝트 저장소

<br/>

## 🎯 STEP 01

<br/>

### 🙋 목표

>- 주어진 주소에서 JSON 데이터를 받아와 처리할 모델 타입을 구현하고 그에 맞는 테스트를 작성해보겠습니다.

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

  제가 구현할 객체가 데이터를 받아오는 것에 사용이 되고, 더 정확히는 요청을 보낼 때에도 사용될 예정이므로 DTO에 가깝다고 할 수 있습니다. 하지만 굳이 이 역할을 하는 것을 Swift 네이밍에 사용할 이유는 없다고 생각합니다. 왜냐하면 Swift Naming이 추구하는 바가 영어 문장처럼 자연스럽게 읽히는 것인데 VO/DTO라는 네이밍은 역할에 가깝기 때문에 여기서는 굳이 사용해주지 않겠습니다. ~~대신 이 타입들을 가진 파일명을 DTO라고 명명해주었습니다.~~ 가장 이 타입들의 역할을 잘 표현해줄 수 있기 때문입니다.

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

  3.  ~~사실 이 생각은 위에서 언급했던 블로그를 보며 든 생각인데 메소드마다 JSON이 다르고 복잡하기 때문에 Domain Model로 Item을 만들고 각 메소드 별로 DTO만 따로 만들어 매핑을 하는 방식을 생각해봤습니다. 그런데 이 아이디어는 구체화가 잘 안되서 아이디어로만 생각해 보았습니다.~~

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

  이 부분이 정말 애매한 부분인데 테스트를 위한 메소드들이 작성되어야한다는 측면에서 객체에 포함되는 개념일 수도 있지만 테스트 메소드는 아니기때문에 조금 망설여집니다. 만약 테스트 세팅을 위한 객체를 선언해서 활용한다면 결국 코스트가 발생하는 것인데 테스트 클래스 안에 어떤 내용들이 포함되어야하는지 개념의 범위가 아직 감이 잡히지 않아 옵션3으로 정의하게 되었습니다.

  🧐 어떤식으로 테스트를 구현할 것인가?

  사실 STEP1은 HTTP에서 데이터를 받아오는 것을 구현하지 않은 상태이기 때문에 결국 구현한 JSON 데이터가 올바르게 매칭될 타입을 구현했는지 밖에 확인할 수 없습니다. 그래서 데이터를 파싱한 결과가 에러 없이 정상적으로 받아와졌다면 nil이 아닐 것이므로 XCTAssertNotNil을 활용했습니다.

  <br/>

- 🔨 수정사항

  통신을 고민하며 Step1에서 구현한 DTO 모델에 대한 생각이 바뀐 점이 있었습니다. 그동안 생각을 잘못하고 있었던 점은 DTO는 데이터를 받기 위한 일종의 형식 객체일 뿐 그 자체가 어떤 정보들을 담는 것은 아니라는 것입니다. 데이터의 중복 문제 때문에 하나의 데이터 형식에 옵셔널로 프로퍼티들을 구현하려고 했는데 생각해보니 결국 중첩된다는 개념은 데이터 자체가 아니라 DTO 객체의 프로퍼티 이름 뿐이었습니다. 그래서 HTTP 메소드별로 DTO를 나누는 작업을 진행했습니다.

  <br/>

  🧐 나누어진 파일 네이밍하기:

  파일을 메소드별로 나누며 네이밍에 대한 고민이 생겼습니다. 전치사 사용을 지양하기 위해 GET 메소드를 위한 Item을 예시로 들면 GETItem이라는 네이밍으로 구성을 했습니다.

  <br/>

  🧐 Codable을 채택?:

  추후 변경이 있을 수 있지만 현재 생각해보면 이렇게 역할을 나눔으로해서 encode시 사용될 구조와 decode시 사용될 구조가 분명히 구별되어진다고 생각했습니다. 그래서 더 엄밀한 정의를 위해 Codable을 각각 맞는 Encodable과 Decodable로 변경했습니다.

  <br/>

  🧐 GETItem과 POSTItem은 사실 같은 코드:

  Response로 오는 정보 중 GET 방식(아이템 조회), POST 방식, PATCH 방식, DELETE 방식의 Response는 완전히 같은 구조입니다. 한가지 객체를 통해 두 정보를 받아오는데 활용할 수 있지만 

  >1. 네이밍의 혼선
  >
  >2. 추후 데이터 정보가 변경될 여지

  로 인해서 유지보수시에 문제가 생길 수 있으므로 각기 다른 파일에 다른 객체로 정의해주었습니다.

  <br/>

  🧐 POST할 때 File Array를 어떻게 처리할 것인가?:

  미해결

  <br/>


## 🛠 STEP 01 Review

<br/>

1. DTO 파일 네이밍

   >밑에 Readme에서 처럼 'DTO'라는 네이밍을 쓰려면 파일명보다는 폴더명에 쓰는 방식이 더 자연스럽게 받아들여질것 같습니다.
   >이후에 Item처럼 사용하는 모델의 종류가 늘어났을 경우에는 해당 파일에 계속 작성하는게 맞을까요?

   💡What I think: 저 객체들의 정체성이 데이터를 받아와서 담는데 사용될 것이기 때문에 막연하게 전부 묶일 것이라고 생각했습니다. 생각해보면 DTO들이 분리된 공간에 작성되어야 할 경우도 있을 수 있고 설계에 따라서는 다른 프로젝트 등에서 재사용 될 수 있을 것 같은데 그럴 때 의미를 분명히 하기 위해서 DTO라는 이유로 전부 묶여있는 것보다 같은 DTO라도 목적에 따라 분리될 필요성이 있을 것 같습니다. 여기서 생각해보면 해결 방법은 2가지가 있습니다.

   >1. Model 폴더 안에 DTO라는 폴더를 만들어주고 그 안에 파일 생성하기
   >2. Model 폴더로 모든 것을 묶는 것이 아니라 현재 Model 폴더 안에 있는 파일들을 세분화한 폴더들로 구별해주기

   1번 방식의 장점은 모델이라는 역할 안에서 DTO라는 역할 안의 파일이라서 직관적으로 이해하기 쉬운 구조일 수 있을 것 같습니다. 단점은 모든 구조를 폴더화하면 디렉토리의 depth가 깊어지는 것이기 때문에 복잡함을 가져올 가능성이 있습니다.

   2번 방식의 장점은 직관적으로 폴더명을 통해 파일에 빠르게 접근할 수 있다는 점입니다. 단점은 정의에 따라서는 최상위 폴더 바로 아래에 폴더들이 무분별하게 많아질 수 있다는 것입니다.

   정리해보면 결국 객체지향처럼 파일들의 정체성, 목적에 공통점이 있는 것들은 묶을 수 있다면 묶는 것이 보기 좋지 않을까 생각을 해봤습니다. 그래서 1번의 방식을 따르기로 결정했고, 파일이 하나여도 조금더 확실히 해주기 위해 폴더를 추가하는 방식도 앞으로 고려해볼 필요가 있을 것 같습니다. 파일이 하나만 들어있는 폴더라 하더라도 추후에 추가 작업이 있을 때 이미 존재하는 폴더에 추가해주는 편이 더 직관적이고 쉬울 것 같습니다. 

2. Error Description

   >Error에 대한 description을 설정해주면 좀 더 편한 디버깅이 될 것 같습니다 :)

   💡What I think: Error description을 생각하지 못했습니다. Error만 throw 하는 것이 아니라 description이 있으면 확실히 디버깅에 도움이 될 것 같습니다 :) 그래서 description을 어떤 방식으로 구현할까 고민하다가 단순히 프로퍼티를 생성해주는 것이 아니라 CustomStringConvertible이라는 프로토콜을 사용하기로 했습니다. 사용에서 얻는 이점은 관련 description을 보고싶을 때 출력하고 싶으면 단순 연산 프로퍼티의 경우 직접 그 프로퍼티를 출력해야하지만 CustomStringConvertible이라는 것은 그 타입 인스턴스를 출력하면 description이 출력되기 때문에 더 편할 수 있을 것 같습니다. 

   🧐 이 과정에서 고민: 문자열을 직접 작성해주는 것이 아니라 유지보수를 위해 한 곳에 모아서 관리하기위해 StringContainer라는 enum을 생성했습니다. enum으로 생성한 이유는 struct나 class일 경우 문자열에 접근하기위해 인스턴스를 생성하거나 전역적으로 선언해야할 것 같은데 단순히 string을 관리하기 위해 두가지 작업을 하는 것은 오히려 번거로움을 가중시키는 일이라고 생각해서 enum을 사용했습니다. 하지만 이 경우 "오히려 가독성을 해치는 결과가 될 수도 있나?" 라는 고민이 듭니다. 그리고 출력을 위해 String을 받을 때 rawvalue를 통해 받는 것보다는 description을 통해 받는 편이 더 좋을 것 같아 마찬가지로 CustomStringConvertible을 채택했습니다.

   🔨 추가 Review

   >Error 또한 CustomStringConvertible로 description을 설정해주는 방법도 좋습니다 👍🏻
   >추가로 [LocalizedError](https://developer.apple.com/documentation/foundation/localizederror)를 사용하는 방법 또한 존재합니다~!

   위의 description을 통해서도 구현이 가능하지만 이미 해당 기능이 LocalizedError라는 형식으로 있었습니다. 다른 점은 description은 String 타입이고 LocalizedError의 errorDescription은 String? 이었습니다. 

   관련된 description이 정상 출력되는지 테스트 메소드를 추가 작성하여 확인했습니다.

3. 무의미한 테스트일 수 있다:

   ```swift
   func test_APIError_description() { 
           let notFoundErrorMessage = "[Error] Cannot find data"
           let JSONParseErrorMessge = "[Error] Cannot parse JSONData"
           guard let testNotFoundErrorMessage = APIError.NotFound404Error.errorDescription else { return }
           guard let testJSONParseErrorMessage = APIError.JSONParseError.errorDescription else { return }
           XCTAssertEqual(testNotFoundErrorMessage, notFoundErrorMessage)
           XCTAssertEqual(testJSONParseErrorMessage, JSONParseErrorMessge)
       }
   ```

   print문으로도 충분한 테스트이기 때문에 테스트를 위한 테스트일 수 있습니다. 추후에 API를 통할 때 일부러 에러를 발생시켜 에러메세지를 확인해 볼 수 있습니다.

4. Model DTO의 Item과 ItemList분리:

   받아와야할 JSON파일은 두가지 종류입니다. 아이템 리스트와 아이템 구조인데 두가지 옵션이 있었습니다.

   >1. Item이라는 파일에 Item과 ItemList 구조를 모두 작성
   >2. 파일을 하나 더 생성해서 ItemList를 분리

   1번 옵션의 경우 코드의 양이 작고 Item에 관련된 DTO라는 공통점을 묶어놨다는 장점이 있지만, 반대로 ItemList에 대한 정보를 찾을 때 어려움이 있을 수 있습니다. 

   2번 옵션의 경우 한 파일에 하나의 타입만 들어있고 파일이 많아질 수 있다는 단점이 있지만, 반대로 직관적인 구조로 찾기 쉬운 구조라고 할 수 있습니다. 

   그래서 2번의 방식으로 진행했습니다.

<br/>

## 🎯 STEP 02

<br/>

### 🙋 목표

>- HTTPS 통신을 통해 데이터를 받아오거나 전달하는 작업을 구현합니다.
>- 받아온 데이터를 기반으로 하면에 테이블뷰로 보여주는 뷰를 구현합니다.
>- 테이블 뷰에서 특정한 항목을 선택했을 때 보여줄 디테일 뷰를 구현합니다.

<br/>

1. HTTPS 통신 구현하기

   🛣 URL 구현하기

   URL을 만들 String을 구현할 때 그 방법에 대해 고민했습니다. 우선 필요한 URL을 분석해보면 기본 URL에  중간 부분을 더하는데 Item List의 경우만 items/로 다르고, 마지막 부분은 HTTP 메소드마다 달랐습니다. 처음으로 생각한 방식은 각각을 모두 따로 구현하여 조립하는 것이었습니다. 하지만 HTTP Request/Response를 처리하는 로직에서 이것들을 조립해주는 것은 읽기에 좋지 못했습니다. 그래서 한번에 URL에 접근이 가능하게 해주고 이 조립은 URL을 생성하는 곳에서 이뤄지게 구현했습니다. 

   🧐 Base URL을 구현할 때 enum vs struct:

   우선 enum으로 구현할 경우 다음과 같은 장점이 있습니다:

   >1. 특정한 경우에 맞추어 String을 반환하는 구조이기 때문에 enum의 컨셉과 잘 맞습니다.
   >2. 인스턴스를 생성할 필요가 없습니다.

   반면 struct의 장점은 아래와 같습니다.

   >1. 저장 프로퍼티를 활용할 수 있기 때문에 기본 URL을 static 선언할 필요가 없습니다.
   >
   >2. 값타입이므로 필요시 인스턴스를 생성하여 활용하고 나면 메모리에서 제거에 대한 부분을 신경쓸 필요가 없습니다.

   ![image-20210524173621261](/Users/seungjinbaek/Library/Application Support/typora-user-images/image-20210524173621261.png)

   두 가지 방식으로 모두 작성해보았습니다. ~~URL은 하드코딩하면 String 한 줄이면 되는데 굳이 인스턴스를 생성해야하나의 측면에서 위의 방식이 나을 수 있지만 마찬가지로 static이면 프로그램 종료시까지 메모리에 전역적으로 상주할 수 있는데 URL 생성을 위해 잠시 생성되어야하는 baseURL을 static하게 갖는 것이 코스트라고 생각되어 struct 구조를 활용했습니다.~~

   눈에 보이는 큰 차이가 발생하지 않는다고 피드백을 받았습니다. 

   >살펴보았을때는 그렇게 눈에 보이는 큰 차이가 나지 않긴하네요.  개인적인 생각으로 요즘에는 하드웨어적인 성능이 뛰어나서 정말 대규모의 프로젝트나 메모리 릭이 매우 많이 발생하지 않는 이상 런타임에서 차이는 눈에 띄게 나타나기 어렵다고 생각됩니다.

   알고리즘 풀이에서 효율에 집중하다보니 습관이 생긴 것 같습니다. 가독성을 생각해보면 인스턴스를 생성하는 것보단 직접적으로 사용하는 편이 더 좋아보입니다. 그래서 enum을 활용했습니다.

   <br>

   🦾 Network Manager 구현하기

   <br/>

   HTTP Method를 실행할 메소드를 가진 구조체를 선언합니다. 네트워크 매니저는 다음과 같은 구조로 구현됩니다.

   >NetworkManager: 네트워킹을 관리할 구조체
   >
   >getJSONDataFromResponse: Response에서 JSONData를 가져오는 메소드
   >
   >sendFormDataWithRequest: Request를 생성해서 보내는 메소드
   >
   >fetchItemList: getJSONDataFromResponse를 사용해서 아이템 목록을 가져오는 메소드
   >
   >fetchItem: getJSONDataFromResponse를 사용해서 아이템 세부 내용을 가져오는 메소드
   >
   >registerItem: getJSONDataFromResponse와 sendFormDataWithRequest를 사용해서 아이템을 등록하는 메소드
   
   <br/>
   
   🧐 request와 response에 모두 dataTask가 들어있고 이 두가지 모두 async할텐데 response가 먼저 동작할 수 있나?:
   
   dataTask는 async하게 동작한다고 이해하고 있습니다. 이 상황에서 dataTask를 생성하는 것은 Serial하게 동작할 것이라고 예상됩니다. 하지만 어떤 async한 작업이 먼저 완료될 지 알 수 없기 때문에 순서의 문제가 생겨 request를 주는 작업이 완료되기 전 response를 받지 않을까 하는 고민이 됩니다.
   
   <br/>
   
   🧐 GET 메소드와 다르게 POST는 url을 통해서 데이터를 전송하고 그 response로 데이터를 받아오는데 GET과 같은 방식으로 Response를 받아올 수 있나?:
   
   GET 메소드에서는 JSON 데이터를 가져오기 위해 getJSONDataFromResponse 메소드를 이용합니다. GET 메소드가 url을 통해 데이터를 받아오는 반면 POST 메소드는 request를 보내고 그에 대한 response로 데이터를 받아옵니다. 같은 getJSONDataFromResponse 메소드로 값을 받아오려면 url을 입력해야하는데 같은 방식으로 작동하는 것인지 고민해 볼 필요가 있습니다.
   
   

<br/>

## 🔫 프로젝트시 만난 에러

<br/>

1. ![image-20210524164954051](/Users/seungjinbaek/Library/Application Support/typora-user-images/image-20210524164954051.png)

   <br/>

   🧐 에러 상황:

   프로젝트 상에 위의 에러가 발생했습니다. Shift + Cmd + K를 시도하라는 해법이 있었지만 해결이 되지 않았습니다. 

   😄 해결 방법:

   문제의 원인을 검색하던 중 같은 이름의 파일이 있으면 이런 문제가 발생한다는 사실을 알았습니다. 다른 디렉토리 상에 있더라도 이름이 같은 파일이 있을 경우 에러가 발생한다는 사실을 알게 되었습니다. 객체의 이름이 중복될 때 뿐만 아니라 파일명 중복에서도 문제가 발생할 수 있기 때문에 파일명에서도 더 디테일한 네이밍이 필요합니다.

2. ViewDidLoad에 작성한 코드는 정상작동하는데 Test코드에서는 작동을 안함:

   Test코드에서 ItemListFetcher가 정상 작동하는지 확인하기 위해 프린트문을 사용했는데 print문이 동작하지 않습니다. NSLog도 마찬가지로 동작하지 않았습니다.

   😄 해결 방법:

   test 메소드는 해당 작업이 끝날때까지 기다려주는 것이 아니라 실행을 시켜보는 로직이기 때문에 비동기 통신의 작업 마무리를 기다려주지 않습니다. 메소드 테스트 시간을 늘려줌으로써 해결할 수 있습니다.

3. JSONParsing 에러:

   알 수 없는 오류가 계속 발생해서 하나하나 테스트하며 문제를 파악해나갔습니다. 문제는 썸네일에서 발생했는데 썸네일이 String Array로 정의되어있는데 계속 nil이 들어왔습니다. 썸네일을 옵셔널로 처리하면 문제가 해결되는 것을 파악하고 썸네일을 집중해서 보니 thumbnails을 thumnails라고 'b'를 빼먹어 발생한 문제였습니다.. 단순한 오타가 큰 에러를 발생시켰고, 에러 메세지만으로 이해하기 어려운 오류가 발생할 수 있다는 것을 경험했습니다. 무조건 에러메세지를 구글링하는 것이 능사가 아니라 오류에 대해 먼저 생각해볼 필요가 있다고 느꼈습니다.

<br/>



