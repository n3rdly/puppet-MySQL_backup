#!/bin/bash

# Backup mysql database to Amazon S3
# Requires awscli to be setup @see http://docs.aws.amazon.com/cli/latest/reference/index.html#cli-aws
# Tested on Ubuntu 14.04
# @date April, 2017
#
# Example usage: ./backup-mysql.sh --bucket="s3://my-bucket" --database="mydb"

BUCKET=""
HOST=""
WORK_DIR=/tmp/s3_backup/mysql
HOME=/root

# Parse arguments
for i in "$@"
do
case $i in
    -b=*|--bucket=*)
    BUCKET="${i#*=}"
    shift # past argument=value
    ;;
    -d=*|--host=*)
    HOST="${i#*=}"
    shift # past argument=value
    ;;
    *)
            # unknown option
    ;;
esac
done

# Check requirements
MISSING=false
if [[ $BUCKET == "" ]]; then
    echo "missing argument -b, --bucket"
    MISSING=true
fi

if [[ $HOST == "" ]]; then
    echo "missing argument -d, --host"
    MISSING=true
fi

if [[ $MISSING == true ]]; then
    exit 1
fi

if [[ $(whoami) != root ]]; then
    echo "should execute as root"
    exit 1
fi

# Generate ID
ID=$HOST-$(date +%Y-%m-%d_%H_%M)

echo "Bucket: $BUCKET"
echo "Database: $HOST"
echo "Id: $ID"


# Ensure that working directory exists and can be accessed by the mysql user
mkdir -p $WORK_DIR
chown -R mysql $WORK_DIR

# Dump and compress
sudo mysqldump --all-databases > $WORK_DIR/$ID.sql
cd $WORK_DIR || exit 1; tar -cvJf "$ID.mysql.tar.xz" "$ID.mysql"

# Upload to AWS
/usr/local/bin/aws s3 cp "$ID.mysql.tar.xz" "$BUCKET"

# Clean up
rm "$ID.mysql.tar.xz"
rm "$ID.mysql"
exit 0
