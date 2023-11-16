> 👆🏻 여기 햄버거 버튼을 눌러 목차를 확인하세요.

## 1. 프로젝트 소개

<img width="900" alt="image" src="https://user-images.githubusercontent.com/53863005/278953655-02aae5ad-379e-492c-8b67-a123df396d99.png">

> 마음 한 켠에 자리잡은 불필요한 감정은 메모를 통해 해소하세요. 휘발이에 쌓인 **감정쓰레기**를 자동으로 **휘발**시켜 드릴게요.

- **개요:** iOS 앱개발 프로젝트
- **팀원:** [이대현](https://github.com/hidaehyunlee), [김서온](https://github.com/anfgbwl), [김도윤](https://github.com/doyuny), [서동준](https://github.com/june-hehe) 총 4명
- **개발 기간:** 2023/10/10 ~ 2023/11/17
- **프로젝트 저장소**: [Github 바로가기](https://github.com/hidaehyunlee/HWIBAL)
- **서비스 주소:** [AppStore 바로가기](https://apps.apple.com/kr/app/%EC%95%84-%ED%9C%98%EB%B0%9C/id6471419210)

<br>

## 2. 기술구조

- **UI**: `UIKit`, `SnapKit`, `Figma`
- **Communication**: `Slack`, `Gather`, `Notion`
- **Architecture**: `MVC`
  - Model: CoreData, UserDefaults 등과 연결되어 영속적으로 관리할 Raw한 데이터 모델
    - Service: Model의 데이터를 View에 표시할 내용으로 정리하고 변환하며, CRUD와 추가 비즈니스 로직을 제공하는 클래스
  - View: UI 컴포넌트를 생성하고 오토레이아웃을 설정하는 클래스
  - ViewController: Navigation, Event, Life Cycle 등을 담당하는 클래스
- **Data** **Storage**: `CoreData`, `UserDefaults`
- **Library**/**Framework**:
  - [SnapKit](https://github.com/SnapKit/SnapKit): UIKit에서 AutoLayout을 보다 쉽게 작성하기 위해 도입하였습니다.
  - [EventBus](https://github.com/swiftarium/EventBus): 특정 상황(이벤트)이 발생했을 때 특정 동작을 수행하기 위해 도입하였습니다.
  - [GoogleSignIn-iOS](https://github.com/google/GoogleSignIn-iOS): 소셜 회원가입을 지원하기 위해 도입하였습니다.
  - [DGCharts](https://developer.apple.com/documentation/Charts): 감정쓰레기 데이터를 그래프로 시각화하기 위해 도입하였습니다.
  - [AVFAudio](https://developer.apple.com/documentation/avfaudio): AVAudioPlayer와 AVAudioRecorder를 사용하기 위해 도입하였습니다.
  - [DSWaveformImage](https://github.com/dmrschmidt/DSWaveformImage): Audio Visualizer를 구현하기 위해 도입하였습니다.

<br>

## 3. 프로젝트 관리

### 3.1. 일정 및 화면별 세부정책

🔗 [프로젝트 관리시트 바로가기](https://docs.google.com/spreadsheets/d/1Xh4y6FqQQsccTn6iG3ArMeJX8OvLOkX86jnjIZrqA0k/edit#gid=1115838130)

- Google Spreadsheets를 사용해 프로젝트 일정을 관리했습니다.
- 화면별 Test Case를 생성하고 각 TC Item에 맞는 Expected Result를 작성해 화면별 세부정책을 수립했습니다.



### 3.2. 와이어프레임

🔗 [Figma 바로가기](https://www.figma.com/file/dzDWbY4xDzeRMc0DwirjPp/HWIBAL?type=design&node-id=1-743&mode=design&t=iQj4D30SdnBWVb1C-0)

<img width="900" alt="image" src="https://user-images.githubusercontent.com/53863005/278954894-6fa80995-87b4-498a-a46c-55ea21c98b24.png">

- IA(정보구조)를 기반으로 화면을 구성했습니다.



### 3.3. 커뮤니케이션 전략

- **Git-Flow 전략**
  - `main` : 최종적으로 완성되었을때 사용할 배포용 브랜치
  - `dev` : 유지 보수와 기술개발 등 하기위해 메인에서 생성한 브랜치, 안정성을 위해 main이 아닌 dev를 default 브랜치로 설정
  - `feature`: 기능 개발 브랜치,
    - 작업 진행시 최신 dev에서 `feature-작업명`으로 생성
    - 기능작업이 완료 된 후 **dev로 PR 생성**
- **Commit Message 전략**
  - [FEAT] : 👍 새 기능 구현
  - [FIX] : 🐛 기존 기능/버그 수정
  - [RENAME] : ✏️ 파일 혹은 폴더명을 수정하거나 옮기는 작업만인 경우
  - [DOCS] : 📚 주석/문서 수정
  - [TEST] : 📝 테스트 코드
  - [MERGE] : ✅ 병합
  - [CONFLICT] : 💥🚚  병합 시 충돌 해결
- **Pull Request 전략**
  - 커밋 후에 push하고 Draft PR 생성
    - Reviewers : 현재 PR을 리뷰를 해 줄 팀원을 지정
    - Assignees : 현재 PR 작업의 담당자(본인)를 지정
  - PR 생성 후 슬랙 채널에 공유해서 리뷰를 부탁해주세요.
  - UI 변경이 있다면 PR에 꼭 **스크린샷**을 남겨주세요.
    - 스크린샷 첨부시 width=300로 변경해주세요.
- **Merge 전략**
  - 최소 1명의 승인을 받아야 merge 가능
    - `Approve` : Comment와 무관하게 리뷰어가 승인을 하는 것으로, 머지해도 괜찮다는 의견을 보내는 것
    - `Request changes` : 말 그대로 변경을 요청하는 것으로, 승인을 거부하는 것. 단, 이 경우 수정사항을 분명하게 comment로 전달해주세요.
  - Reviewers의 comments 및 승인이 완료되면 Assignees가 dev에 merge

- **Trouble Shootings 관리**
  - Github Issue 사용
    - dev 브랜치에서 발견한 버그, 앱 크래시 등을 기록합니다.
    - Assignees에 해당 기능을 맡은 팀원을 등록해주시고, 에러가 발생하는 시나리오(과정)를 자세히 적어주세요. 스크린샷도 있으면 좋습니다.
  - Issue를 close 할 때는 해결한 방법 혹은 해결한 `PR number`를 멘션해주세요.

<br>

## 4. 핵심경험
