# 오픈마켓 

## 🙋🏻‍♂️ 프로젝트 소개
오픈마켓 어플 입니다 

> 프로젝트 기간: 2022-07-11 ~ 2022-08-05</br>
> 팀원: [백곰](https://github.com/Baek-Gom-95), [브래드](https://github.com/bradheo65) </br>
리뷰어: [Corn](https://github.com/protocorn93)</br>
그라운드롤: [GroundRule](https://github.com/Jeon-Minsu/ios-open-market/tree/step01/Docs/GroundRule.md)

## 📑 목차

- [🧑🏻‍💻🧑🏻‍💻 개발자 소개](#-개발자-소개)
- [📱 동작 화면](#-동작-화면)
- [💡 키워드](#-키워드)
- [🤔 핵심경험](#-핵심경험)
- [📚 참고문서](#-참고문서)
- [📝 기능설명](#-기능설명)
- [🚀 TroubleShooting](#-TroubleShooting)
    - [🚀 STEP 1](#-STEP-1)
    - [🚀 STEP 2](#-STEP-2)
    - [🚀 STEP 3](#-STEP-3)

- STEP 상세 내용
    - [1️⃣ STEP 1](https://github.com/bradheo65/ios-open-market/blob/Step1/Docs/Step01.md)
    - [2️⃣ STEP 2](https://github.com/bradheo65/ios-open-market/blob/Step2/Docs/Step02.md)
    - [3️⃣ STEP 3](https://github.com/bradheo65/ios-open-market/blob/Step2/Docs/Step03.md)
## 🧑🏻‍💻🧑🏻‍💻 개발자 소개

|||
|:---:|:---:|
|<image src = "https://user-images.githubusercontent.com/45350356/174251611-46adf61c-93fa-42a0-815b-2c998af1c258.png" width="250" height="250">| <image src = "https://i.imgur.com/c17eEk8.jpg" width="250" height="250">
|[브래드](https://github.com/bradheo65)|[백곰](https://github.com/Baek-Gom-95)|  
    
## 📱 동작 화면

### 형태별 동작 화면
|LIST|GRID|
|:---:|:---:|
|<image src = "https://user-images.githubusercontent.com/45350356/180375191-93a7e49e-acf9-45e3-a4cc-619ca86affd1.gif" width="250" height="500">| <image src = "https://user-images.githubusercontent.com/45350356/180376138-1d97f86a-92b0-4f10-86a7-9c7e5d9e6165.gif" width="250" height="500">


## 💡 키워드
- HTTP
- URLSession
- URLSession Unit Test
- AutoLayout
- URLSession GET
- CollectionView
- Modern CollectionView
- Cache
- API
- UIImagePicker
- ResizeImage
    
## 🤔 핵심경험
- [x] 파싱한 JSON 데이터와 매핑할 모델 설계
- [x] URL Session을 활용한 서버와의 통신
- [x] CodingKeys 프로토콜의 활용
- [x] 네트워크 상황과 무관한 네트워킹 데이터 타입의 단위 테스트(Unit Test)
- [x] Safe Area을 고려한 오토 레이아웃 구현
- [x] Collection View의 활용
- [x] Mordern Collection View 활용
- [x] multipart/form-data의 구조 파악
- [x] URLSession을 활용한 multipart/form-data 요청 전송
- [x] 사용자 친화적인 UI/UX 구현 (적절한 입력 컴포넌트 사용, 알맞은 키보드 타입 지정)
- [x] 상속 혹은 프로토콜 기본구현을 통해 (수정/등록 과정의) 공통기능 구현


## 📚 참고문서
- URLSession
    - Fetching Website Data into Memory
- UICollectionView
    - Modern cell configuration
    - Lists in UICollectionView
    - Implementing Modern Collection Views
- API
    - Yagom Academy iOS - OpenMarket API


## 📝 기능설명
### `Mock`
 - MockURLSession: 네트워크가 연결되지 않은 상태에서 Unit Test를 진행할때 사용할 코드 입니다 
### `Extension`
 - String+Extension
    - func strikeThrough(): DisCountPrice가 있으면 Label에 CancelLine 을 만들어줄 함수입니다
 - UIImage+Extension
    - func logImageSizeInKB(): 이미지의 크기를 KB단위로 계산하여 반환해주는 함수입니다
 - UIImageView + Extension
    - func setImageURL(): 이미지를 캐싱해줍니다
### `Enum`
 - URLCollection: URL주소를 Enum 타입으로 만들어주었습니다
 - CustomError: Error 타입을 모아놓은곳 입니다
### `View`
 - GridCollectionViewCell: GridCollectionViewCell 의 뷰를 그려줍니다
 - ListCollectionViewCell: ListCollectionViewCell 의 뷰를 그려줍니다
 - AddProductCollectionViewCell: 상품등록 화면 뷰를 그려줍니다
 - PaddingLabel: Label에 Padding 기능을 구현하기 위한 코드입니다
### `Model` 
 - ProductListResponse: API 주소에서 가져온 Json 타입의 상품 리스트 데이터들을   담을 Model 구조체 입니다
 - Product: API 주소에서 가져온 Json 타입의 상품의 상세 데이터들을 담을 Model 구   조체 입니다
 - ImageCacheManager: 싱글톤으로 이미지캐시를 처리하기 위한 클래스입니다
 - JsonParser 
    - dataTask(): 매개변수로 받은 URL 주소를 GET 방식으로 서버와 데이터를 주고받        은후 Escaping Closure로 결과값을 반환해 줍니다.
### `ViewController`
 - MainController: SegmentSwitch 를 컨트롤 하고 세그먼트 Select 에 따라      List 와 Grid 화면을 보여주는 코드 입니다.
 - ListViewController: UICollectionView List 화면을 구현하는 코드 입니다 
 - GridViewController: UICollectionView Grid 화면을 구현하는 코드 입니다
 - AddProductViewController: 상품등록 화면을 구현하는 코드 입니다.

    
## 🚀 TroubleShooting
    
### 🚀 STEP 1

#### T1. HTTP method `POST` 테스트
`POST` method 를 통해 서버에 테스트 데이터를 API문서를 보면서 필요한 정보에 대해 Json 형식으로 `POST`를 해주었지만, 계속해서 `400` 에러가 발생되었습니다. 알고 보니 해당 서버 접근에 필요한 `id` 와 `password`가 아직 할당 받지 못해서 발생된 에러였습니다.    

#### T2. 네트워크가 연결되지 않을 때 네트워크 `Unit` 테스트
네트워크 Unit 테스트 목적: 인터넷에 의존하기 떄문에 테스트를 신뢰할 수 없어서, 실제 서버와 통신하면 의도치 않은 결과 도출될 수 있음. 실제 서버에 영향이 갈 수 도 있어 테스트가 필수적이다. 하지만 테스트 코드 직접 작성하고 나서 실행 시 결과 값이 클로저의 데이터값을 확인하는 것이기 때문에 비동기적으로 실행되서 무조건 `SUCCESS`로 되어서 비동기 테스트에 대한 지식이 필요하다.
    
### 🚀 STEP 2

#### T1. UI 생성 시 스토리보드 vs 코드
이번 프로젝트에서 스토리보드를 활용해 UI를 설계해보았는데, 코드로 설계했을 때와 많이 달랐습니다. 개인적으로 느끼기에는 큰 틀을 그릴때는 스토리보드가 빠르고 쉽게 가능 했지만 막상 세세한 설정을 해야할 상황에서는 코드로 하는 게 좋다고 느껴졌습니다. 특히 이번프로젝트에서 오토레아웃에 대한 고민을 많이 해봤을때 스토리보드로 하는 것보단 코드로 했으면 어떗을까 생각이 들었습니다. 다음 UI 설계시 코드로 하는 방향에 대해서 좀 더 생각해 보는게 좋을 것 같습니다.

#### T2. CollectionViewCell 재사용 문제
API에서 데이터를 적게 가져올 때는 문제가 없었지만, 데이터의 갯수가 30~40개가 넘어가게 되면 스크롤 시 해당 라벨에 대한 정보가 섞인 현상을 볼 수 있었습니다. 해결 방법에 대해서 생각해보았는데 셀 재사용시 호출되는 메소드 `prepareForReuse()`를 통해 해결해보긴 했지만 [애플에서는 `prepareForReuse()`에서 cell의 item을 초기화해주거나 변경시켜주는 기능 시 사용을 지양한다고 나와 있어 사용을 다른 생각을 해보았습니다.](https://developer.apple.com/documentation/uikit/uicollectionreusableview/1620141-prepareforreuse) 
아래 구문에 해당 내용이 나와 있었습니다.
>Override this method in your subclass to reset properties to their default values and make the view ready to use again. Don’t use this method to assign any new data to the view; that’s the responsibility of your data source object.
    
그래서 cell이 생성되는 메소드 `func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell`에서 각 라벨들의 데이터들을 초기화시켜주고 재 할당해주는 방식으로 코드를 작성해보니 원하는대로 동작하게 되었습니다. 무조건 `prepareForReuse()`사용해서 재사용성에 대한 고민을 해결했을텐데 생각의 전환이 되는 계기가 되었습니다.

#### T3. 데이터 로드 시 로딩 창 구현
요구사항에 데이터가 로드할 떄까지 별도로 로딩 창을 띄어주는 뷰를 추가해야 했었습니다. 그래서 `viewDidLoad` 해당 실행하는 함수를 넣어 실행해보니 `viewDidLoad` 메소드 내에 선언되어 있는 메소드들이 다 종료가 되어야지 첫 view가 보여주어서 별도로 로딩 창이 나오지 않았습니다. view 라이프 사이클에 대해 생각해 보았고 `viewDidAppear`에서 컬렉션뷰에 데이터를 넣어주는 메소드를 넣어주고 나머지는 `viewDidLoad`를 넣어줘서 로딩 창을 구현했고 API에서 데이터를 가져오는 시점에서 애니메이션을 종료시켜주고 컬렉션뷰를 `reloadData()` 메소드를 넣어주어 컬렉션뷰를 다시 그려주는 로직으로 구현해 해결했습니다.
    
#### T4. Grid CollectionView Column 2Line 으로 만들기 및 Cell 간격 띄우기
Grid 형태의 CollectionView 에서 2열형태 및 Cell 간격을 띄워주는 Layout이 요구사항이었습니다 처음엔 스토리보드로 하려고 했지만 Attributes inspector 에도 설정하는곳이 없어 UICollectionVIewDelegateFlowLayout 에 있는 Cell의 크기를 설정해주고 Cell사이의 Spacing 을 설정해주는 코드로 해당 요구사항을 구현했습니다.
    

### 🚀 STEP 3

#### T1. HTTP POST 시 서버 에러 1 - JSON

#####  에러 메시지
```shell
"code":400,"message":"JSON parse error: Cannot construct instance of `edu.yagom.dev.ecommerce.rest.product.params.ProductCreationParams` (although at least one Creator exists): no int/Int-argument constructor/factory method to deserialize from Number value (154); nested exception is com.fasterxml.jackson.databind.exc.MismatchedInputException: Cannot construct instance of `edu.yagom.dev.ecommerce.rest.product.params.ProductCreationParams` (although at least one Creator exists): no int/Int-argument constructor/factory method to deserialize from Number value (154)\n at [Source: (PushbackInputStream); line: 1, column: 1]"
```

##### 문제점
multipart/form-data로 POST 시 위와 같은 에러가 발생 했습니다.
에러 메시지에 중요한 부분은 `no int/Int-argument constructor/factory method to deserialize from Number value (154)\n at [Source: (PushbackInputStream); line: 1, column: 1]"` 으로 보여집니다.
해석하자면 "넘버 값(154)에 대한 디이니셜라이저 메소드가 없다?" 라는 에러 메시지 인 것 같은데 어떻게 해결하면 좋을까 생각해보았습니다.


#### 해결방법
일단 코드에서 "154"라는 데이터를 보내지 않고 있습니다.
그래서  multipart/form-data 구조에서 실제 데이터값이 들어가 있는 Body 를 확인해 보았습니다.
![image](https://user-images.githubusercontent.com/45350356/181588628-e28df7ee-1041-4383-8aef-4ee35dc4d6d1.png)
위의 빨간 네모칸에 154 bytes가 value로 들어가 있는 것처럼 보이는데 Body 데이터를 만들어주는 부분의 코드를 확인 해보니
![image](https://user-images.githubusercontent.com/45350356/181590932-b9e0481a-dde6-440b-b92b-18776ce29239.png)
해당 `value` 타입 값은 `Data`인대, Body의 `value`값을 JSON 형식으로 보내야 하는데 Data형식으로 보내고 있어 앞서 발생한 에러가 나온 것으로 판단되었습니다.
그래서 JSON형식은 텍스트 형식으로 되어 있어 해당 `value`값을 String형식으로 타입캐스팅? 변환을 해주었습니다.
![image](https://user-images.githubusercontent.com/45350356/181591350-c14b833f-fb3f-4a17-9a58-b8b8cf8ac4d0.png)
위의 코드처럼
```swift
String(data: , encoding: .utf8)
```
형태로 String타입으로 만들어 주었는데, 강제로 한 느낌이 강해서 타입캐스팅 하는 부분이 수정이 필요할 것으로 보입니다.
재 실행 결과...
![image](https://user-images.githubusercontent.com/45350356/181591840-6d83b13e-a32d-4187-94a9-b51481a64b43.png)
위의 결과처럼 텍스트형식으로 JSON 데이터가 잘 들어간 것을 알 수 있습니다.

#### T2. HTTP POST 시 서버 에러 2 - Image
##### 에러 메시지
```shell
"code":400,"message":"Failed to parse multipart servlet request; nested exception is java.io.IOException: org.apache.tomcat.util.http.fileupload.FileUploadException: Header section has more than 10240 bytes (maybe it is not properly terminated)"
```
#### 문제점
에러 메시지를 보니 `Header section has more than 10240 bytes`이 부분이 핵심인 것으로 보입니다. 해석하자면 "헤더 섹션이 10240바이트를 초과합니다." 라는 내용인대, "처음엔 request의 Header 데이터를 너무 많이 넣었나" 라고 생각 했었습니다. 하지만 Header에 `Content-Type`, `identifier`만 넣어주기 때문에 아닌 것 같고 fileupload의 힌트로 image 데이터가 문제로 보여 집니다.

#### 해결방법
다행스럽게도 동일한 고민에 답변을 [stackoverflow](https://stackoverflow.com/questions/54437636/header-section-has-more-than-10240-bytes-maybe-it-is-not-properly-terminated)에서 확인할 수 있었습니다.

위의 내용 중  "I ran into this same issue and it turns out JIRA (or Java) requires \r\n as new line character. After I changed \n to \r\n my requests went through without problem."문장을 해석 해보니 "`\r\n`를 한번더 확인해라" 인 것 같아
데이터 넣는 부분의 맨 끝에 `\r\n`을 추가 해주었더니 정상적으로 `POST`가 되었습니다.
![image](https://user-images.githubusercontent.com/45350356/181594117-c724f26f-b46b-4182-bb9e-fa650a44ae31.png)
아직 정확하게 이해한건 아니지만, 구조가 처음 작성한 코드대로 되어 있었다면 
![image](https://user-images.githubusercontent.com/45350356/181594461-93247fda-a43e-40d8-bed2-e1c1aac2f995.png)
위의 사진처럼 Body의 Header부분과 value부분이 없고 붙어있는 상태로 되어 있었고
![image](https://user-images.githubusercontent.com/45350356/181594722-f63fb383-c4b7-4b1c-a2d7-40859bc54f5e.png)
다시 수정해서 실행시켜보니
![image](https://user-images.githubusercontent.com/45350356/181594900-cf9ddeb0-5dec-4d8b-8e2b-8ea776bb4f77.png)
 Body의 Header부분과 value부분이 분리되어 있는 것을 볼 수 있고 정상적으로 POST가 되어 해결할 수 있었습니다.
