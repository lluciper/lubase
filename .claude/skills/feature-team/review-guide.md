# Review guide — Tech Lead (theo `ponytail-review`)

Dùng ở bước Review của `/feature-team` và `/bugfix-team`. Review như người sẽ bị gọi dậy lúc 3 giờ sáng nếu thay đổi này hỏng. Thứ tự ưu tiên: **đúng** → **an toàn** → **chịu được tải thật** → **logic rủi ro có test** → **nhanh** → **gọn**.

## Phạm vi đọc

- Toàn bộ thay đổi của việc vừa làm: `git diff` + file mới (`git status`).
- Cộng code mà thay đổi chạm tới: caller, hàm được gọi, test liên quan, `CLAUDE.md`, `PROJECT.md`.
- Lần theo dữ liệu: **vào** từ đâu (input người dùng, response API, deep link, storage) → **lưu** ở đâu (state, `SecureStorage`, `SharePreference`) → **ra** đâu (UI, request, log).
- Hàm đổi chữ ký / giá trị trả / hành vi → grep **mọi** caller.
- Đánh giá tải theo bối cảnh app (số item trong list, tần suất gọi API, số request song song) và ghi rõ giả định tải đã dùng.

## Tìm gì (theo thứ tự)

1. **Bug** — kết quả sai, crash, edge case bị bỏ, caller bị hỏng, AC chưa đạt.
2. **Rủi ro** — bảo mật: token/dữ liệu nhạy cảm lọt vào log, deep link/tham số route không được kiểm tra, dữ liệu từ server dùng không validate; mất dữ liệu: lỗi bị nuốt, thứ tự ghi sai.
3. **Tải thật** — race condition (bấm liên tục, request song song, refresh token), rebuild thừa (selector trả object mới), list không giới hạn, gọi API lặp, ViewModel `emit` sau khi đã `close`.
4. **Thiếu test** — logic rủi ro mới không có test nào sẽ đỏ nếu nó hỏng.
5. **Hiệu năng** — chậm rõ rệt là vấn đề; tối ưu nhỏ chỉ là gợi ý.
6. **Gọn** — code chết, helper/base có sẵn mà không dùng, SDK/framework làm được, abstraction sớm, code gần trùng, hàm làm nhiều việc không liên quan, vi phạm quy tắc phụ thuộc trong `CLAUDE.md`.

## Trước khi ghi một phát hiện

- Phải nêu được **tình huống/input cụ thể** dẫn tới kết quả sai. Không có → không ghi.
- Kiểm lại: caller có thật, giá trị có thể rỗng thật, code thật sự không được dùng.
- `// shortcut:` có ghi giới hạn là **quyết định**, không phải lỗi — trừ khi tải dự kiến vượt giới hạn đó.
- Đề xuất cách sửa nhỏ nhất, ưu tiên cách **xoá** code. Không góp ý về style, không lo ngại chung chung.

## Cách ghi

```
<2–3 câu: thay đổi này làm gì>

**Phải sửa**
1. <code đang làm gì> — <vấn đề, tình huống cụ thể> — <cách sửa> — <cái giá nếu bỏ qua>

**Nên sửa**
2. …

**Có thì tốt**
3. …

Kết luận: Ship | Sửa 1, 3 trước. (Có thể bỏ ~N dòng.) Chưa kiểm tra: …
```

Không có phát hiện: `Ổn. Ship.` + một dòng đã kiểm những gì. Viết câu ngắn, giải thích thuật ngữ ở lần đầu.

## Trong quy trình team

- **Phải sửa**: DEV sửa ngay, chạy lại `dart analyze` + `flutter test`, rồi review lại phần đã sửa.
- **Nên sửa**: sửa nếu nằm trong phạm vi việc đang làm; ngoài phạm vi → đưa vào báo cáo.
- **Có thì tốt**: chỉ báo cáo.
