app:
  user.present:
    - name: app

/tmp/apache-tomcat-7.0.90.gz:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://software/tomcat/files/apache-tomcat-7.0.90.gz
  cmd.run:
    - name: cd /tmp && tar xf apache-tomcat-7.0.90.gz && mv apache-tomcat-7.0.90/* /data/tomcat/tomcat/
    - unless: test -f /data/tomcat/tomcat/bin/catalina.sh

/usr/bin/tomcattools.sh:
  file.managed:
    - user: root
    - group: root
    - mode: 777
    - source: salt://software/tomcat/files/tomcattools.sh
