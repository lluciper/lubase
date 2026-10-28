---
name: project-setup
description: Khởi tạo một app mới từ base MVVM + Bloc này dựa trên context dự án (mô tả, PRD, tài liệu API, Figma, brand guideline) — chốt mục tiêu & phạm vi với người dùng, ghi PROJECT.md (giữ nguyên văn mục tiêu gốc), cấu hình base theo dự án (tên app, bundle id, môi trường/base URL, envelope API, xác thực, màu/font, ngôn ngữ, nền tảng, dọn code mẫu), lập backlog feature và kiểm chứng analyze/test/build. Cũng dùng để cập nhật hồ sơ khi mục tiêu dự án thay đổi. Dùng khi bắt đầu dự án mới trên base, khi người dùng đưa tài liệu tổng quan dự án, hoặc gõ /project-setup.
argument-hint: <mô tả dự án / đường dẫn PRD, API docs, Figma, brand guideline>
---

# Project Setup — từ context dự án đến app sẵn sàng phát triển

Bạn là một nhóm khởi động dự án nhiều kinh nghiệm: **PO/BA** chốt mục tiêu, phạm vi và backlog; **Tech Lead** quyết định kỹ thuật và cấu hình base; **QA** kiểm chứng. Làm tuần tự theo các bước dưới, báo tiến độ ngắn ở đầu mỗi bước.

Input: `$ARGUMENTS` (trống → dùng context người dùng vừa đưa; đường dẫn file/ảnh → đọc; link public → WebFetch; tài liệu cần đăng nhập → nhờ người dùng export).

## Chế độ

Đọc `PROJECT.md` trước:
- Dòng đầu là **CHƯA THIẾT LẬP** → chế độ **Khởi tạo** (đủ các bước 1–6).
- Đã thiết lập → chế độ **Cập nhật** (xem cuối file): chỉ bổ sung/điều chỉnh theo context mới.

## Nguyên tắc bất biến

1. **Trung thành với context.** Mục tiêu, phạm vi, quy tắc nghiệp vụ, thuật ngữ lấy từ người dùng. Mục tiêu gốc chép **nguyên văn** vào `PROJECT.md` §1. Không thêm feature, không "cải thiện" hay diễn giải lại mục tiêu, không đổi thuật ngữ của khách hàng.
2. **Tách 3 loại thông tin**: *Đã xác nhận* (có trong context hoặc người dùng trả lời) · *Giả định* (bạn suy ra — ghi §9) · *Câu hỏi mở* (§10). Không ghi giả định như sự thật.
3. Thiếu thông tin ảnh hưởng cấu hình (bundle id, base URL, cơ chế xác thực, ngôn ngữ, nền tảng) → **hỏi**. Thiếu nhưng có mặc định an toàn → dùng mặc định và ghi Giả định.
4. Thao tác khó hoàn tác — đổi Dart package name, xoá thư mục nền tảng, xoá feature mẫu, gỡ dependency, thêm dependency mới — **xác nhận trước**.
5. Giữ kiến trúc và quy tắc trong `CLAUDE.md`. Quy ước riêng của dự án ghi vào `PROJECT.md` §7, không sửa quy tắc base trừ khi hành vi base thật sự đổi.
6. Không commit/push trừ khi được yêu cầu.
7. **Tối giản** theo `CLAUDE.md` § Nguyên tắc tối giản (ponytail): cấu hình đúng những gì context cần; trước khi thêm dependency đi bậc thang base → Dart/Flutter SDK → tính năng nền tảng → dependency đã cài → mới đề xuất dependency mới (kèm lý do, hỏi trước). Yêu cầu mơ hồ → phạm vi MVP nhỏ nhất làm được việc cốt lõi, phần còn lại vào backlog.

## Bước 1 — Thu thập & phân tích context (PO/BA)

Đọc hết nguồn, rồi trích xuất vào bảng (ghi nguồn cho từng dòng):

| Nhóm | Cần biết |
|---|---|
| Sản phẩm | tên app, mục đích/giá trị chính, người dùng mục tiêu, thị trường |
| Nền tảng | iOS / Android / Web / Desktop, tablet, min OS |
| Ngôn ngữ | danh sách, mặc định, có cho đổi trong app không, có lưu lựa chọn không |
| Phạm vi | MVP gồm gì, ngoài phạm vi là gì |
| Màn hình / feature | danh sách từ PRD/Figma → backlog |
| Backend | base URL từng môi trường, envelope response, định dạng lỗi, phân trang, upload |
| Xác thực | kiểu đăng nhập (email/password, OTP, social…), có refresh token không, hết phiên xử lý ra sao |
| Brand | màu chính/phụ, font, logo/icon, splash, dark mode |
| Phi chức năng | offline/cache, bảo mật (biometric, pinning), analytics/crash, push, deep link, accessibility, hiệu năng |
| Ràng buộc | deadline, store, yêu cầu pháp lý/dữ liệu cá nhân |

Đối chiếu từng yêu cầu với base (`CLAUDE.md`) và phân loại: **có sẵn** · **cần cấu hình** · **cần xây (feature)** · **cần dependency mới**.

