#!/bin/bash
# filepath: /home/ubuntu/orthnac-config/Viewers/run.sh

ORTHANC_IP=$(curl -s ifconfig.me)
CONFIG_FILE="platform/app/public/config/default.js"
echo "Orthanc IP: $ORTHANC_IP"

# Use awk to only replace inside the orthanc block
awk -v ip="$ORTHANC_IP" '
  BEGIN { in_orthanc=0 }
  /sourceName: '\''orthanc'\''/ { in_orthanc=1 }
  in_orthanc && /wadoUriRoot:/ { sub(/wadoUriRoot: .*/, "wadoUriRoot: '\''http://" ip ":8043/dicom-web'\'',"); }
  in_orthanc && /qidoRoot:/ { sub(/qidoRoot: .*/, "qidoRoot: '\''http://" ip ":8043/dicom-web'\'',"); }
  in_orthanc && /wadoRoot:/ { sub(/wadoRoot: .*/, "wadoRoot: '\''http://" ip ":8043/dicom-web'\'',"); }
  in_orthanc && /},/ { in_orthanc=0 }
  { print }
' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"

yarn run dev
