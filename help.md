```
# 参考 https://grafana.com/docs/loki/latest/configuration/

1. 基于docker正常搭建 loki+grafana+prometheus+.. 系统
lokigateway <>   loki-read (grafana + alert rules告警)       <>  promrtheus  > alertmanagement > webhook-adapter(国内通讯软件代理器 钉钉/企业微信/个人微信等)
            >   loki-write (接收promtail日志并写入)    

2. loki配置注意事项  (memberlist + inmemory)

3. 告警规则定义 , 需要注意 loki默认有个租户,  规则文件需要存放/挂载到租户目录下
   如  告警规则 dir/<tenantid>/*.yml  >  rules/docker/*.yml [docker即默认租户]

4.重写webhook-adapter源码, 增加个人微信推送消息
  index.js 增加GET发送消息方式;  wx_personal.js增加告警内容转换参数
  webhook-adapter增加启动命令:
      # 个人微信
      - "--adapter=/app/prometheusalert/wx_personal.js=/wx_personal=https://wxpusher.zjiecode.com/demo/send/custom/[个人微信uid]"
  alertmanager.yaml增加/wx_personal方式(或者/wx或者/dingtalk)
      route:
        receiver: 'default-receiver'
        group_wait: 30s
        group_interval: 30m
        group_by: [ alertname ]
      
      receivers:
      
        - name: 'default-receiver'
          webhook_configs:
          - url: 'http://webhook-adapter:80/adapter/wx_personal'
            send_resolved: true

 5. promtail日志上报(一个Job一个线程, 如info日志一个Job,  debug日志一个Job等)
    授权(positions.yaml日志位置文件,  promtail-linux-amd6日志上报客户端, start_promtail.sh自定义脚本如1杀进程2定点重置下标3授权4启动日志采集上报)  chmod a+rwx /tmp/positions.yaml /opt/run/promtail-linux-amd64 /opt/run/start_promtail.sh
    注意 如果自己的日志文件是按天滚动,需要写个定时任务脚本定期清空positions.yaml内容,防止文件下标不对,日志上报不及时
```
