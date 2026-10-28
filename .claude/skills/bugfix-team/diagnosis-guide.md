# Diagnosis guide — triệu chứng → nguyên nhân hay gặp → chỗ cần xem

Dành cho base MVVM + Bloc (Cubit) + get_it này. Dùng ở bước "Tái hiện" của `/bugfix-team` để khoanh vùng nhanh; vẫn phải xác nhận bằng test đỏ.

## State & Bloc

| Triệu chứng | Nguyên nhân hay gặp | Xem / cách kiểm tra |
|---|---|---|
| UI không cập nhật khi state đổi | đọc `viewModel.state` trong build thay vì `viewModel.listen(context, …)`; `context` nằm ngoài page (vd. `context` của State thay vì của `buildBody`/`Builder`) | file page/widget: chỗ hiển thị có `listen` không |
| UI rebuild liên tục / giật | selector trả object mới mỗi lần (list/map tạo mới trong selector) | đổi selector trả giá trị nguyên thủy hoặc so sánh được |
| Đổi state không có tác dụng hoặc ném `UnsupportedError` | mutate tại chỗ (`state.items.add(x)`) — collection của freezed là unmodifiable | dùng `state = state.copyWith(items: [...state.items, x])` |
| State bị reset, ViewModel bị tạo lại | page không kế thừa `BasePage`; tự tạo ViewModel trong `build` thay vì `createViewModel()`; route đổi `key` của page | dùng `viewModel` của base; page override `createViewModel()` |
| `Cannot emit new states after calling close` | ViewModel `emit` sau `await` khi page đã đóng; Cubit dùng chung (singleton) bị page `close()` | trong ViewModel kiểm tra `if (isClosed) return;` trước khi `emit`; state dùng chung đặt trong `getIt`, không làm ViewModel của page |
| `GetIt: Object/factory with type Repository is not registered` | chạy ngoài `Dependence`, hoặc test chưa đăng ký fake | test: `Dependence.register(FakeRepository(...))` + `getIt.reset()` |
| `ProviderNotFoundException` khi gọi `listen`/`context.read` | `context` nằm trên `BlocProvider` của page (vd. `context` trong `onStateCreated`) | dùng `viewModel` trực tiếp, hoặc `context` của `buildBody` |
| Test: state đã đổi nhưng UI chưa đổi | Cubit báo qua stream (bất đồng bộ); `tester.pump()` chưa chạy microtask | `await tester.pump(Duration.zero)` |

## Async, loading, dialog lỗi

| Triệu chứng | Nguyên nhân hay gặp | Xem |
|---|---|---|
| Loading không tắt | future không bao giờ complete (thiếu `return`/`await`); lỗi bị nuốt ở VM trước khi tới page; gọi `showLoadingDialog` tay mà không `dismissLoadingDialog` | method VM trả `Future` đúng chưa; chuỗi `subscribe…` ở page |
| Không hiện dialog lỗi | thiếu `.subscribeHandleError(this)` hoặc không đứng cuối chuỗi; VM `try/catch` nuốt lỗi | chuỗi gọi ở page; `catch` trong VM/repository |
| Hiện nhiều dialog lỗi | tự gọi `handleError` thay vì `handlerFutureError`; nhiều chuỗi với `onError` riêng | `lib/core/base_page.dart` |
| `ArgumentError (onError): The error handler of Future.catchError must return a value…` | code feature tự viết `catchError` trả `void` trên `Future` non-null | dùng `subscribeHandleError` hoặc trả giá trị đúng kiểu |

## Mạng & API

| Triệu chứng | Nguyên nhân hay gặp | Xem |
|---|---|---|
| Chạy debug được nhưng bản **release Android** báo lỗi mạng mọi request | thiếu `android.permission.INTERNET` trong manifest `main` | `android/app/src/main/AndroidManifest.xml`, `test/platform_config_test.dart` |
| Request treo mãi, loading quay không tắt | dio < 5.11 (interceptor async ném lỗi thì request treo) | `pubspec.yaml` (`dio: ^5.11.1`), `pubspec.lock` |
| Mọi request báo mất mạng (`connectionError`) | base URL sai (`AppFlavorValue`, `ApiConstants`, sai file `dart_defines`); emulator không có mạng (interceptor chỉ kiểm tra mạng khi lỗi không có response) | `lib/core/app_flavor.dart`, log `LoggerInterceptor` (debug) |
| Gọi API thành công nhưng app báo lỗi | JSON khác DTO: sai key, field `null` nhưng DTO non-null, số dạng chuỗi, định dạng ngày → lỗi trong `fromJson` | so JSON thật (log debug) với DTO; viết test parse với JSON đó |
| 401 lặp lại / bị đăng xuất liên tục | token chưa được lưu (đăng nhập không qua `AuthRepository.login`); endpoint login/refresh chưa nằm trong `ApiConstants.nonAuthenticatedPaths`; refresh endpoint trả 400/401/403 (bị từ chối → đăng xuất là đúng thiết kế); mất mạng/timeout/5xx khi refresh hay 401 sau khi refresh thành công thì **không** được đăng xuất (`_isRefreshRejected`) | `dio_interceptor.dart`, `auth_repository.dart`, `test/data/services/dio_interceptor_test.dart` |
| Hết phiên mà không về Login / về Login sai lúc | màn mới không nằm dưới guard (`redirect`) ; router không nhận `refreshListenable`; xoá token không qua `SecureStorage.clearTokens` | `lib/app_router.dart`, `test/app_router_test.dart` (group `session end`) |
| Cài lại app trên iOS vẫn "đã đăng nhập" / người dùng bị đăng xuất sau khi cập nhật | cơ chế cờ `LocalStorageKey.installed` trong `Dependence` | `lib/core/dependence.dart`, `test/core/dependence_test.dart` |
| Upload/form-urlencoded bị server từ chối | header `Content-Type` bị ép ở interceptor (base đã bỏ — kiểm tra code feature) | `DioInterceptor.onRequest` |
| Nhiều request cùng gọi refresh | interceptor bị đổi sang `QueuedInterceptorsWrapper` hoặc tự viết refresh ngoài `_refreshAccessToken` | giữ cơ chế `Completer` dùng chung |
| Server trả tiếng Việt dù app đang tiếng Anh | header `Accept-Language` cố định `'vi'` | `DioInterceptor.onRequest` |
| Lỗi chỉ trên web: `Unsupported operation` | dùng `dart:io` (`Platform`, `File`, `InternetAddress`) | dùng `kIsWeb` / `defaultTargetPlatform` |

