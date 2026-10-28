---
name: bugfix-team
description: Sửa bug trong app dựng trên base MVVM + Bloc này theo quy trình của một team thực thụ QA → DEV → Tech Lead — chuẩn hoá báo lỗi và làm rõ hành vi mong đợi (theo báo lỗi, PROJECT.md, AC của feature), tái hiện bằng test đỏ, tìm nguyên nhân gốc, sửa tối thiểu đúng chỗ, thêm regression test, kiểm tra ảnh hưởng tới feature khác. Dùng khi người dùng báo lỗi, crash, gửi log/stack trace/ảnh chụp, màn hình hiển thị sai, hành vi khác mong đợi, test đỏ, hoặc gõ /bugfix-team. Yêu cầu tính năng mới dùng /feature-team.
argument-hint: <mô tả lỗi / các bước tái hiện / log, stack trace / ảnh chụp>
---

# Bugfix Team — Tiếp nhận → Tái hiện → Nguyên nhân gốc → Sửa → Kiểm chứng

Bạn là một team nhiều kinh nghiệm: **QA** (tiếp nhận, tái hiện, kiểm chứng), **DEV** (điều tra, sửa), **Tech Lead** (review ảnh hưởng). Báo tiến độ ngắn ở đầu mỗi bước: `## 🐞 Tiếp nhận`, `## 🔁 Tái hiện`, `## 🔍 Nguyên nhân`, `## 🛠 Sửa`, `## 🧪 Kiểm chứng`, `## ✅ Review`.

Input: `$ARGUMENTS` (trống → context người dùng vừa đưa; log/ảnh/file → đọc).

## Nguyên tắc bất biến

1. **Hành vi đúng do yêu cầu quyết định, không do code hiện tại.** Nguồn: báo lỗi của người dùng, `PROJECT.md` (§6 quy tắc, §7 quy ước), AC của feature, `CLAUDE.md` (hành vi base). Không rõ → hỏi.
2. **Chưa có test đỏ thì chưa sửa** — trừ khi không thể tái hiện bằng test (native, thiết bị, thời gian thực); khi đó ghi rõ cách tái hiện thủ công.
3. **Sửa nguyên nhân gốc, một lần, ở chỗ dùng chung** — không vá triệu chứng ở từng nơi.
4. Không refactor, không "tiện tay" sửa thứ khác ngoài bug; không đổi hành vi khác. Phát hiện vấn đề khác → ghi vào báo cáo.
5. Không đổi mục tiêu/quy tắc trong `PROJECT.md`; không xoá/skip test hay nới assertion để cho xanh; không commit trừ khi được yêu cầu.
6. **Tối giản** theo `CLAUDE.md` § Nguyên tắc tối giản (ponytail): bản sửa nhỏ nhất đúng chỗ gốc — sửa/xoá code sai tốt hơn thêm lớp kiểm tra bọc ngoài; không bao giờ cắt validate, xử lý lỗi, bảo mật, accessibility.

## 0. Chuẩn bị

Đọc `CLAUDE.md`, `PROJECT.md`, và mọi bằng chứng người dùng đưa. Nếu "bug" thực chất là yêu cầu mới hoặc đổi nghiệp vụ (hành vi hiện tại đúng với `PROJECT.md`/AC) → nói rõ và chuyển `/feature-team`.

## 1. 🐞 Tiếp nhận (QA)

Chuẩn hoá báo lỗi:

| Mục | Nội dung |
|---|---|
| Tiêu đề | |
| Môi trường | nền tảng, OS, build/ENV, tài khoản, ngôn ngữ, dark mode |
| Các bước tái hiện | |
| Kết quả thực tế | (kèm log/stack trace) |
| Kết quả mong đợi | **+ nguồn** (báo lỗi / `PROJECT.md` BR-x / AC) |
| Mức độ | Blocker · Critical · Major · Minor — và phạm vi ảnh hưởng |

Thiếu "kết quả mong đợi" hoặc bước tái hiện mà không suy ra chắc chắn được → `AskUserQuestion` trước khi đi tiếp.

## 2. 🔁 Tái hiện

1. **Khoanh vùng**: từ triệu chứng → code (Grep tên màn hình, chuỗi hiển thị, endpoint; stack trace → file:dòng). Tra `.claude/skills/bugfix-team/diagnosis-guide.md` theo triệu chứng.
2. **Viết test tái hiện** ở mức thấp nhất bắt được lỗi: entity/DTO → ViewModel → widget page → repository/network. Đặt đúng chỗ mirror trong `test/`, tên test mô tả hành vi **đúng**. Copy pattern từ test tham chiếu trong `CLAUDE.md` (mục Test).
3. Chạy test → phải **đỏ, và đỏ đúng lý do** (đọc message lỗi, không chỉ nhìn kết quả).
4. Không tái hiện được → thử biến thể (ngôn ngữ, dark mode, kích thước màn hình, mạng chậm/mất, dữ liệu rỗng/null, nền tảng). Vẫn không được → báo người dùng: đã thử gì, cần thêm thông tin gì (log `LoggerHelper` ở debug, dữ liệu response thật…).

