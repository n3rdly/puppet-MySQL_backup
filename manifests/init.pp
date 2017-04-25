class s3_backup (
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $region = undef,
) {

  validate_string($aws_access_key_id)
  validate_string($aws_secret_access_key)
  validate_string($region)

  package {'awscli': ensure => present}

  # Put mysql backup script into $PATH
    file {  '/usr/local/bin/s3_backup-backup-mysql':
    source => 'puppet:///modules/s3_backup/backup-mysql.sh',
    mode   => 'a+x',
    }

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
