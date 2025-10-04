# Используем последнюю стабильную версию Ubuntu
FROM ubuntu:22.04

# Устанавливаем переменные окружения для неинтерактивной установки
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow

# Обновляем систему и устанавливаем базовые пакеты
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    # Базовые утилиты
    curl \
    wget \
    git \
    vim \
    nano \
    htop \
    tree \
    unzip \
    zip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    # Сетевые утилиты
    net-tools \
    iputils-ping \
    traceroute \
    nmap \
    # Системные утилиты
    systemd \
    sudo \
    openssh-server \
    # Инструменты разработки
    build-essential \
    python3 \
    python3-pip \
    nodejs \
    npm \
    # Дополнительные полезные пакеты
    mc \
    tmux \
    screen \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Установка Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Установка Docker Compose (standalone)
RUN curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Создаем пользователя с правами sudo и docker
RUN useradd -m -s /bin/bash ubuntu && \
    echo 'ubuntu:ubuntu' | chpasswd && \
    usermod -aG sudo ubuntu && \
    usermod -aG docker ubuntu && \
    echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Настраиваем SSH
RUN mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Создаем рабочую директорию
WORKDIR /home/ubuntu

# Создаем директории для монтирования
RUN mkdir -p /home/ubuntu/shared && \
    chown -R ubuntu:ubuntu /home/ubuntu

# Переключаемся на пользователя ubuntu
USER ubuntu

# Настраиваем Git и другие пользовательские настройки
RUN git config --global init.defaultBranch main && \
    echo 'alias ll="ls -la"' >> ~/.bashrc && \
    echo 'alias la="ls -A"' >> ~/.bashrc && \
    echo 'export PS1="\u@ubuntu-vm:\w\$ "' >> ~/.bashrc

# Возвращаемся к root для финальных настроек
USER root

# Создаем скрипт запуска
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'set -e' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Запуск SSH' >> /start.sh && \
    echo 'service ssh start' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Запуск Docker daemon' >> /start.sh && \
    echo 'dockerd > /var/log/docker.log 2>&1 &' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Ожидание запуска Docker' >> /start.sh && \
    echo 'timeout 30 sh -c "until docker info >/dev/null 2>&1; do sleep 1; done" || echo "Docker daemon failed to start"' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Настройка прав для Docker socket' >> /start.sh && \
    echo 'chown root:docker /var/run/docker.sock 2>/dev/null || true' >> /start.sh && \
    echo 'chmod 660 /var/run/docker.sock 2>/dev/null || true' >> /start.sh && \
    echo '' >> /start.sh && \
    echo '# Запуск основной команды' >> /start.sh && \
    echo 'exec "$@"' >> /start.sh && \
    chmod +x /start.sh

# Открываем порты
EXPOSE 22 80 443 3000 8000 8080

# Точка входа
ENTRYPOINT ["/start.sh"]
CMD ["/bin/bash"]