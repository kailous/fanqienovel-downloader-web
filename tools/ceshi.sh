function add_css_link() {
    # 获取NEW_ABSOLUTE_EXPORT_DIR文件夹下所有的html文件，使用xargs处理空格和特殊字符
    find "$NEW_ABSOLUTE_EXPORT_DIR" -type f -name "*.html" -print0 | while IFS= read -r -d '' html_file; do
        # 检查html文件中是否已经包含链接，防止重复添加
        if ! grep -q '<link rel="stylesheet" href="styles/style.css">' "$html_file"; then
            # 如果文件中没有css链接，插入css链接
            # 使用sed进行替换并确保只插入一次
            if [[ "$(uname)" == "Darwin" ]]; then
                # macOS：插入到<head>后面
                sed -i '' '/<head>/a\
    <link rel="stylesheet" href="styles/style.css">' "$html_file"
            else
                # Linux：插入到<head>后面
                sed -i '/<head>/a\
    <link rel="stylesheet" href="styles/style.css">' "$html_file"
            fi
            green_echo "$(basename "$html_file") 添加css链接成功✅"
        else
            green_echo "$(basename "$html_file") css链接已存在✅"
        fi
    done
}
