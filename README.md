# 오픈마켓 II
> 프로젝트 기간 2022.05.23 ~ 2022.06.03 </br>
팀원 : [@Lingo](https://github.com/llingo) [@쿼카](https://github.com/Quokkaaa) / 리뷰어 : [@혀나노나](https://github.com/hyunable)

## 목차

- [키워드](#키워드)
- [STEP 1](#STEP-1)
    + [고민 및 알게된 점](#고민-및-알게된-점)
    + [해결한 점](#해결한-점)
    + [조언받고 싶은 점](#조언받고-싶은-점)
- [STEP 2](#STEP-2)
    + [고민 및 알게된 점](#고민-및-알게된-점)
    + [해결한 점](#해결한-점)
    + [조언받고 싶은 점](#조언받고-싶은-점)
- [그라운드 룰](#그라운드-룰)
    + [활동시간](#활동시간)
    + [코딩 컨벤션](#코딩-컨벤션) 

---

## 키워드
- `URLSession`
- `URLSessionDataTask`
- `Mock 객체`
- `HTTP Request / Response`
- `Result 타입`
- `@escaping Closure`
- `UICollectionView`
- `UIActivityIndicator`
- `UISegmentControl`
- `AutoLayout`
- `Multipart/form-data`
- `UITextView`
- `UITextViewDelegate`
- `NotificationCenter`
- `UIImagePickerController`
- `UIImagePickerControllerDelegate`
- `UIGraphicsImageRenderer`
- `UINavigationControllerDelegate`
- `UISwipeGestureRecognizer`

---

## STEP 1
### 고민 및 알게된 점
- Multipart/form-data의 구성에 대해서 학습하였습니다.
- 클라이언트가 서버에 Multipart/form-data 형식에 맞춰 데이터를 전송하는 원리에 대해 학습하였고 어떻게 추상화를 할 수 있을지 고민하였습니다.
- UI를 코드로 구현을 할것인가, 스토리보드로 구현할 것인가에 대해 고민하였고 코드로 구현해보았습니다.
- 이미지 크기를 줄이는 방법에 대해 고민했습니다.
- Miro를 통해 UI를 기능 구현에 대해 구상해보았습니다.😃

<img width="400px" src="https://i.imgur.com/EtC6F9u.png"/>

**Modal 방식과 역할에 대해**
Modal 방식으로 화면 전환할 때 `modalPresentationStyle = .fullScreen`과 `backgroundColor` 설정을 어느 ViewController에서 하는 것이 맞는 지를 고민했습니다.

present한 이후에 fullscreen을 설정하면 이미 뷰를 로드된 이후이기에 ListVC에서 설정하는게 맞고 backgroundColor같은 경우에는 해당 뷰에서 해주는 것이 좋다고 판단을 했습니다.

**leading과 left, trailing과 right 차이에 대해**
한국은 왼쪽에서 오른쪽으로 읽고 아랍에서는 우측에서 좌측으로 읽는 것처럼 나라마다 글자를 읽는 방향이 다르기 때문에 leading과 trailing으로 따로 두었다는 것을 알 수 있었습니다.

<img width="500px" src="https://i.imgur.com/xLbDpnC.png"/>

**UIImagePicker구현에 대해서**
info파일에서 
Privacy - Photo Library Additions Usage Description 를 설정 해줌으로써 포토라이브러리에 접근할 수 있는 권한을 허용해준다는 것으로 이해했습니다.
추가로 Privacy - Photo Camera Usage Description을 추가하게되면 카메라에 접근할 수 도 있으나 추측해보기론 시뮬레이터가 카메라 기능이 존재하지않기에  에러가나는것을 볼 수 있었습니다. 그래서 앨범에 접근하는 기능만 구현해보았습니다.



**TextView의 글자수 제한하는 방법에 대해**
TextView 글자수를 제한하는 방법으로 아래의 2가지 방법을 시도해봤으며 2번의 방법을 적용했습니다.

1. textView(_:shouldChangeTextIn:replacementText:) 메서드를 사용하는 방법
```swift
func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
  guard let str = textView.text else { return true }
  let newLength = str.characters.count + text.characters.count - range.length
  return newLength <= 1000
}

// 참고)
// https://mizzo-dev.tistory.com/entry/iOSSwift-TextField-TextView-%EA%B8%B8%EC%9D%B4-%EC%A0%9C%ED%95%9C%ED%95%98%EA%B8%B0-maxLength
```

2. textViewDidChange에서 deleteBackward를 사용하여 초과할 시 지워주는 방식
```swift
func textViewDidChange(_ textView: UITextView) {
  if textView.text.count > Const.Limit.maximumTextCount {
    textView.deleteBackward()
  }
}
```
**ImageResize에 대해서** 🤔
Imageresize하는 로직의 코드를 이해하고 리사이즈 방법의 두가지와 둘의 용량 차이에 대해서 알아보았습니다. 크게 `UIGraphicsBeginImageContext`인 구식과 `UIGraphicsImageRenderer`인 신식의 방법이 존재했습니다. 

<img width="400px" src="https://i.imgur.com/gQbEhOc.png"/>

jpegData로 byte의 크기를 확인하였습니다. 
시도해본결과 구식보다 신식의 용량이 더 작다는걸 확인하였습니다. 그리고 정확한 이유는 모르겠으나 2018 wwdc image resize에 대한 내용에서 신식을 사용하라고 권장하여서 결론적으로 renderer방식으로 구현하였습니다.

[참고 자료](https://nsios.tistory.com/154)

**TextView 입력시 키보드가 가려지지 않는 방법에 대해**
TextField일 경우 키보드로 인해 가려지지 않지만 TextView는 가져지는 현상이 있었습니다.
문제를 해결하기 위해 키보드 높이만큼 View의 위치를 올려주도록 하였고 아래의 순서로 동작하도록 구현했습니다.

1. 키보드의 높이를 알기 위해 Notification Center를 사용하여 `UIREsponder.keyboardWillShow`와 `UIResponder.keyboardWillClose`로 키보드가 보여질 때/사라질 때의 Notification을 관측하도록 옵저버를 등록한다.
2. TextView가 클릭될 때 keyboardWillShow Notification이 불리면 등록된 옵저버의 selector 메서드를 통해 받은 키보드 높이를 저장한다.
3. CGAffineTransform을 통해 view의 y축을 키보드 높이만큼 올린다. 
4. TextView의 편집모드가 종료되면 `transform = .identity`로 원래대로 view의 위치를 되돌린다.

TextView의 편집모드가 종료하는 방법으로 view의 touchBegan 메서드를 사용하는 방법이 있었지만 사용자에게 입력받을 수 있는 영역이 좁기 때문에 TextView에 Down Swipe 제스처를 인식할 수 있는 `UISwipeGestureRecognizer`를 등록해주어 제스처가 발생하면 `endEditing`하는 방법으로 사용자 편의를 생각했습니다! 🤩

[참고 자료](https://fluffy.es/move-view-when-keyboard-is-shown/)

---

### 해결한 점
**textView클릭시 keyboard가 빠르게 올라가는 현상**
textView를 클릭하게되면 View를 keyboard높이만큼 올려주고 Gesture를 밑으로 주면 다시 View가 keyboard가 내려가는 로직입니다.
그런데 Gesture를 밑으로 동작하여 키보드가 내려갈때 키보드와 view가 내려가는 속도가 다르다보니 컴은색 창이 잠시 보이게되는 현상이 발생하였습니다.
이를 `UIView.animate(withDuration: 0.2)`로 낮춰주었더니 키보드 내려가는 속도가 비슷해져 검은색 에러가 해결되었습니다.

---

### 조언받고 싶은 점
**Xcode 문제 발생** 
Xcode에서 boringssl_metrics_log_metric_block_invoke 문제가 있었습니다.
서버에게 API 요청을 하지 않았을 땐 경고가 발생하지 않는 것을 확인했고 [How to eliminate boringssl log warning?: Developer Forum](https://developer.apple.com/forums/thread/697026)을 통해 Xcode가 네트워크 연결이 제대로 되지 않아 발생한 문제로 파악했고 링크된 StackOverFlow에서 Xcode scheme 설정에서 `OS_ACTIVITY_MODE`를 `disable`로 설정하여 해결은 가능했지만 전체를 NSLog 꺼버리는 것이므로 근본적인 해결 방법이 되진 못할 것 같은데 좋은 방법이 있을지 궁금합니다.🥲

**ViewController와 View분리에 대한 고민?**
viewController에 모든 코드를 다 작성을 했다보니 코드가 대략 400줄정도 나온 것같습니다. 그런데 코드 수정할때나 조금 번거롭다는걸 느꼈습니다. 분리하는 것이 좋을 지 400줄도 작은 편인지 궁금합니다.

---

## STEP 2
### 고민 및 알게된 점


---

### 해결한 점


---

### 조언받고 싶은 점


---

## 그라운드 룰

### 활동시간
### 📚 공통
- 10시 ~ 12시

### 세션 있는 날 (월/목)
- 세션 후) 17시 ~ 18시
- 식사 후) 20시 ~ 22시+

### 세션 없는 날 (화/수/금)
- 식사 후) 14시 ~ 18시

---

### 코딩 컨벤션
- Swift Lint 적용
- UI를 코드로 구현하기

**Swift 코드 스타일**
- 코드 스타일은 [스타일쉐어 가이드 컨벤션](https://github.com/StyleShare/swift-style-guide#%EC%A4%84%EB%B0%94%EA%BF%88)에 따라 진행한다.

**커밋 규칙**
- 커밋 제목은 최대 50자 입력
- 본문은 한 줄 최대 72자 입력

**커밋 제목 규칙**
- 제목 끝에 마침표(.) 금지, 한글로 작성

**커밋 메세지**
```
feat: [기능] 새로운 기능 구현.
fix: [버그] 버그 오류 해결.
refactor: [리팩토링] 코드 리팩토링 / 전면 수정이 있을 때 사용합니다
style: [스타일] 코드 형식, 정렬, 주석 등의 변경 (코드 포맷팅, 세미콜론 누락, 코드 자체의 변경이 없는 경우)
test: [테스트] 테스트 추가, 테스트 리팩토링(제품 코드 수정 없음, 테스트 코드에 관련된 모든 변경에 해당)
docs: [문서] 문서 수정 / README나 Wiki 등의 문서 개정.
chore: [환경설정] 코드 수정, 내부 파일 수정
```

**브랜치 이름 규칙**
`STEP1`, `STEP2`
