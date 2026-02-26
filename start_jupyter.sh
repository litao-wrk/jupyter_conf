#!/bin/zsh

# Jupyter 本地启动脚本
# 用途: 在本机启动 JupyterLab/Jupyter Notebook
# 作者: Claude Code
# 日期: 2026-02-26

# 获取脚本所在目录
WORK_DIR=$(cd "$(dirname "$0")"; pwd)
CONFIG_DIR="$WORK_DIR/.jupyter"
NOTEBOOK_DIR="$WORK_DIR/notebooks"

# 创建必要的目录
mkdir -p "$CONFIG_DIR"
mkdir -p "$NOTEBOOK_DIR"

# 默认配置
PORT=8888
JUPYTER_CMD="lab"  # 默认使用 JupyterLab，可选 "notebook"
LOG_FILE="$WORK_DIR/jupyter.log"  # 日志文件路径

# 设置 Python bin 路径（确保 jupyter 命令可用）
export PATH="/Users/litk/Library/Python/3.9/bin:$PATH"

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --port)
            PORT="$2"
            shift 2
            ;;
        --notebook)
            JUPYTER_CMD="notebook"
            shift
            ;;
        --lab)
            JUPYTER_CMD="lab"
            shift
            ;;
        --help)
            echo "用法: $0 [选项]"
            echo "选项:"
            echo "  --port PORT       指定端口号 (默认: 8888)"
            echo "  --lab            启动 JupyterLab (默认)"
            echo "  --notebook       启动经典 Notebook"
            echo "  --help           显示此帮助信息"
            exit 0
            ;;
        *)
            echo "未知选项: $1"
            echo "使用 --help 查看帮助"
            exit 1
            ;;
    esac
done

echo "======================================"
echo "Jupyter 启动配置"
echo "======================================"
echo "工作目录: $WORK_DIR"
echo "笔记本目录: $NOTEBOOK_DIR"
echo "配置目录: $CONFIG_DIR"
echo "启动模式: $JUPYTER_CMD"
echo "端口: $PORT"
echo "======================================"

# 启动 Jupyter
if [ "$JUPYTER_CMD" = "lab" ]; then
    echo "正在启动 JupyterLab..."
    nohup jupyter lab \
        --notebook-dir="$NOTEBOOK_DIR" \
        --port="$PORT" \
        --config="$CONFIG_DIR/jupyter_lab_config.py" \
        --no-browser \
        --allow-root > "$LOG_FILE" 2>&1 &
else
    echo "正在启动 Jupyter Notebook..."
    nohup jupyter notebook \
        --notebook-dir="$NOTEBOOK_DIR" \
        --port="$PORT" \
        --config="$CONFIG_DIR/jupyter_notebook_config.py" \
        --no-browser \
        --allow-root > "$LOG_FILE" 2>&1 &
fi

# 获取进程 ID
JUPYTER_PID=$!
echo "======================================"
echo "✅ Jupyter 已在后台启动"
echo "进程 PID: $JUPYTER_PID"
echo "日志文件: $LOG_FILE"
echo ""
echo "查看日志命令："
echo "  tail -f $LOG_FILE"
echo ""
echo "查看启动 URL："
echo "  grep 'http://127.0.0.1:$PORT' $LOG_FILE"
echo ""
echo "停止服务命令："
echo "  kill $JUPYTER_PID"
echo "  # 或"
echo "  pkill -f 'jupyter.*$PORT'"
echo "======================================"
