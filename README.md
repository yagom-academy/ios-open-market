# 🏪 오픈마켓 프로젝트

- 팀 프로젝트
- 구현 기간 : 2022.01.03 ~ 01.28 (4 weeks)

## 목차 
- [구현](#구현)
- [STEP1](#STEP1)
    - [고민했던 점](#STEP1-1)
    - [학습 키워드](#STEP1-2)
- [STEP2](#STEP2)
    - [고민했던 점](#STEP2-1)
    - [학습 키워드](#STEP2-2)
- [STEP3](#STEP3)
    - [고민했던 점](#STEP3-1)
    - [학습 키워드](#STEP3-2)
- [STEP4](#STEP4)
    - [고민했던 점](#STEP4-1)
    - [학습 키워드](#STEP4-2)
---

## 구현

<center>
    
|List|Grid|ActivityIndicator|List, Grid 전환|
|:---:|:---:|:---:|:---:|
|<img src="https://i.imgur.com/LlxM52k.gif" width="390" height="450">|<img src="https://i.imgur.com/ZYYRaKq.gif" width="350" height="450">|<img src="https://i.imgur.com/6F1WWhb.gif" width="300" height="450">|<img src="https://i.imgur.com/vyhsNog.gif" width="390" height="450">|

    
|Pagination(무한 스크롤)|리프레시 컨트롤|수정/등록 Alert| 상세 이미지 페이징 |
|:---:|:---:|:---:|:---:|
|![](https://i.imgur.com/OV760oy.gif)|![](https://i.imgur.com/gcTPDbU.gif)|![](https://i.imgur.com/95ahAb9.gif)|![](https://i.imgur.com/NPBKeXf.gif)|

| 업데이트 버튼(새 게시물) | 키보드 높이 조정 | 상품 삭제 및 업데이트 | 상품 수정 및 업데이트  |
|:---:|:---:|:---:|:---:|
|![](https://i.imgur.com/TybJtTU.gif)|![](https://i.imgur.com/ycqAzdY.gif)|![](https://i.imgur.com/DPPsjQg.gif)|![](https://i.imgur.com/nQkNwAD.gif)|


</center>

<a name="STEP1"></a>

## 🤔 STEP 1


<a name="STEP1-1"></a>

## 고민했던 점 

### 1. 네트워크 무관 테스트

프로젝트의 Step1에서 요구되는 실제 네트워크와 통신하지 않으며 진행하는 테스트를  Mock을 생성하여 구현해봤습니다.

실제 `Session`과 통신하지 않기 위해 기존 `URLSession`에 의존하는 것이 아닌 `URLSessionProtocol`을 생성하여 이에 의존하도록 했습니다. APIService내의 프로퍼티가 이제 `URLSession` 타입이 아니라, `URLSessionProtocol` 타입을 갖게 되고, 이 프로퍼티를 상황에 따라 실제/가짜 Session을 넣어주기 위해 생성자 주입 방식을 사용했습니다. 

먼저 `URLSessionDataTask`를 대체할 `MockURLDataTask` 타입을 생성했습니다. 이 또한 `URLSessionDataTask`를 상속하도록 하고, `URLSessionDataTask`의 `resume()` 메서드를 재정의하여 `MockURLDataTask`에서 정의한 클로저를 실행시켜주도록 구현했습니다. 

이후 `URLSessionProtocol`을 채택한 `MockURLSession` 타입을 구현하여 Unit Test시 `APIService` 인스턴스를 생성할 때 `MockURLSession`을 주입하였고, 해당 세션이 채택한 프로토콜에 정의되어있는 `dataTask()`를 구현해주었습니다.

생성한 task가 `resume()`될 때 앞서 `MockURLDataTask`에서 정의한 클로저가 이어서 실행되면서 사전에 만들어둔 성공/실패 결과를 반환하게 됩니다. 

이제 Unit test를 할 때, `APIService의` session에 `MockURLSession`을 넣어주어 항상 성공/실패하도록 설정해두었습니다. 이에 기대하던 데이터를 미리 디코딩해두고, `APIService`의 메서드를 실행 결과가 이와 동일한지 비교하여 네트워크와 무관한 로직 테스트를 수행했습니다. 


### 2. `URLRequest` initializer 추가 

`URLRequest` 인스턴스를 커스텀하게 생성해주기 위해 extension을 사용하여 이니셜라이저를 생성하였습니다. 생성과 함께 httpHeader/Body도 설정해주고, url도 달아주기 위해 부가적으로 `API`, `URLCreator`와 같은 타입을 생성하였습니다.

### 3. `dataTask()` 공통 사용 및 HTTPMethod 별 메서드 분리 

서버 요청에 반복적으로 사용될 수 있는 `dataTask()`를 하나로 묶어 사용하였습니다. 이 덕분에 상품 상세 조회, 상품 리스트 조회, 상품 삭제 등 여러 요청에서 해당 메서드를 재사용할 수 있었습니다.

HTTPMethod 별로 반환값 혹은 completion handler가 필요한 경우가 달라 이는 각각의 메서드로 구현해주었습니다. API문서에 따른 request들을 생성하기 위한 데이터들을 메서드의 파라미터에서 받도록 하고, 내부에서 조건에 맞는 `URLRequest`를 생성하여 성공/실패시 데이터/오류를 반환하도록 하였습니다. (데이터 반환이 필요하지 않은 경우는 에러만 반환하도록 했습니다)


### 4. `@escaping` closure 및 `Result` 타입 사용 

메서드가 리턴되더라도 추후에 데이터를 전달받기 위해 `@escaping`을 클로저에 사용해주었습니다. 이와 함께 `Result` 타입을 활용하여 성공/실패에 따른 정상적인 결과/에러를 반환해 줄 수 있도록 했습니다. 

<a name="STEP1-2"></a>

## 학습키워드 
- API
- HTTMethod
- 네트워크와 무관한 네트워킹 타입의 Unit test
- Multipart/form-data
- URLSession
- Completion Handler
- escape closure
- decode/encode
- CodingKey
- Result Type
- Unit Test


<a name="STEP2"></a>

## 🤔 Step 2 

<a name="STEP2-1"></a>

## 고민했던 점 

### 1. Modern CollectionView 구현

기존의 방식과 달리 애플에서 새롭게 제시하는 modern collectionView 구현 방식을 사용하여 프로젝트를 진행했습니다. 
이 때 compositional Layout과 DiffableDataSource를 주로 활용하였으며, 이 들의 장점을 체감했던 것 같습니다.

- Compositional Layout
    - 입맛에 맞게 유연하고 빠르게 구성할 수 있다.
    - section/group/item을 쌓는 모습이 시각적으로 나타난다

- DiffableDataSource
    - 데이터를 관리하고 collectionView에 대한 cell을 제공하는데 사용된다.
    - collectionView의 데이터와 UI를 간편하고, 효율적이게 관리할 수 있다.

이러한 내용들에 기반해서 이번 프로젝트는 modern CollectionView 구현 방식을 사용했습니다!

### 2. List/Grid collectionView 스위치하기

두 개의 collectionview에 각각의 Cell을 추가하여 사용할 지, 하나의 collectionView에 각각의 cell을 상황에 따라 바꿔 사용할 지 고민해보았습니다.

- 두 개의 collectionview를 사용하는 경우
    - `isHidden`으로만 쉽게 switching을 관리할 수 있다.
- 하나의 collectionview에 cell이 두 개 바뀌는 경우
    - 매번 switch될 때마다 새로 collectionView의 layout, dataSource 등을 설정해줘야 한다. 

고민해본 결과, SegmentedControl을 사용하여 하나의 collectionView에 List/ Grid로 레이아웃을 변경할 때마다 새로이 layout을 설정하는 것의 비용이 더 클 것이라고 생각하여 ListLayoutCollectView와 GridLayoutCollectionView를 각각 만들어 레이아웃에 만든 셀을 추가시키고, 콜렉션뷰의 인스턴스를 한번씩만 생성하도록 하는 방식을 채택하였습니다.

첫 화면이 ListLayoutCollectionView 이므로 앱이 시작되고 데이터가 불러와졌을 때 해당 뷰의 인스턴스를 생성하였고 화면이 스위칭되었을 때 GridLayoutCollectionView의 인스턴스를 생성해주었으며, 각 뷰가 스위칭 될 때마다 현재 보이는 뷰는 hidden되지않고 보이지 않는 뷰는 hidden되게 만들어 뷰를 올렸습니다. alpha값을 변경하여 뷰를 숨기는 것과 고민했으나, alpha 값을 1로 주게 되면 보이기에는 사라지지만 뷰가 실제로는 그려지기에 메모리 관점에서 `isHidden`을 사용하는 것이 뷰를 그리지 않는 방법이라고 하여 비용 관점에서 효율적이라고 생각했습니다.


### 3. 스토리보드 없이 코드로 하게된 이유

![](https://minjunkweon.github.io/assets/images/image-20190814150748264.png)


- 리팩터링이 더 편하다고 생각하였습니다. 
    - 변경사항을 편하게 추적하고 괸리할 수 있을 것 같았습니다. 
        - 협업의 경우 보통 git을 사용하여 협업을 하는데 이전 커밋과의 diff를 살펴볼 때 스토리보드의 경우는 XML로 올라가 있기때문에 비교가 직관적이지 못하다고 생각하였습니다.
    - 레이아웃이 꼬인 경우, 스토리보드에선 어느 부분부터 꼬인 것인지 직관적으로 보이지 않고, 레이아웃이 잘못됐다는 오류 또한 Xcode의 오류때문인지 정상적인 것인데 잘못됐다고 나오거나 오류가 나오다 마는 경우도 있었습니다.
- 코드로 UI를 작성하는 것을 경험해보고 싶었습니다.
    - modern Cell, modern collectionView의 경우 코드로 Configuration을 지정하여 주기 때문입니다.
- 간단한 레이아웃을 설정하는 부분이라면 재사용을 고려할 수 있었습니다.
- 위 사진처럼 코드로 짜는 UI가 스토리보드로 짜는 UI의 범주를 포함하고있어 스토리보드로만 UI를 구성하는 것은 한계가 있다고 생각하였습니다.

### 4. Image Cache 구현 

NSCache를 활용하여 URL으로 부터 받아오는 이미지 데이터를 캐싱하였습니다.

`imageCache`에 URL로부터 받아오는 이미지가 이미 존재하는 경우 해당 이미지를 반환하고, `imageCache`에 해당 이미지가 없는 경우 캐시에 저장 후 이미지를 반환하도록 구현하였습니다. 
추후에 데이터를 업데이트하는 경우, 데이터를 리로드하는 경우에 생성해둔 캐시를 활용하여 조금 더 빠르게 이미지를 로드할 수 있다는 이점을 취할 수 있을거라 생각했습니다. 

### 5. 상수 관리 

레이아웃에 들어가는 제약값과, 문자열의 헤더부분을 각 네임스페이스에 정리하여 향후 사이즈를 변경하거나, 문자열을 변경하는 등의 상황에서 유연하게 대처할 수 있도록 하기 위해 상수 관리를 해주었습니다.

### 6. 모든 기기에 대응하도록 autolayout 지원 

모든 기기에 대응하기위해 collectionView의 프레임을 각 기기마다 다른 사이즈를 가진 safe Area에 맞춰주었습니다. 또한 cell내의 텍스트, 이미지가 잘리지 않도록 하기 위해 cell의 이미지 크기가 줄어들도록 autolayout을 설정하여 유연하게 조정되도록 구현하였습니다. 

|List|Grid|
|:--:|:--:|
|![](https://i.imgur.com/PfQh21S.png)|![](https://i.imgur.com/7s6uknN.png)|

<a name="STEP2-2"></a>

## 학습 키워드 
- Modern cell configuration
    - `UIConfigurationStateCustomKey`
    - `UIConfigurationState`
    - `ConfigurationState`
    - `updateConfiguration(using state: UICellConfigurationState)`
- Modern collectionView 구현
    - `UICollectionViewCompositionalLayout`
    - `UICollectionViewDiffableDataSource`
    - `NSDiffableDataSourceSnapshot`
    - `UICollectionLayoutListConfiguration`
    - `CellRegistration`
    - `dequeueConfiguredReusableCell`
- NSCache (image cache)
- Segmented Control
- AutoLayout
- NSMutableAttributedString


<a name="STEP3"></a>

## 🤔 Step 3

<a name="STEP3-1"></a>

## 고민했던 점 

### 1. 상품 등록/수정 `ViewController`의 공통 기능 구현 

컨테이너 뷰의 레이아웃을 잡는다거나, alert를 띄우는 등 등록/수정 ViewController에서 공통적으로 필요로하는 기능들을 프로토콜 기본구현으로 제공해봤습니다. 다만 Objective-C 메서드들은 프로토콜 기본 구현이 불가하다는 점에 한계를 직접 경험해본 것 같습니다. 이에 상속과 프로토콜 기본 구현 관련하여 고민을 해봤습니다.

- 상속
    - 다중 상속이 불가능하다
- 프로토콜 기본 구현 
    - Objective-C 프로토콜은 기본 구현이 불가능하다.

### 2. `UIImage` 이미지 크기 조정 

UIGraphics를 사용하여 이미지 크기를 조절해주었습니다. `UIGraphicsBeginImageContextWithOptions()` 메서드를 호출하여 비트맵을 만들고 `UIImage.draw(in:)`로 원하는 사이즈만큼 줄인 뒤, `UIGraphicsGetImageFromCurrentImageContext()` 메서드를 통해 크기가 조정된 이미지를 얻었습니다. 이후 `UIGraphicsEndImageContext()`를 호출하여 비트맵을 제거 처리해주면서 이미지 크기를 조정하는 로직을 구현했습니다. 

### 3. 키보드 사용에 따른 ScrollView inset 조정

textField나 textView에 텍스트 작성시 화면이 작은 iPod Touch의 경우 키보드가 이벤트 발생 뷰를 가려버리는 문제가 있어 키보드가 올라옴에 따라 스크롤 뷰의 `contentInset.bottom`을 키보드의 높이만큼 지정하여 키보드가 텍스트필드나, 텍스트뷰를 가릴 일이 없도록 구현하였습니다.

### 4. View와 ViewController 분리 

뷰와 뷰컨트롤러의 책임을 덜기위해 둘 사이에 `ProductRegisterManager`라는 객체를 생성하였습니다.

매니저는 뷰를 알고있어 뷰의 특정 속성값을 알 수 있고, 뷰컨트롤러는 매니저를 알고있기에 매니저가 구한 뷰의 속성값을 받기만 하면 되게끔 하여 뷰컨트롤러의 책임을 덜어주었습니다.


### 5. 이미지 추가/삭제 

이미지의 경우 5개까지 추가 가능하기에, 추가된 이미지가 5개가 되면 추가 버튼을 `isHidden = true`하여 숨겨주었습니다. 이 부분은 숨김 처리하는 것 보다, 추후에 alert를 주어 최대 등록 개수를 알려주거나, 추가 버튼 내에서 현재 등록된 개수/최대 개수를 나타내주는 방식으로 수정하면 좋을 것 같다고 생각했습니다. 

또한 이미지를 등록하는 과정에서 추가한 이미지를 제거할 수 도 있어야 한다고 생각해서 제거 버튼을 구현해주었습니다. 이 부분은 `UIImageview`와 `UIButton`을 가지는 컨테이너 뷰를 만들어서 커스텀하게 구현해주었습니다. 

<a name="STEP3-2"></a>

## 학습 키워드

- Image Resizing
- 프로토콜 기본 구현 / 상속
- Custom View 구현 
- View와 ViewController 분리 
- Keyboard 관리 
- Delegate pattern
- UIImagePickerController
    - 사용자 사진첩 접근 권한 설정 
- UISegmentedControl
- ScrollView
- Networking
    - multipart/form
    - URLSession
    - HttpRequest, HttpResponse
    - Request, Response Debugging

<a name="STEP4"></a>

## 🤔 Step 4

<a name="STEP4-1"></a>

### 고민했던 점 

### 1. 공통 기능 상속 구현 

상품 등록/수정 화면에서 요구되는 공통된 화면,기능들이 많았었기에, 이전 step에서는 프로토콜 기본 구현을 활용하여 공통 기능들을 구현해줬었습니다. 하지만 objective-c 메서드들은 프로토콜 기본 구현이 불가하기 때문에, 이번 step에서는 `상속`을 활용하여 공통 기능을 구현하고 이를 상속하여 기능들을 사용할 수 있도록 해줬습니다. 

각 하위 뷰 컨트롤러에서 가져야하는 특수한 화면이나, 기능들의 경우 상속 이후 자체적으로 내부에서 구현해줬습니다.

### 2. 상품 수정/삭제 접근 권한 

상품 상세 화면에 진입하게 되면, 우측 상단에 상품 수정/삭제 버튼이 보여야 한다는 요구사항이 있었습니다. 

상품 수정/삭제의 경우 본인이 등록한 상품이 아닐 경우 수정/삭제가 불가능하기 때문에 초입부에서부터 접근을 막아주는 것이 효율적일 것이라 판단했습니다. 

이에 상품 상세 화면에 진입했을 때, 본인 상품인지 아닌지를 먼저 판별하여 화면에서의 버튼 노출 여부를 결정하였습니다. 

|본인이 등록 상품 상세 화면|타인이 등록한 상품 상세 화면|
|:---:|:---:|
|![](https://i.imgur.com/OP1NXVk.png)|![](https://i.imgur.com/SiEaFuX.png)|

### 3. NotificationCenter를 활용한 업데이트 요청

상품 수정/삭제가 이루어지고 해당 화면이 내려가게 되면 이전 메인 화면이나 상품 상세 화면에서의 업데이트 또한 필요했습니다. 

이에 NotificationCenter의 userInfo에 업데이트된 데이터를 담아 최신 데이터로 업데이트 해줄 것을 요청하는 로직을 구현했습니다. 매번 업데이트를 요청하는 것이 아니라, 데이터의 변경사항에 발생했을 때만 업데이트를 보내주도록 하여 무분별한 API 요청을 하지 않도록 구현했습니다.

### 4. 상세 화면 이미지를 화면에 꽉 차도록 리사이징

|Before Resize|After Resize|
|:--:|:--:|
|![](https://i.imgur.com/qbF7kyy.png)|![](https://i.imgur.com/cwPyPpd.png)|

`scaleAspectFill`을 쓰면 이미지가 확대되어 잘리는데, 저희가 원하는 모습은 이미지가 잘리지않는 모습이기때문에 이미지뷰의 속성을 `scaleAspectFit`을 사용하여 이미지가 잘리지 않게 구현하였습니다.

하지만 이미지가 잘리진 않아도, 양 옆에 하얀 공백이 생기는 것이 마음에 들지않아 이전에 구현해놓았던 `resize` 메서드를 활용하여 공백이 생기지 않도록 조정해주었습니다. 


### 5. Pagination(무한 스크롤) 구현 

CollectionView를 스크롤하여 가장 마지막 게시글까지 화면에 노출되는 경우, 추가적으로 다음 페이지의 데이터를 서버에 요청해오고 데이터 및 UI를 업데이트 하도록 해줬습니다. 

하지만 추가적으로 데이터가 발생함에 따라 스크롤이 버벅이는 문제가 발생했습니다. 이에 기존에 동기적으로 받아오던 이미지를 비동기적으로 받아올 수 있도록 개선하였고, collectionView의 prefetch를 사용하여 데이터를 보여주기 이전에 미리 데이터를 업데이트 해둘 수 있도록 했습니다. 

### 6. CollectionView RefreshControl 구현 

CollectionView를 위에서 아래로 터치하여 끌어내릴 경우 list/grid 화면을 업데이트 해주도록 구현하였습니다. collectionView가 가지는 기본적인 RefreshControl에 Custom RefreshControl을 적용시켰고, 목록 최상단에서 스크롤을 끌어내릴 시 서버에 요청을 보내 최신 데이터를 받아 기존 데이터가 업데이트되도록 구현하였습니다.

### 7. 새 게시물 조회 후 업데이트 버튼 노출

![](https://i.imgur.com/nTDW4dq.gif)

`Timer`를 이용하여 정해준 시점에 한번씩 서버에 요청을 보내 현재 어플리케이션이 갖고 있는 데이터와 서버단의 데이터를 비교하여 서버단의 데이터가 현재 데이터보다 최신일 시 애니메이션이 추가된 버튼이 내려와 사용자에게 새로운 게시물이 있다고 알림으로써 접근성과 편의성을 고려하였습니다.

<a name="STEP4-2"></a>

## 학습 키워드

- View Animate
- Custom View
- Image Resize
- Notification
- 공통 기능 상속
- UIAdaptivePresentationControllerDelegate
- 상품 수정/삭제 API 
- CollectionView
    - UICollectionViewDataSourcePrefetching
    - prepareForReuse
    - Pagination (무한 스크롤)
