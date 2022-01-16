# Read Me

# STEP 1

## 🤔 고민했던 점

### 1. 줄바꿈 규칙

```swift
// 처음 규칙
private static func buildBody(with salesInformation: SalesInformation,
                              images: [String: Data]) -> Data? {
```

```swift
// 변경된 규칙
private static func buildBody(
    with salesInformation: SalesInformation,
    images: [String: Data]
) -> Data? {
```

Parameter가 길어서 이전 줄바꿈 규칙으로 문제가 있었습니다.
줄바꿈 규칙을 [Swift Style Guide](https://github.com/StyleShare/swift-style-guide#%EC%A4%84%EB%B0%94%EA%BF%88) 를 따르도록 변경했습니다.

### 2. 구조체의 프로퍼티에 let를 사용

`var`로 선언한 경우 인스턴스를 생성할 때 let으로 선언해주면 내부 프로퍼티도 전부 let으로 변경이 불가능하고, var로 선언해주면 내부 프로퍼티를 수정할 수 있다고 알고 있었습니다.

따라서 처음에는 let으로 선언해주는 것보다 코드를 유동적으로 사용할 수 있다고 판단했고 var로 프로퍼티들을 정의했습니다.

하지만 아래와 같은 이유로 let이 더 낫다고 판단했고, let으로 선언했습니다. 

> 네 경우에 따라서 구조체 인스턴스 값을 직접 변경해야하는 경우도 필요합니다. 다만 네트워크 매핑 모델의 같은 경우는 `let`으로 불변성을 유지하는게 좀 더 바람직한 접근법 같아요. 이렇게 원천 데이터에 변경을 직접 가하는건 예상치 못한 사이드 이펙트를 발생시키는 경우도 있거든요. 그래서 저는 보통

원격 저장소 데이터 매핑 모델 - 비즈니스 로직 수행을 위한 모델 - 화면에 그려주는데 필요한 모델

이렇게 모델도 계층을 나누어 관리합니다. 한 계층에서의 변경의 여파가 외부로 퍼저나가지 않도록 하기 위해 말이죠
> 

### 3. Snake-Case와 Date를 변환하는 방법

Mock 데이터와 서버에서 받아야 하는 데이터 모두 SnakeCase로 작성되어 있었습니다. 또한 Date의 경우도 Mock 데이터에서 String으로 되어 있어 변환하는 방법에 대해 고민했습니다.
처음에는 따로 `init(from decoder: Decoder)`을 만들어 바꿔주는 방식을 택했습니다.

```swift
init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Self.CodingKeys)
    id = try container.decode(Int.self, forKey: .id)
    vendorId = try container.decode(Int.self, forKey: .vendorId)
    name = try container.decode(String.self, forKey: .name)
    thumbnail = try container.decode(String.self, forKey: .thumbnail)
    currency = try container.decode(Currency.self, forKey: .currency)
    price = try container.decode(Int.self, forKey: .price)
    bargainPrice = try container.decode(Int.self, forKey: .bargainPrice)
    discountedPrice = try container.decode(Int.self, forKey: .discountedPrice)
    stock = try container.decode(Int.self, forKey: .stock)

    let createdAt = try container.decode(String.self, forKey: .createdAt)
    let issuedAt = try container.decode(String.self, forKey: .issuedAt)

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"guard let formattedCreatedAt = formatter.date(from: createdAt),
          let formattedIssuedAt = formatter.date(from: issuedAt) else {
              throw FormattingError.dateFormattingFail
          }
     self.issuedAt = formattedIssuedAt
     self.createdAt = formattedCreatedAt
}
```

하지만 이후 `dateDecodingStrategy`와 `keyDecodingStrategy` 중 `convertFromSnakeCase`이 있는 것을 알았고 위 방법이 아닌 Decoding Strategy를 사용하는 방법을 선택했습니다.

### 4. URLSession.dataTask(with:) `URLRequest` 타입만 사용

```swift
let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
    if let error = error {
        completionHandler(.failure(error))
        return
    }
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
              completionHandler(.failure(NetworkError.httpError))
              return
          }
    guard let data = data else { return }
    completionHandler(.success(data))
}
```

위 코드가 `NetworkTask`에서 반복적으로 사용되었음에도 URL을 사용하는 부분과 URLRequest를 사용하는 부분으로 나눠져 있어 함수로 분리하는데 어려움이 있었습니다.
처음에는 저희가 만든 `dataTask` 메서드에서 with request 매개변수에 제네릭을 사용하려고 했으나 이렇게 할 경우 `URLSession.shared.dataTask(with: request)`에서 문제가 발생했습니다.

> No exact matches in call to instance method 'dataTask’
> 

따라서 여기선 항상 `URLRequest`를 받도록 구현했고, URL을 사용하는 경우 다음과 같이 `URLRequest`로 변환하는 과정을 추가해주었습니다.`var request = URLRequest(url: url)`

### 5. `URLSession.dataTask(with:completionHandler:)` 에서 error와 response를 처리하는 방법

```swift
enum NetworkResponse {
    case response(URLResponse, Data?)
    case error(Error)
}
```

`Result<Data, Error>` 타입 대신 위의 `NetworkResponse` 타입을 사용할지 고민했습니다.
지금은 http status code를 따로 처리할 필요가 없을듯 해서 Result 타입을 사용했습니다.

### 6. `multipart/form-data` 를 위한 body 만들기

다른 곳에선 `application/json`을 사용해서 문제가 없었으나 상품 등록에선 `multipart/form-data`을 사용해야 해서 이를 위한 body를 구현해줘야 하는 문제가 있었습니다.
따라서 따로 `buildBody`라는 메서드를 만들어 `multipart/form-data`에 맞는 body를 만들어줄 수 있도록 구현했습니다.

`multipart/form-data`의 body를 만들기 위해 지켜야 할 점

1. 바운더리를 구분하기 위한 문자열을 임의로 정한다.
→ 저희의 경우 UUID().uuidString을 통해 임의의 문자열을 생성해주었습니다.
2. 각 폼 필드 요소의 값은 `-바운더리` 모양의 라인 하나로 구분된다.
3. 이후 해당 필드 요소 데이터에 대한 헤더를 정의한다.
→ ex: `"Content-Disposition: form-data; name=\"params\"\r\n\r\n"`
4. 헤더와 내용에는 반드시 빈 줄 1개가 있어야 한다.
5. 모든 요소의 기입이 끝났으면 줄을 바꾸고 `-바운더리--`의 모양으로 데이터를 기록하고 끝낸다.

### 7. 의존성 주입을 통한 객체 간 강결합 해소

기존에는 `NetworkTask`에서 `JSONParser`를 사용할 때 `static`을 사용하여 접근할 수 있도록 했습니다. 하지만 이렇게 사용할 경우 JSONParser를 전역에서 사용할 수 있기 때문에 싱글톤 사용 시 발생하는 “Sacrificing Transparency for Convenience” 문제가 발생했습니다. 

따라서 `JSONParser`를 프로토콜로 추상화한 뒤 `NetworkTask`의 인스턴스를 생성할 때 의존성 주입으로 `JSONParser`를 사용할 수 있도록 수정했습니다.

```swift
struct NetworkTask {
    let jsonParser: JSONParsable
}

protocol JSONParsable {
    func decode<Element: Decodable>(from data: Data) throws -> Element
    func encode<Element: Encodable>(from element: Element) throws -> Data
}
```

# STEP 2

## 🤔 고민했던 점

### 1. 썸네일 다운로드를 비동기로 변경했습니다.

스크롤 속도가 느려지는 문제가 있었습니다.
썸네일 다운로드를 비동기로 변경했습니다.

```swift
// sync
let image = UIImage(data: imageData)
cell.productImageView.image = image
```

```swift
// async
cell.productImageView.image = nil
networkTask.downloadImage(from: url) { result in
    guard let image = UIImage(data: data) else { return }
    DispatchQueue.main.async {
        guard indexPath == tableView.indexPath(for: cell) else { return }
        cell.productImageView.image = image
    }
}
```

sync | async
-- | --
![iPhone 11 - sync](README_IMAGES/iPhone_11_-_sync.gif) | ![iPhone 11 - async](README_IMAGES/iPhone_11_-_async.gif)


### 2. SwiftLint 사용

코드 컨벤션을 보다 명확하게 준수하기 위해 SwiftLint를 사용했습니다. 

처음에는 CocoaPod을 활용해 SwiftLint를 프로젝트에 적용시켜줬으나, 이미 `.swiftlint.yml` 파일을 통해 컨벤션을 정해주었고 버전 관리까지 해줄 필요는 없다고 판단하여 homebrew를 통해 직접 설치를 해주었습니다. 

특히 코코아팟을 사용할 경우 불필요하게 생기는 파일도 많았는데, 버전 관리를 해줄 필요가 없다면 코코아팟을 굳이 사용할 이유는 없다고 판단하여 코코아팟으로 설치한 SwiftLint는 제거해주었습니다. 

### 3. NSAttributedString 사용

단순히 label.text로 할 경우 String으로 값을 주게 되는데 이 경우 font나 color를 지정해주려면 label에 직접 적용해줘야 했습니다. label에 직접 적용을 할 경우 CollectionView와 TableView에 중복되는 코드를 반복해서 적어줘야 하는 단점이 존재했습니다. 

따라서 label.attributeText에 레이블을 넣어주고 `Product`에서 직접 연산 프로퍼티를 통해 `attributedTitle`, `attributedPrice`, `attributedStock`를 생성해주었습니다. 또한 여기서 직접 color와 font, strikethroughStyle을 적용시켜줄 수 있도록 했습니다. 

### 4. extension UIViewController

`ProductsCollectionViewController`, `ProductsTableViewController`에서 중복되는 코드를 `UIViewController`의 extension 함수 하나로 분리했습니다.

```swift
case .failure(let error):
    self.showAlert(
        title: "Network error",
        message: "데이터를 불러오지 못했습니다.\n\(error.localizedDescription)"
    )
    self.loadingActivityIndicator.stopAnimating()
}

extension UIViewController {
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
```

### 5. extension Data

NetworkTask.buildBody(from:images:)의 가독성을 높이기 위한 것입니다.

```swift
// 변경전
var data = Data()
var paramsBody = ""
paramsBody.append("--\(boundary)\r\n")
paramsBody.append("Content-Disposition: form-data; name=\"params\"\r\n\r\n")
guard let paramsBody = paramsBody.data(using: .utf8) else {
    return nil
}
data.append(paramsBody)
```

```swift
// 변경후
var data = Data()
data.append("--\(boundary)\r\n")
data.append("Content-Disposition: form-data; name=\"params\"\r\n\r\n")

private extension Data {
    mutating func append(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.append(data)
    }
}
```

### 6. 스토리보드 파일 분리

협업시 충돌 방지를 위해서 스토리보드 파일을 분리했습니다.

### 7. 통화 줄바꿈 문제 해결

통화 이름과 숫자 사이의 공백이 줄바꿈 되지 않도록 수정했습니다.
`" "` 대신 `"\u{A0}"` 를 사용합니다.

전 | 후
-- | --
![usdAfter](README_IMAGES/usdBefore.png) | ![usdAfter](README_IMAGES/usdAfter.png)

### 8. 컬렉션 뷰 가로화면에서 셀 크기 개선

가로로 디바이스를 돌릴 경우 컬렉션 뷰의 셀 크기가 너무 커지는 문제가 있었습니다. 

따라서 frameWidth가 frameHeight보다 작은 경우(세로인 경우)는 기존대로 frameWidth를 기준으로 Cell의 너비를 정해줬으나, 가로로 돌렸을 때에는 frameHeight을 기준으로 Cell의 너비를 정할 수 있도록 구현했습니다. 

```swift
let frameWidth = collectionView.frameLayoutGuide.layoutFrame.width
    let frameHeight = collectionView.frameLayoutGuide.layoutFrame.height
    let shortLength = frameWidth < frameHeight ? frameWidth : frameHeight
    let cellWidth = shortLength / 2 - 15
    return CGSize(width: cellWidth, height: cellWidth * 1.5)
```

### 9. Pagination 구현

기존에는 1페이지의 아이템 20개만 로드되는 문제가 있었습니다. 

페이지를 넘기면 새로운 데이터가 로드될 수 있도록 `collectionView(_:willDisplay:forItemAt:)` 메서드를 사용하여 indexPath의 item이 전체 products의 개수와 같은 경우 새로운 페이지를 로드하고 pageNumber를 1 추가할 수 있도록 구현했습니다. 

tableView의 경우도 동일한 매개변수를 가진 메서드를 사용해 문제를 해결했습니다. 

## 💡 새롭게 알게 된 점

### 1. 셀의 높이가 변하지 않음

레이아웃의 제약끼리 충돌이 있어서 셀의 크기가 늘어나지 않는 문제가 있었습니다.

이유는 테이블뷰 셀의 이미지뷰가 스택뷰안에 들어가있고, 이 안에서 너비를 60을 유지하며 높이는 이와 동일하게 가져가려하기 때문이었습니다.

이미지뷰를 스택뷰 밖으로 빼서 해결했습니다.

### 2. 의존성 주입을 통한 JSONParser 및 NetworkTask 전달

기존에는 CollectionView와 TableView에 직접 jsonParser 및 networkTask의 인스턴스를 생성하여 이를 사용했습니다. 

하지만 이 경우 `instantiateViewController(identifier:creator:)`메서드를 사용하여 의존성 주입을 할 수 있도록 구현했습니다. 

하지만 이는 추후 TableViewController와 CollectionViewController가 유연성과 변동성이 일반 ViewController에 비해 떨어진다고 판단하여 현재 관련 코드는 삭제한 상황입니다. 

## ❓ 아직 해결하지 못한 점

### 1. iOS 13, 14 시뮬레이터에서 컬렉션 뷰 이미지 다운로드가 이상함

비정상 | 정상
-- | --
![비정상](README_IMAGES/ios13.0.gif) | ![정상](README_IMAGES/ios15.0.gif)

iOS 15에선 CollectionView, TableView 모두 이미지를 잘 받아왔습니다. 하지만 ios13.0, 13.2, 14.0 시뮬레이터로 테스트를 했을 때에는 컬렉션 뷰만 이미지 일부가 다운로드되지 않는 문제가 있었습니다. 

테이블 뷰에선 버전 차이 없이 이미지 다운로드가 원활히 됐는데, 컬렉션 뷰에서만 이미지 다운로드가 잘 되지 않아 이유를 고민해보았지만 원인을 찾을 수 없었습니다.