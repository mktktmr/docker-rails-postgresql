#!/bin/bash

service postgresql start
sudo -i -u postgres psql -c 'CREATE USER root SUPERUSER;'

cat <<EOF >> ~/.bashrc
trap 'service postgresql stop; exit 0' TERM
EOF

exec /bin/bash
