#!/bin/bash

# Kiểm tra xem fvm đã được cài đặt hay chưa
if ! command -v fvm &> /dev/null
then
    echo "FVM chưa được cài đặt. Hãy cài đặt FVM trước."
    exit 1
fi

# Kiểm tra xem flutter đã được cài đặt qua fvm hay chưa
if ! fvm list &> /dev/null
then
    echo "Không có Flutter version nào được cài đặt qua FVM. Hãy cài đặt Flutter version bằng FVM trước."
    exit 1
fi

# Hàm check phiên bản
check_version() {
    current_version=$(grep -Eo 'version: [0-9]+\.[0-9]+\.[0-9]+\+[0-9]+' pubspec.yaml | sed 's/version: //')
    version_number=$(echo $current_version | cut -d "+" -f 1)
    build_number=$(echo $current_version | cut -d "+" -f 2)
    echo "------------------------------------------------"
    echo -e "\033[0;33m" "Current version: $version_number+$build_number" "\033[0m"
    echo "------------------------------------------------"
}

# Hàm tăng version
increase_build_number() {
    check_version
    new_build_number=$((build_number + 1))
    echo "------------------------------------------------"
    echo -e "\033[0;33m" "New build version: $version_number+$new_build_number" "\033[0m"
    echo "------------------------------------------------"
    # Cập nhật phiên bản trong pubspec.yaml
    sed -i "" "s/version: $version_number+$build_number/version: $version_number+$new_build_number/" pubspec.yaml
}

increase_version_major() {
    check_version
    new_version_number=$(echo $version_number | cut -d "." -f 1)
    new_version_number=$((new_version_number + 1))
    new_version_number="$new_version_number.0.0"
    echo "------------------------------------------------"
    echo -e "\033[0;33m" "New version: $new_version_number+0" "\033[0m"
    echo "------------------------------------------------"
    sed -i "" "s/version: $version_number+$build_number/version: $new_version_number+0/" pubspec.yaml
}

increase_version_minor() {
    check_version
    new_version_number=$(echo $version_number | cut -d "." -f 2)
    new_version_number=$((new_version_number + 1))
    new_version_number=$(echo $version_number | cut -d "." -f 1).$new_version_number.0
    echo "------------------------------------------------"
    echo -e "\033[0;33m" "New version: $new_version_number+0" "\033[0m"
    echo "------------------------------------------------"
    sed -i "" "s/version: $version_number+$build_number/version: $new_version_number+0/" pubspec.yaml
}

increase_version_patch() {
    check_version
    new_version_number=$(echo $version_number | cut -d "." -f 3)
    new_version_number=$((new_version_number + 1))
    new_version_number=$(echo $version_number | cut -d "." -f 1).$(echo $version_number | cut -d "." -f 2).$new_version_number
    echo "------------------------------------------------"
    echo -e "\033[0;33m" "New version: $new_version_number+0" "\033[0m"
    echo "------------------------------------------------"
    sed -i "" "s/version: $version_number+$build_number/version: $new_version_number+0/" pubspec.yaml
}

change_version_number() {
    check_version
    read -p "Enter app version number (Example: $version_number): " NEW_VERSION
    sed -i "" "s/version: $version_number+$build_number/version: $NEW_VERSION+0/" pubspec.yaml
}

