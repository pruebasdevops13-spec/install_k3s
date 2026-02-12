# 04-backup-cron.sh
cat << 'EOF' > /etc/cron.daily/k8s-backup
#!/bin/bash
DATE=$(date +%F_%H%M)
echo "=== K8s Backup $DATE ===" >> /var/log/k8s-backup.log

k3s etcd-snapshot save --name daily-$DATE
kubectl get all,pvc,secrets,configmaps,ingresses --all-namespaces -o yaml > /k8s-backups/daily/cluster-$DATE.yaml

echo "✅ $(date): Backup completado /k8s-backups/daily/cluster-$DATE.yaml" >> /var/log/k8s-backup.log
EOF
chmod +x /etc/cron.daily/k8s-backup
/etc/cron.daily/k8s-backup
