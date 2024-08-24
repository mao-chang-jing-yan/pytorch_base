FROM continuumio/anaconda3
LABEL maintainer="HuiLanYiLiao, Inc."

EXPOSE 8888

WORKDIR /app
RUN chmod 777 /app

COPY create_conda_env.sh .
RUN #sh create_conda_env.sh pytorch_test 3.8 do_not

# 确保容器启动时激活环境
#SHELL ["conda", "run", "-n", "pytorch_test", "/bin/bash", "-c"]

COPY requirements.txt .

COPY dockerfile_run.sh .
RUN chmod +x dockerfile_run.sh
# 安装 requirements.txt 中列出的包
#RUN conda run -n pytorch_test pip install -r requirements.txt


# 设置环境变量以确保启动时激活环境
#ENV CONDA_DEFAULT_ENV=pytorch_test


#CMD cd models && conda run -n pytorch_test python unet_withlstm.py




RUN apt-get update
# 安装 ssh服务
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN rm -rf /root/.ssh
#RUN mkdir -p /root/.ssh
# 取消 pam 限制
#RUN sed -ri 's/session requried pam_loginuid.so/#session required pam_loginuid.so/g' /etc/pam.d/sshd

# 开启ssh并设置密码
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config



CMD ["sh", "dockerfile_run.sh"]