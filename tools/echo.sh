# 绿色echo
function green_echo() {
    echo -e "\033[32m$1\033[0m"
}

# 黄色echo
function yellow_echo() {
    echo -e "\033[33m$1\033[0m"
}

# 红色echo
function red_echo() {
    echo -e "\033[31m$1\033[0m"
}