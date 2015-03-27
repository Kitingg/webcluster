settings  {
  logfile    = "/var/log/lsyncd/lsyncd.log",
  statusFile = "/var/log/lsyncd/lsyncd.status",
  insist = true,
  nodaemon   = false --<== ÌÞÅÏÔ×Ô ÄÑÄÂÇ. ÐÔÍ×ËÀÉÅ
}

sync {
  default.rsyncssh,
  source="/etc/nginx",
  host="f-example2",
  targetdir="/etc/nginx",
--  exclude={
--        "/sites-available/upstream",
--  },
--  rsync={"-ausOS", "--temp-dir=/tmp"},
  rsync = {
     archive = true,
     compress = false,
     whole_file = false
   },
   ssh = {
     port = 2423
   },
  delay=3
}

