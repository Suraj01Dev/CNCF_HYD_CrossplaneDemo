echo "cncf-hyd-bucket-"$(head -n 4096 /dev/urandom | openssl sha1 | tail -c 10)

