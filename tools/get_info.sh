#!/bin/bash

# 引入颜色函数
source ./tools/echo.sh
# 引入配置文件
source ./tools/config.sh

# 遍历EXPORT_DIR 下的文件夹 忽略style文件夹 输出列表让用户选择
function select_book() {
    # 获取EXPORT_DIR下的所有文件夹
    BOOKS=($(ls -d "$EXPORT_DIR"/*/))
    # 忽略style文件夹
    BOOKS=(${BOOKS[@]//*style/})
    # 输出列表
    for i in "${!BOOKS[@]}"; do
        green_echo "$i: $(basename "${BOOKS[$i]}")"
    done
    # 选择书籍
    read -p "请选择书籍: " BOOK_INDEX
    # 获取选择的书籍
    SELECTED_BOOK="${BOOKS[$BOOK_INDEX]}"
    BOOK_NAME=$(basename "$SELECTED_BOOK")
    BOOK_DIR="$EXPORT_DIR/$BOOK_NAME"
    check_info_file
}

# 检查是否有存在书籍信息文件
function check_info_file() {
    if [ -f "$BOOK_DIR/info.json" ]; then
        green_echo "书籍信息文件已存在✅"
    else
        GET_BOOK_UUID
        GET_BOOK_AUTHOR
        generate_info_file
        exit 1
    fi
}

# 请求UUID
function GET_BOOK_UUID() {
    read -p "请输入番茄读书 ID 以生成 UUID: " id
    
    # 使用 SHA1 哈希算法生成 UUID，采用 UUIDv5 的规则
    hash=$(echo -n "$id" | sha1sum | awk '{print $1}')
    
    # 格式化哈希值为符合 UUID 格式
    # 1. 在第13位填充 '4'。
    # 2. 在第17位填充 '8' 到 'b' 的值。
    UUID="${hash:0:8}-${hash:8:4}-4${hash:12:3}-${hash:16:1}$(printf '%x' $((RANDOM % 4 + 8)))-${hash:17:12}"
}

# 请求输入作者名
function GET_BOOK_AUTHOR() {
    read -p "请输入作者名: " AUTHOR
}

# 生成书籍信息文件
function generate_info_file() {
    cat > "$BOOK_DIR/info.json" << EOF
{
    "name": "$BOOK_NAME",
    "uuid": "$UUID",
    "author": "$AUTHOR"
}
EOF
    green_echo "书籍信息文件生成成功: ${BOOK_DIR}/info.json"
}

# 传递变量 BOOK_NAME AUTHOR UUID
function get_book_info() {
    BOOK_NAME=$(jq -r '.name' "$BOOK_DIR/info.json")
    AUTHOR=$(jq -r '.author' "$BOOK_DIR/info.json")
    UUID=$(jq -r '.uuid' "$BOOK_DIR/info.json")
}

# 其他衍生变量