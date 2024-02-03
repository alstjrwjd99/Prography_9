# Prography_9 AOS by Flutter

프로그라피 9기 AOS 사전 과제 - Flutter 어플리케이션

## 패키지 사용

- flutter_screenutil: ^5.9.0
- cached_network_image: ^3.3.1
- flutter_staggered_grid_view: ^0.7.0
- skeletonizer: ^1.0.1
- path_provider: ^2.1.2
- path: ^1.8.3
- sqflite: ^2.3.2
- get: ^4.6.6
- permission_handler: ^11.2.0

## 프로젝트 구조

프로젝트는 MVC (Model-View-Controller) 패턴을 기반으로 구성되어 있습니다.

- `lib/`: 소스 코드 파일이 위치하는 디렉토리
    - `model/`: 애플리케이션의 데이터 모델을 정의하는 파일들이 위치
    - `view/`: 사용자 인터페이스를 정의하고 관리하는 파일들이 위치
    - `controller/`: 비즈니스 로직을 처리하고 모델과 뷰를 연결하는 파일들이 위치
- `pubspec.yaml`: Flutter 프로젝트의 의존성 및 설정 정보

### `lib/model/`

모델 디렉토리에는 애플리케이션에서 사용되는 데이터 모델에 관한 파일들이 위치합니다.

- `DetailModel.dart`: 상세 페이지 데이터 모델 정의
- `FeedModel.dart`: 메인 화면 데이터 모델 정의
- `RandomFeedModel.dart`: 랜덤 화면 데이터 모델 정의

### `lib/view/`

뷰 디렉토리에는 사용자 인터페이스를 정의하고 관리하는 파일들이 위치합니다.

- `LatestImage.dart`: 메인 화면의 화면 정의
- `RandomPhoto.dart`: 랜덤 화면의 화면 정의
- `bottomNavigator.dart`: 두 페이지의 base가 되는 화면 정의

### `lib/controller/`

컨트롤러 디렉토리에는 비즈니스 로직을 처리하고 모델과 뷰를 연결하는 파일들이 위치합니다.

- `fileController.dart`: 북마크 기능을 위한 생성, 삭제, 불러오기 기능을 구현한 컨트롤러

## 메인 탭 (첫 번째 탭)

- **사진 목록 가져오기:** `GET https://api.unsplash.com/photos`
- **로딩 상태:** SkeletonView를 사용하여 로딩 중 표현
- **북마크:** LocalDB를 사용하여 북마크 구현
- **무한 스크롤:** 최하단에 도달하면 다음 이미지들을 불러올 수 있도록 구현

## 랜덤 포토 탭 (두 번째 탭)

- **랜덤 사진 가져오기:** `GET https://api.unsplash.com/photos/random`
- **옵션 1:**
    - 좌우로 넘길 수 있는 사진 카드 구현
    - 가운데 북마크 버튼 클릭 시 자동으로 다음 카드로 이동
- **옵션 2:**
    - 좌측 스와이핑 시 다음 카드로 이동
    - 우측 스와이핑 시 북마크 저장 후 다음 카드로 이동

## 포토 디테일

- **사진 디테일 가져오기:** `GET https://api.unsplash.com/photos/:id`
- **이미지 사이즈:** 고정 가로, 가변적인 세로 크기
- **북마크 상태 표시:** LocalDB에 저장된 북마크 여부에 따라 표시
- **북마크 버튼:** 우측 상단에 북마크 버튼, 클릭 시 북마크 저장 또는 취소

## Contributing

프로젝트에 기여하려면 다음 단계를 따르세요:

1. Fork the project
2. Create a new branch (`git checkout -b feature/new-feature`)
3. Make changes and commit (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Additional Information

For more information, contact [Your Name](mailto:ms990926@gmail.com).