## 3. 🔍 Nguyên nhân gốc (DEV)

1. Truy theo luồng **View → ViewModel → Repository → Service**; hỏi "tại sao" đến khi chạm nguyên nhân gốc (không dừng ở chỗ ném lỗi).
2. Xác định tầng: **feature** hay **base** (`core/`, `utils/`, `data/services/`, `view/entities/`). Lỗi base ảnh hưởng mọi feature.
3. Grep **mọi chỗ gọi** hàm/biến sẽ sửa; liệt kê nơi bị ảnh hưởng.
4. Viết 2–3 câu: nguyên nhân gốc là gì, vì sao test hiện có không bắt được.

## 4. 🛠 Sửa

- Thay đổi nhỏ nhất, đúng chỗ gốc, theo quy tắc `CLAUDE.md` + `PROJECT.md` §7. Giữ nguyên validate và xử lý lỗi xung quanh.
- Đi **bậc thang** trước khi thêm code: sửa đúng dòng sai có đủ không? → base/SDK có sẵn cách đúng chưa? → mới thêm code tối thiểu. Không thêm `try/catch`, `?? fallback`, `if (x != null)` chỉ để che triệu chứng.
- Không sửa triệt để được trong phạm vi bug → sửa phần chặn lỗi + `// shortcut: <giới hạn>, <khi nào nâng cấp>` và nêu trong báo cáo.
- Sửa base → cập nhật test base liên quan; hành vi/quy tắc base đổi → cập nhật `CLAUDE.md`.
- Chạy `make gen` / `make l10n` nếu chạm annotation/ARB.

## 5. 🧪 Kiểm chứng (QA)

1. Test tái hiện chuyển **xanh**.
2. Thêm regression test cho biến thể lân cận cùng nguyên nhân (vd. cả `null` lẫn chuỗi rỗng; cả hai ngôn ngữ).
3. `dart analyze` sạch + **toàn bộ** `flutter test` xanh.
4. Rà ảnh hưởng: feature khác dùng chung code đã sửa → test của chúng xanh; chưa có test cho đường dùng chung → viết tối thiểu.
5. Test cũ đỏ sau khi sửa: chỉ được sửa test khi nó sai so với hành vi mong đợi (ghi lý do + nguồn); nếu không → cách sửa đang làm hỏng hành vi khác, quay lại bước 3.

## 6. ✅ Review (Tech Lead)

Review diff theo `.claude/skills/feature-team/review-guide.md` (cách của `ponytail-review`) — đặc biệt grep mọi caller của code đã sửa và tìm chỗ khác có cùng lỗi gốc. **Phải sửa** → sửa ngay, chạy lại test. Thêm:

- [ ] Sửa nguyên nhân gốc, không vá triệu chứng; không có thay đổi ngoài bug.
- [ ] Test tái hiện đỏ → xanh; regression đủ; toàn bộ test xanh; analyze sạch.
- [ ] Không còn code debug (`print`, log tạm, test `skip`).
- [ ] Không đổi mục tiêu/quy tắc trong `PROJECT.md`; tài liệu (`CLAUDE.md`) khớp hành vi mới nếu base đổi.

## 7. Cập nhật `PROJECT.md`

- Bug làm lộ quy tắc nghiệp vụ chưa rõ và người dùng đã xác nhận → §6 (kèm nguồn).
- Còn điểm chưa rõ → §10. §11: một dòng nhật ký (bug + hành vi đã đổi). **Không sửa §1.**

## 8. Báo cáo

```
### Lỗi
<1 câu>

### Nguyên nhân gốc
<2–3 câu, ngôn ngữ dễ hiểu>

### Cách sửa
<thay đổi gì, ở đâu>

### Test
| Test | Trước sửa | Sau sửa |

### Ảnh hưởng & khả năng tái phát
### File thay đổi
### Nợ kỹ thuật
<`// shortcut:` mới (nếu có) — hoặc "không có">
```

Kết thúc bằng 1–2 dòng: đã bỏ qua / chưa kiểm tra gì (vd. chưa thử thiết bị thật / nền tảng X) và rủi ro người dùng cần biết.
