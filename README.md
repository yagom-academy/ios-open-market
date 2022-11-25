
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
│   │   ├── Assets.xcassets
│   │   │   ├── AccentColor.colorset
│   │   │   │   └── Contents.json
│   │   │   ├── AppIcon.appiconset
│   │   │   │   └── Contents.json
│   │   │   ├── Contents.json
│   │   │   └── step1_testdata.dataset
│   │   │       ├── Contents.json
│   │   │       └── step1_testdata.json
│   │   ├── DetailProduct.swift
│   │   ├── NetworkCommunication.swift
│   │   ├── SearchListProducts.swift
│   │   └── TestJsonProducts.swift
│   ├── SceneDelegate.swift
│   └── View
│       └── Base.lproj
│           ├── LaunchScreen.storyboard
│           └── Main.storyboard
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

</details>

## 📱 실행 화면
- 추가예정
 
## 👀 고민한 점

### Step 1

- 서버 API 문서의 데이터 형식을 고려하여 모델 타입을 구현할 때, 서버API에서 요구하는 타입과 일치시켜주지 않아 계속 오류가 발생하였습니다.
    - `GET:Application HealthChekcer`, `GET:상품리스트조회` ,`GET상품 상세 조회` 에서 각각 요구하는 프로퍼티의 타입이 모두 달라서 발생했던 문제였고, 나중엔 해당 부분을 보완하여 구현했을 때 문제가 없었습니다. 

- 통신해야할 네트워킹요소가 3가지이며, 디코딩해야하는 요소는 2가지 였습니다. 따라서, 너무 많은 중복코드가 발생했고 이를 보완하려고 고민했습니다.
    - 메타타입 & 제네릭함수를 공부했고 이를 활용하여 해결하였습니다. 제네릭함수를 활용하였기에 추 후 Step에서 추가적으로 네트워킹&디코딩 할 요소들을 추가되더라도 하나의 함수로 대응이 가능하도록 구현 하였습니다. 

- @escaping 추가적으로 작성
- Result<Success, Failure> 추가적으로 작성

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

## 🔗 참고 링크

[Apple Developer Documentation - URLSession](https://developer.apple.com/documentation/foundation/urlsession)  
[부스트코스 - IOS App Programming](https://www.boostcourse.org/mo326/lecture/16863?isDesc=false)    
[야곰 닷넷 - 동시성 프로그래밍](https://yagom.net/courses/%eb%8f%99%ec%8b%9c%ec%84%b1-%ed%94%84%eb%a1%9c%ea%b7%b8%eb%9e%98%eb%b0%8d-concurrency-programming/)  
[Swift 공식문서 - Closures](https://docs.swift.org/swift-book/LanguageGuide/Closures.html)

---

[🔝 맨 위로 이동하기](#-오픈마켓-프로젝트)
