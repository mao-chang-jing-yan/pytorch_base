nohup /usr/sbin/sshd -D > nohupcmd.out 2>&1 &
jupyter-lab --ip=0.0.0.0 --port 8888 --allow-root --no-browser