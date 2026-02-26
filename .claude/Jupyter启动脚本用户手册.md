# Jupyter 启动脚本用户手册

## 概述

`start_jupyter.sh` 是一个用于在本地启动 JupyterLab/Jupyter Notebook 的 Bash 脚本，提供便捷的配置管理和灵活的启动选项。

**脚本位置**: `/Users/litk/repos/jupyter/start_jupyter.sh`

**创建日期**: 2026-02-26

**作者**: Claude Code

---

## 功能特性

### 核心功能

- ✅ **自动目录管理**: 自动创建配置目录 `.jupyter/` 和笔记本目录 `notebooks/`
- ✅ **双模式支持**: 支持 JupyterLab（推荐）和经典 Notebook 两种模式
- ✅ **灵活端口配置**: 可自定义服务端口（默认 8888）
- ✅ **工作区隔离**: 配置和数据分离存储，便于管理
- ✅ **命令行参数**: 提供丰富的启动选项

### 目录结构

启动后自动创建以下目录结构：

```
/Users/litk/repos/jupyter/
├── start_jupyter.sh          # 启动脚本
├── .jupyter/                 # Jupyter 配置目录
│   ├── jupyter_lab_config.py     # JupyterLab 配置（首次运行后生成）
│   └── jupyter_notebook_config.py # Notebook 配置（首次运行后生成）
└── notebooks/                # 笔记本存储目录
    └── (您的 .ipynb 文件)
```

---

## 使用方法

### 基本用法

```bash
# 1. 进入项目目录
cd /Users/litk/repos/jupyter

# 2. 启动 JupyterLab（默认模式）
./start_jupyter.sh

# 或使用 bash 执行
bash start_jupyter.sh
```

### 命令行参数

| 参数 | 说明 | 示例 |
|------|------|------|
| `--port PORT` | 指定端口号 | `--port 9999` |
| `--lab` | 启动 JupyterLab（默认） | `--lab` |
| `--notebook` | 启动经典 Notebook | `--notebook` |
| `--help` | 显示帮助信息 | `--help` |

---

## 使用示例

### 示例 1: 默认启动 JupyterLab

```bash
./start_jupyter.sh
```

**输出**:
```
======================================
Jupyter 启动配置
======================================
工作目录: /Users/litk/repos/jupyter
笔记本目录: /Users/litk/repos/jupyter/notebooks
配置目录: /Users/litk/repos/jupyter/.jupyter
启动模式: lab
端口: 8888
======================================
正在启动 JupyterLab...
```

### 示例 2: 启动经典 Notebook

```bash
./start_jupyter.sh --notebook
```

适用场景：习惯使用经典界面或需要特定 Notebook 扩展。

### 示例 3: 自定义端口

```bash
# 避免端口冲突，使用 9999 端口
./start_jupyter.sh --port 9999
```

**提示**: 如果 8888 端口被占用，可以尝试其他端口如 9999、8080 等。

### 示例 4: 组合参数使用

```bash
# 启动 Notebook 并使用自定义端口
./start_jupyter.sh --notebook --port 9999
```

---

## 访问 Jupyter

### 启动后访问

启动脚本会显示访问 URL，格式类似：

```
http://127.0.0.1:8888/lab?token=xxxxxxxxxxxxxxxxxxxxxxxx
```

### 在浏览器中打开

1. 复制终端显示的 URL
2. 在浏览器中粘贴访问
3. 首次访问需要输入 token（从启动日志中获取）

### 取消 token 认证（可选）

如需永久取消 token 认证，可以修改脚本或生成配置文件：

```bash
# 生成 Jupyter 配置文件
jupyter lab --generate-config

# 编辑配置文件
vim ~/.jupyter/jupyter_lab_config.py

# 添加以下内容
c.ServerApp.token = ''
c.ServerApp.password = ''
c.ServerApp.allow_origin = '*'
```

---

## 常见问题

### Q1: 启动时提示 "command not found: jupyter"

**原因**: PATH 环境变量未生效

**解决方案**:
```bash
# 方式1: 重新加载 zsh 配置
source ~/.zshrc

# 方式2: 直接使用完整路径
export PATH="/Users/litk/Library/Python/3.9/bin:$PATH"

# 方式3: 使用 python3 模块启动
python3 -m jupyter lab
```

### Q2: 端口 8888 已被占用

**错误信息**:
```
Port 8888 is already in use
```

**解决方案**:
```bash
# 使用其他端口
./start_jupyter.sh --port 9999

# 或查看并关闭占用进程
lsof -i :8888
kill -9 <PID>
```

### Q3: 如何自动打开浏览器？

**解决方案**: 编辑启动脚本，移除 `--no-browser` 参数：

```bash
# 找到这一行（约第58行）
--no-browser \

# 改为
# --no-browser \
```

### Q4: 如何修改默认笔记本目录？

