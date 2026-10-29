# Setup checklist — cấu hình base theo dự án

Dùng trong bước 4 của `/project-setup`. Mỗi nhóm: **khi nào làm** → **file cần sửa** → **kiểm chứng**. Đường dẫn tính từ gốc repo. Chỉ làm nhóm mà context yêu cầu.

---

## A. Định danh app

**Khi nào:** luôn làm (app không được giữ `lubase` / `com.example`).

Tên hiển thị:

| Nền tảng | File | Khoá |
|---|---|---|
| Android | `android/app/build.gradle.kts` | `resValue("string", "app_name", …)` của từng flavor (manifest dùng `@string/app_name`) |
| iOS | `ios/Runner/Info.plist` | `CFBundleDisplayName` (+ `CFBundleName`) |
| macOS | `macos/Runner/Configs/AppInfo.xcconfig` | `PRODUCT_NAME` |
| Web | `web/index.html`, `web/manifest.json` | `<title>`, `apple-mobile-web-app-title`, `name`, `short_name` |
| Windows | `windows/runner/main.cpp`, `windows/runner/Runner.rc` | tiêu đề cửa sổ, `FileDescription`, `ProductName` |
| Linux | `linux/runner/my_application.cc` | `gtk_header_bar_set_title`, `gtk_window_set_title` |

Bundle id / applicationId:

| Nền tảng | File | Khoá |
|---|---|---|
| Android | `android/app/build.gradle.kts` | `namespace`, `applicationId` (flavor `dev`/`stage` tự thêm hậu tố `.dev`/`.stg`) |
| Android | `android/app/src/main/kotlin/com/example/lubase/MainActivity.kt` | dòng `package` + **chuyển file** sang thư mục khớp package mới |
| iOS | `ios/Runner.xcodeproj/project.pbxproj` | mọi `PRODUCT_BUNDLE_IDENTIFIER` (Runner và `.RunnerTests`) |
| macOS | `macos/Runner/Configs/AppInfo.xcconfig` | `PRODUCT_BUNDLE_IDENTIFIER` |
| Linux | `linux/CMakeLists.txt` | `APPLICATION_ID` (và `BINARY_NAME` nếu muốn) |
| Windows | `windows/CMakeLists.txt` | `BINARY_NAME` (tuỳ chọn) |

Scheme deep link (`lubase://`): `android/app/src/main/AndroidManifest.xml` (`<data android:scheme>`), `ios/Runner/Info.plist` (`CFBundleURLSchemes`), hằng link trong `test/app_router_test.dart`, mục "Điều hướng & deep link" trong `CLAUDE.md`. Cần https App Links/Universal Links → thêm domain (intent-filter `autoVerify` + Associated Domains) và file xác minh trên server — hỏi domain trước.

Khác:
- `pubspec.yaml`: `description`, `version`.
- **Dart package name** (`name: lubase`) — chỉ đổi khi người dùng yêu cầu (xác nhận trước): sửa `name`, thay mọi `package:lubase/` trong `lib/` và `test/`, sửa `excludePaths` trong `lib/utils/logger/logger_helper.dart`, rồi `flutter pub get` + `make gen`.

Kiểm chứng: `grep -rn "lubase\|com\.example" android ios macos web linux windows pubspec.yaml lib test` chỉ còn những chỗ cố ý giữ; build nền tảng chính.

---

## B. Môi trường & base URL

**Khi nào:** luôn làm.

- `lib/data/services/api/api_constants.dart`: `devBaseUrl`, `prodBaseUrl` (+ `stagingBaseUrl` nếu có).
- `lib/core/config/app_flavor.dart`: `AppFlavorType`, `AppFlavorValue` (thêm staging nếu có).
- Base đã có 3 môi trường dev/stg/prod: `dart_defines/*.json` (`ENV`) + `.vscode/launch.json` + flavor Android `dev`/`stage`/`prod` (xem mục "Môi trường" trong `CLAUDE.md`). Việc cần làm: điền base URL thật cho từng môi trường trong `ApiConstants`; bỏ/thêm môi trường thì sửa đồng bộ các chỗ đó (`test/platform_config_test.dart` canh lệch).
- iOS chưa có flavor (scheme + xcconfig): chỉ tạo khi người dùng cần cài song song nhiều bản trên iOS — hỏi trước.
- `LoggerHelper` bật theo `kDebugMode`, không theo môi trường.

