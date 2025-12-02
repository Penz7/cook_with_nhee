#!/bin/bash

echo "Chọn option để chạy:"
echo "1) Gen build_runner (build)"
echo "2) Gen intl_utils"
echo "3) Gen launcher icons (production)"
echo "4) Gen launcher icons (develop)"
echo "5) (Nhấn Enter mặc định) Gen cả build_runner và intl_utils"
echo "6) Clean build_runner"
read -p "Nhập số (1/2/3/4/6) hoặc nhấn Enter để chọn cả hai: " option

echo "Chạy fvm use 3.38.2..."
fvm use 3.38.2

if [ -z "$option" ] || [ "$option" = "5" ]; then
  echo "Chạy build_runner và intl_utils..."
  fvm dart run build_runner build --delete-conflicting-outputs
  fvm flutter pub run intl_utils:generate
elif [ "$option" = "1" ]; then
  echo "Chạy build_runner build..."
  fvm dart run build_runner build --delete-conflicting-outputs
elif [ "$option" = "2" ]; then
  echo "Chạy intl_utils..."
  fvm flutter pub run intl_utils:generate
elif [ "$option" = "3" ]; then
  echo "Chạy flutter_launcher_icons production..."
  fvm flutter pub run flutter_launcher_icons -f flutter_launcher_icons-production.yaml
elif [ "$option" = "4" ]; then
  echo "Chạy flutter_launcher_icons develop..."
  fvm flutter pub run flutter_launcher_icons -f flutter_launcher_icons-develop.yaml
elif [ "$option" = "6" ]; then
  echo "Chạy build_runner clean..."
  fvm dart run build_runner clean
else
  echo "Lựa chọn không hợp lệ. Vui lòng chọn 1, 2, 3, 4, 6 hoặc nhấn Enter."
  exit 1
fi

echo "Hoàn thành."
