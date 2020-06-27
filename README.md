# UnsplashClone

원본 앱
https://apps.apple.com/us/app/unsplash/id1290631746?ls=1

- Unsplash Api 를 이용하여 랜덤 이미지를 출력해주는 어플리케이션
- 하단 스크롤시 이미지 추가 로드
- 이미지 선택시 상세보기
- 이미지 검색 기능

- MVVM 구조 
- RxSwift 사용하여 데이터바인딩 
- RxCocoa 사용하여 UI 이벤트 처리 


사용한 외부 라이브러리

SPM

Then : https://github.com/devxoul/Then.git
코드문법 정리용


CocoaPods

ALLoadingView : https://github.com/ALoginov/ALLoadingView.git
로딩뷰

Toast-Swift : https://github.com/scalessec/Toast-Swift.git
메세지 표시용 토스브 뷰 라이브러리

RxSwift : https://github.com/ReactiveX/RxSwift.git
반응형 프로그래밍 라이브러리
RxCocoa : https://github.com/ReactiveX/RxSwift.git
반응형 프로그래밍을 UIKit에 적용하기 위한 라이브러리
RxDataSources : https://github.com/RxSwiftCommunity/RxDataSources.git
데이터기반 컬렉션뷰, 테이블뷰 dataSource 매핑 라이브러리
RxReachability : https://github.com/RxSwiftCommunity/RxReachability.git
디바이스의 네트워크 상태 확인용 
RxAlamofire : https://github.com/RxSwiftCommunity/RxAlamofire.git
네트워크 라이브러리 Alamofire를 Rx방식으로 사용하게 해주는 라이브러리

DeallocationChecker :  https://github.com/fastred/DeallocationChecker.git
Viewcontroller의 메모리누수를 찾는 용도

Kingfisher : https://github.com/onevcat/Kingfisher.git
이미지 다운로드 및 캐싱 라이브러리
