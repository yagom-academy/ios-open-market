# 🛍 오픈 마켓

>프로젝트 기간 2022.05.09 ~ 2022.05.20
>
>팀원 : [marisol](https://github.com/marisol-develop), [Eddy](https://github.com/kimkyunghun3) / 리뷰어 : [린생](https://github.com/jungseungyeo)

## 목차

- [프로젝트 소개](#프로젝트-소개)
- [UML](#UML)
- [키워드](#키워드)
- [고민한점](#고민한점)
- [배운개념](#배운개념)

## 프로젝트 소개

오픈마켓 만들기!

## 실행 화면
![](https://i.imgur.com/rm7Cr35.gif)

## UML
![](https://i.imgur.com/7gT8slu.jpg)

## 개발환경 및 라이브러리
![swift](https://img.shields.io/badge/swift-5.5-orange)
![xcode](https://img.shields.io/badge/Xcode-13.0-blue)
![iOS](https://img.shields.io/badge/iOS-13.0-yellow)

## 키워드

`git flow` `Test Double` `URLSession` `StubURLSession` `Protocol Oriented Programming` `추상화` `json` `HTTP method` `decode` `escaping closure` `Cache` `CompositionalLayout`

### 자세한 고민 보기

#### [STEP1](https://github.com/yagom-academy/ios-open-market/pull/142)
#### [STEP2](https://github.com/yagom-academy/ios-open-market/pull/153)




# STEP 1

## 고민한점

- URL을 어떻게 조합해서 만들어줘야 할까?
- 하나의 NetworkManager로 네트워크 통신 성공시 여러 타입의 데이터를 디코딩하기 위한 제네릭 타입 사용
- dataTask 속 error의 에러처리 표현
- init Deprecated
- test code에서 강제언래핑 사용가능여부
- HTTPURLResponse 에 대한 궁금증

## 배운개념

### 📌 1. URL을 어떻게 조합해서 만들어줘야 할까?

네트워크에 요청을 보내는 GET 역할을 하는 execute 메서드에서 사용할 url을 어떻게 만들어줄지 고민했습니다.
공통으로 사용되는 hostAPI, path 등을 API enum에 static let으로 선언해주고, case 별로 돌면서 enum 메서드에서 연관값을 입력받아 쿼리를 완성한 뒤에, hostAPI와 Path와 쿼리를 합쳐 url을 만들어주었습니다.

```swift
enum API {
    static let hostAPI = "https://market-training.yagom-academy.kr"
    static let productPath = "/api/products"
    static let healthCheckerPath = "/healthChecker"
    
    case productList(pageNo: Int, itemsPerPage: Int)
    case productDetail(productId: Int)
    case healthChecker
    
    func generateURL() -> String {
        switch self {
        case .productList(let pageNo, let itemsPerPage):
            return API.hostAPI + API.productPath + "?page_no=\(pageNo)&items_per_page=\(itemsPerPage)"
        case .productDetail(let productId):
            return API.hostAPI + API.productPath + "/\(productId)"
        case .healthChecker:
            return API.hostAPI + API.healthCheckerPath
        }
    }
}
```

### 📌 2. 하나의 NetworkManager로 네트워크 통신 성공시 여러 타입의 데이터를 디코딩하기 위한 제네릭 타입 사용

Product, ProductDetail, Application HealthChecker 3가지 타입의 데이터를 하나의 GET 메서드를 사용해서 가져올 수 있도록 NetworkManager에 Decodable을 채택하는 제네릭 타입을 선언해주었습니다. 처음에는 ProductNetworkManager와 HealthCheckerNetworkManager 2개의 타입을 만들어주었는데, String이 Decodable 프로토콜을 채택하고 있다는 것을 알게되어 하나로 사용할 수 있었습니다.



### STEP 1 추가 코멘트 

### 📝 구조 설명

- `URLSessionProtocol`: URLSession과 StubURLSession에 의존성을 주입해주기 위한 프로토콜

- `URLSession` : dataTask 메서드를 실행하여 URLSessionDataTask를 생성하고 resume하여 서버로부터 data, statusCode, error를 전달받아서 NetworkManager에게 전달하는 객체

- `APIable`: hostAPI와 path, parameter, HTTPMethod를 갖는 프로토콜

- `StubURLSession`:URLSessionProtocol을 활용하여 data, statusCode, error를 포함한 가짜 response를 만들어서 NetworkManager에게 전달하는 객체

- `NetworkManager`: URLSession으로부터 받아온 reponse를 HTTPmethod방식에 따라 구분하여 error, statuscode, data를 확인 후 data를 디코더하여 그 값을 내보내는 객체

### ❓ 추가 질문

#### get 이외에 post/put/delete의 처리

NetworkManager의 execute 메서드에서 URLSession으로부터 받은 HTTPMethod 정보에 따라 다르게 처리해주기 위해서 switch문을 작성했는데요, post/put/delete에 대해서는 처리가 어떻게 달라져야 할지 아직 몰라서 구현을 해두지 않은 상태입니다🥲 이 부분은 STEP2에서 구현을 해도 될까요??

#### StubDataTask 제거
저희 생각에 이 구조체는 초기화도 사용 못하고 DataTaskCompletionHandler에서 저희가 만들어준 Custom Response 타입을 사용하고 실제로도 이를 활용해서 데이터를 받도록 했기 때문에 StubDataTask는 불필요하다고 생각해서 없앴습니다. 그리고 이를 테스트 사용 시에도 잘 되는 것은 확인했는데 이게 적절한 구조와 설계였는지 궁금합니다!!


# STEP 2

## 📝 구조 설명

### 기본 구조
- `MainViewController`: productView에서 구성한 view를 올리고, 네트워크 통신을 통해 받아온 데이터를 cell에 뿌려주는 역할
- `Presenter`: MainViewController의 makeDataSource에서 받은 product 데이터를 cell에 뿌려주기 전에 가공하는 역할
- `ProductView`: segmented control, collectionView, listLayout과 gridLayout을 구성하는 역할
- `ListCollectionViewCell`: Presenter에서 받아온 데이터로 cell을 list 형태로 구성하는 역할
- `GridCollectionViewCell`:Presenter에서 받아온 데이터로 cell을 grid 형태로 구성하는 역할 


## 🧐 고민한점 & 해결방법
### 📌 1. list cell과 grid cell에 dataSource의 data를 어떻게 뿌려줄까?
 
처음에 MainViewController의 makeDataSource 메서드 내부에서 데이터들을 가지고 cell을 구성해주었는데요, 그렇게 하다보니 makeDataSource 메서드가 너무 길어지고 역할 분리도 애매해졌다는 생각이 들었습니다. 그래서 configureCell이라는 메서드에 파라미터로 product를 받도록 하고, cell 내부에서 파라미터의 product 데이터로 cell을 구성해주도록 변경했습니다.


> 각각 grid, list cell에 따라 View에 직접적으로 뿌려주게 되면 View에 로직이 더 필요하기 떄문에 Presenter라는 중간 매체를 사용했습니다. 이 곳에서는 cell에서 통신을 통해 받아온 데이터를 활용해서 뷰에 필요한 로직들을 구현했습니다.
예를 들어, 데이터포맷터를 통해 쉼표를 넣어주거나 재고 수량유무에 따라 cell에 다르게 보여줘야하는 부분을 처리하여서 View에서는 보여주는 역할만을 수행하도록 분리했습니다.

### 📌 2. collectionView의 cell에 구분선을 어떻게 만들어 줘야 할까?

cell마다 구분선을 주는 방법에 대해 오래 고민했습니다ㅠㅠ 다른 캠퍼들에게 조언을 구해 view를 얇게 만들어서 넣는 방법이 있다는 것도 알게 되었고, CALayer를 extension해서 bottom에 구분선을 넣어주는 방법도 알게 되어, CALayer를 extension하는 방법을 채택했습니다.
혹시 footer나 다른 방법으로도 구현할 수 있는 방법이 있을까요? 린생은 어떤 방법을 사용하시는지 궁금합니다!

```swift=
extension CALayer {
    func addSeparator() {
        let separator = CALayer()
        
        separator.frame = CGRect.init(x: 10, y: frame.height - 0.5, width: frame.width, height: 0.5)
        
        separator.backgroundColor = UIColor.systemGray2.cgColor
        self.addSublayer(separator)
    }
}
```

> cell 속에 view를 넣어서 구분선을 넣는 방법이 존재한다는 것을 알게 되었습니다. 하지만 위의 코드로 CALayer를 확장하여 사용하면 더 편리하다고 판단하여 위의 코드를 사용했습니다.

### 📌 3. modern CollectionView의 뷰의 전환을 비동기적으로 구현
segmentedControl의 index를 활용해서 뷰의 전환을 구현했었습니다.
하지만 이 코드는 modern ColletctionView에서 제공하는 init의 비동기적으로 뷰의 전환을 활용하지 않는 코드였습니다.

그리하여 내부에 존재하는 init를 활용해서 처리했습니다.
```swift
  public init(sectionProvider: @escaping UICollectionViewCompositionalLayoutSectionProvider,
              configuration: UICollectionViewCompositionalLayoutConfiguration)

```

이 init는 뷰 안에 여러 Section들에 대한 전환을 비동기적으로 처리해주므로 이전 코드와 다르게 더 효율적으로 가능해집니다.

그리하여 아래처럼 구현했으며
```swift
   private lazy var layouts: UICollectionViewCompositionalLayout = {
        return UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            return LayoutType.section(self.layoutType)()
        }, configuration: .init())
    }()
```

이곳에서 layoutType는 enum를 활용해서 내부를 캡슐화해서 사용했습니다. 그리하여 외부에서의 접근도 피할 수 있으며 segmentedIndex를 활용하지 않고도 뷰의 변환을 비동기적으로 처리할 수 있었습니다.

### 📌 4. 이미지 캐싱 처리 방법

NSCache를 사용해서 이미지를 캐싱하도록 했습니다.

UIImageView를 extension해서 `loadImage(_ urlString: String)`라는 메서드를 만들고, 
이미 캐시에 해당 url의 이미지가 존재한다면 해당 이미지를 사용하도록 하고, 캐시에 없는 이미지라면 해당 url로 이미지를 만들어 캐시에 저장하도록 했습니다.


### 📌 5. 뷰의 ancestor 문제
뷰의 레이아웃을 잡고 빌드를 했을 때 아래와 같은 문제가 자주 발생했습니다.
> Thread 1: "Unable to activate constraint with anchors <NSLayoutXAxisAnchor:0x6000034dcec0 \"UILabel:0x12260c090.centerX\"> and <NSLayoutXAxisAnchor:0x6000034dcf00 \"UIView:0x12260ab30.centerX\"> because they have no common ancestor. Does the constraint or its anchors reference items in different view hierarchies? That's illegal."

이 문제가 발생했을 시 2가지를 고려하면 됩니다.
1. addSubview가 잘되어있는지
2. addSubview -> Layout Constraint 순으로 잘했는지

두 가지를 잘 생각해보면 해결가능합니다!!

### 📌 6. cell의 indexPath 비교 vs cell prepareForReuse

#### prepareForReuse 

- 셀을 재사용하는 메서드다
    - CollectionView의 장점은 셀을 재사용한다는것. 그래서 이 메서드가 효율적으로 발휘할 수 있다.

- 또한 Object 책에서 말하길, "객체지향에서 객체 사이에서 서로의 정보를 많이 알수록 의존 관계가 높아진다."고 하는데, indexPath가 cell의 정보를 아는 것이 객체 사이의 정보를 공유하는 것이기 떄문에 이는 의존관계를 높일 수 있는 결과를 초래한다.

- 값을 부분적으로 update할 수 있는 장점이 존재한다.
 

#### indexPath

- indexPath를 사용하면 고정적으로 update를 해줄 수 있다

- 여기에서는 재사용 셀을 사용하지 않고 고정적으로 적절한 곳에 업데이트 해주므로 고정적으로 사용한다면 유리할 듯싶다.

- 하지만 재사용성이 떨어지므로 이를 주의해야하며, 관리를 해줄 수 없는 단점이 존재한다.

> 위와 같은 특성이 있고, collectionView의 장점인 재사용성을 이용한 prepareForReuse를 사용하도록 변경하였다

---

## ❓ 궁금한점
### 📌 1. List화면에서 Grid 갔다가 List로 넘어갔을 때 AccessoryUI 쪽이 더 생겨나는 버그
처음에 동일한 셀을 제대로 초기화하지 않고 사용하기에 문제가 발생한다고 생각했습니다. 
그래서 prepareForReuse() 메서드를 활용해서 하면 될 것이라고 생각했는데, 코드를 작성해보고 했으나 저희가 이해를 못한것인지 아니면 코드가 적절하지 않았던 것인지 제대로 작동이 되지 않습니다. 왜 이런 문제가 발생한 것일까요?

<img src="https://i.imgur.com/LjYL1Sp.png" width="500" height="800"/>

prepareForReuse는 두 cell에 작성했습니다
```swift

// ListCollectionViewCell
override func prepareForReuse() {
    super.prepareForReuse()
    productImage.image = UIImage(systemName: "swift")
    productName.text = nil
    currency.text = nil
    price.text = nil
    bargainPrice.text = nil
    stock.text = nil
    accessoryStackView.removeFromSuperview()
}

// GridCollectionViewCell.swift
override func prepareForReuse() {
    super.prepareForReuse()
    productImage.image = nil
    productName.text = nil
    currency.text = nil
    price.text = nil
    bargainPrice.text = nil
    stock.text = nil
}

```

> cell이 재사용될 때 AccessoryStackView가 계속 쌓여서 발생하는 문제라고 파악했고,
그래서 `prepareForReuse` 메서드에서 accessoryStackView의 subview들을 `removeFromSuperview`해서 삭제시켜주었습니다.

``` swift
override func prepareForReuse() {
    super.prepareForReuse()
    
    discountedPrice.isHidden = false
    originalPrice.attributedText = nil
        
    accessoryStackView.arrangedSubviews.forEach {
        $0.removeFromSuperview()
    }
}
```


### 📌 2. Layout 설정 한 것이 적절하게 동적으로 대응한 것인지?
저희가 레이아웃에서 일명 숫자를 활용해서 constraint를 맞추는 곳이 많아서 이렇게 해도 될지 궁금합니다. 이렇게 하게되면 동적으로 처리가 안될 것 같은데.. 저희가 다르게 생각해봐야 될까요? 

> 일반적으로는 고정적으로 하지 않고 동적처리를 해주어야 하지만 동적으로 변하지 않을 곳에는 고정적으로 해도 된다고는 하지만 변화에 대응하기 어렵다고 판단했습니다. 현재 코드에서는 문제없지만 추후에 변화가 생기면 동적으로 처리해줘야 한다고 인지했습니다.

### 📌 3. DataSource 메서드 내부를 밖으로 캡슐화해서 빼는 방법이 없는지?
```swift 
guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell else {
    return UICollectionViewCell()
}

DispatchQueue.main.async {
    if collectionView.indexPath(for: cell) == indexPath {
        cell.configureCell(productDetail)
    }
}
```
이와 같은 코드가 분기에 따라 거의 동일하게 이루어지고 있어서 재사용성 있게 만들고 싶었는데, 이를 밖에서 메서드로 만들어서 호출하는 방법이 떠오르지 않습니다.

indexPath를 파라미터로 받으면 될 것 같은데, 그외에도 다른 요소들이 또 필요한 것같아서 메서드로 분리하다가 실패했는데 이 부분도 분리가 가능할지 궁금하네요!

> 빼려면 제네릭으로 뺄 수는 있지만, 어차피 configure에서 한번 타입캐스팅이 되어야 하기 때문에 현행을 유지하도록 했습니다.

### 📌 4. GridLayOut 보여줄 때 첫 화면의 위치
처음 GridLayout으로 가게되면 스크롤이 맨위에 있지 않고 바로 하나의 그룹 아래에 놓여져 있습니다. 원래 의도대로라면 GridLayout으로 가게되면 첫번째의 셀이 보여줘야되는데 이처럼 되는 현상이 무엇 떄문에 그런 것일까요? 이를 강제로 처음에 보여주게 만드는 방법을 사용해야할까요? 아니면 reuseCell과 같은 문제로 생긴 부분일까요?

> Layout 에러가 존재해서 첫 화면의 위치가 이상했었습니다. 그리하여 에러를 수정하며 자연스럽게 해결되었습니다.

### 📌 5. segmented control에서 selected되지 않은 segment의 색상 지정

선택된 segment는 selectedSegmentTintColor와 setTitleTextAttributes로 색을 정해줄 수 있었는데요,
selected되지 않은 segment에 대한 속성을 지정해줄 수 있는 방법을 찾지 못했습니다ㅠㅠ
LIST가 선택된 상태일때 GRID가 blue가 될 수 있도록 지정할 수 있는 방법이 있을까요?!

