# 🏪 오픈마켓 프로젝트

## 목차 
- [구현](#구현)
- [STEP1](#step-1)
    - [고민했던 점](#고민했던-점)
    - [학습 키워드](#학습-키워드)
- [STEP2](#step-2)
    - [고민했던 점](#고민했던-점)
    - [학습 키워드](#학습-키워드)

---

## 구현

<center>
    
|List|Grid|
|:---:|:---:|
|<img src="https://i.imgur.com/LlxM52k.gif" width="300" height="650">|<img src="https://i.imgur.com/ZYYRaKq.gif" width="300" height="650">|

|ActivityIndicator|List, Grid 전환|
|:---:|:---:|
|<img src="https://i.imgur.com/6F1WWhb.gif" width="300" height="650">|![](https://i.imgur.com/vyhsNog.gif)|

</center>

## STEP 1

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




## Step 2 

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