clean_build_success() {
  rm -rf ./_build_success/*
  echo "------------------------------------------------"
  echo -e "\033[0;32m" "===> Clean build success" "\033[0m"
  echo "------------------------------------------------"
}

# Hiển thị tùy chọn sửa phiên bản
choose_version_option() {
    echo "Select an option to change version number:"
    PS3="Please enter your choice (1/2/3/4/5/6): "
    options=("increase_build_number (0.0.0[+1])" "increase_version_patch (0.0.[+1])" "increase_version_minor (0.[+1].0)" "increase_version_major ([+1].0.0)" "change_version_number" "clean_build_success" "Skip")
    select opt in "${options[@]}"
    do
        case $opt in
            "increase_build_number (0.0.0[+1])")
                increase_build_number
                break
                ;;
            "increase_version_patch (0.0.[+1])")
                increase_version_patch
                break
                ;;
            "increase_version_minor (0.[+1].0)")
                increase_version_minor
                break
                ;;
            "increase_version_major ([+1].0.0)")
                increase_version_major
                break
                ;;
            "change_version_number")
                change_version_number
                break
                ;;
            "clean_build_success")
                clean_build_success
                exit
                ;;
            "Skip")
                check_version
                break
                ;;
            *)
                echo "Invalid option."
                ;;
        esac
    done
    # Lưu phiên bản cũ vào version_history.txt và ngày
    date_update=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$current_version | $date_update" >> version_history.txt
}

# Hiển thị danh sách các flavor
choose_flavor() {
    echo "Select an option flavor to build:"
    PS3="Please enter your choice (1/2/3): "
    options=("staging" "production" "Exit")
    select opt in "${options[@]}"
    do
        case $opt in
            "staging")
                flavor="staging"
                break
                ;;
            "production")
                flavor="production"
                break
                ;;
            "store")
                flavor="store"
                break
                ;;
            "Exit")
                exit
                ;;
            *)
                echo "Invalid option."
                ;;
        esac
    done
    echo "------------------------------------------------"
    echo -e "\033[0;33m" "===> Start build app with flavor: $flavor" "\033[0m"
    echo "------------------------------------------------"
}

# Build app android hoặc ios
choose_platform_build() {
    echo "Select an option platform to build app:"
    PS3="Please enter your choice (1/2/3/4/5): "
    options=("Android_APK" "Android_AppBundle" "iOS" "iOS_ADHOC" "Web" "Exit")
    FILE_PATH_BUILD_SUCCESS="_build_success"
    mkdir -p "$FILE_PATH_BUILD_SUCCESS"
    select opt in "${options[@]}"
    do
        case $opt in
            "Android_APK")
                fvm flutter clean
                fvm flutter pub get
                fvm flutter build apk --flavor $flavor --dart-define-from-file=config.$flavor.json --no-tree-shake-icons
                while read filepath; do
                   filename=$(basename "$filepath" .apk)
                   filepath_new="$FILE_PATH_BUILD_SUCCESS"/"$flavor"_"$filename"_"$(date '+%Y_%m_%d_%H:%M:%S')".apk
                   cp "$filepath" "$filepath_new"
                   FILE_PATH_BUILD_SUCCESS=$(echo $filepath_new)
                done <<<$(find ./build/app/outputs/flutter-apk/ -type f -name "*.apk")
                break
                ;;
            "Android_AppBundle")
                fvm flutter clean
                fvm flutter pub get
                fvm flutter build appbundle --flavor $flavor --dart-define-from-file=config.$flavor.json --no-tree-shake-icons
                while read filepath; do
                   filename=$(basename "$filepath" .aab)
                   filepath_new="$FILE_PATH_BUILD_SUCCESS"/"$flavor"_"$filename"_"$(date '+%Y_%m_%d_%H:%M:%S')".aab
                   cp "$filepath" "$filepath_new"
                   FILE_PATH_BUILD_SUCCESS=$(echo $filepath_new)
                done <<<$(find ./build/app/outputs/bundle/productionRelease/ -type f -name "*.aab")
                break
                ;;
            "iOS")
                fvm flutter clean
                fvm flutter pub get
                fvm flutter build ipa --flavor $flavor --dart-define-from-file=config.$flavor.json
                while read filepath; do
                   filename=$(basename "$filepath" .ipa)
                   filepath_new="$FILE_PATH_BUILD_SUCCESS"/"$flavor"_"$filename"_"$(date '+%Y_%m_%d_%H:%M:%S')".ipa
                   cp "$filepath" "$filepath_new"
                   FILE_PATH_BUILD_SUCCESS=$(echo $filepath_new)
                done <<<$(find ./build/ios/ipa/ -type f -name "*.ipa")
                break
                ;;
            "iOS_ADHOC")
                fvm flutter clean
                fvm flutter pub get
                fvm flutter build ipa --flavor $flavor --dart-define-from-file=config.$flavor.json --release --export-method=ad-hoc
                while read filepath; do
                   filename=$(basename "$filepath" .ipa)
                   filepath_new="$FILE_PATH_BUILD_SUCCESS"/"$flavor"_adHoc_"$filename"_"$(date '+%Y_%m_%d_%H:%M:%S')".ipa
                   cp "$filepath" "$filepath_new"
                   FILE_PATH_BUILD_SUCCESS=$(echo $filepath_new)
                done <<<$(find ./build/ios/ipa/ -type f -name "*.ipa")
                break
                ;;
            "Web")
                # Build html from template
                cd scripts && bash define_webapp_html.sh && bash define_webapp_deeplink.sh && cd ..
                fvm flutter clean
                fvm flutter pub get
                fvm flutter build web --dart-define-from-file=config.$flavor.json --release
                # Tạo thư mục build success
                BUILD_FOLDER_NAME="web_$flavor"_"$(date '+%Y_%m_%d_%H:%M:%S')"
                mkdir -p "$FILE_PATH_BUILD_SUCCESS"/"$BUILD_FOLDER_NAME"
                cp -r ./build/web/* "$FILE_PATH_BUILD_SUCCESS"/"$BUILD_FOLDER_NAME"
                cd "$FILE_PATH_BUILD_SUCCESS" && zip -r "$BUILD_FOLDER_NAME".zip "$BUILD_FOLDER_NAME" && rm -rf "$BUILD_FOLDER_NAME"
                cd ..
                break
                ;;
            "Exit")
                exit
                ;;
            *)
                echo "Invalid option."
                ;;
        esac
    done
}

# Kiểm tra thông số đầu vào
choose_version_option
choose_flavor
choose_platform_build
echo "------------------------------------------------"
echo -e "\033[0;32m" "===> Build app successfully" "\033[0m"
echo -e "\033[0;33m" "===> File path: $FILE_PATH_BUILD_SUCCESS" "\033[0m"
echo "------------------------------------------------"
