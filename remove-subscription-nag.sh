#!/bin/bash

FILE_PANEL="/usr/share/pve-manager/js/pvemanagerlib.js"
FILE_WIDGET="/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js"
TIMESTAMP=$(date +%Y%m%d-%H%M)

# 1. Dashboard panel (Datacenter -> Summary -> Subscriptions)
if [ -f "$FILE_PANEL" ]; then
    cp "$FILE_PANEL" "$FILE_PANEL.$TIMESTAMP.bak"
    sed -i '/title: gettext('\''Subscriptions'\''),/a \ \ \ \ \ \ \ \ \ \ \ hidden: true,' $FILE_PANEL
    echo "Dashboard subscription panel hidden."
else
    echo "Panel file not found: $FILE_PANEL"
fi

# 2. Login notice (Nag Screen)
if [ -f "$FILE_WIDGET" ]; then
    cp "$FILE_WIDGET" "$FILE_WIDGET.$TIMESTAMP.bak"
    grep -q "res.data.status = 'active'" $FILE_WIDGET || \
    sed -i "/let res = response.result/a\        if (res && res.data && res.data.status) { res.data.status = 'active'; }" $FILE_WIDGET
    echo "Login pop-up disabled."
else
    echo "Widget file not found: $FILE_WIDGET"
fi

echo "Restarting pveproxy.service"
systemctl restart pveproxy
echo "Changes applied. Delete the page data in your browser and refresh (Ctrl+R)."
