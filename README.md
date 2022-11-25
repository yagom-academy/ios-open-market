# 🧑‍🌾 오픈마켓 프로젝트

## 📖 목차
1. [소개](#-소개)
2. [Tree](#-tree)
3. [타임라인](#-타임라인)
4. [실행 화면](#-실행-화면)
5. [고민한 점](#-고민한-점)
6. [트러블 슈팅](#-트러블-슈팅)
7. [참고 링크](#-참고-링크)

## 🌱 소개

`Mangdi`와 `woong`이 만든 오픈마켓 앱입니다.
- API서버와 통신해서 데이터를 주고받습니다.
- **KeyWords**
  - `URL Session`, `Codable`, `JsonDecoder`, `GCD`
  - `@escaping` `dataTask(with:completionHandler:)` 
  - `generic function` , `Result<Success, Failure>`
  - `UICollectionView(step2추가작성)`

## 💻 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-13.4.1-blue)]()

## 🧑🏻‍💻 팀원
|<img src="https://avatars.githubusercontent.com/u/49121469" width=160>|<img src = "https://avatars.githubusercontent.com/u/96489602?v=4" width=160>|
|:--:|:--:|
|[Mangdi](https://github.com/MangDi-L)|[woong](https://github.com/iOS-Woong)|

## 🌲 Tree

```
.
├── OpenMarket
│   ├── AppDelegate.swift
│   ├── Controller
│   │   └── ViewController.swift
│   ├── Info.plist
│   ├── Model
│   │   ├── APIError.swift.swift
│   │   ├── ApiUrl.swift.swift
│   │   ├── Assets.xcassets
│   │   │   ├── AccentColor.colorset
│   │   │   │   └── Contents.json
│   │   │   ├── AppIcon.appiconset
│   │   │   │   └── Contents.json
│   │   │   ├── Contents.json
│   │   │   └── step1_testdata.dataset
│   │   │       ├── Contents.json
│   │   │       └── step1_testdata.json
│   │   ├── CustomCollectionViewCell.swift
│   │   ├── DetailProduct.swift
│   │   ├── NetworkCommunication.swift
│   │   ├── SearchListProducts.swift
│   │   └── TestJsonProducts.swift
│   ├── SceneDelegate.swift
│   └── View
│       ├── Base.lproj
│       │   ├── LaunchScreen.storyboard
│       │   └── Main.storyboard
│       ├── CustomCollectionViewGridCell.xib
│       └── CustomCollectionViewListCell.xib
```
 
## ⏰ 타임라인

<details>
<summary>Step 1 타임라인</summary>
    
- **22/11/15**
    - 코코아팟 설치 및 SwiftLint 라이브러리 적용 후 warning이 뜨지않도록 swiftLint rule 수정
    - Asset에 저장된 json파일 읽기위해 모델타입 구현
    - json파일 디코딩 테스트코드 작성

- **22/11/16**
    - API서버에서 불러올 데이터에 맞게 모델타입 구현
    - 네트워크를 통신을 관리하는 타입 구현 
    
- **22/11/19**
    - API서버에서 받아온 데이터를 completionHandler클로저의 인자로 Result Type 전달하도록 구현
    - API통신 에러 타입 구현

</details>

<details>
<summary>Step 2 타임라인</summary>
    
- **22/11/23**
    - UICollectionView 구현
    - customListCell 구현 및 compositionalLayout 적용
    - segmentedControl 스타일 적용
    - customGridCell 구현 및 segmentedControl에 따라 컬렉션뷰 레이아웃이 List와 Grid로변환하게 구현
- **22/11/24**
    - NSCache로 이미지 저장 및 불러오기 구현
    - 기존 NSCache 방식에서 -> FileManager로 이미지 저장 및 불러오기 구현 
    - 이미지 url을 dataTask로 처리하도록 구현
    - 컬렉션뷰 로딩할동안 나타나는 indicator 구현
    
</details>

## 📱 실행 화면
|처음설치|종료후다시실행|
|:--:|:--:|
|![Simulator Screen Recording - iPhone 11 - 2022-11-25 at 00 57 15](https://user-images.githubusercontent.com/49121469/203825802-c1a9679c-89b2-4506-917c-05cb88236e39.gif)|![Simulator Screen Recording - iPhone 11 - 2022-11-25 at 00 31 56](https://user-images.githubusercontent.com/49121469/203821039-8767d88d-eedb-492c-ab84-47fb8d534190.gif)|
 
## 👀 고민한 점

### Step 1

- 서버 API 문서의 데이터 형식을 고려하여 모델 타입을 구현할 때, 서버API에서 요구하는 타입과 일치시켜주지 않아 계속 오류가 발생하였습니다.
    - `GET:Application HealthChekcer`, `GET:상품리스트조회` ,`GET상품 상세 조회` 에서 각각 요구하는 프로퍼티의 타입이 모두 달라서 발생했던 문제였고, 나중엔 해당 부분을 보완하여 구현했을 때 문제가 없었습니다. 

- 통신해야할 네트워킹요소가 3가지이며, 디코딩해야하는 요소는 2가지 였습니다. 따라서, 너무 많은 중복코드가 발생했고 이를 보완하려고 고민했습니다.
    - 메타타입 & 제네릭함수를 공부했고 이를 활용하여 해결하였습니다. 제네릭함수를 활용하였기에 추 후 Step에서 추가적으로 네트워킹&디코딩 할 요소들을 추가되더라도 하나의 함수로 대응이 가능하도록 구현 하였습니다. 


### Step 2

- Modern CollectionView를 활용하여 두가지 레이아웃 활용
    - segmentedControl에 따라 콜렉션뷰를 테이블뷰랑 같은 listLayout 형식, 그리고 gridLayout 형식으로 셀을 꾸며주어야했습니다. 처음에 콜렉션뷰를 List전용으로 하나 Grid 전용으로 하나 2개를 만들어줘야하나 고민했었습니다. 그런데 좀 더 고민해보니 데이터만 공유하고 셀만 다르게 해줄수 있을거란 생각이 들었습니다. 데이터를 담당하는 하나의 UICollectionViewCell class를 만들어놓고 List와 Grid 전용 custom셀을 생성해서 class를 적용했습니다. compositionalLayout을 이용해서 segmentedControl의 index값에 따라 List와 Grid셀을 로드하게 구현할수 있었습니다.

## ❓ 트러블 슈팅

### Step 1

<details>
    <summary>parsing 모델 타입 구현</summary>

Asset에 저장된 json파일을 파싱하는 타입과 API서버와 통신하여 가져오는 json을 파싱하는 타입을 구현할때 오타가 있었습니다. 
단위 테스트를 통해 오타가 있었다는것을 뒤늦게 확인할수있었습니다.
json파일에 매칭해야할 자료형이 많을수록 오타가 나올 확률이 높을것이란 생각이 들었습니다. 
[json을 swift모델로 바꿔주는사이트](https://app.quicktype.io/)
이 사이트를 이용해서 json파일을 swift 모델로 바꾸어서 사용했습니다.
시간도 절약하고 오타를 유발할일이 없기때문에 유용하게 이용했습니다.
    
</details>

<details>
<summary>Metatype & Generic함수를 활용하여 중복되는 코드 해결 </summary>

통신해야할 네트워킹요소가 3가지(`GET:Application HealthChekcer`, `GET:상품리스트조회` ,`GET상품 상세 조회`)이며, 디코딩해야하는 요소는 2가지 였습니다. 따라서, 통신요소에 따라서 너무 많은 중복코드가 발생했고 이를 보완하려고 고민했습니다. 
하지만, JSONDecoder의 .decode 메서드는 `Decodable` 프로토콜을 준수하는 `타입자체`를 파라미터값으로 전달해주어야만 했습니다. 우리는 `타입자체`를 어떻게 함수의 `Placeholder`로 활용할 지 고민하였습니다.
결과적으로 제네릭과 메타타입을 공부하여 타입자체(메타타입)을 파라미터값과 Placehorder로 전달하여 이를 해결했습니다. 
```swift
JSONDecoder().decode(type: Decodable을 준수하는 타입, from: data)
```
</details>

### STEP2

<details>
<summary>NSCache의 한계</summary>
    
처음에 NSCache를 이용해서 각 셀의 이미지를 구현을했었습니다. 그런데 앱을 종료했다 키면 저장된 캐쉬데이터들이 사라져서 실행할때마다 모든 이미지들이 다 보이기까지 시간이 걸려서 비록 긴시간은 아니지만 조금이라도 기다려야하는 불편한 상황을 경험해야했습니다. NSCache는 Memory Cache영역에 저장되기때문에 발생하게 된 문제인데 이를 해결하기 위해 FileManager로 Disk Cache영역에 저장하는 방식으로 바꾸었습니다. Disk Cache 영역은 앱을 종료했다 켜도 지워지지않는 영역이기때문에 처음 의도한대로 구현할수있었습니다.   

</details>

<details>
<summary>네트워크 통신으로서 Data(contentsOf:)의 한계점 </summary>
    
- 네트워크 통신으로 이미지를 가져올 때, 처음에 Data(contentsOf:)를 활용하였고 화면이 스크롤되는 속도와 성능이 매우 저하되었습니다.
    - 알고보니 이 메서드는 동기적으로 동작하는 메서드였고, 스크롤을 하게되면 현재 작업중인 모든 작업을 해당 작업을 수행하는 동안 멈추게 되고 심할 경우 앱이 종료될 수 있는 위험성이 잠재되어 있는 코드였습니다. 따라서, 비동기로 동작하는 URLSession을 활용하도록 수정해주었고 결과적으로 속도와 성능이 다시 정상적으로 돌아오게 되었습니다. 
    - 아래는 공식문서에서 권장하는 Data(contentsOf:) 메서드의 적합한 활용방법입니다.
    - 이 동기식 이니셜라이저를 사용하여 네트워크 기반 URL을 요청하지 마십시오. 네트워크 기반 URL의 경우, 이 방법은 느린 네트워크에서 수십 초 동안 현재 스레드를 차단하여 사용자 환경이 좋지 않을 수 있으며, iOS에서는 앱이 종료될 수 있습니다.대신 파일이 아닌 URL의 경우 URL 세션 클래스의 dataTask(with:completionHandler:) 메서드를 사용해 보십시오. 예는 웹 사이트 데이터를 메모리로 가져오는 것을 참조하십시오.

![](https://i.imgur.com/b40E8mW.png)
</details>



## 🔗 참고 링크

[Apple Developer Documentation - URLSession](https://developer.apple.com/documentation/foundation/urlsession)  
[부스트코스 - IOS App Programming](https://www.boostcourse.org/mo326/lecture/16863?isDesc=false)    
[야곰 닷넷 - 동시성 프로그래밍](https://yagom.net/courses/%eb%8f%99%ec%8b%9c%ec%84%b1-%ed%94%84%eb%a1%9c%ea%b7%b8%eb%9e%98%eb%b0%8d-concurrency-programming/)  
[Swift 공식문서 - Closures](https://docs.swift.org/swift-book/LanguageGuide/Closures.html)

---

[🔝 맨 위로 이동하기](#-오픈마켓-프로젝트)
