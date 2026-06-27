# 宅建ドリル — Luyện đề Takken mỗi ngày

Mỗi ngày 3 câu hỏi từ đề thi thật **宅地建物取引士 (Takken)** 10 năm qua, kèm dịch nghĩa và phân tích chi tiết bằng tiếng Việt.

## Mô hình
"Tĩnh nhưng nạp động" — giao diện cố định, nội dung nạp qua JavaScript (Fetch API). Host trên GitHub Pages.

## Cấu trúc
```
luyen-de-takken/
├── index.html              # Trang chủ: đọc database.json, nạp đề, chấm điểm, ẩn/hiện giải thích
├── database.json           # Mục lục: quiz_list = ["YYYY-MM-DD", ...] (mới → cũ)
├── archive/
│   ├── YYYY-MM-DD.html      # Đề từng ngày (fragment thô, 3 câu)
│   └── _TEMPLATE.html       # Khung mẫu + "hợp đồng" data-attribute (không push)
├── serve.ps1               # Server test local cổng 8080
├── .nojekyll               # Tắt Jekyll
├── CLAUDE.md               # Prompt vận hành tự động hằng ngày
└── README.md
```

## "Hợp đồng" file archive
- `<div class="question-card" data-correct="N">` — N = số đáp án đúng (1–4).
- 4 thẻ `<li class="option" data-choice="1..4">`.
- 1 `<button class="reveal-btn">` + 1 `<div class="explanation">` ẩn sẵn.
- Đề + phương án: tiếng Nhật. Giải thích: tiếng Việt.

## Test local
```powershell
powershell -ExecutionPolicy Bypass -File serve.ps1
# http://localhost:8080
```
(Phải qua HTTP server — mở thẳng file:// sẽ bị chặn Fetch/CORS.)
