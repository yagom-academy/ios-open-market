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
- API서버와 통신해서 데이터를 조회,생성,수정,삭제 작업을 진행했습니다.
- **KeyWords**
  - `URLSession`, `Codable`, `JsonDecoder`, `GCD`
  - `@escaping` `URLSessionDataTask`, `generic function`
  - `Result<Success, Failure>`, `UICollectionView`
  - `multipart/form-data`, `UIImagePickerController`
  - `NotificationCenter`, `NSCache`, `FileManager`

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
│   │   ├── RegisterProductViewController.swift
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
│   │   ├── Data+Extensions.swift
│   │   ├── DetailProduct.swift
│   │   ├── NetworkCommunication.swift
│   │   ├── PostRequestParams.swift
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

<details>
<summary>Step 3 타임라인</summary>
    
- **22/12/01**
    - POST를 보내기위한 multipart/form-data의 구조 파악
    - POST 메서드 구현
- **22/12/02**
    - 상품등록화면 UI 구현
    - UIImagePickerController로 앨범에서 이미지 가져올수있도록 구현
    - 이미지 및 데이터 입력확인 후 정상적인 POST할수있게 구현
- **22/12/03**
    - multipart/form-data타입의 body가 받는 파라미터들을 따로 모델타입으로 구현
- **22/12/04**
    - 이미지용량이 최대 300kb가 넘지 않도록 구현 및 POST완료핸들러 구현
- **22/12/05**
    - 상품등록화면의 데이터를 입력할때 나타나는 키보드를 고려해서 뷰가 키보드에 가리지 않도록 구현 
- **22/12/06**
    - 기존 콜렉션뷰 로딩 indicator를 각각 셀의 이미지로딩 indicator로 변경 및 구현
    - MemoryCache와 DiskCache 영역 둘 다 사용하도록 수정 및 구현
    
</details>

## 📱 실행 화면

step4 구현 후 추가예정입니다.

## 👀 고민한 점

### Step 1

- 서버 API 문서의 데이터 형식을 고려하여 모델 타입을 구현할 때, 서버API에서 요구하는 타입과 일치시켜주지 않아 계속 오류가 발생하였습니다.
    - `GET:Application HealthChekcer`, `GET:상품리스트조회` ,`GET상품 상세 조회` 에서 각각 요구하는 프로퍼티의 타입이 모두 달라서 발생했던 문제였고, 나중엔 해당 부분을 보완하여 구현했을 때 문제가 없었습니다. 

- 통신해야할 네트워킹요소가 3가지이며, 디코딩해야하는 요소는 2가지 였습니다. 따라서, 너무 많은 중복코드가 발생했고 이를 보완하려고 고민했습니다.
    - 메타타입 & 제네릭함수를 공부했고 이를 활용하여 해결하였습니다. 제네릭함수를 활용하였기에 추 후 Step에서 추가적으로 네트워킹&디코딩 할 요소들을 추가되더라도 하나의 함수로 대응이 가능하도록 구현 하였습니다. 


### Step 2

- Modern CollectionView를 활용하여 두가지 레이아웃 활용
    - segmentedControl에 따라 콜렉션뷰를 테이블뷰랑 같은 listLayout 형식, 그리고 gridLayout 형식으로 셀을 꾸며주어야했습니다.
    - 처음에 콜렉션뷰를 List전용으로 하나 Grid 전용으로 하나 2개를 만들어줘야하나 고민했었습니다. 
    - 그런데 좀 더 고민해보니 데이터만 공유하고 셀만 다르게 해줄수 있을거란 생각이 들었습니다. 
    - 데이터를 담당하는 하나의 UICollectionViewCell class를 만들어놓고 List와 Grid 전용 custom셀을 생성해서 class를 적용했습니다. 
    - compositionalLayout을 이용해서 segmentedControl의 index값에 따라 List와 Grid셀을 로드하게 구현할수 있었습니다.

### Step 3

- POST 후, 셀을 업데이트 시켜주는 방법에 대한 고민
    - ResisterProductViewController에서 사용자가 입력한 데이터를 POST 후, ViewController의 Cell에서 어떤 방법으로 등록된 상품이 표시되도록 업데이트 해줄 것인지 고민하였습니다. 
    - 고민해보니 ResisterProductViewController에서 dismiss 메서드를 통해 ViewController로 돌아오면 viewWillAppear(:) 메서드가 실행되었고 해당 메서드가 호출 될 시점에 상품 리스트 데이터를 GET해오는 것으로 셀을 업데이트 해줄 수 있었습니다.

