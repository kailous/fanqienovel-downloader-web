#!/bin/bash

# 引入颜色函数
source ./tools/echo.sh

# 项目初始化函数
install() {
    # 创建虚拟环境
    python3 -m venv .venv
    # 激活虚拟环境
    source .venv/bin/activate
    # 安装依赖
    pip install -r requirements.txt
    # 升级 pip
    pip install --upgrade pip
    # 运行项目
    start
}

# 项目启动函数
start() {
    # 激活虚拟环境
    source .venv/bin/activate
    # 启动项目
    python src/server.py
    # 打开浏览器访问 http://localhost:12930
    open http://localhost:12930
}

# 检查是否创建了虚拟环境，如果没有则执行初始化函数，否则执行启动函数
if [ ! -d ".venv" ]; then
    yellow_echo "项目未初始化，正在初始化..."
    install
else
    green_echo "项目已初始化，正在启动..."
    start
fi

# 判断是否安装了 pandoc 没有则安装
if ! command -v pandoc &> /dev/null; then
    # 判断是否安装了 brew
    if ! command -v brew &> /dev/null; then
        yellow_echo "未安装 brew，正在安装..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
        yellow_echo "未安装 pandoc，正在安装..."
    brew install pandoc
fi