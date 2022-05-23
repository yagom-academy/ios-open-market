# 🛍 오픈 마켓
> 프로젝트 기간 2022.05.09 ~ 2022-05-20
팀원 : [mmim](https://github.com/JoSH0318) [cathy](https://github.com/cathy171)


- [프로젝트 목표](#프로젝트-목표)
- [실행화면](#실행화면)
- [UML](#uml)
- [STEP 1](#step-1)
    + [고민했던 것들(트러블 슈팅)](#고민한-점트러블-슈팅)
    + [배운 개념](#배운-개념)
    + [PR 후 개선사항](#pr-후-개선사항)
- [STEP 2](#step-2)
    + [고민했던 것들(트러블 슈팅)](#고민한-점트러블-슈팅-1)
    + [배운 개념](#배운-개념-1)
    + [PR 후 개선사항](#pr-후-개선사항-1)
- [Ground Rules](#ground-rules)

---

## 프로젝트 목표

---

## 실행화면

---

## UML

<image width="500" src="https://i.imgur.com/isTPzq2.jpg"/>


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

### PR 후 개선사항

---

## Ground Rules
### 스크럼
- 🌈  10시 시작 
- 스크럼 시간은 30분이 넘지 않기
- 오늘의 목표 / 공유할 이슈 / 컨디션 공유
- 자신의 부족한 부분 / 우리 팀이 아쉬운 부분 토론
- 상황에 따라 조정 가능

### 주간 활동 시간
- 월, 화, 수, 목, 금 : 10시 ~ 24시
- 점심시간 : 13시 ~ 14시
- 저녁시간 : 18시 ~ 20시
- 상황에 따라 조정 가능

---

## 🪧 프로젝트 관련 규칙
### 코딩 컨벤션
#### Swift 코드 스타일
코드 스타일은 [스타일쉐어 가이드 컨벤션](https://github.com/StyleShare/swift-style-guide#%EC%A4%84%EB%B0%94%EA%BF%88) 에 따라 진행한다.

### Commit 규칙
커밋 제목은 최대 50자 입력
본문은 한 줄 최대 72자 입력

### Commit 메세지
🪛[chore]: 코드 수정, 내부 파일 수정.  
✨[feat]: 새로운 기능 구현.  
🎨[style]: 스타일 관련 기능.(코드의 구조/형태 개선)  
➕[add]: Feat 이외의 부수적인 코드 추가, 라이브러리 추가  
🔧[file]: 새로운 파일 생성, 삭제 시  
🐛[fix]: 버그, 오류 해결.  
🔥[del]: 쓸모없는 코드/파일 삭제.  
📝[docs]: README나 WIKI 등의 문서 개정.  
💄[mod]: storyboard 파일,UI 수정한 경우.  
✏️[correct]: 주로 문법의 오류나 타입의 변경, 이름 변경 등에 사용합니다.  
🚚[move]: 프로젝트 내 파일이나 코드(리소스)의 이동.  
⏪️[rename]: 파일 이름 변경이 있을 때 사용합니다.  
⚡️[improve]: 향상이 있을 때 사용합니다.  
♻️[refactor]: 전면 수정이 있을 때 사용합니다  
🔀[merge]: 다른브렌치를 merge 할 때 사용합니다.  
✅ [test]: 테스트 코드를 작성할 때 사용합니다.  
  
### Commit Body 규칙
제목 끝에 마침표(.) 금지
한글로 작성

### 브랜치 이름 규칙
`STEP1-1`, `STEP1-2`, `STEP2-1``STEP2-2` ...

---
