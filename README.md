# s3\_backup

Backup various stuff to S3

## Usage

**Install and configure**

Define AWS credentials in s3_backup class and  and The access policy only needs to allow PutObject action in backup bucket.

```puppet
class s3_backup {

  $aws_access_key_id = XXXXXXXXXXXXXXXXXXXX,
  $aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX,
  $region = xx-xxxx-x,

```


**Setup cron to backup a specific MySQL database 2AM, every night**

```puppet
class s3_backup::backup_mysql_cron {
  require => Class['s3_backup'],
  $ensure = 'present',
  $bucket = s3://my-bucket,
  $host = $(hostname),
  $minute   = '0',
  $hour     = '2',
  $weekday  = '*',
  $monthday = '*',
  $month    = '*',
```

Once the schedule is executed, it will result in a compressed and timestamped backup archive E.g. `s3://my-bucket/hostname-2017-04-25_02_00.mysql.tar.xz` .


===================
