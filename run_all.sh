#!/bin/bash
set -e

echo "=== Đang thiết lập TrackEval ==="
if [ ! -d ~/TrackEval ]; then
    git clone https://github.com/JonathonLuiten/TrackEval.git ~/TrackEval
fi
conda run -n cv_robotics_lab21 pip install -e ~/TrackEval/

echo "=== Bắt đầu chạy tracking cho 5 video ==="
LAB_DATA="data_lab21"

conda run -n cv_robotics_lab21 python scripts/run_tracking.py --source "$LAB_DATA/video_1/img1" --seq-name video_1 --tracker bytetrack --conf 0.3 --iou 0.5 --out runs/nop_bai --save-video --device cuda:0
conda run -n cv_robotics_lab21 python scripts/run_tracking.py --source "$LAB_DATA/video_2/img1" --seq-name video_2 --tracker strongsort --conf 0.25 --iou 0.5 --out runs/nop_bai --save-video --device cuda:0
conda run -n cv_robotics_lab21 python scripts/run_tracking.py --source "$LAB_DATA/video_3/img1" --seq-name video_3 --tracker ocsort --conf 0.3 --iou 0.5 --out runs/nop_bai --save-video --device cuda:0
conda run -n cv_robotics_lab21 python scripts/run_tracking.py --source "$LAB_DATA/video_4/img1" --seq-name video_4 --tracker deepocsort --conf 0.4 --iou 0.5 --out runs/nop_bai --save-video --device cuda:0
conda run -n cv_robotics_lab21 python scripts/run_tracking.py --source "$LAB_DATA/video_5/img1" --seq-name video_5 --tracker botsort --conf 0.3 --iou 0.5 --out runs/nop_bai --save-video --device cuda:0

echo "=== Chấm điểm video_1 ==="
conda run -n cv_robotics_lab21 python scripts/evaluate_practice.py --trackeval-root ~/TrackEval --lab-data-root "$LAB_DATA" --submission runs/nop_bai/video_1.txt --run-name nhom01_video1 > runs/nop_bai/evaluate_video1.log

echo "=== ĐÃ HOÀN THÀNH TẤT CẢ ==="