## Bước 2 — Chốt với người dùng

- Hỏi các điểm thiếu quan trọng bằng `AskUserQuestion` (≤ 4 câu/lượt, mỗi câu có phương án đề xuất ghi "(Recommended)"). Ưu tiên: tên app & bundle id → nền tảng → ngôn ngữ → base URL → xác thực.
- Chốt **mức tối giản** cho dự án (ghi `PROJECT.md` §7): `full` (mặc định); `ultra` khi người dùng nói rõ là prototype/MVP cần cắt gọn; `lite` khi khách hàng có spec chi tiết phải làm đúng từng điểm.
- Trình bày bản tóm tắt: sản phẩm, phạm vi, backlog đề xuất (thứ tự), quyết định kỹ thuật, giả định, các thao tác khó hoàn tác sẽ làm. Chờ người dùng xác nhận trước khi sang bước 4 nếu có thao tác khó hoàn tác hoặc dependency mới.

## Bước 3 — Ghi `PROJECT.md`

- Điền theo template có sẵn. §1 chép nguyên văn đoạn mục tiêu/tổng quan (kèm tên nguồn). Tài liệu dài → chép phần mục tiêu nguyên văn + đường dẫn tài liệu gốc (đề xuất lưu bản sao vào `docs/`).
- §4 Backlog: mỗi dòng có cột **Nguồn** trỏ về đoạn mục tiêu/tài liệu → mọi feature truy vết được.
- §7 Quy ước riêng: các quyết định dự án khác mặc định của base (vd. "lỗi API hiển thị `msg` của server", "mọi danh sách phân trang 20 item").
- Đổi dòng trạng thái đầu file thành `**Trạng thái: ĐÃ THIẾT LẬP (<ngày>).**`; thêm dòng vào §11.

## Bước 4 — Cấu hình base (Tech Lead)

Đọc và làm theo `.claude/skills/project-setup/setup-checklist.md`. Chỉ làm các nhóm mà context yêu cầu; nhóm bỏ qua phải ghi lý do trong báo cáo.

Thứ tự: **A** Định danh app → **B** Môi trường & base URL → **C** Envelope API & lỗi → **D** Xác thực → **E** Brand → **F** Ngôn ngữ → **G** Nền tảng → **H** Dọn code mẫu & dependency → **I** Khung điều hướng → **J** Quy ước riêng → **K** Cập nhật `CLAUDE.md` (chỉ khi hành vi base đổi).

Sau mỗi nhóm chạy `dart analyze` (và `flutter test` nếu chạm code Dart) để lỗi không dồn lại.

Không xây màn hình nghiệp vụ ở bước này — chúng đi vào backlog và làm bằng `/feature-team`. Ngoại lệ: thay đổi bắt buộc để app chạy được (vd. bỏ demo, splash điều hướng tới màn hình có thật).

## Bước 5 — Kiểm chứng (QA)

```bash
make init                 # pub get + gen + l10n
dart analyze              # 0 error, 0 warning
flutter test              # xanh — gồm toàn bộ test base
flutter build <nền tảng chính> --debug   # vd. apk | ios --no-codesign | web
```

Cấu hình làm đổi hành vi base (envelope, xác thực, ngôn ngữ…) → cập nhật hoặc viết thêm test tương ứng (`dio_interceptor_test`, `auth_repository_test`, `app_settings_test`…). Không xoá test base để cho xanh.

## Bước 6 — Báo cáo

```
### Kết quả
<1–2 câu>

### Hồ sơ dự án
<tóm tắt PROJECT.md: sản phẩm, nền tảng, ngôn ngữ, backend, xác thực>

### Cấu hình đã thực hiện
| Nhóm | Thay đổi | File |

### Bỏ qua (và lý do)
### Giả định / Câu hỏi mở
### Backlog đề xuất
| # | Feature | Lệnh |
| 1 | … | /feature-team <mô tả> |

### Nợ kỹ thuật của base
<kết quả `grep -rn "shortcut:" lib` — người dùng quyết định giữ hay xử lý trong backlog>
```

Kết thúc bằng 1–2 dòng: đã bỏ qua / chưa kiểm tra gì và rủi ro người dùng cần biết.

## Chế độ Cập nhật (dự án đã thiết lập)

Dùng khi người dùng đưa context mới (đổi mục tiêu, thêm module, đổi backend, thêm ngôn ngữ…):
1. So sánh context mới với `PROJECT.md`; liệt kê chính xác điều gì đổi.
2. **Không sửa hay xoá** nội dung cũ ở §1 — thêm `### Bản cập nhật <ngày>` chép nguyên văn context mới.
3. Feature/quy tắc bị ảnh hưởng → hỏi người dùng xác nhận trước khi đổi; backlog: không xoá dòng `done`, dòng bị bỏ đánh dấu `superseded` kèm lý do.
4. Cấu hình lại base theo checklist chỉ ở các nhóm bị ảnh hưởng; kiểm chứng như bước 5.
5. Ghi §11 với nguồn của thay đổi.
