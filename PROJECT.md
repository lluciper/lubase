# PROJECT.md — Hồ sơ dự án

> **Trạng thái: CHƯA THIẾT LẬP.** Chạy `/project-setup <context dự án>` để điền.
>
> File này là nguồn sự thật về **mục tiêu và quy tắc nghiệp vụ** của dự án (CLAUDE.md lo phần kỹ thuật của base).
> Mọi skill (`/project-setup`, `/feature-team`, `/bugfix-team`) đọc file này trước khi làm việc.
>
> Quy tắc ghi:
> - **Mục 1 chép NGUYÊN VĂN** từ người dùng/tài liệu gốc. Không diễn giải, không rút gọn, không sửa. Mục tiêu đổi → thêm bản mới có ngày ở cuối mục 1, giữ nguyên bản cũ.
> - Điều gì chưa được người dùng xác nhận phải nằm ở mục **Giả định** hoặc **Câu hỏi mở**, không được ghi như sự thật.
> - Mỗi lần cập nhật → thêm một dòng vào **Nhật ký thay đổi**.

## 1. Mục tiêu gốc (nguyên văn)

_(chưa có)_

## 2. Tóm tắt sản phẩm (đã xác nhận)

| Mục | Giá trị |
|---|---|
| Tên app | |
| Mục đích / giá trị chính | |
| Người dùng mục tiêu | |
| Nền tảng | |
| Ngôn ngữ hỗ trợ (mặc định) | |
| Bundle id / applicationId | |

## 3. Phạm vi

- **Trong phạm vi (MVP):**
- **Ngoài phạm vi:**

## 4. Backlog feature

| # | Feature / màn hình | Mô tả ngắn | Nguồn (mục tiêu/tài liệu) | Ưu tiên | Trạng thái |
|---|---|---|---|---|---|
| 1 | Home (màn tạm) | Tiêu đề + lời chào; nội dung thật chờ spec | Yêu cầu "thêm màn home" (2026-10-28) | — | done |
| 2 | Deep link tới Login / Home | `lubase://app/login`, `lubase://app/home` | Yêu cầu "xử lý deeplink để có thể nhảy sang màn login và home" (2026-10-28) | — | done |
| 3 | Màn Chi tiết + deep link có param | Nút ở Home mở Chi tiết; `lubase://app/home/detail?id=42` → hiển thị param trong text | Yêu cầu "thêm 1 màn chi tiết … param được lấy từ deeplink sẽ hiển thị trong text ở màn chi tiết" (2026-10-28) | — | done |
| 4 | Luồng xác thực | Màn đầu theo token, hết phiên/đăng xuất → Login, nút Đăng xuất ở Home | Người dùng đồng ý "Sửa hết phần 1" (2026-10-28) | — | done |

Trạng thái: `todo` · `in-progress` · `done` · `blocked`.

## 5. Backend / API

| Mục | Giá trị |
|---|---|
| Base URL dev / prod | |
| Xác thực | |
| Envelope response | |
| Định dạng lỗi | |
| Phân trang | |
| Tài liệu API | |

## 6. Quy tắc nghiệp vụ (đã xác nhận)

| ID | Quy tắc | Nguồn |
|---|---|---|
| BR-1 | Đăng nhập thành công → đi tiếp tới màn đang muốn mở trước khi bị chuyển sang Login (vd. deep link `…/home/detail?id=42`), không có thì vào Home; không back về Login | Người dùng xác nhận 2026-10-28; bổ sung theo báo lỗi "deeplink không đến đúng màn" 2026-10-28 |
| BR-2 | Vào Home (kể cả qua deep link) khi chưa có token → chuyển sang Login | Người dùng xác nhận 2026-10-28 |
| BR-3 | Chỉ đăng xuất (về Login, không back lại được) khi: access token hết hạn **và** refresh bị server từ chối (refresh token hết hạn/bị thu hồi, vd. server yêu cầu đăng nhập lại), server trả `forceLogout`, hoặc người dùng bấm Đăng xuất. Mất mạng / timeout / lỗi server khi refresh → giữ phiên. Đã refresh được token mới mà request vẫn 401 → chỉ báo lỗi, vẫn dùng tiếp | Người dùng xác nhận 2026-10-28 ("chỉ đăng xuất khi token không còn hạn và refresh token không thành công…") |
| BR-4 | Mở app (không qua link): có token → Home, chưa có → Login | Người dùng đồng ý "Sửa hết phần 1" 2026-10-28 |

## 7. Quy ước riêng của dự án

Bổ sung hoặc ghi đè quy tắc mặc định trong CLAUDE.md cho riêng dự án này (UI pattern, validate, analytics, …). Skill áp dụng mục này; nếu mâu thuẫn với yêu cầu hiện tại thì hỏi người dùng.

- **Mức tối giản (ponytail):** `full` _(mặc định — `lite` | `full` | `ultra`, xem CLAUDE.md)_

## 8. Thuật ngữ

| Thuật ngữ | Nghĩa | EN | VI |
|---|---|---|---|

## 9. Giả định

- Deep link / location không tồn tại → về màn đầu theo token: Home hoặc Login (2026-10-28; trước đó là Splash demo, đã bỏ).
- Màn Chi tiết mở không có param (từ nút ở Home) → hiển thị "Không có tham số"; param là query `id` (2026-10-28).

## 10. Câu hỏi mở

- _(chưa có)_

## 11. Nhật ký thay đổi

| Ngày | Thay đổi | Nguồn | Bởi |
|---|---|---|---|
| 2026-10-28 | Thêm Home (tạm), deep link Login/Home, BR-1, BR-2 | /feature-team | Claude |
| 2026-10-28 | Thêm màn Chi tiết + deep link có param `id` | Yêu cầu người dùng | Claude |
| 2026-10-28 | Luồng xác thực (BR-3, BR-4), bỏ Splash demo; sửa base: content type, kiểm tra mạng, báo lỗi, ENV, CI, backup/cài lại | "Sửa hết phần 1" | Claude |
| 2026-10-28 | Development đăng nhập giả (`DemoAuthRepository`) vì API mock chưa có login (trả 400) | Người dùng chọn "Đăng nhập giả trong app" | Claude |
| 2026-10-28 | BR-1: login xong đi tiếp tới đích deep link (`LoginRoute.from`) thay vì luôn về Home | Báo lỗi của người dùng | Claude |
| 2026-10-28 | BR-3 sửa theo người dùng: refresh lỗi tạm thời (mạng/timeout/5xx) giữ phiên; 401 sau khi refresh thành công không đăng xuất | Người dùng | Claude |
| 2026-10-28 | Sửa theo review độc lập (65/100): quyền INTERNET bản release, interceptor (forceLogout, retry FormData, đăng xuất giữa lúc refresh, dio ≥ 5.11), dọn code demo/chết + 10 dependency, commit lockfile, thông báo lỗi server, routerProvider + bỏ biến toàn cục, test App và cấu hình native | "Sửa đi và sau đó review lại" | Claude |
| 2026-10-28 | Dựng base Bloc song sinh với base Riverpod: cùng cấu trúc, code, test, skill; state là Bloc (Cubit), DI là get_it (mục "Khác base Riverpod" trong CLAUDE.md) | Yêu cầu người dùng | Claude |
