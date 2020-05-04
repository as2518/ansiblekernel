FROM centos:7

# Install Ansible Jupyter Kernel
RUN yum install -y python3.6 python3-pip git
RUN yum -y install epel-release  && \
    yum -y install python3-psutil bzip2 python3-crypto openssh openssh-clients gcc python3-devel.x86_64 && \
    localedef -c -i en_US -f UTF-8 en_US.UTF-8 && \
    pip3 install --no-cache-dir wheel psutil && \
    rm -rf /var/cache/yum

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

ENV NB_USER notebook
ENV NB_UID 10001

ENV APP_ROOT=/opt/app-root
ENV HOME=${APP_ROOT}
ENV USER_NAME=${NB_USER}
RUN mkdir ${APP_ROOT}
RUN useradd \
    -c "Default user" \
        -d  ${APP_ROOT} \
    -u ${NB_UID} \
    -g 0 \
    ${NB_USER}
ENV PATH=${APP_ROOT}/.local/bin:${PATH} 
RUN chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd
USER ${NB_UID}
WORKDIR ${APP_ROOT} 
RUN pip3 install --user --no-cache-dir prompt-toolkit
RUN pip3 install --user --no-cache-dir ipython
RUN pip3 install --user --no-cache-dir ipykernel
RUN pip3 install --user --no-cache-dir git+https://github.com/ansible/ansible-jupyter-kernel.git@master && \
    python3 -m ansible_kernel.install

CMD [".local/bin/jupyter-notebook", "--ip", "0.0.0.0"]
EXPOSE 8888
