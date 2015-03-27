settings = {
  logfile    = "/var/log/lsyncd/lsyncd.log",
  statusFile = "/var/log/lsyncd/lsyncd.status",
  insist = true,
  nodaemon   = false --<== лучше оставить для дебага. потом выключите.
}

sync {
  default.rsyncssh,
  source="/var/www",
  host="b-example2",  
  targetdir="/var/www",
  rsyncOps={"-ausOS", "--temp-dir=/tmp"},
  delay=3
}

sync {
  default.rsyncssh,
  source="/etc/nginx",
  host="b-example2",
  targetdir="/etc/nginx",
  rsyncOps={"-ausOS", "--temp-dir=/tmp"},
  delay=3
}

sync {
  default.rsyncssh,
  source="/etc/apache2",
  host="b-example2",
  targetdir="/etc/apache2",
  rsyncOps={"-ausOS", "--temp-dir=/tmp"},
  delay=3
}

