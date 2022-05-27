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
