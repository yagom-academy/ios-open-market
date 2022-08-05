# Open Market

## 프로젝트 소개
`URLSession`을 이용하여 `API` 정보를 기반으로 만든 이커머스 어플 `오픈마켓` 프로젝트입니다. 🙆🏻‍♂️

> 프로젝트 기간: 2022-07-11 ~ 2022-08-05</br>
> 팀원: [finnn](https://github.com/finnn1), [bonf](https://github.com/apwierk2451) </br>
리뷰어: [쿠마](https://github.com/leejun6694)</br>
그라운드룰: [GroundRule](https://github.com/Jeon-Minsu/ios-open-market/tree/step01/Docs/GroundRule.md)

## 📑 목차

- [🧑🏻‍💻🧑🏻‍💻 개발자 소개](#-개발자-소개)
- [📈 UML](#[📈-UML)
- [💡 키워드](#[💡-키워드)
- [🤔 STEP1 핵심경험](#-STEP1-핵심경험)
- [🤔 STEP2 핵심경험](#-STEP2-핵심경험)
- [🤔 STEP3 핵심경험](#-STEP3-핵심경험)
- [🤔 STEP4 핵심경험](#-STEP4-핵심경험)
- [📚 참고문서](#[📚-참고문서)
- [📝 기능설명](#[📝-기능설명)
- [🚀 STEP 1](#-STEP-1)
    - [🚀 TroubleShooting](#[🚀-TroubleShooting)
- [🚀 STEP 2](#-STEP-2)
    - [🚀 TroubleShooting](#🚀-TroubleShooting1)
- [🚀 STEP 3](#-STEP-3)
    - [🚀 TroubleShooting](#🚀-TroubleShooting2)
- [🚀 STEP 4](#-STEP-4)
    - [🚀 TroubleShooting](#🚀-TroubleShooting3)
##  STEP별 PR 내용
- [OpenMarket 1️⃣ STEP 1 PR](https://github.com/yagom-academy/ios-open-market/pull/173)
- [OpenMarket 1️⃣ STEP 2 PR](https://github.com/yagom-academy/ios-open-market/pull/185)
- [OpenMarket 2️⃣ STEP 1 PR](https://github.com/yagom-academy/ios-open-market/pull/193)
- [OpenMarket 2️⃣ STEP 2 PR](https://github.com/yagom-academy/ios-open-market/pull/199)

## 🧑🏻‍💻🧑🏻‍💻 개발자 소개

|Bonf|Finnn|
|:---:|:---:|
|<img src="https://i.imgur.com/9tYqNmy.jpg" width="250" height="250">|<img src="https://i.imgur.com/5EQ0KJy.png" width="250" height="250">|
|[@bonf](https://github.com/)|[@finnn](https://github.com/finnn1)|

## 📈 UML

![](https://i.imgur.com/YVf47qO.jpg)



## 💡 키워드
- JSONEncode & Decode
- HTTPRequest & Response
- URLSession
- escaping closure
- completion Handler

## 🤔 STEP1 핵심경험
- [x] 파싱한 JSON 데이터와 매핑할 모델 설계
- [x] URL Session을 활용한 서버와의 통신
- [x] CodingKeys 프로토콜의 활용
- [x] 네트워크 상황과 무관한 네트워킹 데이터 타입의 단위 테스트(Unit Test)

## 🤔 STEP2 핵심경험
- [x] Safe Area을 고려한 오토 레이아웃 구현
- [x] Collection View의 활용
- [x] Mordern Collection View 활용
- [x] 네트워크 상황과 무관한 네트워킹 데이터 타입의 단위 테스트(Unit Test)

## 🤔 STEP3 핵심경험
- [x] multipart/form-data의 구조 파악
- [x] URLSession을 활용한 multipart/form-data 요청 전송
- [x] 사용자 친화적인 UI/UX 구현 (적절한 입력 컴포넌트 사용, 알맞은 키보드 타입 지정)
- [x] 상속 혹은 프로토콜 기본구현을 통해 (수정/등록 과정의) 공통기능 구현

## 🤔 STEP4 핵심경험
- [x] UIAlertController 액션의 completion handler 활용
- [x] UIAlertController의 textFields 활용
- [x] UICollectionView 를 통한 좌우 스크롤 기능 구현


## 📚 참고문서
- [URLSession](https://developer.apple.com/documentation/foundation/urlsession)
    - [Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
- [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview)
    - [Modern cell configuration](https://developer.apple.com/videos/play/wwdc2020/10027/)
    - [Lists in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10026)
    - [Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)
- [Data Entry - iOS - Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios/user-interaction/data-entry/)
- [UIAlertContrller](https://developer.apple.com/documentation/uikit/uialertcontroller)


## 📝 기능설명
- **`Products` :**
상품 리스트를 GET 받아 올 때 데이터를 담을 타입입니다.
- **`Page` :**
Products 내부의 pages 데이터를 담을 타입입니다.
- **`ProductsDataManager` :**
API로 부터 데이터를 가져와 Products에 담는 역할을 하는 클래스입니다.
- **`URLSessionError` :**
URLSession 에 관한 에러를 처리하기 위한 Error 열거형입니다.
- **`Titles` :**
SegmentControl에 들어갈 부분을 namespace로 표현한 열거형입니다.
- **`Section` :**
DiffableDataSource 및 snapshot에 사용할 Section의 정보가 담긴 열거형입니다.
- **`ItemCollectionViewCell` :**
CollectionView의 각 셀을 표현하는 customCell입니다.
- **`extension UISegmentedControl`:**
SegmentControll의 Font 색상을 정의하는 Extension입니다.
- **`extension String`:**
스트링에 취소선을 추가해서 반환해주는 Extension입니다.
    
## 🚀 STEP 1

### 🚀 TroubleShooting

#### 다른 API의 통신이 가능한 코드
다른 API를 이용하는 경우가 만약 생긴다면 getData 기능을 갖는 새로운 함수를 만들어야 되기 때문에 더 유리한 코드를 만들기 위해 수정을 해야겠다고 생각했습니다.
```swift
func getData<T: Decodable>(pageNumber: Int, itemsPerPage: Int, completion: @escaping (T) -> Void) {
        
    var urlComponent = URLComponents(string: url)
    urlComponent?.queryItems = [
        URLQueryItem(name: "page_no", value: String(pageNumber)),
        URLQueryItem(name: "items_per_page", value: String(itemsPerPage))
    ]

    guard let urlComponentURL = urlComponent?.url else { return }

    let request = URLRequest(url: urlComponentURL)

    sendRequest(request, completion)
    }
```
위 코드와 같이 getData에 Generic타입을 정의하여 다른 타입의 API가 들어와도 사용할 수 있는 메서드로 수정하였습니다.

---

#### CustomCell의 ImageView의 높이 조절

CustomCell의 높이가 타이트해서 사용자가 터치를 할 때 잘못 클릭을 할 수도 있겠다는 생각을 했습니다. Layout을 이용해 contentView의 heightAnchor로 설정하려고 하였으나 잘 되지 않았습니다.
```swift   
private func setupCollectionViewLayout() {
    let flowLayout = UICollectionViewFlowLayout()

    let width = self.view.frame.width
    let height = self.view.frame.height

    flowLayout.minimumLineSpacing = 2
    flowLayout.estimatedItemSize = CGSize(width: width, height: height * 0.08)

    collectionView?.collectionViewLayout = flowLayout
}
```
flowLayout을 추가하여 CollectionView의 각 높이를 조절하였습니다.

## 🚀 STEP 2

### 구현 내용

|**실행**|**List 하단 스크롤**|**List 새로고침**|
|:---:|:---:|:---:|
|![](https://i.imgur.com/o7M5s8G.gif)|![](https://i.imgur.com/EImgRTh.gif)|![](https://i.imgur.com/cIH916P.gif)|
|**Segment변경**|**Grid 하단 스크롤**|**Grid 새로고침**|
|![](https://i.imgur.com/bpMr2XW.gif)|![](https://i.imgur.com/eCPsHGm.gif)|![](https://i.imgur.com/5ONbvQH.gif)|

### 🚀 TroubleShooting

#### 세그먼트 컨트롤 변경시 LIST와 GRID를 보여주는 방법

> `STEP2`를 시작하면서 가장 큰 고민은 `LIST`와 `GRID`의 변경 방식이었습니다.
> 세그먼트가 변경될 때, 하나의 뷰에서 레이아웃을 변경해서 표현할지, 아니면 별도의 뷰를 따로 두어 보여줄지 고민을 했었습니다.
> 별도의 뷰를 만들 경우, 뷰가 변경될 때 마다 컬렉션뷰(테이블뷰)를 다시 업데이트 해줘야 한다는 점과, 사용하지 않는 데이터가 생길 수 있다고 생각을 하여 하나의 뷰에서 데이터를 모두 읽어온 후 레이아웃을 변경하는 방식으로 선택했습니다.

---

### List와 Grid 변경시 셀 내부 레이아웃

> 컬렉션 뷰의 레이아웃 같은 경우는 ViewController 에서 변경해주면 되지만, 셀 내부의 레이아웃 같은 경우는 변경되지 않았습니다.
> Cell 내부에서 StackView의 axis 및 레이아웃을 변경해줄 수 있는 메서드를 정의해서 해결했습니다.

## 🚀 STEP 3

### 구현 내용

|**상품등록**|**이미지 선택**|**Post**|
|:---:|:---:|:---:|
|![](https://i.imgur.com/LqXgcYQ.gif)|![](https://i.imgur.com/l14ZEQU.gif)|![](https://i.imgur.com/8fzFZmz.gif)|

### 🚀 TroubleShooting

#### 이미지가 추가되는 순서
> 이미지를 추가할 때, 이미지를 추가하는 버튼과 같은 `StackView`에 들어가 있어 정상적인 순서로 보여지지 않았습니다. 해당 `StackView`의 `arrangedSubviews`를 불러와 확인해 본 결과 다행히 스택에 들어가 있는 순서대로 인덱스가 할당되는 것을 확인했습니다. `arrangedSubviews`가 리턴해준 배열의 인덱스를 활용해서 리팩토링 한 결과, 이미지의 순서를 정상적으로 보여지게 할 수 있었습니다.

---

#### Description에서 여러 줄을 작성했을 때 DecodingError가 발생하는 문제 
> `Descripton`에 한 줄만 작성했을 경우 `Post`가 잘 되는 반면, 여러 줄을 작성하면 에러가 발생하였습니다. `LLDB`를 이용하여 `json` 데이터로 타입 변경하는 중 "\n"이 추가되지 않는 문제를 발견하였습니다.
따라서 """ 를 이용하여 저장되던 정보를 `Dictionary`를 사용하여 각 `String`을 저장하고, `JSONSerialization`를 사용하여 타입을 변경하였습니다.
```swift
let jsonData = try JSONSerialization.data(withJSONObject: parameterDictionary, options: [])
```

## 🚀 STEP 4

### 구현 내용

|**상품등록**|**이미지 선택**|
|:---:|:---:|
|![](https://i.imgur.com/Vgcz5pC.gif)|![](https://i.imgur.com/l14ZEQU.gif)|
|**Post**|**입력내용 확인**|
|![](https://i.imgur.com/6DpOnqV.gif)|![](https://i.imgur.com/9dN0UaJ.gif)|

### 🚀 TroubleShooting

#### 이미지가 추가되는 순서
> 이미지를 추가할 때, 이미지를 추가하는 버튼과 같은 `StackView`에 들어가 있어 정상적인 순서로 보여지지 않았습니다. 해당 `StackView`의 `arrangedSubviews`를 불러와 확인해 본 결과 다행히 스택에 들어가 있는 순서대로 인덱스가 할당되는 것을 확인했습니다. `arrangedSubviews`가 리턴해준 배열의 인덱스를 활용해서 리팩토링 한 결과, 이미지의 순서를 정상적으로 보여지게 할 수 있었습니다.

---

#### Description에서 여러 줄을 작성했을 때 DecodingError가 발생하는 문제 
> `Descripton`에 한 줄만 작성했을 경우 `Post`가 잘 되는 반면, 여러 줄을 작성하면 에러가 발생하였습니다. `LLDB`를 이용하여 `json` 데이터로 타입 변경하는 중 "\n"이 추가되지 않는 문제를 발견하였습니다.
따라서 """ 를 이용하여 저장되던 정보를 `Dictionary`를 사용하여 각 `String`을 저장하고, `JSONSerialization`를 사용하여 타입을 변경하였습니다.
```swift
let jsonData = try JSONSerialization.data(withJSONObject: parameterDictionary, options: [])
```

---

#### 갑자기 DecodingError가 발생하여 Decoding이 안되는 문제 
> 어떤 문제 때문인지 인지하는 것에도 시간이 꽤 걸릴 정도로 되던 것에서 문제가 발생하여 당황스러웠습니다. 문제는 `Double` 타입의 데이터가 저희가 구현한 이래로 처음 발생된 것이었습니다. `Double`로 들어오는 데이터의 모델 타입을 `Double`로 변경하여 문제를 해결하였습니다.
