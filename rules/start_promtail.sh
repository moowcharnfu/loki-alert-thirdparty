# kill port
ps -ef | grep promtail-linux-amd64 | awk '{print $2}' | xargs kill -9
# file positions 
echo "" > /tmp/positions.yaml
echo "1 0 * * * echo '' > /tmp/positions.yaml" > /etc/crontabs/root
# chmod excutable
chmod a+rwx /tmp/positions.yaml /opt/run/promtail-linux-amd64 /opt/run/start_promtail.sh
# start
nohup /opt/run/promtail-linux-amd64 -config.file=/opt/run/promtail.yaml -print-config-stderr=true >/tmp/promtail.log 2>&1 &
