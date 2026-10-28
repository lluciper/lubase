# CLAUDE.md

Base project Flutter theo mô hình **MVVM + Bloc (Cubit) + get_it**. File này là nguồn sự thật về công nghệ, cấu trúc thư mục và quy tắc code. Đọc trước khi sửa code; khi code thay đổi quy tắc thì cập nhật file này.

Base này là **bản song sinh của base Riverpod** (`lu_base_riverpod`): cùng cấu trúc, cùng code ngoài phần state, cùng test và skill. Phần khác nằm gọn trong mục [Khác base Riverpod](#khác-base-riverpod) — sửa phần dùng chung thì sửa ở **cả hai** base.

Hồ sơ dự án — mục tiêu, phạm vi, backlog, quy tắc nghiệp vụ, quy ước riêng (ưu tiên hơn mặc định ở đây khi khác): @PROJECT.md

## Quy trình làm việc (skills)

| Việc | Skill | Ghi chú |
|---|---|---|
| Bắt đầu dự án mới từ base / mục tiêu dự án thay đổi | `/project-setup <context>` | Ghi `PROJECT.md`, cấu hình base, lập backlog |
| Feature / màn hình mới, đổi hành vi feature | `/feature-team <yêu cầu>` | BA → DEV → QA → Review |
| Sửa lỗi, crash, hành vi sai | `/bugfix-team <báo lỗi>` | Test đỏ → nguyên nhân gốc → sửa → regression |

- `PROJECT.md` §1 (mục tiêu gốc) chép nguyên văn và **chỉ đọc** — không skill nào được diễn giải lại hay sửa; thay đổi mục tiêu đi qua `/project-setup` (thêm bản cập nhật có ngày).
- Tuỳ chỉnh cách làm cho từng dự án: ghi vào `PROJECT.md` §7, không sửa file skill.

## Nguyên tắc tối giản (theo [ponytail](https://github.com/dietrichgebert/ponytail))

Thay đổi nhỏ nhất **mà vẫn giải quyết trọn vẹn**: lười ở lời giải, không lười ở việc đọc hiểu và hoàn thiện thay đổi. Áp dụng cho mọi việc, kể cả ngoài skill.

1. **Đọc trước**: đọc code bị ảnh hưởng, lần theo luồng thật View → ViewModel → Repository → Service.
2. **Bản đồ phạm vi** trước khi viết: mọi chỗ thay đổi phải chạm tới — caller, test, fixture, export trong `index.dart`, file sinh (`make gen`), ARB của mọi ngôn ngữ, cấu hình nền tảng (AndroidManifest, Info.plist) — và điều gì có thể hỏng với người dùng. Tính năng không ai yêu cầu không thuộc phạm vi.
3. **Bậc thang** — dừng ở bậc đầu tiên đáp ứng trọn vẹn:
   1. Có cần tồn tại không? Không ai yêu cầu → không làm, nêu tên trong 1 dòng.
   2. Base/codebase đã có chưa? (`BasePage`, `FutureEx`, entities, extensions, `DialogPlatform`, repository, widget dùng chung)
   3. Dart/Flutter SDK làm được?
   4. Tính năng nền tảng/framework có sẵn? (go_router, deep link của Flutter, `CircularProgressIndicator.adaptive`…)
   5. Dependency đã cài? Không thêm dependency cho vài dòng code.
   6. Một dòng đọc là hiểu?
   7. Cuối cùng: code tối thiểu chạy được + test nhỏ nếu có logic.
4. Không viết abstraction, wrapper, option, config hay code "để sau" khi chưa ai cần. Xoá tốt hơn thêm. Giữ tầng, cấu trúc, quy ước sẵn có. Code di chuyển/gộp giữ nguyên validate và xử lý lỗi.
5. **Không bao giờ cắt**: validate ở ranh giới tin cậy (input người dùng, response API, deep link), xử lý lỗi chống mất dữ liệu, bảo mật (token, dữ liệu nhạy cảm trong log), accessibility, và mọi thứ người dùng đã yêu cầu.
6. Logic không tầm thường (rẽ nhánh, vòng lặp, parser, tiền, bảo mật) phải có ít nhất một test nhỏ.
7. Đường tắt có giới hạn biết trước → comment `// shortcut: <giới hạn>, <khi nào nâng cấp>`. Sổ nợ: `grep -rn "shortcut:" lib`.
8. Báo cáo luôn kết thúc bằng 1–2 dòng: đã bỏ qua / chưa kiểm tra gì, và rủi ro người dùng cần biết.

**Mức** — đặt trong `PROJECT.md` §7, mặc định `full`:
- `lite`: làm đúng yêu cầu, nêu phương án nhỏ hơn trong 1 dòng để người dùng chọn.
- `full`: toàn bộ nguyên tắc trên.
- `ultra`: thêm bước chất vấn — phần yêu cầu nào mục tiêu không biện minh được thì hỏi lại người dùng trước khi làm (**hỏi, không tự cắt**).

Review theo cách của `ponytail-review`: `.claude/skills/feature-team/review-guide.md`.

## Công nghệ

| Mảng | Thư viện (bản đang dùng) |
|---|---|
| SDK | Flutter 3.47 stable, Dart 3.13 (`sdk: ^3.10`, dùng được dot-shorthand `.start`) |
| State | `flutter_bloc` 9 (`BaseViewModel` là `Cubit<State>`) |
| DI | `get_it` 9 — container duy nhất `getIt`, đăng ký tay trong `Dependence` (không dùng injectable/codegen) |
| Routing | `go_router` 18 + `go_router_builder` 4.5 (typed routes, mixin `with $XRoute`) |
| Network | `dio` ≥ 5.11 (bản cũ hơn treo request khi interceptor async ném lỗi) + `retrofit` 4.10 |
| Model / State | `json_serializable` 6 (DTO), `freezed` 4 (state & entity bất biến) |
| Storage | `shared_preferences`, `flutter_secure_storage` 11 |
| i18n | `intl` + `intl_utils` 2.8 (dev dependency) — ARB ở `lib/resources/l10n`, class `S` |
| Assets | `flutter_gen` (class `Assets`) |
| Khác | `visibility_detector`, `connectivity_plus`, `logger` |
| Lint | `flutter_lints` (không dùng `bloc_lint`: chạy qua CLI riêng, và 2 luật mặc định chống lại thiết kế của base — method ViewModel trả `Future`, file `*_view_model.dart`) |

## Lệnh

```bash
make init        # pub get + build_runner + l10n
make gen         # dart run build_runner build — sau khi sửa @freezed/@JsonSerializable/@RestApi/@TypedGoRoute
make l10n        # dart run intl_utils:generate — sau khi sửa file .arb
make check       # dart analyze --fatal-infos + flutter test — phải sạch trước khi commit
```

### Môi trường

Chạy trong VS Code: **Run and Debug** → chọn cấu hình (`.vscode/launch.json`). Dòng lệnh:

```bash
flutter run --flavor dev --dart-define-from-file=dart_defines/develop.json   # Android: bắt buộc --flavor
flutter run --dart-define-from-file=dart_defines/develop.json                # iOS, web
flutter build appbundle --flavor prod --dart-define-from-file=dart_defines/production.json
flutter build ipa --dart-define-from-file=dart_defines/production.json
```

| Môi trường | File define | `ENV` | Android flavor (applicationId, tên app) |
|---|---|---|---|
| dev | `dart_defines/develop.json` | `development` | `dev` (`….dev`, "… Dev") |
| stg | `dart_defines/stage.json` | `staging` | `stage` (`….stg`, "… Stg") |
| prod | `dart_defines/production.json` | `production` | `prod` (applicationId gốc) |

- `ENV` → `AppFlavorValue.fromEnv` → base URL trong `ApiConstants`. Không truyền define → `development`; giá trị lạ → lỗi ngay khi mở app.
- Android có `productFlavors` (`android/app/build.gradle.kts`) để cài song song 3 bản; iOS **không** có flavor (một bundle id cho mọi môi trường).
- Thêm môi trường: file JSON mới + case trong `fromEnv` + base URL + flavor Android + 2 cấu hình trong `launch.json`. `test/platform_config_test.dart` kiểm tra các chỗ này khớp nhau.
- File trong `dart_defines/` được commit → **không** chứa bí mật (key bí mật đưa qua biến môi trường của CI).

- CI (`.github/workflows/ci.yml`, mỗi push/PR): sinh lại code + l10n, `dart format lib test`, **fail nếu working tree đổi** (quên commit file sinh hoặc chưa format), rồi `dart analyze --fatal-infos` + `flutter test`. Trước khi commit: `make gen`, `make l10n`, `dart format lib test`.
- `pubspec.lock` và `Podfile.lock` **được commit** (build lặp lại được, CI không đổi phiên bản ngẫu nhiên).

- Không sửa tay file sinh tự động: `*.g.dart`, `*.freezed.dart`, `lib/resources/generated/**`.
- `build_runner` 2.16 đã bỏ cờ `--delete-conflicting-outputs`.

## Cấu trúc thư mục

```
lib/
├── main.dart                  # Bắt lỗi toàn cục, chọn ENV (dart_defines/*.json), Dependence → runApp
├── app.dart                   # MaterialApp.router: router, LocaleCubit, ThemeCubit (đọc từ getIt)
├── app_router.dart            # Toàn bộ route (typed), deep link, guard — composition root, biết mọi page
├── core/                      # Hạ tầng base — KHÔNG biết feature nào, hiếm khi sửa
│   ├── base_page.dart         # BasePage / BasePageState + FutureEx (loading, error)
│   ├── base_view_model.dart   # BaseViewModel (Cubit) + viewModel.listen(context, …)
│   ├── dependence.dart        # getIt + composition root: Dio, storage, Repository → getIt
│   ├── app_flavor.dart, refresh_service.dart
│   ├── locale_support.dart, theme_support.dart   # State toàn app: LocaleCubit, ThemeCubit (trong getIt)
│   ├── widgets/               # Widget hạ tầng: BaseDialog, DialogPlatform, LoadingWrapper…
│   └── index.dart             # Barrel export
├── data/                      # M — Model layer
│   ├── models/
│   │   ├── <domain>/          # DTO theo domain, trùng tên repository: auth/ ↔ auth_repository.dart
│   │   └── common/            # (tạo khi cần) DTO dùng chung, vd. envelope của backend
│   ├── repositories/          # <domain>_repository.dart; `Repository` gom tất cả (repository.auth…)
│   ├── services/              # DioClient (retrofit), ApiConstants, interceptor, SecureStorage, SharePreference
│   └── index.dart
├── view/                      # V + VM — UI layer
│   ├── entities/              # Value object cho form (freezed): valid + errorText()
│   ├── widgets/               # (tạo khi cần) widget dùng chung từ 2 feature trở lên
│   └── features/<feature>/
│       ├── <feature>_page.dart        # View
│       ├── <feature>_view_model.dart  # ViewModel
│       ├── <feature>_state.dart       # State (freezed) — bỏ qua nếu state là kiểu đơn giản
│       └── widgets/                   # Widget chỉ dùng trong feature này
├── resources/                 # Màu (context.colors), ARB, file generated (S, Assets)
└── utils/                     # Helper, constant, extensions/ (part library) — không phụ thuộc core/
test/                          # Mirror cấu trúc lib/; fake dùng chung ở test/helpers/fakes.dart
```

**Đặt file ở đâu**

| Thứ cần thêm | Vị trí |
|---|---|
| DTO request/response | `data/models/<domain>/<tên>_model.dart` (dùng chung → `models/common/`) |
| Endpoint | hằng trong `ApiConstants` + method trong `DioClient` |
| Logic gọi API / lưu trữ | `data/repositories/<domain>_repository.dart` |
| Màn hình | `view/features/<feature>/` (page + view_model + state) |
| Widget của 1 feature | `view/features/<feature>/widgets/` |
| Widget dùng ở ≥ 2 feature | `view/widgets/` |
| Widget/hạ tầng cho mọi page (dialog, loading…) | `core/widgets/` |
| Validate input form | `view/entities/<tên>_entity.dart` |
| Route, guard đăng nhập | `lib/app_router.dart` |
| Scheme deep link | `android/app/src/main/AndroidManifest.xml` (intent-filter) + `ios/Runner/Info.plist` (`CFBundleURLTypes`) |
| State toàn app (ngôn ngữ, theme…) | `core/` (Cubit, đăng ký trong `Dependence.register`) |

Giữ cấu trúc phẳng: chỉ `models/` chia thư mục con theo domain; không tạo thư mục con trong `services/`, `repositories/`, `entities/`, `utils/` khi chưa vượt ~15 file; không tạo `view_model/`, `components/` trong feature.

## Quy tắc phụ thuộc giữa các thư mục

```
main.dart / app.dart / app_router.dart   ← composition root, được import mọi thứ
view/ ──▶ core/ ──▶ data/ ──▶ utils/ ──▶ resources/
```

- `resources/` không import layer nào. `utils/` chỉ import `resources/`.
- `data/` (Model) chỉ import `utils/` — không biết UI, page hay ViewModel.
- `core/` import `data/`, `utils/`, `resources/`; **không** import `view/` hay `app_router.dart`.
- `view/`: page & widget import `core/`, `resources/`, `utils/`, `app_router.dart`; **không import `data/`**. Chỉ ViewModel (và test) import `data/`.
- Feature **không** import feature khác — phần dùng chung đưa lên `view/widgets/` hoặc `view/entities/`.

## Quy tắc MVVM

Luồng một chiều: **View → ViewModel → Repository → Service**.

### View (`*_page.dart`, `widgets/`)
- Màn hình kế thừa `BasePage` + `BasePageState<Page, VM>`; tạo ViewModel trong `createViewModel()`:
  ```dart
  class _LoginPageState extends BasePageState<LoginPage, LoginViewModel> {
    @override
    LoginViewModel createViewModel() => LoginViewModel();
  }
  ```
  Base tạo ViewModel **một lần**, đưa vào cây con qua `BlocProvider` và `close()` khi page đóng. Dùng `viewModel`, không tự tạo ViewModel khác.
- `resizeToAvoidBottomInset` mặc định `true` như Flutter (bàn phím không che ô nhập). Cần biết app vào nền/quay lại: dùng `AppLifecycleListener` của Flutter.
- Override `buildBody` (+ `buildAppBar`); **không** override `build`/`initState`/`dispose` → dùng `onInitState`, `onStateCreated`, `onAppearedPage`, `onDisappearedPage`, `onRefreshPage`, `onDispose`. Tuỳ biến qua getter: `backgroundColor`, `hasUseSafeArea`, `tapOutsideHideKeyBoard`, `resizeToAvoidBottomInset`, `onPopWithResult`; đổi UI lỗi bằng cách override `handleError`.
- Đọc state: `viewModel.listen(context, (s) => s.field)` (= `context.select`, chỉ rebuild khi field đổi; dùng `context` của `buildBody` hoặc của widget con). Gọi hành động: `viewModel.xxx()`.
- Widget con nhận ViewModel qua constructor và tự bọc `Builder` phần cần rebuild.
- Tác vụ async — `subscribeHandleError` **luôn đứng cuối** (trả `Future<T?>`, `null` khi lỗi):
  ```dart
  viewModel.onPressLogin()
      .subscribeLoadingFullScreen(this)                 // overlay tới khi MỌI future đã subscribe xong (kể cả khi một cái lỗi)
      .subscribeOnSuccess(this, success: (res) { ... }) // tuỳ chọn; chỉ chạy khi page còn mounted
      .subscribeHandleError(this);                      // dialog lỗi (1 dialog dù nhiều lỗi); lỗi không phải API → reportError
  ```
- Muốn page tự `onRefreshPage` khi quay lại: `RefreshService.addPage(HomePage)`.
- Dialog: `DialogPlatform(content: ..., type: TypeDialog.confirm).show(context)` → `ActionDialog`. Dialog riêng: kế thừa `BaseDialog<R>`, override `build` (được bọc trong `Dialog` Material), đóng bằng `dismiss(result: ...)`.
- Text từ `S.current.xxx` (widget tách riêng dạng `const` dùng `S.of(context)` để tự đổi theo ngôn ngữ); màu `context.colors.xxx`; ảnh `Assets.xxx`. Không hard-code string/màu. View không gọi repository, không validate.

### ViewModel (`*_view_model.dart`)
- Kế thừa `BaseViewModel<State>` (là `Cubit<State>`), truyền state khởi tạo vào `super(...)`.
- Không import widget, không nhận `BuildContext`; state toàn app lấy từ `getIt` (vd. `getIt<ThemeCubit>().setBrightness(mode)`).
- Gọi data qua `repository.<domain>` (getter `@protected` của base); không gọi `DioClient`/storage trực tiếp.
- API công khai chỉ gồm **method + `state`** (kiểm khi review): không có getter/field public; helper cho lớp con đánh dấu `@protected`.
- Cập nhật bất biến `emit(state.copyWith(...))`. Hàm async trả `Future` cho View gắn loading/error; ViewModel không show dialog, không điều hướng.
- Sau `await` trong ViewModel, kiểm tra `if (isClosed) return;` trước khi `emit`: page có thể đã đóng (base `close()` ViewModel) và Cubit ném `StateError` khi `emit` sau `close`.

### State & Entity
- State: `@freezed sealed class`, có factory `initial()`.
- Validate field trong entity ở `view/entities/` (`valid`, `errorText()`).

### Model (`data/`)
- DTO: `@JsonSerializable()`, mọi field có `@JsonKey(name: ...)`, có `fromJson`/`toJson`.
- Repository mới: tạo `<domain>_repository.dart`, thêm field vào `Repository`, export trong `data/index.dart`.
- Dependency được tạo một chỗ trong `Dependence.initDependence` và đăng ký vào **`getIt` — biến toàn cục duy nhất** (không gọi `GetIt.instance`, không thêm singleton/static khác). Router đăng ký bằng `registerAppRouter()`. Test đăng ký fake qua `Dependence.register(...)` như app thật và `getIt.reset()` sau test.
- HTTP: thành công = mọi status 2xx; lỗi được chuẩn hoá (timeout → `connectionTimeout`, mất mạng → `connectionError`).
- Thông báo lỗi (`ErrorHelper`): 4xx → `msg` (hoặc `error`) dạng chuỗi trong body của server; 5xx → `server_error`; timeout/mất mạng → message tương ứng; lỗi không phải API → `unknown_error`. **Không bao giờ hiện `toString()`** cho người dùng. Đổi tên khoá theo backend trong `ErrorHelper._serverMessage`.
- Không ép `Content-Type`: Dio tự suy (JSON cho map, multipart cho `FormData`) và giữ content type khai báo riêng (vd. `@FormUrlEncoded`). Kiểm tra mạng (DNS) chỉ chạy khi request lỗi **không có response**, không chạy trước mỗi request.

### Auth & token
- `AuthRepository.login` lưu access/refresh token vào `SecureStorage`; `AuthRepository.logout()` xoá token.
- **Môi trường `development` đăng nhập giả** (`DemoAuthRepository`, bật bằng `demoLogin` trong `Dependence`): email hợp lệ bất kỳ + mật khẩu ≥ 8 ký tự, không gọi API — để thử guard/deep link/đăng xuất khi API dev chưa có login. stg/prod luôn gọi API thật. Có API login cho dev → đặt `demoLogin: false` và xoá `DemoAuthRepository`.
- `DioInterceptor` gắn `Bearer` cho mọi path không nằm trong `ApiConstants.nonAuthenticatedPaths`. Gặp 401: **một** lần refresh dùng chung `Completer` cho mọi request đang lỗi, rồi retry mỗi request một lần (body `FormData` được clone). Đăng xuất trong lúc refresh đang chạy → token mới **không** được lưu.
- **Khi nào kết thúc phiên** (chỉ những trường hợp này): refresh bị server **từ chối dứt khoát** (400/401/403 — refresh token hết hạn/bị thu hồi, vd. server yêu cầu đăng nhập lại; `_isRefreshRejected`), không còn refresh token, server trả `forceLogout` (đọc thẳng `body['forceLogout'] == true`), hoặc người dùng bấm Đăng xuất. **Giữ phiên** khi refresh lỗi do mất mạng / timeout / 5xx (request báo đúng lỗi đó, lần gọi sau refresh lại) và khi request **vẫn 401 sau khi đã refresh thành công** (chỉ báo lỗi của endpoint đó, vd. sai mật khẩu cũ).
- Access token được cache trong `SecureStorage` (không đọc Keychain/Keystore ở mỗi request). Đọc storage lỗi → `isLoggedIn` trả `false` (về Login) thay vì làm router lặp.
- **Hết phiên → về Login tự động**: mọi lần xoá token (`SecureStorage.clearTokens`) phát `AuthRepository.sessionEnded` → GoRouter (`refreshListenable`) chạy lại guard → màn cần đăng nhập chuyển sang Login. ViewModel/interceptor **không tự điều hướng** khi logout.
- Mở app: route `/` chỉ có `redirect` — có token → Home, chưa có → Login (redirect bất đồng bộ: có thể thấy một khung hình trống rất ngắn).
- Bảo mật lưu trữ: Android `allowBackup="false"` (khoá của `flutter_secure_storage` không khôi phục được từ backup). Lần chạy đầu của mỗi lần cài, `Dependence` xoá token còn sót (iOS Keychain giữ token sau khi gỡ app) — cờ `LocalStorageKey.installed` trong SharedPreferences.
- Interceptor kế thừa `Interceptor`, **không** dùng `QueuedInterceptorsWrapper` (deadlock khi retry).

### Điều hướng & deep link
- Route typed trong `lib/app_router.dart`; app đọc router từ `getIt` (`registerAppRouter()` trong `main.dart`), test tạo router mới bằng `createAppRouter()`.
- Điều hướng sau thành công: trong `subscribeOnSuccess` → `XRoute().go(context)` (`go` thay stack, `push` chồng lên).
- Deep link: `lubase://app/<path>` (vd. `lubase://app/home`). Flutter bật deep link mặc định và chuyển **nguyên URI** xuống; go_router chỉ khớp **path** → không cần code Dart đọc URL, nhưng route phải nằm ở path (`lubase://home` có `home` là host → mở `/`).
- Route cần đăng nhập: override `redirect` của `GoRouteData`, đọc qua repository `getIt<Repository>().auth.isLoggedIn()` và trả `const LoginRoute().location` khi chưa có token (mẫu: `HomeRoute`). Áp dụng cho cả deep link.
- Guard chuyển sang Login kèm đích: `LoginRoute(from: '/home/detail?id=42')`. Đăng nhập xong `LoginPage` đi tiếp tới `from` (chỉ nhận path trong app, bắt đầu bằng `/`; giá trị khác → Home).
- Location không tồn tại → `onException` đưa về `/` (chọn Home/Login theo token).
- `/login` là route cấp cao nhất (không lồng dưới `/`, nếu không redirect của `/` sẽ chạy cả cho `/login` và lặp).
- **Param**: field của `GoRouteData` không nằm trong path → query param (`lubase://app/home/detail?id=42`; tên camelCase thành kebab-case: `userId` → `user-id`); khai báo `:id` trong path → path param. Code đọc param do go_router_builder sinh (`app_router.g.dart`, đã decode URL) → `make gen` sau khi thêm field.
- Param đi theo luồng **Route → Page (constructor) → ViewModel**: page tạo `DetailViewModel(widget.id)` trong `createViewModel()`, route tạo page với `key: ValueKey(id)` — go_router dùng lại page của cùng route, mà page giữ ViewModel, nên param mới phải là page mới (mẫu: `lib/view/features/detail/`). Tải dữ liệu theo param đặt trong ViewModel.
- Param từ deep link là **input không tin cậy**: parse/kiểm tra (`int.tryParse`, độ dài…) trước khi dùng gọi API; chỉ hiển thị bằng `Text` thì an toàn.
- Route con (khai báo trong `routes:` của route cha) kế thừa guard của cha và back về cha.
- Thử trên máy: `adb shell am start -a android.intent.action.VIEW -d "lubase://app/home"` · `xcrun simctl openurl booted "lubase://app/home"`.
- Test: cold start `tester.binding.platformDispatcher.defaultRouteNameTestValue = '<link>'`; app đang chạy: gửi `pushRouteInformation` qua kênh `flutter/navigation` (mẫu: `test/app_router_test.dart`).

### Logging
- Dùng `LoggerHelper` (chỉ chạy ở debug, `kDebugMode`); request/response Dio log qua `LoggerInterceptor` — **chỉ gắn ở debug** (nó chuyển cả body thành chuỗi trên UI isolate) và không in body của endpoint đăng nhập/refresh (mật khẩu, token). Không dùng `print` hay `LogInterceptor` của Dio.
- Lỗi không bắt được (framework: `FlutterError.onError`, async: `PlatformDispatcher.onError`, gắn trong `main.dart`) đi về **một chỗ**: `reportError` (`lib/utils/error_reporter.dart`) — nơi gắn Crashlytics/Sentry khi dự án chọn.

## Thêm một feature (checklist)

> Làm trọn vẹn từ một yêu cầu (phân tích → code → test → review): `/feature-team <yêu cầu>`.

1. `data/models/<domain>/` — DTO → `make gen`.
2. `ApiConstants` + `DioClient` + `<domain>_repository.dart` (+ đăng ký trong `Repository`).
3. `view/features/<feature>/<feature>_state.dart` + `<feature>_view_model.dart`.
4. `<feature>_page.dart` kế thừa `BasePage`, override `createViewModel()`.
5. Route trong `lib/app_router.dart`: `class XRoute extends GoRouteData with $XRoute` (+ path trong `RouterPath`) → `make gen`. Điều hướng bằng `XRoute().push(context)` / `.go(context)`. Màn cần đăng nhập → override `redirect` như `HomeRoute`; mở được bằng deep link sẵn (không cần cấu hình thêm).
6. String vào **cả** `intl_en.arb` và `intl_vi.arb` → `make l10n`.
7. Test (xem mục Test) → `dart analyze` + `flutter test` sạch.

## Test

Test của base là "hợp đồng" của base — **sửa `core/`, `utils/`, `data/services/`, `view/entities/` thì chạy `flutter test` và cập nhật test tương ứng**. Feature `login` là mẫu tham chiếu, copy pattern từ đó.

| Phần | File test |
|---|---|
| `BaseViewModel`, `listen(context)`, `LoadingWrapperViewModel` | `test/core/base_view_model_test.dart` |
| `BasePage` (lifecycle, giữ VM sống, đóng VM khi page đóng, loading, dialog lỗi, refresh, đổi ngôn ngữ, dispose an toàn) + `FutureEx` | `test/core/base_page_test.dart` |
| `LocaleCubit`, `ThemeCubit`, `RefreshService` | `test/core/app_settings_test.dart` |
| `DialogPlatform` / `BaseDialog` | `test/core/widgets/dialog_platform_test.dart` |
| `DioInterceptor` (token, refresh 401 dùng chung, retry, force logout, 2xx, content type, kiểm tra mạng chỉ khi lỗi, body 401 lạ, storage lỗi, retry `FormData`, đăng xuất giữa lúc refresh) | `test/data/services/dio_interceptor_test.dart` |
| `AuthRepository` (lưu token, `isLoggedIn`, storage lỗi, `logout` + `sessionEnded`), `DemoAuthRepository` (không gọi API) | `test/data/repositories/auth_repository_test.dart` |
| `App` (router, bản dịch, theme như `main.dart` chạy) | `test/app_test.dart` |
| Cấu hình native (INTERNET, `allowBackup`, scheme deep link) + `launch.json` ↔ `dart_defines` ↔ `ENV` ↔ flavor Android | `test/platform_config_test.dart` |
| `Dependence` (dọn token sau khi cài lại, login giả chỉ ở development), `AppFlavorValue.fromEnv` | `test/core/dependence_test.dart`, `test/core/app_flavor_test.dart` |
| Entities | `test/view/entities/entities_test.dart` |
| Extensions, `ErrorHelper` | `test/utils/utils_test.dart` |
| Router: màn đầu theo token, deep link (cold/warm), param, guard, hết phiên/đăng xuất → Login, location lạ, Home → Detail | `test/app_router_test.dart` |
| Feature mẫu: ViewModel / Page (điều hướng qua router thật) | `test/view/features/login/login_view_model_test.dart`, `login_page_test.dart` |

Pattern:
- **Fake dùng chung**: `FakeRepository`, `FakeAuthRepository` (đặt `loggedIn`, `onLogin`, đọc `requests`), `BrokenSecureStorage` trong `test/helpers/fakes.dart` — repository có thêm hàm thì sửa fake **một chỗ**.
- **ViewModel**: tạo thẳng `XViewModel()`; cần repository → `Dependence.register(FakeRepository(auth: ...))` + `tearDown(getIt.reset)`.
- **Page**: `Dependence.register(...)` + `addTearDown(getIt.reset)`, rồi `MaterialApp.router(routerConfig: createAppRouter())` (hoặc `MaterialApp(home: XPage())` nếu không điều hướng); Cubit báo state qua stream (bất đồng bộ) → sau khi đổi state trực tiếp trong test dùng `await tester.pump(Duration.zero)` (`pump()` có thể chưa thấy state mới); `setUpAll`: `S.load(const Locale('en'))` + `VisibilityDetectorController.instance.updateInterval = Duration.zero`; `tester.ensureVisible` trước khi tap. Lỗi API trong test: ném `DioException` thật (vd. 401 kèm `{'msg': …}`), không ném `Exception('…')`.
- **Repository**: fake `DioClient` (`implements DioClient` + `noSuchMethod`), `SharedPreferences.setMockInitialValues({})`, `FlutterSecureStorage.setMockInitialValues({})`.
- **Network**: fake `HttpClientAdapter` (xem `dio_interceptor_test.dart`) — không gọi mạng thật.
- Sửa bug: viết test tái hiện (đỏ) trước, rồi mới sửa. Không sửa/xoá test để "xanh" khi hành vi base đổi ngoài ý muốn.

## Quy ước code

- File `snake_case.dart`; class `PascalCase`; hậu tố: `Page`, `ViewModel`, `State`, `Entity`, `Model`, `Repository`.
- Import nội bộ bằng đường dẫn tương đối, ưu tiên barrel (`core/index.dart`, `data/index.dart`, `utils/index.dart`); thêm file vào `core/`, `data/`, `utils/` → thêm export vào `index.dart`.
- Không đặt top-level function trùng tên getter của `BaseViewModel` (`repository`): tên import che getter kế thừa.
- Comment chỉ giải thích *tại sao*; doc công khai song ngữ Anh–Việt như code hiện có. Đường tắt có chủ đích: `// shortcut: <giới hạn>, <khi nào nâng cấp>`.

## Giới hạn đã biết

- API mock của dev chưa có login → development đăng nhập giả (`// shortcut:` trong `dependence.dart` và `demo_auth_repository.dart`); token giả bị API thật từ chối.
- Lỗi ở bản release mới chỉ ghi log thiết bị (`// shortcut:` trong `error_reporter.dart`) — chưa gắn dịch vụ báo crash.
- Dọn token theo cờ cài đặt: bản đầu tiên có cơ chế này sẽ đăng xuất **một lần** người dùng đang dùng bản cũ (chưa có cờ).
- API refresh `POST /auth/refresh` (`{refresh_token}` → `{access_token, refresh_token}`) là giả định — xác nhận với backend.
- `DialogPlatform`: Material trên Android/web, Cupertino trên các nền tảng còn lại.
- Guard đăng nhập chỉ kiểm tra **có** token (không kiểm tra hạn — hết hạn thì refresh khi gọi API). Deep link mới cấu hình cho Android/iOS (web dùng URL sẵn); chưa có https App Links/Universal Links.
- Header `Accept-Language` cố định `'vi'` (`DioInterceptor`); ngôn ngữ người dùng chọn không được lưu (mở lại app về mặc định).
- Ngôn ngữ mặc định `en`, chưa theo ngôn ngữ của máy.
- 3 flavor Android dùng chung scheme deep link `lubase`: cài song song thì hệ thống hỏi chọn app khi mở link.

## Khác base Riverpod

Chỉ những chỗ sau khác `lu_base_riverpod`; mọi file khác giống hệt (trừ tên package `lubase`). Sửa phần dùng chung → sửa cả hai base.

| Chỗ | Riverpod | Bloc (base này) |
|---|---|---|
| ViewModel | `Notifier<State>`, `State build()`, `state = …` | `Cubit<State>`, `super(initialState)`, `emit(…)` |
| Page có ViewModel | provider top-level + `get provider` | `createViewModel()`; base `close()` khi page đóng |
| Đọc state | `_provider.listen(ref, …)`, `Consumer` | `viewModel.listen(context, …)`, `Builder` |
| DI / state toàn app | `ProviderContainer`, `repositoryProvider`, `routerProvider`, `localeProvider`, `themeProvider` | `getIt`: `Repository`, `GoRouter` (`registerAppRouter`), `LocaleCubit`, `ThemeCubit` |
| Param route | provider family | `ValueKey(id)` cho page trong `DetailRoute.build` |
| Test | `ProviderScope(overrides: …)`, `ProviderContainer.test` | `Dependence.register(fake)` + `getIt.reset()`; `pump(Duration.zero)` sau khi đổi state |
| Lint | `riverpod_lint` | không có (xem mục Công nghệ) |
| File khác | — | `lib/{main,app,app_router}.dart`, `lib/core/{base_page,base_view_model,dependence,locale_support,theme_support}.dart`, `lib/core/widgets/loading_wrapper.dart`, `lib/data/repositories/repository.dart`, page + view_model của 3 feature, `login_panel.dart`, 8 file test |
