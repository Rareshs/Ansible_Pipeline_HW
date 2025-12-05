FROM jenkins/jenkins:lts

# Switch to root to install packages
USER root

# Install Ansible + Python + SSH tools
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-venv \
                       sshpass openssh-client ansible && \
    apt-get clean

# Make sure Jenkins (jenkins user) can access SSH keys
RUN mkdir -p /var/jenkins_home/.ssh && \
    chmod 700 /var/jenkins_home/.ssh && \
    chown -R jenkins:jenkins /var/jenkins_home/.ssh

# Go back to Jenkins user
USER jenkins
