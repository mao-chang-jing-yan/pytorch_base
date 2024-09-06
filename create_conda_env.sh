

# 开启异常退出。当任何一行的命令执行错误，直接退出，不继续往下执行
# function open_err_exit(){
#     set -e
# }

# 关闭异常退出。当任何一行的命令执行错误，继续往下执行
# function close_err_exit(){
#     set +e
# }

#创建conda 环境指定python版本
set -e
set -x
version=${2:-'3.8'}
do_not_set_proxys=${3:-''}

eval "$(conda shell.bash hook)"


if [ "$1" = "base" ]; then
    echo ''
    conda install -y python=$version
else
   conda create -n $1 python=$version -y
fi

#conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
#conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
## 设置搜索时显示通道地址
#conda config --set show_channel_urls yes


conda activate $1

if [ "$do_not_set_proxys" = "" ]; then
  conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
  conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
  conda config --add channels https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge
else
  echo ''
fi


## 设置搜索时显示通道地址
conda config --set show_channel_urls yes

# 在当前的paddle环境中安装好ipykernel
conda install ipykernel -y

if [ "$1" = "base" ]; then
    # conda install nb_conda_kernels pip jupyterlab=3 "ipykernel>=6" xeus-python nodejs  -y

    conda install nb_conda_kernels pip nodejs  -y

    


else
    echo ''
fi

# 换源
if [ "$do_not_set_proxys" = "" ]; then
  pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
else
  echo ''
fi


if [ "$1" = "base" ]; then
      echo ''
    # pip install notebook
    # 安装 nbextensions
    pip install jupyter_contrib_nbextensions
    # 安装 javascript and css files
    jupyter contrib nbextension install --user

    # pip install jupyter_nbextensions_configurator
    # jupyter nbextensions_configurator enable --user
    # jupyter labextension install @jupyterlab/debugger
    pip install jupyterlab-language-pack-zh-CN
else
    echo ''
fi



# conda install xeus-python -y


# 安装configurator
pip install jupyter_nbextensions_configurator
# 弹出错误提示：缺少autopep8 或者yapf模块，需要安装对应模块。
# （大多数 Python 代码格式化工具（比如：autopep8 和 pep8ify）是可以移除代码中的 lint 错误，具有局限性。比如：遵循 PEP 8 指导的代码可能就不会被格式化了，但这并不说明代码看起来就舒服。yapf把初始代码重新编排，即便初始代码并没有违背规范，也可使其达到遵循代码规范的最佳格式。这个理念和 Go 语言中的 gofmt 工具相似。）
pip install autopep8 
pip install yapf


conda deactivate

set +e
set +x