Kiểm chứng: `dart analyze`; chạy app trỏ đúng base URL (log `LoggerInterceptor` ở debug).

---

## C. Envelope API & lỗi

**Khi nào:** có tài liệu/ví dụ response của backend.

- Envelope (vd. `{success, data, msg}`): base trả thẳng object. Backend có envelope → tạo DTO generic trong `lib/data/models/common/` (`@JsonSerializable(genericArgumentFactories: true)`), `DioClient` trả nó và repository bóc `data`. Ghi quyết định vào `PROJECT.md` §5/§7.
- Định dạng lỗi: `ErrorHelper` (`lib/utils/error/error_helper.dart`) đã hiện `msg`/`error` (chuỗi) của body cho 4xx và `server_error` cho 5xx — đổi tên khoá trong `_serverMessage` theo backend; cập nhật test trong `test/utils/error/error_helper_test.dart`.
- Cờ hết phiên kiểu `forceLogout`: đổi khoá trong `DioInterceptor._isForceLogout` (đọc thẳng body, không qua DTO) theo backend; cập nhật test trong `test/data/services/interceptors/dio_interceptor_test.dart`.
- Header `Accept-Language` đang cố định `'vi'` trong `lib/data/services/interceptors/dio_interceptor.dart` → đặt theo ngôn ngữ mặc định, hoặc truyền callback lấy ngôn ngữ hiện tại từ `Dependence` (data/ không được import core/).
- Timeout: `lib/core/di/dependence.dart` (mặc định 20s).

Kiểm chứng: test parse DTO với JSON mẫu thật của backend; `flutter test test/data`.

---

## D. Xác thực

**Khi nào:** app có đăng nhập.

- Login: `ApiConstants.login`, `LoginRequestModel`, `LoginResponseModel` (tên field token theo backend). API dev đã login được → trong `lib/core/di/dependence.dart` đặt `demoLogin: false`, xoá `DemoAuthRepository` và test của nó.
- Refresh token:
  - Có: `ApiConstants.refreshToken`, `RefreshTokenRequestModel`, `DioInterceptor._requestNewToken` theo đúng API. Mã lỗi mà refresh endpoint dùng để **từ chối** (mặc định 400/401/403) → `DioInterceptor._isRefreshRejected`; chỉ những mã này mới đăng xuất.
  - Không có: `_handleUnauthorized` chỉ cần logout + trả lỗi; xoá endpoint/DTO refresh; cập nhật `dio_interceptor_test.dart` (bỏ các test refresh, giữ test 401 → xoá token) và mục "Auth & token" trong `CLAUDE.md`.
- `ApiConstants.nonAuthenticatedPaths`: thêm register, forgot password, OTP…
- Hết phiên / đăng xuất → về Login: base **đã có** (`sessionEnded` + `refreshListenable`, route `/` chọn màn đầu theo token). Màn mới cần đăng nhập: lồng dưới `/home` hoặc override `redirect` như `HomeRoute`. Có API logout phía server → gọi trong `AuthRepository.logout()` trước khi xoá token.
- Lưu token: `SecureStorage` (đã có). Biometric/pinning → dependency mới, hỏi trước.

Kiểm chứng: `flutter test test/data` xanh.

---

## E. Brand

**Khi nào:** có brand guideline/Figma.

- Màu: `lib/resources/app_colors.dart` (`ColorsDefine` light/dark) — thêm/đổi tên màu theo design token; dùng qua `context.colors`.
- Theme: `lib/app.dart` (`ThemeData`: `colorScheme` từ màu chính, `fontFamily`, style nút/input dùng chung).
- Font: thêm file vào `assets/fonts/`, khai báo `flutter: fonts:` trong `pubspec.yaml`.
- Ảnh/icon: `assets/image/`, `assets/svg/` → `make gen` → `Assets.xxx`.
- App icon / native splash: cần `flutter_launcher_icons` / `flutter_native_splash` (dependency mới — hỏi trước) hoặc thay icon thủ công trong từng nền tảng.
- Không hỗ trợ dark mode → giữ `Brightness.light`, bỏ nút đổi theme trong code mẫu.

Kiểm chứng: `make gen`, `dart analyze`, chạy app xem màu/font.

---

## F. Ngôn ngữ

**Khi nào:** luôn kiểm tra.