- API 문서를 해석하며 swift에 어떻게 구현할지에 대한 고민
    1. 문서를 읽으며, Content-Type, Mime-Type, multipart/formdata, application/json, application/x-www-form-urlencoded, httpMethod 등 생소한 단어들이 많았습니다.
    2. MDN 및 공식문서, 기타 블로그 등을 참고하여 해당 용어의 의미를 찾아보려고 노력했습니다.
    3. 해당 용어에 대해 이해한 후에는 PostMan을 이용하여 데이터를 어떻게 주고 받는지 테스트를 시도해보았습니다.
    4. API 통신으로 데이터를 어떻게 주고 받는지 이해한 후 오픈소스나 강의영상, 등 갖가지 매체를 통해 swift 환경에서 어떻게 적용하고 구현해야할지 찾아보았습니다.

- 키보드가 올라올때, 화면을 보여주는 방식에 대한 고민
    1. 사용자가 데이터를 입력하려고 할때 키보드가 올라오게되는데 키보드 위의 화면은 어디로 어떻게 사용자에게 보여줄지 고민했습니다.
    2. textField부분은 4가지가 모여있고 textView는 하나만 구성되어 있기 때문에 textField를 터치했을경우랑 textView를 터치했을경우 두가지로 구분했습니다.
    3. textField를 터치했을 경우 입력할 정보가 많기 때문에 입력란에 신경을 쓸 수 있도록 y축을 이동시켰습니다.
    4. textView를 터치했을 경우 키보드가 정보를 가리지 않게 y축을 이동했습니다.

