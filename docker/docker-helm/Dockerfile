FROM amd64/ubuntu:22.04

LABEL version="0.4"
LABEL description="Docker Image for helm"
LABEL maintainer="luke <luke@thephuck.com>"

WORKDIR /root
ENV TERM=linux

COPY vsphere-plugin/bin/ /bin/

RUN apt update && apt install -y apt-transport-https ca-certificates curl gnupg \
&& curl -fsSL https://baltocdn.com/helm/signing.asc | gpg --dearmor -o /usr/share/keyrings/helm.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list \
&& curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
&& echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list \
&& apt update && apt install -y kubectl helm openssh-server git \
&& mkdir /var/run/sshd \
&& echo 'root:VMware@1234!' | chpasswd \
&& sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
&& sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
&& apt clean && rm -rf /var/lib/apt/lists/*

EXPOSE 22
CMD ["sh", "-c", "/usr/bin/git clone https://github.com/opea-project/GenAIInfra && /root/GenAIInfra/helm-charts/scripts/update_dependency.sh && /usr/sbin/sshd -D"]
