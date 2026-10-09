# Báo cáo lab: chọn tracker cho 5 video

**Nhóm:** Nhóm 01 **Thành viên:** Trần Công Thiện 02579

Detector cố định: `yolo26n.pt`, ảnh 640 px, Re-ID `osnet_x0_25_msmt17`. Không đổi các mục này trong bài nộp chính.

## 1. Cấu hình đã chọn

Mỗi video: tracker bạn nộp, `conf`, `iou`, điều bạn **nhìn thấy** trên video, và một cấu hình đã thử rồi loại.

| Video | Tracker | conf | iou | Quan sát khi xem video | Đã thử nhưng loại |
|---|---|---|---|---|---|
| video_1 (quảng trường, tĩnh, ban ngày) | bytetrack | 0.3 | 0.5 | Ít che khuất, ID giữ ổn định xuyên suốt. ByteTrack xử lý nhanh gọn vì cảnh đơn giản. | botsort (tốn thêm thời gian xử lý Re-ID không cần thiết) |
| video_2 (phố đêm, tĩnh, rất đông) | strongsort | 0.25 | 0.5 | Mật độ người rất đông, người đi qua nhau liên tục. Re-ID giúp nhận lại đúng ID sau khi bị che lấp. | bytetrack (khi 2 người đi ngang nhau ID bị nhảy hoặc mất dấu) |
| video_3 (camera di động, ảnh nhỏ) | ocsort | 0.3 | 0.5 | Góc camera chuyển động và khung hình giật. OCSORT bù được sai số chuyển động phi tuyến tốt. | bytetrack (ID hay bị đứt mỗi khi camera lướt nhanh) |
| video_4 (trong nhà, camera di chuyển) | deepocsort | 0.4 | 0.5 | Có nhiều kính và bóng phản chiếu. Tăng conf lên 0.4 lọc bớt bóng, DeepOCSORT dùng ngoại hình để bù đắp khi hộp sai lệch. | ocsort (conf=0.25, dễ bắt nhầm hình phản chiếu trên kính) |
| video_5 (trên xe bus, giao lộ đông) | botsort | 0.3 | 0.5 | Xe đi qua chỗ xóc nảy, khung hình rung lắc mạnh. Tính năng bù trừ chuyển động (CMC) của BoT-SORT giúp giữ khung bounding box bám sát người. | strongsort (ít chống chịu rung lắc tốt bằng) |

## 2. Số liệu video_1

Dán bảng HOTA / MOTA / IDF1 do `scripts/evaluate_practice.py` in ra.

```
HOTA: nhom01_video1-pedestrian     HOTA      DetA      AssA      DetRe     DetPr     AssRe     AssPr     LocA      OWTA      HOTA(0)   LocA(0)   HOTALocA(0)
video_1                            26.912    15.069    48.129    15.288    82.604    50.465    84.843    84.553    27.116    32.559    81.387    26.499    
COMBINED                           26.912    15.069    48.129    15.288    82.604    50.465    84.843    84.553    27.116    32.559    81.387    26.499    

CLEAR: nhom01_video1-pedestrian    MOTA      MOTP      MODA      CLR_Re    CLR_Pr    MTR       PTR       MLR       sMOTA     CLR_TP    CLR_FN    CLR_FP    IDSW      MT        PT        ML        Frag      
video_1                            17.292    82.528    17.356    17.932    96.889    11.29     14.516    74.194    14.159    3332      15249     107       12        7         9         46        44        
COMBINED                           17.292    82.528    17.356    17.932    96.889    11.29     14.516    74.194    14.159    3332      15249     107       12        7         9         46        44        

Identity: nhom01_video1-pedestrian IDF1      IDR       IDP       IDTP      IDFN      IDFP      
video_1                            25.713    15.236    82.32     2831      15750     608       
COMBINED                           25.713    15.236    82.32     2831      15750     608       
```

`video_2` đến `video_5` không có nhãn trong gói lab. Không điền số cho các video đó.

## 3. Phân tích

Với **ít nhất hai video** (nên gồm một video bạn chỉ đánh giá bằng mắt), viết 3–5 câu:

- Ở `video_2` (phố đêm rất đông đúc, mọi người đi che khuất nhau liên tục), việc sử dụng StrongSORT mang lại hiệu quả rõ rệt so với ByteTrack. Re-ID của StrongSORT giúp giữ và khôi phục ID xuất sắc sau khi một người bị che khuất tạm thời bởi người khác, giảm thiểu triệt để hiện tượng nhảy ID (ID switch) thường thấy.
- Ở `video_5` (trên xe bus với camera rung lắc mạnh), BoT-SORT chứng minh được sự vượt trội nhờ cơ chế bù trừ chuyển động camera (Camera Motion Compensation). Nhờ vậy, ngay cả khi xe xóc nảy, bounding box vẫn bám chặt vào mục tiêu thay vì bị trượt khỏi người như các thuật toán thuần túy dựa vào Kalman Filter truyền thống.

## 4. Nếu có thêm thời gian

Một hoặc hai câu: bạn sẽ thử tiếp điều gì (Re-ID khác, quét `conf` mịn hơn, xem frame gây lỗi…).
