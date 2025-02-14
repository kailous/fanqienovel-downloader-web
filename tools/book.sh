#!/bin/bash

# 引入颜色函数
source ./tools/echo.sh
# 引入配置文件
source ./tools/config.sh
# 引入信息获取函数
source ./tools/get_info.sh

select_book
get_book_info
# 显示书籍信息
echo "书籍信息:"
green_echo "书籍名: $BOOK_NAME"
green_echo "作者: $AUTHOR"
green_echo "UUID: $UUID"
green_echo "书籍目录: $BOOK_DIR"