- `lib/core/settings/locale_support.dart`: `SupportLocale` (hằng + `support`), mặc định trong constructor `LocaleCubit()`.
- ARB: mỗi ngôn ngữ một `lib/resources/l10n/intl_<code>.arb`, cùng bộ key → `make l10n`.
- Bỏ ngôn ngữ: xoá ARB + `SupportLocale` + cập nhật `test/core/settings/app_settings_test.dart`.
- Base **không lưu** ngôn ngữ đã chọn (mỗi lần mở app về mặc định). Cần lưu → feature: đọc/ghi qua repository dùng `SharePreference`.
- Đồng bộ header `Accept-Language` (nhóm C).

Kiểm chứng: `make l10n`, `flutter test test/core`.

---

## G. Nền tảng

**Khi nào:** dự án không nhắm tất cả nền tảng, hoặc có yêu cầu min OS.

- Xoá thư mục nền tảng không dùng (`web/`, `windows/`, `linux/`, `macos/`) — **xác nhận trước**.
- Quyền INTERNET đã có trong manifest `main` (template Flutter chỉ đặt ở debug/profile → bản release không gọi được API); `test/platform_config_test.dart` canh lỗi này.
- `android:allowBackup="false"` đã bật (bảo vệ `flutter_secure_storage`); dự án cần sao lưu dữ liệu khác → dùng `dataExtractionRules` loại trừ file của secure storage thay vì bật lại toàn bộ.
- iOS min version: `ios/Podfile` (`platform :ios, 'x.0'`) + `IPHONEOS_DEPLOYMENT_TARGET` trong `project.pbxproj` (hiện 13.0).
- Android: `minSdk`/`targetSdk` trong `android/app/build.gradle.kts` (hiện theo `flutter.*`).
- Quyền hệ thống (camera, vị trí, thông báo…): thêm trong feature cần nó (AndroidManifest + Info.plist usage description), không thêm sẵn.

Kiểm chứng: build từng nền tảng còn giữ.

---

## H. Dọn code mẫu & dependency

**Khi nào:** luôn làm (sau khi người dùng đồng ý phương án).

- Feature mẫu `login`: giữ làm tham chiếu (khuyến nghị cho tới khi có feature thật) **hoặc** chuyển thành màn hình đăng nhập thật bằng `/feature-team`.
- Màn mẫu: Login (có nút đổi ngôn ngữ/theme để minh hoạ), Home (màn tạm), Detail (minh hoạ param deep link) → giữ làm tham chiếu hoặc thay bằng màn thật qua `/feature-team`.
- Base không còn dependency thừa; thêm dependency mới chỉ khi bậc thang (CLAUDE.md § Nguyên tắc tối giản) cho phép.
- `README.md`: tổng quan dự án, cách chạy (`make init`, cấu hình `.vscode/launch.json`), link `PROJECT.md`.

Kiểm chứng: `dart analyze`, `flutter test` (cập nhật test của phần bị xoá).

---

## I. Khung điều hướng

**Khi nào:** đã biết cấu trúc màn hình (Figma/PRD).

- Ghi sơ đồ điều hướng vào `PROJECT.md` (backlog + ghi chú): route nào, tab nào, cần đăng nhập không.
- Route chỉ thêm vào `lib/app_router.dart` cùng lúc với màn hình (qua `/feature-team`). Tab/bottom navigation → một feature riêng (go_router `StatefulShellRoute`).
- Màn hình đầu (`initialLocation`) / chuyển hướng theo trạng thái đăng nhập → thuộc feature "Luồng xác thực" (nhóm D).

---

## J. Quy ước riêng

Ghi vào `PROJECT.md` §7 những gì dự án khác mặc định của base, ví dụ: định dạng ngày/tiền tệ, cỡ trang phân trang, kiểu hiển thị lỗi (dialog/snackbar), empty state, quy tắc đặt tên analytics event, validate (độ dài mật khẩu…). `/feature-team` và `/bugfix-team` áp dụng mục này.

---

## K. Cập nhật CLAUDE.md

Chỉ khi hành vi/quy tắc **của base** thay đổi (vd. bỏ refresh token, đổi cách hiển thị lỗi mặc định, thêm dependency nền tảng như Firebase). Cập nhật đúng mục liên quan và "Giới hạn đã biết". Thông tin riêng dự án để ở `PROJECT.md`.
