
# 🛍 오픈마켓 OPEN MARKET
> **프로젝트 기간** : 2022.07.21 목  ~ 2022.07.29 금 </br>**리뷰어** : [콘](@protocorn93)
---
## 🪧 목차
- [📜 프로젝트 소개](#-프로젝트-소개)
- [👥 팀원](#-팀원)
- [💾 개발환경 및 라이브러리](#-개발환경-및-라이브러리)
- [💡 Step3 핵심경험](#-step3-핵심경험)
- [🕰 타임라인](#-타임라인)
- [📱 구현 화면](#-구현-화면)
- [🧑‍💻 코드 설명](#-코드-설명)
- [⛹🏻‍♀️ STEP 3 트러블 슈팅](#%EF%B8%8F-step-3-트러블-슈팅)
- [⌨️ 커밋 규칙](#%EF%B8%8F-커밋-규칙)
- [🔗 참고 링크](#-참고-링크)


<br>

## 📜 프로젝트 소개
> 물건 팔아요~ 오픈 마켓<br>
> 상품 목록 리스트와 그리드 뷰 형식으로 보여주는 화면 구성, 새로운 상품을 등록할 수 있는 화면 구성, 실제 서버와 통신하여 등록한 상품을 생성할 수 있는 기능.

<br>

## 👥 팀원

| **재재(ZZBAE)** | **주디(Judy)** |
|:---:|:---:|
|![](https://i.imgur.com/Xa9oBRA.png)|<img src="https://i.imgur.com/n304TQO.jpg" width="400" height="400" />|
|[Github](https://github.com/ZZBAE)|[Github](https://github.com/Judy-999)|

<br>

## 💾 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]() [![xcode](https://img.shields.io/badge/Xcode-13.4.1-blue)]()
<br>


## 💡 Step3 핵심경험
- [x] multipart/form-data의 구조 파악
- [x] URLSession을 활용한 multipart/form-data 요청 전송
- [x] 사용자 친화적인 UI/UX 구현 (적절한 입력 컴포넌트 사용, 알맞은 키보드 타입 지정)
- [x] UIAlertController 액션의 completion handler 활용
- [x] UIAlertController의 textFields 활용
- [x] UICollectionView 를 통한 좌우 스크롤 기능 구현

<br>

## 🕰 타임라인

**둘째 주**
| 날짜 | 내용 |
|:----:|:---:|
|**7/21(목)**|개인 공부|
|**7/22(금)**|리드미 작성 및 STEP 2 리뷰 반영 리팩토링 진행|

**셋째 주**
| 날짜 | 내용 |
|:----:|:---:|
|**7/25(월)**|step2의 간단한 리팩토링 및 multipart-formdata 공부|
|**7/26(화)**|서버와 소통하는 post, patch, delete 연습용 코드로 multipart-formdata 기능 구현|
|**7/27(수)**|상품등록화면 구성 구현, UIImagePickerController 활용하여 이미지 부분 구현|
|**7/28(목)**|상품등록 textView와 키보드, 연습용 코드를 실제 서버와 소통할 수 있게끔 수정, 상품등록화면을 상품수정화면으로 재사용할 수 있게끔 구현|
|**7/29(금)**|추가 리팩토링, Readme.md 작성 및 step 1 PR|

<br>

---

## 📱 구현 화면

| 상품의 ListView | 상품의 GridView | 상품을 등록하는 화면 |
|:---:|:---:|:---:|
|![](https://i.imgur.com/qODkdGJ.gif)|![](https://i.imgur.com/LXZsYu6.gif)|![](https://i.imgur.com/djsjE9H.gif)|

| 상품 기본 정보 입력 | 상품 상세 설명 입력 | 상품의 이미지 최대 5장까지 추가 |
|:---:|:---:|:---:|
|![](https://i.imgur.com/YjFMx7A.gif)|![](https://i.imgur.com/AOUbqYN.gif)|![](https://i.imgur.com/4gvsZuo.gif)|
|상품명, 상품가격, 할인가격, 재고수량 정보 입력할 때 해당 키보드가 나오게끔 구현|상품의 상세 설명이 길어져도 밑에서 올라오는 키보드가 설명칸을 가리지 않게끔 구현|상품 이미지를 정사각형으로 넣을 수 있고, 1장 ~ 5장을 추가할 수 있도록 구현|

---

## 🧑‍💻 코드 설명
**[ STEP 3 ]**

### **Model** 
#### **Param**
> 상품 등록 화면에 표시되는 해당 상품 정보들의 타입
- `vendorInfo`: 판매자의 `secret`과 `identifier`를 담은 열거형
- `Param`: productName(상품명), price(상품가격), discountedPrice(할인가격), currency(통화단위), stock(재고수량), description(상품상세설명), secret(VendorInfo의 사용자 비밀번호)
- `ImageParam`: imageName(이미지 파일 이름), imageType(이미지 파일 타입), imageData(이미지 데이터 타입)
<br>

### **View**
#### 화면 구성 정리본
<img src="https://i.imgur.com/uo6MJEY.png" width="500" height="500" />


#### 1) AddProductView
> 새로운 상품을 등록(또는 수정)하는 화면
- `arrangeSubView`: 요소들을 `SubView`에 넣고 제약을 설정하는 메서드 
- `createParam`: 입력된 정보들을 `Param`으로 반환해주는 메서드
- `configure`: `Param`의 각 요소들을 각각의 칸`(TextField)`에 넣어주는 메서드

#### 2) AddProductCollectiongViewCell
> 상품 등록 화면에서 이미지의 설정을 해주는 셀
- `arrangeSubView`: 상품 이미지의 constraint를 설정해주는 메서드
<br>

### ViewController
#### AddProductViewController
> 상품등록(또는 수정)하는 뷰를 관리하는 컨트롤러 
- `changeToEditMode`: 상품등록화면을 상품수정화면에서 사용할 수 있게끔 해주는 메서드
- `configureUI`: 상단의 네비게이션 아이템 넣어준 부분의 layout 잡아주는 메서드
- `goBack`: 상품리스트 화면으로 돌아가는 objc 메서드
- `goBackWithUpdate`: 상품의 정보들을 입력해준 후 post 해주고, 성공과 실패의 얼럿을 띄워주는 메서드
- `CollectionView's DataSource & Delegate`: `UICollectionViewDataSource`, `UICollectionViewDelegate`를 채택하여 뷰를 재사용할 수 있고, 이미지의 indexPath를 계산하여 얼럿을 띄워주고 제약을 걸어주는 메서드
- `ImagePickerController`: `UIImagePickerControllerDelegate`와 `UINavigationControllerDelegate`를 채택하여, post할 이미지의 설정과 제약을 걸어주는 메서드
- `UITextView`: `textView`에 작성을 시작하고 끝낼때의 `viewConstraint`를 조절해주는 메서드
<br>

---

## ⛹🏻‍♀️ STEP 3 트러블 슈팅
### 1. 텍스트뷰 자동 스크롤 
**TextView**에 글자를 입력 시 글자가 키보드에 가려지지 않게 즉 키보드 위로 자동으로 스크롤되도록 하는 요구사항이 있습니다. 키보드 위로 글자가 보이게 하는 방법을 세가지로 시도해봤습니다.

#### 1) StackView의 Constraint 변경
```swift
extension ProductViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        productView.entireStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -300).isActive = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        productView.entireStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
    }
}
```
첫 번쩨는 **TextView**가 속해있는 **StackView**의 **Constraint**를 변경해보려고 했습니다. 키보드 크기만큼 **bottom**을 올렸다가 입력이 끝나면 내리도록 했는데 올리는 것은 성공했으나 다시 내려오지 않았습니다.

#### 2) View의 높이 변경
```swift
extension ProductViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
         view.frame.size.height -= 300
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        view.frame.size.height += 300
    }
}
```
두 번째 방법으로 전체 **View**의 높이를 변경해봤습니다. 키보드 크기만큼 올린 후 다시 내려오는 것이 가능했으니 빈 부분이 검정색으로 보이고 **View**가 압축되어 일그러졌습니다.

#### 3) Content Offset 변경
```swift
extension ProductViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        productView.descriptionTextView.setContentOffset(CGPoint(x: 0, y:  productView.descriptionTextView.contentSize.height - productView.descriptionTextView.bounds.height + 300), animated: false)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        productView.descriptionTextView.setContentOffset(CGPoint(x: 0, y:  productView.descriptionTextView.contentSize.height - productView.descriptionTextView.bounds.height), animated: false)
    }
}
```
마지막으로는 **TextView**의 스크롤의 커서 위치를 조절하려 했습니다. 하지만 입력을 시작하자마자 키보드 위치로 커서가 이동해버렸고, 입력을 끝내면 다시 위로 이동시키는 것이 어려웠습니다.

#### 시도했던 방법의 예시와 문제점
| StackView| View    | Content Offset   |
| :---: | :---: | :-------------: |
| ![](https://i.imgur.com/5zIHntC.gif)              | ![](https://i.imgur.com/jsvOAix.gif) | ![](https://i.imgur.com/UIqfDXS.gif)                      |
| TextView의 크기가 줄어들었으나 다시 돌아오지 않음 | 위로 올라간 후 다시 내려오지만 view가 압축되어 일그러짐   | 처음부터 중간에서 시작하게 되고 입력이 끝나면 아래로 이동 |

<br>

#### (최종) 첫 번째 방법 사용
최종적으로 첫 번째 방법을 사용했습니다. 첫 시도에서 발생했던 문제는 계속 새로운 **Constraint**를 추가해서 상충됐기 때문이었습니다. 

```swift
private lazy var viewConstraint = productView.entireStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -260)

extension AddProductViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        viewConstraint.isActive = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        viewConstraint.isActive = false
    }
}
```
하나의 **Constraint**를 선언해 `isActive`를 조절하는 방식으로 했습니다. 또한 기본적으로 뷰를 구성할 때 지정한 **bottom** 제약의 **Priority**를 낮춰서 상충없이 동작하도록 구현했습니다.
<br>

### 2. 스크롤 시 상품에 맞지 않는 이미지가 나오는 문제 해결
빠르게 스크롤 하다보면 엉뚱한 사진이 띄워져 있는 문제가 있었습니다. 서버를 통해 사진을 받아오는 요청은 비동기로 진행되고, **Cell**이 재사용되기 때문에 발생하는 문제였습니다. 사진의 용량이 크거나 느린 네트워크일 경우 이전에 요청한 사진이 뒤늦게 돌아와서 잘못된 이미지가 떴습니다.

[**문제 예시 - 제다이가 된 주디와 웡빙 (원래는 연예인 사진)**]

<img src="https://i.imgur.com/TnUm6tg.jpg" width="250" height="500" />

<br>이미지를 요청한 **Cell**과 현재 **Cell**이 일치하지 않았을 때의 문제이므로 **Cell**에 이미지를 할당하기 전에 이미지를 요청했던 **Cell** 비교하여 **Cell**이 일치한 경우에만 이미지를 넣도록 하여 해결했습니다.

```swift
 guard indexPath == self.collectionView.indexPath(for: cell) else { return }
```
<br>

### 3. 상위 셀 생성해 상속받기
이전 스텝에서 사용한 **LIST**와 **Grid Cell**이 중복된 코드가 많아 해결하고 싶었습니다.
`UICollectionViewCell`을 상속받는 `MarketCollectionViewCell`을 생성해 중복되는 UI와 메서드를 갖도록 했습니다. 이후 **LIST**와 **Grid Cell**이 `MarketCollectionViewCell`를 상속받아 사용할 수 있도록 하여 코드의 중복을 줄이고 추상화해 줄 수 있었습니다.
<br>

### 4. Alert은 Main Thread에서 실행하기
**get**이나 **post**와 같은 서버 요청이 실패한 경우 얼럿을 띄워 사용자에게 알려주도록 했는데 통신이 실패했을 때 얼럿이 뜨지 않고 아래와 같은 에러가 발생했습니다.

**Alert을 메인 스레드에서 하지 않았을 때 나타난 에러**
![](https://i.imgur.com/IkZy5AD.png)

얼럿을 띄우는 것 역시 UI 동작이기 때문에 `Main Thread`에서 실행되도록 변경해 해결했습니다.
<br>



## ⌨️ 커밋 규칙
* feat    : 기능 추가 (새로운 기능)
* refactor : 리팩토링 (네이밍 수정 등)
* style   : 스타일 (코드 형식, 세미콜론 추가: 비즈니스 로직에 변경 없음)
* docs    : 문서 변경 (문서 추가, 수정, 삭제)
* test    : 테스트 (테스트 코드 추가, 수정, 삭제: 비즈니스 로직에 변경 없음)
* chore   : 기타 변경사항 (빌드 스크립트 수정 등)
<br>

## 🔗 참고 링크

**[Step 3]**<br>
[UIImagePickerController 를 사용해 이미지 수정 및 가져오기](https://silver-g-0114.tistory.com/44)<br>[MultiPart통신 (멀티파트 이미지업로드)](https://nsios.tistory.com/39)<br>[URLSession으로 multipart/form-data request하기-wody](https://wody.tistory.com/16)<br>[UIImagePickerControllerDelegate](https://developer.apple.com/documentation/uikit/uiimagepickercontrollerdelegate)<br>[UITextViewDelegate](https://developer.apple.com/documentation/uikit/uitextviewdelegate)
