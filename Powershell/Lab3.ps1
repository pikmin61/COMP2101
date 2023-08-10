$networkadapters = get-ciminstance win32_networkadapterconfiguration | Where-Object ipenabled

$networkadapters | Select-Object Description,index,ipaddress,ipsubnet,dnsdomain,DNSServerSearchOrder |  format-table -AutoSize -Wrap