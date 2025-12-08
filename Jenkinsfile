pipeline {
    agent any
    
    stages {

        stage('Checkout') {
            steps {
                git url: 'https://github.com/Rareshs/Ansible_Pipeline_HW.git',
                    branch: 'master',
                    credentialsId: 'github_cred'

                echo "GitHub checkout successful!"
            }
        }

        stage("Check ansible version") {
            steps {
                sh 'ansible --version'
            }
        }

        stage('Check SSH Access to VMs') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'vm_slaves',     // your SSH credential ID
                        keyFileVariable: 'SSH_KEY',      
                        usernameVariable: 'SSH_USER'
                    )
                ]) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY $SSH_USER@192.168.56.102 "echo VM1 OK"
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY $SSH_USER@192.168.56.103 "echo VM2 OK"
                    '''
                }
            }
        }

        stage('Ansible ping all test') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'vm_slaves',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'SSH_USER'
                    )
                ]) {
                    sh '''
                        ansible all -m ping -i inventory/hosts.ini \
                          --user $SSH_USER \
                          --private-key $SSH_KEY
                    '''
                }
            }
        }

        stage('Ansible check') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'vm_slaves',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'SSH_USER'
                    ),
                    string(credentialsId: 'vault_pass', variable: 'VAULT_PASS')
                ]) {
                    sh '''
                        echo "$VAULT_PASS" > vault_pass.txt
                        chmod 600 vault_pass.txt
        
                        ansible-playbook playbook.yml \
                          --check \
                          --vault-password-file vault_pass.txt \
                          --user $SSH_USER \
                          --private-key $SSH_KEY
        
                        rm -f vault_pass.txt
                    '''
                }
            }
        }

        stage("Deploy with Ansible") {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'vm_slaves',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'SSH_USER'
                    ),
                    string(credentialsId: 'vault_pass', variable: 'VAULT_PASS')
                ]) {
                    sh '''
                        echo "$VAULT_PASS" > vault_pass.txt
                        chmod 600 vault_pass.txt
        
                        ansible-playbook playbook.yml \
                          --vault-password-file vault_pass.txt \
                          --user $SSH_USER \
                          --private-key $SSH_KEY
        
                        rm -f vault_pass.txt
                    '''
                }
            }
        }

        stage('Post-deploy verification') {
            steps {
                sh '''
                    echo "Testing VM1 webserver..."
                    curl -f http://192.168.56.102:8080 || exit 1
                    
                    echo "Testing VM2 webserver..."
                    curl -f http://192.168.56.103:8080 || exit 1

                    echo "All webservers WORK !!!!!!"
                '''
            }
        }

    } 
}     
