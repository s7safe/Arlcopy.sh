#!/bin/bash

# 定义常量
IMAGE_NAME="tophant/arl:latest"
FILE_MAPPING=(
    ["file_top_2000"]="file_top_2000.txt"
    ["domain_2w"]="domain_2w.txt"
)
DEFAULT_TARGET_PATH="/code/app/dicts/"

# 定义帮助信息
USAGE="使用方法：$0 [OPTION] FILENAME\n将文件复制到Arl中自定义自己的子域名和敏感路径扫描文件，在复制的过程中。\n\n选项：\n  -h\t显示此帮助信息并退出\n\n参数：\n  FILENAME\t要复制的文件名 \n\n file_top_2000.txt 为敏感路径 domain_2w.txt为子域名 用法 sh Arlcopy.sh file_top_2000.txt \n\n"

# 定义运行logo
LOGO="╔═════════════════════════╗
║  ╦═╗┌─┐┌─┐┬  ┌─┐┌┐┌┌─┐   ║
║  ╠╦╝├┤ ├┤ │  ├─┤│││├┤    ║
║  ╩╚═└─┘└  ┴─┘┴ ┴┘└┘└─┘   ║
║                         ║
║         Arlcopy        ║
║                         ║
║     Designed by R.M6   ║
╚═════════════════════════╝\n\n"

# 检查输入参数
if [[ $# -eq 0 ]] || [[ "$1" == "-h" ]]; then
  echo -e "$LOGO"
  echo -e "$USAGE"
  exit 0
elif [[ $# -ne 1 ]]; then
  echo "错误：需要提供一个参数。"
  echo -e "$USAGE"
  exit 1
fi

# 获取输入参数
file_to_copy="$1"  # 要复制的文件名

# 获取目标路径
target_path=""
for key in "${!FILE_MAPPING[@]}"; do
    if [ "$key" = "$file_to_copy" ]; then
        target_path="${FILE_MAPPING[$key]}"
        break
    fi
done

# 如果找不到对应的目标路径，则使用默认路径
if [ -z "$target_path" ]; then
    target_path="$DEFAULT_TARGET_PATH$file_to_copy"
fi

# 获取容器ID列表
container_ids=$(docker ps --filter ancestor="$IMAGE_NAME" --format "{{.ID}}")

# 检查是否找到容器
if [[ -z "$container_ids" ]]; then
  echo "错误：找不到基于镜像 $IMAGE_NAME 运行的容器。"
  exit 1
fi

# 执行文件复制操作
for container_id in $container_ids; do
    docker cp "$file_to_copy" "$container_id:$target_path"
done

# 显示操作结果
echo -e "$LOGO"
echo "脚本执行完毕"
