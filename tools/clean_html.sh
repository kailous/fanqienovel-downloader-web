#!/bin/bash

# 引入颜色函数
source ./tools/echo.sh
# 引入配置文件
source ./tools/config.sh

# 遍历 DOWNLOAD_DIR 下的文件夹 输出列表让用户选择
function select_download() {
    # 获取 DOWNLOAD_DIR 下的所有文件夹
    DOWNLOADS=($(ls -d "$DOWNLOAD_DIR"/*/))
    # 输出列表
    for i in "${!DOWNLOADS[@]}"; do
        green_echo "$i: $(basename "${DOWNLOADS[$i]}")"
    done
    # 选择下载目录
    read -p "请选择下载目录: " DOWNLOAD_INDEX
    # 获取选择的下载目录
    DIRECTORY="${DOWNLOADS[$DOWNLOAD_INDEX]}"
    IGNORE_FILE="${DIRECTORY}${IGNORE_LIST_FILE}"
    EXPORT_FILES_DIR="$EXPORT_DIR/$(basename "$DIRECTORY")"
}

# 读取忽略清单
function read_ignore_list() {
    if [ -f "$IGNORE_FILE" ]; then
        IGNORE_LIST=()
        while IFS= read -r line; do
            IGNORE_LIST+=("$line")
        done < <(jq -r '.[]' "$IGNORE_FILE")
        echo "读取忽略清单:"
        for ignored_file in "${IGNORE_LIST[@]}"; do
            echo " - $ignored_file"
        done
    else
        IGNORE_LIST=()
        echo "忽略清单文件未找到。"
    fi
}

# 清理 HTML 文件的函数
function clean_html_files() {
    # 确保输出目录存在
    mkdir -p "$EXPORT_FILES_DIR"

    find "$DIRECTORY" -type f -name "*.html" | while read -r FILE; do
        FILENAME=$(basename "$FILE")
        
        green_echo "处理文件: $FILENAME ✅"
        
        # 创建输出文件路径
        OUTPUT_FILE="$EXPORT_FILES_DIR/$FILENAME"
        
        # 删除 <div class="navigation"> ... </div> 部分并输出到新文件
        sed '/<div class="navigation">/,/<\/div>/d' "$FILE" | \
        sed '/<style>/,/<\/style>/d' > "$OUTPUT_FILE"
    done

    green_echo "所有 HTML 文件处理完毕。"
}

# 删除忽略清单中的文件
function delete_ignored_files() {
    for ignored_file in "${IGNORE_LIST[@]}"; do
        OUTPUT_FILE="$EXPORT_FILES_DIR/$ignored_file"
        if [ -f "$OUTPUT_FILE" ]; then
            yellow_echo "删除忽略文件: $ignored_file"
            rm -f "$OUTPUT_FILE"
        fi
    done
}

# 格式化 <div class="toc"> 内的所有 <a> 标签
function format_toc() {
    local filepath="$EXPORT_FILES_DIR/index.html"

    # 检查是否提供文件路径
    if [ -z "$filepath" ]; then
        red_echo "未提供文件路径"
        return 1
    fi

    # 确保文件存在
    if [ ! -f "$filepath" ]; then
        red_echo "文件未找到: $filepath"
        return 1
    fi

    # 读取文件内容并格式化 <div class="toc"> 内的所有 <a> 标签
    awk '
    BEGIN { RS="</div>"; FS="<div class=\"toc\">"; ORS="</div>" }
    {
        if (NF > 1) {
            gsub(/\n/, "", $2)
            gsub(/>[ \t]+</, "><", $2)
            $2 = "<ul>\n<li>" $2 "</li>\n</ul>"
            gsub(/<\/a><a /, "</a></li>\n<li><a ", $2)
            gsub(/ {2,}/, " ", $2)  # 将超过2个空格的部分替换为1个空格
            print $1 "<div class=\"toc\">\n" $2 "\n</div>"
        } else {
            print
        }
    }
    ' "$filepath" > "${filepath}.tmp"

    # 替换原文件
    mv "${filepath}.tmp" "$filepath"

    green_echo "文件已格式化: $filepath"
}

# 输出所有变量调试
function debug() {
    echo "DIRECTORY: $DIRECTORY"
    echo "EXPORT_FILES_DIR: $EXPORT_FILES_DIR"
    echo "IGNORE_FILE: $IGNORE_FILE"
    echo "IGNORE_LIST_FILE: $IGNORE_LIST_FILE"
    echo "EXPORT_DIR: $EXPORT_DIR"
    echo "DOWNLOAD_DIR: $DOWNLOAD_DIR"
    echo "EPUB_TYPE: $EPUB_TYPE"
    echo "MOBI_TYPE: $MOBI_TYPE"
    echo "DELETE_STRINGS: ${DELETE_STRINGS[@]}"
    echo "IGNORE_LIST: ${IGNORE_LIST[@]}"
}

select_download # 调用选择下载目录函数
clean_html_files # 调用清理函数
read_ignore_list # 调用读取忽略清单函数
delete_ignored_files # 调用删除忽略文件的函数
format_toc # 调用格式化 <div class="toc"> 内的所有 <a> 标签的函数
# debug