|초기화면|텍스트필드 입력|텍스트뷰 입력|
|:--:|:--:|:--:|
![](https://i.imgur.com/qNtIytz.png)|![](https://i.imgur.com/3k4DaAV.png)|![](https://i.imgur.com/GPKSbfA.png)|
    
</details>

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

통신해야할 네트워킹요소가 3가지(`GET:Application HealthChekcer`, `GET:상품리스트조회` ,`GET상품 상세 조회`)이며, 디코딩해야하는 요소는 2가지 였습니다.  
따라서, 통신요소에 따라서 너무 많은 중복코드가 발생했고 이를 보완하려고 고민했습니다. 
하지만, JSONDecoder의 .decode 메서드는 `Decodable` 프로토콜을 준수하는 `타입자체`를 파라미터값으로 전달해주어야만 했습니다.  
우리는 `타입자체`를 어떻게 함수의 `Placeholder`로 활용할 지 고민하였습니다.  
결과적으로 제네릭과 메타타입을 공부하여 타입자체(메타타입)을 파라미터값과 Placehorder로 전달하여 이를 해결했습니다. 

```swift
JSONDecoder().decode(type: Decodable을 준수하는 타입, from: data)
```
</details>

### STEP2

<details>
<summary>NSCache의 한계</summary>
    
처음에 NSCache를 이용해서 각 셀의 이미지를 구현을했었습니다.  
그런데 앱을 종료했다 키면 저장된 캐쉬데이터들이 사라져서 실행할때마다 모든 이미지들이 다 보이기까지 시간이 걸려서 비록 긴시간은 아니지만 조금이라도 기다려야하는 불편한 상황을 경험해야했습니다.  
NSCache는 Memory Cache영역에 저장되기때문에 발생하게 된 문제인데 이를 해결하기 위해 FileManager로 Disk Cache영역에 저장하는 방식으로 바꾸었습니다. Disk Cache 영역은 앱을 종료했다 켜도 지워지지않는 영역이기때문에 처음 의도한대로 구현할수있었습니다. 
    
</details>

<details>
<summary>네트워크 통신으로서 Data(contentsOf:)의 한계점 </summary>
    
- 네트워크 통신으로 이미지를 가져올 때, 처음에 Data(contentsOf:)를 활용하였고 화면이 스크롤되는 속도와 성능이 매우 저하되었습니다.
- 알고보니 이 메서드는 동기적으로 동작하는 메서드였고, 스크롤을 하게되면 현재 작업중인 모든 작업을 해당 작업을 수행하는 동안 멈추게 되고 심할 경우 앱이 종료될 수 있는 위험성이 잠재되어 있는 코드였습니다.  
따라서, 비동기로 동작하는 URLSession을 활용하도록 수정해주었고 결과적으로 속도와 성능이 다시 정상적으로 돌아오게 되었습니다.
- 아래는 공식문서에서 권장하는 Data(contentsOf:) 메서드의 적합한 활용방법입니다.

![](https://i.imgur.com/b40E8mW.png)
</details>

### STEP3

<details>
<summary>multipart/form-data 구조 파악</summary>
    
HTTP Request 구조에서 Content-Type중 multipart/form-data의 구조를 처음에 파악하기가 어려웠습니다.  
가장 기본적이고 많이 쓰이는 application/x-www-form-urlencoded, application/json Content-Type과 무엇이 다른지 하나씩 비교해보면서 학습했습니다.  
구조를 완전히 이해하는데 2-3일이 걸려 프로젝트에 착수하는데 시간이 많이 부족했었습니다.  
HTTP Request 구조를 처음 접해보았고 multipart/form-data란 친구를 만났을때 사용 예시를 보고 당황했습니다.  
이걸 내가 이해할수있을까 걱정되었지만 이해하려고 노력하고 공부하다보면 언젠간 결국 해내게 되는구나라는 깨달음을 얻게 되었습니다.  

</details>

<details>
<summary>셀의 재사용과 이미지 관련 문제 해결</summary>

- 컬렉션뷰의 셀이 예를 들어서 100개가 있다고 가정했을때, 앱을 처음 실행했을때 셀의 이미지 로딩이 덜 된 상태에서 밑으로 스크롤을 내리다가 15번셀에 15라는 이미지가 들어와야하는데 5,10이라는 엉뚱한 이미지가 들어왔다가 정상적인 이미지로 변경되는 기이한 현상을 목격했습니다.
- 왜 이런일이 발생하게 된건지 알아본 결과, 각각의 셀마다 이미지를 비동기로 요청하는데 밑으로 스크롤을 내려서 재사용되는 셀로 전환하게 된다면 비동기요청이 완료되는 시점에 이미지를 보여줄때 재사용된 셀로 이미지를 보여주게되어서 이런 현상이 일어나게 된 것이라 생각했습니다.
- 왜 이런 일이 발생하게 되었는지에 대한 답을 알아냈으니 어떻게 고치야 하는지 고민했습니다.  
    생각보다 고치는 방법은 간단했습니다.
- URLSessionDataTask 인스턴스를 resume() 해서 실행하듯이, 셀이 재사용될때 cancel()해서 비동기작업을 멈추게 하는 식으로 구현해주었다.

</details>

<details>
<summary>이미지를 캐싱하는 여러 방법</summary>

1. 기존에는 메모리캐시와 디스크캐시영역 중 어느걸 사용할지 고민해서 디스크캐시영역을 선택하여 구현했습니다.
2. 이후에 메모리캐시와 디스크캐시 둘 다 동시에 구현할 수 있다고 듣게 되어서 왜 처음에 둘 다 구현할 생각을 하지 못했을까 하는 깨우침을 얻었습니다. 
3. 어떻게 구현하면 좋을지 고민 해 본 결과, 앱을 실행 할 때 이와같은 순서로 작동할 수 있게 구성했습니다.
    (1) 메모리캐쉬에 데이터를 가져온다 없다면 2번으로 이동
    (2) 디스크캐쉬에 데이터를 가져온다 없다면 3번으로 이동, 있다면 추가로 메모리캐쉬에 저장
    (3) 디스크캐쉬에 해당하는 데이터가 없다면 API통신으로 데이터를 받아온다. 그리고 디스크캐쉬와 메모리캐쉬에 저장
    
|앱 처음 실행했을때|앱 다시 실행했을때|
|:--:|:--:|
|![networkandmemory](https://user-images.githubusercontent.com/96489602/205856689-dbb21584-19d7-4cae-9e57-8ed76d160127.gif)|![diskandMemory](https://user-images.githubusercontent.com/96489602/205856739-4f8c44cf-fe36-4112-b871-8aa32f94628f.gif)|
    
</details>

## 🔗 참고 링크

[Apple Developer Documentation - URLSession](https://developer.apple.com/documentation/foundation/urlsession)  
[부스트코스 - IOS App Programming](https://www.boostcourse.org/mo326/lecture/16863?isDesc=false)    
[야곰 닷넷 - 동시성 프로그래밍](https://yagom.net/courses/%eb%8f%99%ec%8b%9c%ec%84%b1-%ed%94%84%eb%a1%9c%ea%b7%b8%eb%9e%98%eb%b0%8d-concurrency-programming/)  
[Swift 공식문서 - Closures](https://docs.swift.org/swift-book/LanguageGuide/Closures.html)
[블로그 레나참나 - HTTP multipart/form-data 이해하기](https://lena-chamna.netlify.app/post/http_multipart_form-data/)
[YouTube - How to send Images in Post Requests w/ Swift (Multipart Form Data)](https://www.youtube.com/watch?v=xhZiKdb68SM&t=14s)
[YouTube - Image upload example using urlsession in swift ios](https://www.youtube.com/watch?v=qhoL1lp4kiY)
[Github Opensource: davBeck - MultipartForm](https://github.com/davbeck/MultipartForm)
[Apple Developer Documentation - UIImagePickerController](https://developer.apple.com/documentation/uikit/uiimagepickercontroller/)

---

[🔝 맨 위로 이동하기](#-오픈마켓-프로젝트)
