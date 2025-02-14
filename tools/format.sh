#!/bin/bash
# filepath: /Users/lipeng/Documents/Repository/fanqienovel-downloader-web/tools/format.sh

# 如果需要颜色输出函数、配置文件和信息获取函数，请取消以下注释：
# source ./tools/echo.sh
# source ./tools/config.sh
# source ./tools/get_info.sh

# 将 BOOK_DIR 中所有 HTML 文件转换为 XHTML 文件（按文件名版本排序），
# 输出文件名形如：chapter0000000001.xhtml, chapter0000000002.xhtml, ...
function html2xhtml() {
    mkdir -p "$DOC_DIR"
    COUNTER=0
    find "$BOOK_DIR" -type f -name "*.html" -print0 | sort -z -V | while IFS= read -r -d '' FILE; do
        ((COUNTER++))
        OUTPUT_FILE="$DOC_DIR/chapter$(printf "%010d" "$COUNTER").xhtml"
        FILENAME=$(basename "$FILE")
        green_echo "处理文件: $FILENAME, 生成: $(basename "$OUTPUT_FILE")"
        if command -v xmllint >/dev/null 2>&1; then
            green_echo "使用 xmllint 转换文件..."
            xmllint --html --xmlout "$FILE" -o "$OUTPUT_FILE"
        else
            green_echo "使用 tidy 转换文件..."
            tidy -q -asxhtml -utf8 "$FILE" > "$OUTPUT_FILE"
        fi
    done
}