## UI, i18n, theme

| Triệu chứng | Nguyên nhân hay gặp | Xem |
|---|---|---|
| Đổi ngôn ngữ nhưng có text không đổi | widget `const` tách riêng dùng `S.current` (không rebuild); text lấy trong selector `listen` không chạy lại | dùng `S.of(context)` trong widget đó |
| Thiếu bản dịch / hiện key | key có ở một file ARB nhưng thiếu ở file kia; quên `make l10n` | so key giữa `intl_en.arb` và `intl_vi.arb` |
| Màu sai ở dark mode | hard-code màu thay vì `context.colors` | Grep `Color(0x` / `Colors.` trong feature |
| Overflow (vạch vàng đen) | `Column`/`Row` không cuộn; chuỗi tiếng Việt dài hơn; màn hình nhỏ/tablet | widget test với `tester.view.physicalSize` + `addTearDown(tester.view.reset)` |
| Bàn phím che ô nhập | page override `resizeToAvoidBottomInset => false`, hoặc body không cuộn được | `BasePage` mặc định `true`; bọc body bằng `SingleChildScrollView` |
| `backgroundColor`/`hasUseSafeArea` không ăn | override sai chỗ (trong widget con thay vì State của page) | override getter trong `BasePageState` |
| `onAppearedPage`/`onRefreshPage` không chạy | page không thực sự hiện > 95% (bị phủ), hoặc chưa `RefreshService.addPage(...)` | `lib/core/widgets/visibility_wrapper.dart`, `lib/core/refresh_service.dart` |

## Điều hướng

| Triệu chứng | Nguyên nhân hay gặp | Xem |
|---|---|---|
| Deep link mở ra Login thay vì màn đích | chưa đăng nhập: guard chuyển sang Login kèm `from`, login xong sẽ đi tiếp; login không được → kiểm tra API login (`ApiConstants.login`, base URL của môi trường) | `lib/app_router.dart`, `test/view/features/login/login_page_test.dart` |
| Back về sai màn hình / mất stack | dùng `go` khi cần `push` (hoặc ngược lại); route lồng sai cấp | `lib/app_router.dart` |
| Tham số route `null` | sai tên query (`userId` ↔ `user-id` do go_router_builder chuyển kebab-case) | file `app_router.g.dart` |

## Codegen & build

| Triệu chứng | Nguyên nhân hay gặp | Xem |
|---|---|---|
| `$XRoute` / `_$X` / `_$XFromJson` không tồn tại | chưa chạy `make gen`; tên `part` không khớp tên file | `make gen` |
| `make gen` báo `Missing mixin clause with $XRoute` | route khai báo kiểu cũ `with _$XRoute` | đổi thành `with $XRoute` |
| Sau khi nâng cấp package, file sinh biến mất (vd. `assets.gen.dart`) và generator báo `skipped` | cache cũ của build_runner từ phiên bản generator trước | `dart run build_runner clean` rồi `make gen` |
| Lỗi chỉ ở bản release | log bị tắt (`LoggerHelper` chỉ chạy debug) — lỗi không bắt được vẫn vào `reportError` (log thiết bị); obfuscation đổi `runtimeType.toString()` (khoá của `RefreshService`) | `flutter run --release` + `adb logcat` / Console.app |

## Test

| Triệu chứng | Nguyên nhân hay gặp | Xem |
|---|---|---|
| `A Timer is still pending` / test treo | `VisibilityDetector` chưa đặt `updateInterval = Duration.zero`; `Future.delayed` thật | `setUpAll` của test page |
| `No instance of S was loaded` | chưa `await S.load(const Locale('en'))` | `setUpAll` |
| Tap không có tác dụng | widget nằm ngoài màn hình test | `await tester.ensureVisible(finder)` trước khi tap |
| Test flaky | phụ thuộc thứ tự/static state (`RefreshService`), mạng/thời gian thật | reset trong `setUp`; dùng fake |

## Công cụ nhanh

- Chạy một test: `flutter test <file> --plain-name "<tên test>"`.
- Log debug: `LoggerHelper.info/print`; request/response qua `LoggerInterceptor` (chỉ debug).
- Cây widget: `debugDumpApp()`; DevTools (Inspector, Network).
