# Fanqienovel-downloader-webs
下载番茄小说的 webapp，通过Python实现，本人实测 macOS 15.3 Python 3.9.19 运行正常。

## 启动
我做了自动化脚本，自动完成虚拟环境的创建和激活。
用 Git 克隆这个项目到本地后使用终端进入到项目根目录

``` sh
cd <项目目录> #进入项目目录
chmod +x ./tools/*.sh #给脚本赋权
./tools/run.sh #启动程序
```

## 脚本工具

| 脚本 | 说明 |
| :--- | :--- |
| clean_html.sh | 将下载的html初步处理并输出到 [export] 目录 |
| book.sh | 处理 [export] 中的图书 |