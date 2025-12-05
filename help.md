```bash
ansible --version # Show Ansible version
ansible all -m ping # Test connectivity
ansible all -a "uptime" -b # Run command on all hosts (with sudo)
ansible-playbook playbook.yml # Run playbook
ansible-playbook playbook.yml --check # Dry-run (simulate changes)
ansible-playbook playbook.yml --syntax-check # Validate syntax
ansible-playbook playbook.yml --vault-pass-file # Use the key to decrypt the file
ansible-galaxy list # List installed roles
ansible-config dump | grep ROLE # Show role search paths
ansible myhosts -a "ls -l /var/www/html/"  # Check the file
```
