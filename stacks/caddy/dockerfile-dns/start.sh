#!/bin/sh

# Debug-Ausgabe zur Kontrolle
echo "### Aktuelle Routing-Tabelle:"
ip route

echo "### Ersetze Default-Route über caddynet mit VLAN-Gateway..."
ip route del default
ip route add default via 192.168.30.1 dev eth1

echo "### Starte Caddy..."
exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
