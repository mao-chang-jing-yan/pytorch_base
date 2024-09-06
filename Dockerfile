FROM continuumio/anaconda3
LABEL maintainer="my, Inc."

EXPOSE 8888

WORKDIR /app
RUN mkdir -p /app/projects

RUN chmod 777 /app
#COPY conda_env.yaml /app/

# COPY .condarc /root/

# RUN conda env create -f conda_env.yaml
# RUN conda init bash && \
#      exec bash && \
#     conda activate decision_tree_predict && \
#     conda install python=3.8 ipykernel nb_conda_kernels nb_conda -y && \
#     conda install jyputer notebook -y && \
#     conda deactivate
#RUN echo "conda activate decision_tree_predict" >> ~/.bashrc






# RUN apt update
# RUN apt install -y wget && rm -rf /var/lib/apt/lists/*
# RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
#     && mkdir /root/.conda \
#     && bash Miniconda3-latest-Linux-x86_64.sh -b \
#     && rm -f Miniconda3-latest-Linux-x86_64.sh
# RUN exec bash \
#     && . /root/.bashrc \
#     && conda init bash \
#     && conda activate
#     # && conda install -y pandas=1.3


# ENV PATH="/root/miniconda3/bin:${PATH}"
# ARG PATH="/root/miniconda3/bin:${PATH}"
# SHELL ["/bin/bash", "-c"]
COPY create_conda_env.sh .
RUN sh create_conda_env.sh base 3.8 not
RUN sh create_conda_env.sh decision_tree_predict 3.8 not

RUN rm -rf /opt/conda/envs/decision_tree_predict

#jyputerbotebook
#RUN jupyter notebook --generate-config
#COPY jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
#CMD jupyter notebook --ip=0.0.0.0 --port 8888 --allow-root --no-browser


#jyputerlab
#RUN conda install jupyterlab-lsp
#
#RUN conda install python-lsp-server[all]
RUN conda install -y jupyterlab
RUN jupyter-lab --generate-config

#COPY jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
COPY jupyter_lab_config.py /root/.jupyter/jupyter_lab_config.py




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
#RUN echo "root:zpd1234" | chpasswd
COPY create_user.sh .
RUN sh create_user.sh root zpd1234 > 1.log


# 开放 conda权限
RUN chmod 755 /opt/conda


COPY dockerfile_run.sh dockerfile_run.sh
CMD sh dockerfile_run.sh
