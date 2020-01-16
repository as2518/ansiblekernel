FROM centos:centos7
RUN yum install -y python3.6 python3-pip
# Install Ansible Jupyter Kernel
RUN yum install -y python3-ipykernel python3-jupyter-core gcc python3-devel \
 bzip2 openssh openssh-clients python3-crypto python3-psutil glibc-locale-source && \
 localedef -c -i en_US -f UTF-8 en_US.UTF-8 && \
 pip3 install --no-cache-dir wheel psutil && \
 rm -rf /var/cache/yum
ENV LANG=en_US.UTF-8 \
 LANGUAGE=en_US:en \
 LC_ALL=en_US.UTF-8
ENV NB_USER notebook
ENV NB_UID 1000
ENV HOME /home/${NB_USER}
RUN useradd \
 -c "Default user" \
 -d /home/notebook \
 -u ${NB_UID} \
 ${NB_USER}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
RUN pip3 install --no-cache-dir ansible-jupyter-widgets
RUN pip3 install --no-cache-dir ansible_kernel==0.9.0 && \
 python3 -m ansible_kernel.install
USER ${NB_USER}
WORKDIR /home/notebook/notebooks
CMD ["jupyter-notebook", "--ip", "0.0.0.0"]
EXPOSE 8888