**解决方案 1**: 直接修改脚本中的 `NOTEBOOK_DIR` 变量：

```bash
# 编辑脚本
vim start_jupyter.sh

# 修改第10行
NOTEBOOK_DIR="$WORK_DIR/notebooks"  # 改为您想要的目录
```

**解决方案 2**: 使用 `--notebook-dir` 参数临时覆盖。

### Q5: 如何在后台运行？

```bash
# 使用 nohup 在后台运行
nohup ./start_jupyter.sh > jupyter.log 2>&1 &

# 查看日志
tail -f jupyter.log

# 停止服务
ps aux | grep jupyter
kill <PID>
```

---

## 高级配置

### 自定义配置文件

在 `.jupyter/` 目录创建自定义配置：

```bash
cd /Users/litk/repos/jupyter/.jupyter

# JupyterLab 配置示例
cat > jupyter_lab_config.py << 'EOF'
# 服务器配置
c.ServerApp.ip = '0.0.0.0'           # 允许外部访问
c.ServerApp.port = 8888              # 默认端口
c.ServerApp.open_browser = False     # 不自动打开浏览器
c.ServerApp.allow_root = True        # 允许 root 运行

# 安全配置
c.ServerApp.token = ''               # 禁用 token（生产环境不推荐）
c.ServerApp.password = ''            # 禁用密码（生产环境不推荐）

# 工作目录
c.ServerApp.root_dir = '/Users/litk/repos/jupyter/notebooks'

# 主题配置
c.ServerApp.terminado_settings = {'shell_command': ['/bin/zsh']}
EOF
```

### 设置密码保护（推荐）

```bash
# 生成密码哈希
python3 -c "from notebook.auth import passwd; print(passwd('your_password'))"

# 复制输出，编辑配置文件
vim .jupyter/jupyter_lab_config.py

# 添加
c.ServerApp.password = 'sha1:xxxxxxxxxxxxxxxxx'
c.ServerApp.token = ''  # 禁用 token，只用密码
```

### 添加 Jupyter 扩展

```bash
# 安装常用扩展
pip install jupyter_contrib_nbextensions

# 启用扩展
jupyter contrib nbextension install --user

# 安装代码格式化工具
pip install jupyter-black
pip install jupyterlab_code_formatter
```

---

## 性能优化建议

### 1. 减少内存占用

```bash
# 限制 Jupyter 内存使用
export JUPYTER_ENABLE_LAB=yes
```

### 2. 加快启动速度

```bash
# 禁用不必要的检查
export JUPYTER_DISABLE_CHECK=1
```

### 3. 清理缓存

```bash
# 清理 Jupyter 缓存
rm -rf ~/.cache/jupyter
rm -rf ~/.local/share/jupyter
```

---

## 与 Podman 版本对比

项目中还有 `run_jupyter_pod.sh`，两者区别：

| 特性 | start_jupyter.sh | run_jupyter_pod.sh |
|------|------------------|-------------------|
| 运行环境 | 本机 Python | Podman 容器 |
| 启动速度 | 快 | 较慢（需拉取镜像） |
| 资源占用 | 低 | 较高 |
| 环境隔离 | 无 | 完全隔离 |
| 适用场景 | 日常开发 | 生产环境/多环境测试 |

**建议**:
- 日常使用 `start_jupyter.sh`（本机版本）
- 需要环境隔离时使用 `run_jupyter_pod.sh`（容器版本）

---

## 故障排查

### 查看详细日志

```bash
# 启动时增加详细输出
jupyter lab --debug
```

### 检查依赖

```bash
# 检查 Python 版本
python3 --version

# 检查已安装的 Jupyter 组件
pip list | grep jupyter

# 重新安装 Jupyter
pip install --upgrade --force-reinstall jupyter
```

### 重置配置

```bash
# 删除配置目录重新开始
rm -rf /Users/litk/repos/jupyter/.jupyter
./start_jupyter.sh
```

---

## 附录

### 相关命令速查

```bash
# 启动 Jupyter
./start_jupyter.sh

# 查看运行中的 Jupyter 进程
ps aux | grep jupyter

# 停止 Jupyter
pkill -f jupyter

# 查看 Jupyter 版本
jupyter --version

# 列出已安装的内核
jupyter kernelspec list

# 添加新的 Python 内核
python3 -m ipykernel install --user --name=myenv
```

### 有用的链接

- [JupyterLab 官方文档](https://jupyterlab.readthedocs.io/)
- [Jupyter Notebook 文档](https://jupyter-notebook.readthedocs.io/)
- [IPython 内核文档](https://ipython.readthedocs.io/)

---

## 更新日志

- **2026-02-26**: 初始版本，支持基本的 JupyterLab/Notebook 启动功能

---

**文件路径**: `/Users/litk/repos/jupyter/.claude/Jupyter启动脚本用户手册.md`
