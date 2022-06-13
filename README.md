# 🛍 오픈 마켓
> 프로젝트 기간 2022.05.09 ~ 2022.06.03
팀원 : [mmim](https://github.com/JoSH0318) [cathy](https://github.com/cathy171)


- [프로젝트 목표](#프로젝트-목표)
- [실행화면](#실행화면)
- [UML](#uml)
- [STEP 1](#step-1)
    + [고민했던 것들(트러블 슈팅)](#고민한-점트러블-슈팅)
    + [질문사항](#질문사항)
    + [배운 개념](#배운-개념)
    + [PR 후 개선사항](#pr-후-개선사항)
- [STEP 2](#step-2)
    + [고민했던 것들(트러블 슈팅)](#고민한-점트러블-슈팅)
    + [질문사항](#질문사항)
    + [배운 개념](#배운-개념)
    + [PR 후 개선사항](#pr-후-개선사항)
- [II STEP 1](#ii-step-1)
    + [고민했던 것들(트러블 슈팅)](#고민한-점트러블-슈팅)
    + [질문사항](#질문사항)
    + [배운 개념](#배운-개념)
    + [PR 후 개선사항](#pr-후-개선사항)
- [II STEP 2](#ii-step-2)
    + [고민했던 것들(트러블 슈팅)](#고민한-점트러블-슈팅)
    + [질문사항](#질문사항)
    + [배운 개념](#배운-개념)
    + [PR 후 개선사항](#pr-후-개선사항)
- [Ground Rules](#ground-rules)

---

## 실행화면
|메인 화면|메인 화면 -> 상세 화면|
|:------:|:---:|
|<image width="200" src="https://i.imgur.com/Ot6U7IR.gif"/>|<image width="200" src="https://i.imgur.com/kb4Dt7k.gif"/>|


|상세 화면(1)|상세 화면(2)|
|:---:|:---:|
|<image width="200" src="https://i.imgur.com/llKH8Av.gif"/>|<image width="200" src="https://i.imgur.com/lBrm7MD.gif"/>|

|상세 등록_사진 등록|상품 등록_실패|상품 등록_성공|
|:---:|:---:|:---:|
|<image width="200" src="https://i.imgur.com/B9hsYGg.gif"/>|<image width="200" src="https://i.imgur.com/biWVxD2.gif"/>|<image width="200" src="https://i.imgur.com/1Ouwflq.gif"/>|

|삭제_실패|삭제_성공|
|:---:|:---:|
|<image width="200" src="https://i.imgur.com/nt3NaXX.gif"/>|<image width="200" src="https://i.imgur.com/M7EGS72.gif"/>|

|상품 수정|
|:---:|
<image width="200" src="https://i.imgur.com/ipTsOmH.gif"/>

---

## UML
<image width="600" src="https://i.imgur.com/Y8T66D8.jpg"/>

### Model
<image width="600" src="https://i.imgur.com/g6rss4c.jpg"/>

### View
<image width="600" src="https://i.imgur.com/4wSeO4B.jpg"/>

### Controller
<image width="600" src="https://i.imgur.com/A2OuZMf.jpg"/>

### Network
<image width="400" src="https://i.imgur.com/IZnmh7J.jpg"/>

---

## STEP 1

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
1️⃣ Mock 테스트를 위한 Mock 객체 변경
- 변경전: 
    - 기존에는 URLSessionDataTask의 init()을 이용하여 원하는 Mock data와 response를 할당하는 방법을 선택
- 변경후: 
    - URLProtocol을 채택하는 방법을 선택
    - `deprecated`된 URLSessionDataTask의 init()을 사용하지 않고, URLProtocol을 채택한 MockURLProtocol 객체를 활용했다. 

```swift
final class MockURLProtocol: URLProtocol {
  static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
  
  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  override func startLoading() {
    guard let handler = MockURLProtocol.requestHandler else {
      return
    }
    do {
      let (response, data) = try handler(request)
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      client?.urlProtocol(self, didLoad: data)
      client?.urlProtocolDidFinishLoading(self)
    } catch {
      client?.urlProtocol(self, didFailWithError: error)
    }
  }
  
  override func stopLoading() { }
}
```


---

## STEP 2

### 고민한 점(트러블 슈팅)
1️⃣ stroyBoard vs code UI 구현
- STEP2를 시작하기 전, UI 구현에 있어 어떠한 방법을 선택할 지 고민했다.
- 각각 장단점이 있는 것 같다.
    - storyBoard 장점: UI 구현이 빠르다. / 직접 눈으로 UI의 구성을 확인할 수 있다. / 여러 기능을 찾아보지 않고 간단하게 사용할 수 있다.
    - storyBoard 단점: 변경 사항 commit을 파악하기 어렵다. / 유지, 보수가 어렵다.
    - code 장점: storyBoard에 비해서 가볍다. /  변경 사항을 파악하기 쉽다. / 충돌 가능성이 낮다.(확인이 용이해서) / UIKit 구조, 원리를 학습하기 좋다.
    - code 단점: 코드가 길어진다. / 시간이 다소 걸린다. / 화면을 파악하기 힘들다.
- 이러한 점들을 비교했을 때, 협력과 리뷰, 학습에 도움이 된다는 점에서 code로 구현하는 것을 선택했다.

2️⃣ List, Grid 화면 전환에 대한 고민
- 셀의 프로토타입을 두개 만드는 방법과 하나의 셀에서 레이아웃만 변경하는 방법 중에서 고민했다.
- 처음에는 셀을 두개 생성하는 방법으로 진행하다가 코드의 중복이 너무 많아서 레이아웃을 변경하는 방법으로도 구현해봤지만, 첫번째 방법과 동일하게 코드의 중복이 많아졌고 하나의 셀을 공유하면서 발생하는 `side effect` 도 많았다. 
- 또한 외부 개발자가 봤을 때 구현한 내용을 바로 이해하기 힘들다는 점에서 가독성이 좋지 않다는 문제점도 있었다. 
> ❗️ 결국 처음의 방법대로 셀을 두 개 생성하여 구현하였는데, 더 좋은 방법이 있을 지 궁금하다.

3️⃣ collectionview contentsOffset 문제와 고민
- List 형식의 Layout에서 Grid 형식으로 화면전환할 때, Grid 형식의 collection view의 시작이 아래쪽인 문제가 생겼다.
- 0번째 index의 cell이 아닌 2번 index의 cell이 기준점이 되는 듯 한 현상이었고, 그 원인에 대해서 고민했다.
> ❗️ 결국 명확한 원인을 찾을 수 없었다. 
> 하지만 cell의 contents size height 만큼 offset이 아래쪽에 있다는 것을 확인했고,
> collection view의 layout이 변경될 때, `collectionView.contentsOffset`을 변경해주는 방법으로 문제를 해결했다.
  
<image width="600" src="https://i.imgur.com/FkYdHJY.png"/>    


4️⃣ reuseCell에 대한 고민
- 빠르게 List, Grid layout을 번갈아가며 변경하면 ListCell에 잘못된 이미지가 로드되는 버그가 생겼고, 이를 해결하기 위해 고민했다.
- cell이 reuse 되면서 생기는 버그로 판단했다.
- 또한 cell의 imageView에 이미지가 로드되는 UI update 작업이 main thred에서 이루어지지 않는다고 판단했다.
- 이러한 근거로 해당 버그를 해결하기 위해 세 가지를 수정했다.
    1. Cell의 prepareForReuse() 메서드를 override하여 reuseCell의 요소들을 reset해주었다.
    2. `collectionView.indexPath(for: cell) == indexPath`인 값들만 UI setUp 메서드를 호출할 수 있도록 했다.
    3. UI를 setUp 해주는 메서드를 `DispatchQueue.main.async`로 처리해주었다.
```swift
DispatchQueue.main.async {
    if collectionView.indexPath(for: cell) == indexPath {
        cell.setUpListCell(page: page)
    }
}
```

5️⃣ collectionView layout은 어떤 것을 선택할까
- compositionalLayout, flowLayout, listCell 방식 중 어떤 것이 이번 프로젝트에 적합할지 고민했다.
- modern collection view를 경험하는 것이 이번 프로젝트의 요구사항이다.
- 따라서 가장 먼저 composiotionalLayout을 생각했다.
    - 복잡한 layout이 요구될 때 용이하다.
    - 유연하고 어느 상황이든 적용이 가능하다.
    - 하지만 이번 프로젝트는 단순히 cell이 순서대로 나열되는 형식이다.
- listCell
    - iOS 14.0 이상이 요구된다. 
- flowLayout
    - 흐름, 순서에 따라 cell이 배치된다.
    - iOS 13.0 부터 지원된다.
    - 따라서 이번 프로젝트에 적합한 스펙이라고 판단했다.

6️⃣ Diffable DataSource, Snapshot 사용
- 처음에는 CollectionViewDataSource를 VC에 채택시켜 data source를 구현했지만, modern collection view를 적용하고자 Diffable DataSource를 적용하기로 결정했다.
- 모델 타입에 Hashable을 채택하고 diffableDataSource를 생성하여 collectionView와 연결해주었다. 
- 그 후 cell을 만들고 register된 셀에 데이터를 넣어주고 데이터가 변경될 때마다 collectionView에 특정 시점의 데이터 상태를 나타내는 snapshot을 만들어주고 DataSource에서 apply를 호출해주었다.
```swift
  private func makeDataSource() -> DataSource {
    let dataSource = DataSource(collectionView: collectionView, cellProvider: {
      (collectionView, indexPath, page) ->
      UICollectionViewCell? in
      if self.segmentedControl.selectedSegmentIndex == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell",
                                                      for: indexPath) as? ListCell
        // somecode
        return cell
      } else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell",
                                                            for: indexPath) as? GridCell
        // somecode
        return cell
      }
    })
    return dataSource
  }
//...
  private func applySnapshot(animatingDifferences: Bool = true) {
    var snapshot = Snapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems(pages)
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
```
7️⃣ 


### 질문사항
1️⃣ cell prototype을 두개 만들면서 발생하는 많은 중복 코드
고민했던 점에 작성했던 것과 같이 저희는 두 개의 셀 프로토타입을 만들어서 구현하였는데 두 개의 셀의 label, imageView, stackView등의 구성과 레이아웃이 비슷한 것이 많아서 중복코드가 많습니다. 중복되는 코드를 줄이기위해서 cell을 한 개 만드는 방법밖에 없을까요?? 저희 코드에서 개선하기위해선 어떻게 해야할 지 여쭤보고 싶습니다!

2️⃣ paging 관련 질문
이번 STEP에서 추가 구현으로 스크롤 페이징을 해보려고 했습니다. view controller에 `UICollectionViewDataSourcePrefetching` 프로토콜을 채택하여 페이징 관련 메서드를 구현해보고자 했지만...실패했습니다.
itemsPerPage가 20인 경우를 기준으로 view에 보여진 Cell의 수가 일정수준(19개 정도)일 때, page에 1을 더해주고, 그 이후에 api에서 데이터를 get하는 메서드를 호출해주는 방법을 생각해봤습니다. 하지만... 실패했습니다. 😭
아직 그 방법이 덜 숙지된 것인지 감을 잡지 못해서 어떠한 키워드로 공부를 하는 것이 좋을지 조언 부탁드립니다.🙇‍♂️

3️⃣ collectionView contentsOffset
GridCell화면에서 첫번째 셀, 두번째 셀이 safeArea안에서 잡히지 않고 넘어가버리는 것을 확인하고 collectionView의 Anchor를 safeArea에 잡아주었는데, 해결이 되지않아서 cell의 contentsOffset을 한개의 셀의 높이만큼 변경해주었습니다. 
해결은 되었지만 셀의 위치를 임의로 맞춰준 것이기 때문에 다른 좋은 방법이 있을지 궁금합니다. 
그리고 이러한 현상이 일어나는 원인이 잘못된 로직 때문인 것인지 다른 이유가 있는 것인지 궁금합니다. 

### 배운 개념
- Modern Collection View
- Collection View
- Diffable DataSource, Snapshot
- URL
- URLSession
- URLComponents
- URLQueryItem
- URLRequest
- escaping closure
- NSCache

### PR 후 개선사항
1️⃣ pagination 기능 수정
- scroll할 때마다, 자동으로 불릴 수 있도록 UICollectionViewDelegate을 채택
- `scrollViewDidScroll` 메서드를 통해 scroll할 때마다 호출
- contentOffset을 계산하여 원하는 offset point에서 pagination될 수 있도록 구현
- pagination Y point는 아래처럼 계산했다. 
    - (content영역 Size) * (한 화면에 보여지는 cell의 수 / 서버에서 GET한 데이터의 수)
```swift
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let contentOffsetY = scrollView.contentOffset.y
    let collectionViewContentSize = self.collectionView.contentSize.height
    let paginationY = collectionViewContentSize * (Constants.itemsPerView / CGFloat(pages.count))
    
    if contentOffsetY > collectionViewContentSize - paginationY {
      currentPageNumber += 1
      fetchPages()
    }
}
```

---

## II STEP 1
### 고민한 점(트러블 슈팅)
> 0️⃣ 이번 프로젝트는 무지함에서 오는 고민이 많았다. 여러가지 선택지나 가설을 통한 고민이 아닌 전혀 모르는 영역을 탐구하는 고민이 대부분이다. 

1️⃣ 상품 등록/수정 페이지 UI 구현
- 상품 등록/수정 페이지는 크게 3 파트로 나뉜다.
    - 상단: 이미지가 들어가는 횡스크롤
    - 중단: 텍스트필드가 들어있는 입력란들
    - 하단: 긴 줄글을 입력하는 텍스트뷰
- 이번 프로젝트의 가장 큰 목표 중에 CollectionView의 구현이 있다.
- 따라서 CollectionView를 통한 구현을 고민했다.
- 하지만 몇 가지 이유로 적합하지 않다고 판단됐다.
    1. 굳이 Cell을 사용한 화면구현이 필요없다. CollectionView, TableView가 사용되는 가장 큰 이유는 반복되는 Cell들을 사용하기 위한이라고 생각한다. 이 화면에서는 반복되는 Cell이 없다고 판단됐다.
    2. Cell protoType이 4가지 이상 존재해야한다.(이미지뷰, 버튼이 있는 뷰, 텍스트필드뷰, 텍스트뷰 등이 구현된 Cell) 하지만 이 요소들이 반복되지 않고, 한번만 쓰인다.
    3. 상단의 scrollView 영역만 collectionView를 쓰는것도 생각해봤다. 하지만 이미지는 5개 이상 생성되지 않는다. 따라서 많은 Cell을 반복적으로 사용하는 collectionView에 적합하지 않다.
> 따라서 상단은 scrollView, 중단은 stackView, 하단은 TextView로 구현하기로 결정했다.    
![](https://i.imgur.com/sXgYrv9.png)  

2️⃣ HTTP POST 구현
- 일단 POST API 명세서를 보면 헤더와 바디에 필요한 요구사항들을 확인할 수 있다.
- 헤더 정보는 `request.setValue`를 통해 간단히 명시할 수 있다.
- 하지만 `params`와 `images`가 다른 타입을 가졌기에 `Multipart/form-data`을 사용해야했다.
- 일단 Multipart/form-data에 대한 고민을 했다.
- Multipart/form-data는 다양한 타입을 POST할 때 사용하는 방식이다.
- 때문에 헤더에 Content-Type으로 Multipart/form-data을 명시하고, boundary를 통해 다른 두 타입을 가진 각각의 바디를 구분하여 생성해주었다.
```
----------
< header >
* 필요한 header정보 입력
* Content-Type: Multipart/form-data
----------
< Body >
* Content-Disposition: MIME Type
* Content-Type: 해당 바디의 Type
* data

----------
< Body >
* Content-Disposition: MIME Type
* Content-Type: 해당 바디의 Type
* data

----------
```
- 서버가 요구하는 명확한 요구조건과 HTTP을 준수해야하기 때문에 오타가 날 경우, 통신이 안된다.
- 오타와 같은 경우 그것을 찾기가 매우 어렵고, 많은 시간이 소모되는 것을 경험했다.
- 때문에 오타와 문법에 각별히 신경써야했다.

3️⃣ image POST
- Multipart/form-data을 통해 image를 POST하기 위한 Body를 구현할 때 고민이 많았다.
- 로컬에 저장된 image의 경로 정보를 통해 image를 POST하거나, image의 URL 정보를 POST하는게 아닐까 생각했다. 이런 잘못된 예상으로 인해 많은 시간을 소모했다.
- API 명세를 살펴보면 image의 타입은 `file[]`로 되어있다. 
- 때문에 URL과 같은 String타입 POST하는 것이 아니라는 새로운 가설을 세웠고, data 형식으로 http body에 append해주는 방법을 생각하게 됐다.
- imagePickerController를 통해 선택된 사진을 UIImgaeView에 뿌리고, 그 UIImageView를 data형식으로 변환하여 http body에 append해주었다.

4️⃣ 키보드가 화면을 가리는 문제
- `textView` 입력할 때 키보드에 화면이 가려지는 문제가 있었다. 
- `Notification`을 사용해서 뷰의 frame을 키보드 높이의 1/3만큼 올려주는 방법으로 해결하려했다. 
- 또한 `UIPanGestureRecognizer`를 사용해서 사용자가 아래로 스와이프했을 때 키보드를 내려주도록 구현하였다. 
- `UITextViewDelegate`를 통해 textView에서만 적용되게 구현하려했지만 textView가 아닌 다른 textField에도 모두 키보드에 대한 설정이 적용되어서 결국 해결하지 못했다.

5️⃣ 모달로 화면 전환하는 방식
```swift
    let registrationVC = RegistrationViewController()
    let navigationController = UINavigationController(rootViewController: registrationVC)
    navigationController.modalPresentationStyle = .fullScreen
    present(navigationController, animated: true, completion: nil)
```
위와 같이 매개변수로 루트뷰 컨트롤러가 될 뷰컨트롤러를 생성하고 그 뷰컨트롤러로 네비게이션 컨트롤러를 생성해주었다.

6️⃣ POST와 비동기
- Post를 하기 위해 navigationItem Done button을 트리거로 이용했다.
- button을 클릭하면 아래와 같은 코드가 실행되게 구현했다.
```swift
self.apiProvider.patch(.editing(productId: product.id), params) { result in
    switch result {
    case .success(_):
        return
    case .failure(let response):
        return
    }
}
self.dismiss(animated: true, completion: nil)
```
- 하지만 이렇게 화면을 빠져나가 상품 리스트 화면으로 가게되면, post한 상품이 반영되지 않는다.
- 이러한 버그가 생기는 이유에 대해서 몇가지 고민했고, 이러한 방법을 통해 해결했다.
    1. post(서버와 통신)하는 메서드는 비동기이다. 때문에 switch문부터 시작하는 내부 코드블럭을 실행하기 이전에 dismiss가 된다. 따라서 화면을 빠져나간 시점에는 아직 post가 완료되지 않아 갱신되지 않는다. (post보다 상품리스트의 get을 통한 갱신이 더 빠르다.)
    이 문제를 해결하기 위해 DispatchGroup을 통해 patch 메서드 내부 코드 블럭이 끝날 때까지 기다려주도록 했다. group.notify을 사용했고, 후행 클로저에 dismiss하는 코드를 구현했다.
    3. 상품 리스트 화면의 viewWillapear 시점에 get을 통해 상품을 갱신한다. get 또한 비동기 메서드 이기 때문에 get을 완료하기 이전에 이미 viewWillApear 시점이 끝나버린다. (현재 가진 정보로 화면을 구성해버히고 지난간 느낌) 따라서 viewDidApear 시점에 get 메서드를 사용했다. 이미 화면의 라이프 사이클은 시작됐고, 그 직후 갱신된 정보를 반영하는 식으로 해결할 수 있었다. 

7️⃣ 빈 문자열을 get, post할 수 있다?
- 현재 서버는 빈 문자열 POST을 허용한다. price와 같은 Int 타입도 `" "`빈 문자열을 받을 수 있고, 예상하기론 nil값으로 서버에 저장되는 것 같다.
- 따라서 정보중 하나라도 nil 상태의 상품을 Get하게 된다면, 디코드 오류가 생기게 된다. 
- 현재 step까지는 상품 상세 화면을 구현하지 않아도 되기 때문에 이러한 nil 정보에 대해서 신경쓰지 않아도 된다고 판단했다.
- 하지만 이번 프로젝트에서 POST나 PATCH 과정에서 빈 문자열 또는 잘못된 문자열을 보낼수 없도록 막는 것이 좋다고 판단했다.
- name, price, discounted_price, stock, description 중 하나라도 입력이 누락됐다면 경고 Alert을 띄우는 것이 사용자 경험상 좋을 것이라고 생각했다. (📎입력을 누락하게 되면 빈문자열("")이 입력된다.) 
- 또한 숫자를 입력해야하는 곳에 Int로 변환할 수 없는 값을 입력하면 0 값이 입력되게 구현했다. 
> 이 후에 정보를 입력하지 않은 textField의 하이라이트를 주는 등 사용자 경험 측면에서 좀더 업그레이드 하고 싶다.


### 질문사항
1️⃣ textview부분만 키보드 내리는 것 적용하는 방법
프로젝트 요구사항을 보면 키보드가 올라왔을 때 컨텐츠를 가리지 않도록 한다는 조건이 있습니다.   
![](https://i.imgur.com/amUTGrJ.png)    
중간에 있는 **상품명 ~ 재고수량 TextField**는 키보드가 가릴 일이 없습니다. 하지만 아래에 있는 **description textView**와 같은 경우는 가립니다!
따라서 **description textView**를 클릭하여 키보드가 올라왔을 때만 view.origin.y를 올려주려했습니다 😭
하지만 `NotificationCenter`가 키보드가 올라오는 액션(UIResponder.keyboardWillShowNotification)를 감지하여 origin을 올려주기 때문에  **description textView**의 키보드가 올라왔을 때만 origin을 올려주지 못했습니다.
그래서 현재는 모든 키보드가 올라올 때, view.origin.y를 올라갑니다 😭
어떠한 키워드로 공부하면 이점을 해결할 수 있을지, 또는 어떤 문제가 있는지 궁금합니다.🙇‍♂️


2️⃣ 공통부분 상속으로 구현했을 때 private 접근제어자 사용하지 못하는 문제
RegistrationView와 EditingView가 완벽히 겹치는 코드가 많아서 프로토콜과 상속을 통한 구현을 시도해봤습니다. 
우선 protocol을 통해 구현하려고 했습니다. 저희 코드는 저장 프로퍼티를 많이 사용하고, 그 프로퍼티가 완벽히 겹칩니다. 때문에 protocol을 통해 구현하면 완벽히 같은 코드블럭도 똑같이 작성해야했습니다.(물론 코드 누락을 피할 수 있다는 장점이 생겼지만 중복코드가 여전히 존재하는 단점이...) 
그래서 현재 ProductUpdator class를 통해 상속으로 구현했습니다. 하지만 super class의 모든 프로퍼티와 메서드의 접근제어자를 사용할 수 없어졌습니다. 결과적으로 은닉화/캡슐화가 잘된 것인가 라는 생각을 하게 됐습니다. 
이 부분에서 저희가 사용한 상속이 올바른 방법인지 다른 방법이 있는지 궁금합니다.❤️‍🔥

3️⃣ 빈 문자열이 post 가능한 것에 대한 질문
위의 고민한 점에서(7️⃣ 빈 문자열을 get, post할 수 있다?) 언급했듯이 httpGet 했을때, price와 같은 Int 타입의 값에서 nil 값이 나옵니다! 
예상하기론 
1. 서버에서 빈 값을 nil로 바꾸어 저장했다. 
2. 서버에서 Int 타입임에도 ""로 가지고 있다가 클라이언트로 넘어오면서 Int타입으로 받을 수 없어서 nil을 반환한다.
이렇게 두가지로 예상해봤습니다.
궁금한 점은 POST할 때 params의 price는 type이 number라고 기재되어있는데, 왜 빈배열("")을 POST 할 수 있는건지. 서버에서 어떤 방식으로 잘못된 정보를 취급하는 것인지 궁금합니다.🙇‍♀️

### 배운 개념
- H.I.G (Human Interface Guidelines)
- HTTP
- Keyboard 
- 상속, 프로토콜
- URLSession
- HTTP POST/PATCH
- Multipart-form data
- imagePickerController
- NotificationCenter
- UIAlertController

### PR 후 개선사항
1️⃣ UITextView 키보드를 사용할 때만 frame 변경하도록 변경
- 기존에는 NotificationCenter를 통해 키보드가 나타나고, 없어질 때 view의 frame을 적용하는 메서드가 불리도록 구현했다.
- 하지만 우리의 기획대로라면 UITextView의 키보드만을 tracking해야하기 때문에 기존의 NotificationCenter 방식을 사용하지 않아야한다.
- `UITextViewDelegate` 채택 -> textViewDidBeginEditing(), textViewDidEndEditing() 메서드를 통해 UITextView의 Editing시작, Editing종료되는 시점에 view의 frame을 조정하는 로직을 구현

---

## II STEP 2

### 고민한 점(트러블 슈팅)
#### 📌II-STEP2-1
1️⃣ 상품 상세화면은 어떻게 구현할까
- 상품 상세화면은 크게 3가지 파트로 나뉜다고 판단했다. 
    - 상단: scroll을 통해 나열된 Image가 보여지는 곳
    - 중단: 상품의 정보가 text로 보여지는 곳
    - 하단: 상품의 설명이 여러줄로 보여지는 곳
- 상, 중, 하가 수직으로 나열되어있기 때문에 vertical StackView를 사용하여 layout을 잡아주었다.
- vertical StackView의 aliment와 distribution을 fill로 주어서 모든 컨텐츠가 화면에 꽉 차도록 설정했다.
- image scroll view와 상품 정보 stack view의 높이값을 화면 비율에 맞추어 설정해주어서 모든 기기에 알맞은 사이즈를 갖도록 했다.
- 상품 이름 label과 설명 label은 길어질수도 있는 유동적인 정보임으로 line을 0으로 설정해주었다.
- 하단의 상품 설명은 scroll view로 구성했고, 글자의 line이 길어지면 scroll을 통해 모든 정보를 확인할 수 있도록 했다.
- 또한, 상품 설명 scroll view의 subview는 바로 label이 아니라 UIView로 설정했고, UIView 안에 label을 넣어주었다.  

<image width="400" src="https://i.imgur.com/IxJKZZL.png"/>  

2️⃣ 상품 상세화면을 들어왔을 때, 경로 찾기
- **상품 상세화면**에 뿌려질 데이터를 위해선 상품마다 각기 다른 Endpoint가 존재한다. 
    - {{api_host}}/api/products/{{product_id}} 
- 위의 예시처럼 상품 `product_id`가 있고, 그 상품의 상세 정보를 가져오기 위해선 `product_id`가 필요하다.
- 🤔 **상품 상세화면**에선 `product_id`가 없어서 아직 데이터를 받아오지 못하는데 어디에서 `product_id`를 알아내야 할지에 대해서 고민했다.
- 이전 화면인 **상품 리스트 화면**에선 GET의 response로 다양한 정보를 받을 수 있는데, 그 중 상품 식별번호인 `id` 값을 가지고있다.
- 따라서 상품 Cell을 클릭했을 때, 해당 `id`값을 상세화면에 전달해주면 된다고 판단했다.
> 이전 화면에서 메서드 주입으로 `id`을 받아오고 그것을 통해 해당 **상품 상세 정보**를 GET할 수 있었다.

3️⃣ 상품상세 화면 데이터 get
- 상품상세 화면에선 GET을 통해 데이터를 필요한 곳에 뿌려준다.
- 때문에 HTTP 통신을 담당하는 메서드와 같은 경우, 
    - 1)최초 상품상세 화면 진입시 
    - 2)Edit 후 변경된 데이터가 적용된 상품상세 화면 진입시 
- 호출되어야한다.
- viewDidLoad()는 해당 VC의 인스턴스가 생성될 때, 호출된다.
- present된 화면을 들어갔다가 나온다 하더라도 VC의 인스턴스는 메모리에서 해제되지 않고있기 때문에 viewDidLoad()는 호출되지 않는다.
> 따라서 viewWillApear()에서 호출해주었고, 두 가지 경우에 모두 HTTP 통신을 할 수 있도록 해주었다.

#### 📌II-STEP2-2
1️⃣ HTTP통신 delete의 실패...🤔 productSecret(secretKey) 조회😭
- delete 구현을 하고 실행했을 때, network status 400 오류가 발생했다.
- 경로값에 `product_id`와 `product_secret`을 넣어주면 되기 때문에 오타의 가능성이 낮다고 판단했고, 다른 이유를 찾아보았다.
> 👏 delete에서 요구하는 `product_secret`에 대해서 오해하고 있었다. 
> `product_secret`는 판매자 비밀번호인 `secret`와 다르다.
- `product_secret`는 판매자 비밀번호가 아니라 상품 삭제에 필요한 secretKey였다.
- 이를 얻기 위해선 상품 삭제 Secret 조회 경로에 판매자 비밀번호를 바디에 넣어 POST해야한다.
> 이런 과정을 통해 response로 얻은 `productSecret(secretKey)`를 delete 경로값에 넣어주어서 문제를 해결하였다.

2️⃣ password가 실패했을 때, 처리방법  
<image width="200" src="https://i.imgur.com/qxw2ZdM.png"/>  
- 위처럼 게시 상품을 삭제하기 위해선 password를 입력해야한다. 
- 만약 사용자가 잘못된 password를 입력했을 경우, 그 다음은 어떠한 식으로 app이 동작해야하는 지에 대해서 고민했다. 
- 결정에 앞서 세 가지 사항을 목표로 했다.
    - 첫번째, 사용자 입장에게 비밀번호가 잘못 됐다는 것을 알려야한다.
    - 두번째, 사용자에게 계속해서 비밀번호를 입력할 기회를 주어야한다.
    - 세번째, 많은 선택지를 주는 것은 사용자로 하여금 혼동의 여지를 준다. 사용자의 선택지를 줄여서 행동을 단순화 시켜야한다.  
    
<image width="200" src="https://i.imgur.com/6W56CNu.png"/>  
- password가 틀렸을 경우, 비밀번호가 틀렸다는 것을 명확히 알리는 alert을 띄웠다.
- 확인 버튼을 누르면 다시 pssword 입력창이 뜨도록 구현했다.

3️⃣ delete에 대한 고민
- 판매자 비밀번호(password)를 입력하고, `상품 삭제 secret 조회` 통신이 성공하면 올바른 비밀번호, 실패하면 잘못된 비밀번호이다.
- 순서를 적어보면 **비밀번호 입력 -> 버튼 클릭 -> `상품 삭제 secret 조회` -> delete 성공 or 실패** 순서로 동작한다. 
- 하나의 트리거(버튼)로 `상품 삭제 secret 조회` 통신 결과에 delete의 여부가 달라진다.
> 이를 해결하기 해서 `상품 삭제 secret 조회` 메서드에 completionHandler를 파라미터로 받도록하고, 성공시 secretKey(String)과 성공여부(Bool)을 튜플타입으로 completionHandler에 전달하도록 했다.
```swift
private func checkSecretKey(
    _ inputPassword: String?,
    completionHandler: @escaping (String, Bool) -> Void
  ) {
    guard let pageId = self.pageId else {
      return
    }
    guard let inputPassword = inputPassword else {
      return
    }
    self.httpProvider.searchSecret(
      .secretKey(productId: pageId),
      inputPassword
    ) { result in
      switch result {
      case .success(let data):
        guard let reponseSecret = String(data: data, encoding: .utf8) else {
          return
        }
        completionHandler(reponseSecret, true)
      case .failure(let error):
        print(error)
        completionHandler(error.localizedDescription, false)
      }
    }
  }
```

4️⃣ scrollView paging
- scrollView의 paging를 적용하기 위해선 imageView의 frame 계산을 해야했고, 이를 구현하는데 가장 많은 고민을 했다.  
<image width="600" src="https://i.imgur.com/jyfyWd5.png"/>  

- 위 그림처럼 page마다 **scrollView의 bounds.origin**은 **view.frame * page수** 이다.
- imageView는 scrollView frame 영역의 중앙에 위치하기 때문에 margin을 더해줘야한다.
- 따라서 **imageView의 page당 origin**은 **view.frame * page수 + margin**이 된다.
- 이 계산을 바탕으로 아래와 같은 코드를 구현하였다.
```swift
for index in 0..<images.count {
      let imageView = UIImageView()
      imageView.loadImage(urlString: images[index].url)
      let margin = (imageScrollView.frame.width - imageScrollView.frame.height) / 2
      let originX = (self.frame.width * CGFloat(index)) + margin
      imageView.frame = CGRect(
        x: originX,
        y: 0,
        width: imageScrollView.frame.height,
        height: imageScrollView.frame.height
      )
      imageScrollView.addSubview(imageView)
      imageScrollView.contentSize.width = imageScrollView.frame.width * CGFloat(index + 1)
    }
```

5️⃣ pageControl
- 이번 프로젝트 요구 조건에는 없었지만 `pageControl`을 추가하면 UI적으로 더 좋을 것 같다고 생각하여 `UIPageControl`을 사용해보았다. 
- `pageControl`의 `numberOfPage`로 이미지 전체 개수를 설정해주고 `UIScrollViewDelegate`를 채택하여 `scrollViewDidScroll` 메서드에서 xPosition값으로 스크롤뷰의 현재 x의 위치에서 스크롤뷰의 가로를 나눈 값을 설정해주었다. 
- 그리고 현재 위치를 UIPageControl의 currentPage로 설정해주었다.
- 마지막으로 DetailViewController에서 viewWillAppear 시점에서 scrollview의 delegate를 Detailcontroller인 self로 설정해주었다.
```swift
extension DetailViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let xPosition = scrollView.contentOffset.x / scrollView.frame.width
    let pageNumber = Int(round(xPosition))
    detailView.setCurrentPage(pageNumber)
  }
}
```

6️⃣ 자신의 게시물만 수정 가능하도록 하기
- 상품의 Edit은 애초에 상품 게시자만 접근할 수 있도록 하는 것이 논리적으로 당연하다고 판단했다.
- 자신이 등록한 상품이 아님에도 Edit를 시도하면 어차피 Edit은 실패하기 때문에 사용자 경험상 정말 좋지 않을 것이다.
- 따라서 상품의 게시자만 Edit에 접근할 수 있도록 구현해야 한다고 판단했다.
- 상품상세 화면에서는 get response로 받아온 데이터를 알고있다. 
- 이 데이터 중에서 해당 상품의 게시자를 식별할 수 있는 식별자는 `vender_ID` 밖에 없다.
- 사실상 우리는 식별자로 `user identifier`와 `password`만 알고있기 때문에 `vender_ID`와 현재 사용자가 같은지 다른지를 판단할 수 없다.
- 따라서 이전에 POST 과정에서 알아낸 `vender_ID` 값을 강제로 넣어줬다.
- 이를 통해 사용자의 id와 네트워크 통신을 통해 받은 작성자의 id가 같을 경우에만 `rightBarButtonItem`에 버튼을 추가하도록 구현하였다.
```swift
    if product?.venderId == Constants.venderId {
      self.navigationItem.rightBarButtonItem = UIBarButtonItem(
        barButtonSystemItem: .action,
        target: self,
        action: #selector(presentActionSheet)
      )
    }
```

### 질문사항 
1️⃣ Network 관련 추상화
Network 관련 객체를 보면 반복되는 코드가 많은 것 같습니다. 
또한, 호출되는 곳에서는 경우에 따라 사용하는 메서드가 달라지고, 메서드가 달라져 파라미터를 주입하는 방법도 달라집니다. 그렇기 때문에 매우 복잡해보입니다.
이러한 이유로 추상화가 안된 것 같다라는 생각을 했습니다.
막연하게 추상화가 안 됐다고만 판단되고 어떻게 해야할지는 모르겠습니다. 😭
추상화 시점에서 바라본 구조적인 문제를 지적해주시고 어떤 방법이 좋은지 말씀해주시면 정말정말정말 감사하겠습니다!!!

2️⃣ Alert layout 오류  
<img width="500" src="https://i.imgur.com/z2cVS6Q.png">  
detail view에서 수정/삭제 버튼을 탭하면 action sheet 후 비밀번호를 입력하는 alert창을 띄우도록 하였는데 위와 같이 alert창 내의 UIView에서 레이아웃 에러가 발생했습니다. UIAlertController에서의 에러인 것 같아서 해결하지 못하였는데 alert을 사용할 때 추가적으로 설정해줘야하는 부분이 있는건지 여쭤보고 싶습니다.

3️⃣ action sheet 선택 기준 (HIG)
- HIG의 action sheet 파트를 보면   
![](https://i.imgur.com/52EJjEe.png)    
<image width="300" src="https://i.imgur.com/ZXrHuLr.png"/>    
> 파괴적(destructive)이거나 위험한 작업을 수행하는 버튼에는 파괴적인(destructive) 스타일을 사용하고 이러한 버튼을 작업 시트의 맨 위에 배치합니다.

- 라고 나와있습니다!
- 하지만 저희 요구사항에는 반대로 나와있습니다. (하지만 HIG를...따르라고 하시기도 했어요.)  
![](https://i.imgur.com/7GAfY5n.png)   

저희가 HIG를 잘못 읽은건지 아니면 HIG에서 제안하는 경우와 다른 경우인 건지 궁금합니다.🤔

4️⃣ Edit 권한에 대해서
위에 고민한 점에서 `II-STEP2-2 > 6️⃣ 자신의 게시물만 수정 가능하도록 하기`를 보시면 저희가 요구사항과 다르게 작성한 점이 있습니다.
위와 같은 방법이 좋지 않은 방법임을 알고있지만, 내가 작성한 게시물이 아님에도 Edit을 허용해주는 것이 너무 논리적으로 말이 되지 않는다고 판단하여 저러한 방법을 선택했습니다.
vender_ID는 게시물을 POST할 때, response로 주어지는 데이터에서 알아냈습니다.
(vender_ID는 서버에서 유저의 identifier에 따라 생성해주는 것으로 예상하고 있습니다.)
만약 서버에서 vender_ID 책정하는 방법을 바꾼다면 아주아주 크리티컬한 버그가 발생될 것으로 생각이 들긴합니다 😭
어떻게 이 부분을 해결해야할까요? 좋은 방법이 있을까요?

### 배운 개념
- AlertController
- HTTP POST/DELETE
- Delegate pattern

### PR 후 개선사항
1️⃣ Network 객체 추상화
- 기존에는 통신을 할 때, HTTP Method에 따라 호출하는 통신 메서드가 달랐다.
    - GET이 필요하면 getData, POST가 필요하면 postData
- 변경후: getData, postData, patchData 등 메서드를 `func execute(_: HttpRequirements, completionHandler) {}` 하나로 합쳤다.
    - 다만 HttpRequirements 타입을 파라미터로 받도록 했고, endpoint만 입력하면 Method를 자동으로 설정해주도록 구현했다.

2️⃣ H.I.G에 따른 action sheet 변경
- H.I.G에서 설명하듯이 destructive한 버튼이 가장 상단에 위치하도록 변경했다.

---
