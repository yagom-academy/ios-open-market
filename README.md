# 오픈마켓 프로젝트 학습


### 타임라인

- 05/31(월)
  - 강의) Core Data, Database
- 06/01(화)
- 06/02(수)
- 06/03(목)
- 06/04(금)


<br>

### 학습키워드

<br>

### 트러블슈팅 (Troubleshooting)

<br>

### 참고 링크


<br>

# Step1

### API 모델 타입 구현



<details>
<summary>Response</summary>
<div markdown="1">

<br>

- ItemPage
  
```swift
struct ItemPage: Decodable {
    var page: Int
    var items: [ItemShortInfo]
}

struct ItemShortInfo: Decodable {
    var id: Int
    var title: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    var thumbnails: [String]
    var registrationDate: Int
    
    private enum CodingKeys: String, CodingKey {
        case id, title, price, currency, stock, thumbnails
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
```
  
- ItemDetail
  

```swift
struct ItemDetail: Decodable {
    var id: Int
    var title: String
    var descriptions: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    var thumbnails: [String]
    var images: [String]
    var registrationDate: Int

    private enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, thumbnails, images
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
```

</div>
</details>






<details>
<summary>Request</summary>
<div markdown="1">    
  
  <br>
  
- ItemRegistraion

```swift
struct ItemRegistration {
    var title: String
    var descriptions: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    var images: [String]
    var password: String
    
    private enum CodingKeys: String, CodingKey {
        case title, descriptions, price, currency, stock, images, password
        case discountedPrice = "discounted_price"
    }
}
```

- ItemModification
  
```swift
struct ItemModification {
    var title: String?
    var descriptions: String?
    var price: Int?
    var currency: String?
    var stock: Int?
    var discountedPrice: Int?
    var images: [String]?
    var password: String
    
    private enum CodingKeys: String, CodingKey {
        case title, descriptions, price, currency, stock, images, password
        case discountedPrice = "discounted_price"
    }
}
```
  
</div>
</details>

<br>

