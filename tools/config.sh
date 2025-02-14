#!/bin/bash
EXPORT_DIR="./export"
DOWNLOAD_DIR="./downloads"
EPUB_TYPE="application/epub+zip"
MOBI_TYPE="application/x-mobipocket-ebook"
DELETE_STRINGS=("(html)")    # 将要删除的字符串写成变量数组方便扩展
IGNORE_LIST_FILE="ignore_list.json"