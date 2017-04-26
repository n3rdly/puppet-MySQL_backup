class s3_backup {

    $aws_access_key_id = XXXXXXXXXXXXXXXXXXXX,
    $aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX,
    $region = xx-xxxx-x,

    validate_string($aws_access_key_id)
    validate_string($aws_secret_access_key)
    validate_string($region)

  # Install awscli
    package {'awscli': ensure => present}

  # Put mysql backup script into $PATH
    file {  '/usr/local/bin/s3_backup-backup-mysql':
    source => 'puppet:///modules/s3_backup/backup-mysql.sh',
    mode   => 'a+x',
    }

  # Configure AWS access
    exec {  'configure_aws_access_key_id':
      command => "/usr/local/bin/aws configure set aws_access_key_id ${aws_access_key_id}"
    }

    exec {  'configure_aws_secret_access_key':
      command => "/usr/local/bin/aws configure set aws_secret_access_key ${aws_secret_access_key}"
    }

    exec {  'configure_aws_region':
      command => "/usr/local/bin/aws configure set region ${region}"
    }
}

class s3_backup::backup_mysql_cron {
  require => Class['s3_backup'],
  $ensure = 'present',
  $bucket = s3://XXXXXXXXXXXXXXXXXXXX,
  $host = $(hostname),
  $minute   = '*',
  $hour     = '*',
  $weekday  = '*',
  $monthday = '*',
  $month    = '*',

  validate_string($bucket)
  validate_string($host)


  cron { "${title}_backup_mysql_cron":
    ensure   => $ensure,
    command  =>  "/usr/local/bin/s3_backup-backup-mysql --bucket='${bucket}' --host='${host}'",
    minute   => $minute,
    hour     => $hour,
    weekday  => $weekday,
    monthday => $monthday,
    month    => $month,
  }
}
