

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

   🧐 ~~request와 response에 모두 dataTask가 들어있고 이 두가지 모두 async할텐데 response가 먼저 동작할 수 있나?:~~

   ~~dataTask는 async하게 동작한다고 이해하고 있습니다. 이 상황에서 dataTask를 생성하는 것은 Serial하게 동작할 것이라고 예상됩니다. 하지만 어떤 async한 작업이 먼저 완료될 지 알 수 없기 때문에 순서의 문제가 생겨 request를 주는 작업이 완료되기 전 response를 받지 않을까 하는 고민이 됩니다.~~

   -> request를 생성하는 메소드를 구현할 때 response 메소드를 재활용해서 받는 것이 아니었습니다. 흐름을 고민해보니 request를 보내고 돌아오는 response를 dataTask에서 받는 것이었으므로 위의 고민은 더이상 고민할 필요가 없었습니다.

   <br/>

   🧐 ~~GET 메소드와 다르게 POST는 url을 통해서 데이터를 전송하고 그 response로 데이터를 받아오는데 GET과 같은 방식으로 Response를 받아올 수 있나?:~~

   ~~GET 메소드에서는 JSON 데이터를 가져오기 위해 getJSONDataFromResponse 메소드를 이용합니다. GET 메소드가 url을 통해 데이터를 받아오는 반면 POST 메소드는 request를 보내고 그에 대한 response로 데이터를 받아옵니다. 같은 getJSONDataFromResponse 메소드로 값을 받아오려면 url을 입력해야하는데 같은 방식으로 작동하는 것인지 고민해 볼 필요가 있습니다.~~

   -> 바로 위의 고민과 마찬가지 이유로 해결되었습니다.

   <br/>

   🧐 하나의 메소드에서 Generic을 2개 설정하고 싶을 때:

   검색해도 관련 자료를 찾기가 어려워서 한번 시도해봤는데 문제가 없었습니다. 코드는 아래와 같습니다.

   >**func** sendFormDataWithRequest<SendType: Encodable, FetchType: Decodable>(data: SendType, HTTPMethod: HTTPMethod, url: String, completionHandler: **@escaping** (FetchType?) -> ()) **throws** {
   >
   >...

   코드의 완성도 여부를 떠나 generic을 위처럼 2개 이상 각각 지정할 수 있다는 사실을 처음 알게 되었습니다.

   <br/>

   🛠 피드백 받은 부분
   
   >"DTO의 Response 구조에 겹치는 부분이 많다. 전부 나눠져 있어 언제 사용되는지는 알기 쉽지만 오히려 프로젝트를 모르는 사람 입장에서는 가독성을 해칠 수 있다. 하나로 합치는 것이 더 좋을 것 같다."
   
   Response를 받는 DTO를 HTTP 메소드 별로 따로 구현했지만 이것을 하나로 합치는 것이 더 좋다는 피드백을 받았습니다. 최초에 프로젝트를 진행하며 생각했던 부분과 일치하는 지점이 있어 하나로 합치는 수정작업을 진행했습니다.
   
   <br/>
   
   🧑🏻‍💻 Result 사용하기
   
   기존에는 아래와 같이 직접 데이터를 처리했습니다.
   
   ```swift
   let task = URLSession.shared.dataTask(with: request) { data, response, error in
              guard let data = data else { return }
              ... 
              }
   task.resume()
   ```
   
   <br/>
   
   이런 구조가 되면 문제가 발생하는데 바로 guard let 구문에서 확인할 수 있습니다. data가 있지 않을 때 동작하는 else는 아무 값도 return 할 수 없습니다. 또한 dataTask는 throws 하지 않기 때문에 error를 throw 할 수도 없습니다. 이러한 구조는 데이터가 존재하지 않을 경우 단순히 동작을 멈추기만 할 뿐 사용자에게 어떠한 알림도 줄 수 없기 때문에 좋지 못한 구조입니다. 이것을 Result를 활용하는 구조로 변경했습니다.
   
   ```swift
   let task = URLSession.shared.dataTask(with: httpRequest) { result in
               switch result {
               case .success(let data):
                   let decodedData = try? JSONDecoder().decode(T.self, from: data)
                   if let decodedData = decodedData {
                       completionHandler(.success(decodedData))
                   } else {
                       completionHandler(.failure(APIError.JSONParseError))
                   }
               case .failure(let error):
                   completionHandler(.failure(APIError.NetworkFailure(error)))
               }
           }
   ```
   
   위의 구조는 이미 dataTask에서 completionHandler를 동작시키기 전에 Result에 대한 체크를 한번하고 completionHandler를 처리하기 때문에 에러 처리가 가능합니다.

<br/>

2021.06.16(수요일)

- NetworkManager의 registerItem, deleteItem, editItem 메소드의 throw를 없애고 completion을 활용하는 구조로 refactoring 했습니다.
- NetworkManager의 fetchItemList에 page를 UInt로 입력받는 parameter를 생성하고 NetworkManager가 가지고있던 page 프로퍼티를 제거했습니다.
- NetworkManager의 프로퍼티 list를 [ItemList]에서 [ListedItem]으로 변경하고 그에 맞게 메소드들을 수정했습니다.
- viewDidLoad의 networkManager completionHandler를 구현할 때 error를 단순히 print하는 것이 아니라 Alert 할 수 있게 UIAlert를 구현했습니다.

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

