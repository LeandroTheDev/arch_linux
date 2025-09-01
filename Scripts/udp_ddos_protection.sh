#!/bin/sh
# This is any example for valve games from ports 27015-27030

# Create a custom chain only once (if it doesn't already exist)
iptables -N UDP_FLOOD 2>/dev/null

# Redirects traffic from each port to the UDP_FLOOD chain
iptables -A INPUT -p udp --dport 27015 -j UDP_FLOOD
iptables -A INPUT -p udp --dport 27016 -j UDP_FLOOD
iptables -A INPUT -p udp --dport 27017 -j UDP_FLOOD
iptables -A INPUT -p udp --dport 27018 -j UDP_FLOOD
iptables -A INPUT -p udp --dport 27019 -j UDP_FLOOD
iptables -A INPUT -p udp --dport 27020 -j UDP_FLOOD
iptables -A INPUT -p udp --dport 27021 -j UDP_FLOOD
iptables -A INPUT -p udp --dport 27022 -j UDP_FLOOD
iptables -A INPUT -p udp --dport 27023 -j UDP_FLOOD
iptables -A INPUT -p udp --dport 27024 -j UDP_FLOOD
iptables -A INPUT -p udp --dport 27025 -j UDP_FLOOD
iptables -A INPUT -p udp --dport 27026 -j UDP_FLOOD
iptables -A INPUT -p udp --dport 27027 -j UDP_FLOOD
iptables -A INPUT -p udp --dport 27028 -j UDP_FLOOD
iptables -A INPUT -p udp --dport 27029 -j UDP_FLOOD
iptables -A INPUT -p udp --dport 27030 -j UDP_FLOOD

# Filters within the UDP_FLOOD chain
iptables -A UDP_FLOOD -p udp --dport 27015 -m recent --name valveddos27015_udp --rcheck --seconds 5 --hitcount 150 -j DROP
iptables -A UDP_FLOOD -p udp --dport 27015 -m recent --name valveddos27015_udp --set -j RETURN

iptables -A UDP_FLOOD -p udp --dport 27016 -m recent --name valveddos27016_udp --rcheck --seconds 5 --hitcount 150 -j DROP
iptables -A UDP_FLOOD -p udp --dport 27016 -m recent --name valveddos27016_udp --set -j RETURN

iptables -A UDP_FLOOD -p udp --dport 27016 -m recent --name valveddos27016_udp --rcheck --seconds 5 --hitcount 150 -j DROP
iptables -A UDP_FLOOD -p udp --dport 27016 -m recent --name valveddos27016_udp --set -j RETURN

iptables -A UDP_FLOOD -p udp --dport 27017 -m recent --name valveddos27017_udp --rcheck --seconds 5 --hitcount 150 -j DROP
iptables -A UDP_FLOOD -p udp --dport 27017 -m recent --name valveddos27017_udp --set -j RETURN

iptables -A UDP_FLOOD -p udp --dport 27018 -m recent --name valveddos27018_udp --rcheck --seconds 5 --hitcount 150 -j DROP
iptables -A UDP_FLOOD -p udp --dport 27018 -m recent --name valveddos27018_udp --set -j RETURN

iptables -A UDP_FLOOD -p udp --dport 27019 -m recent --name valveddos27019_udp --rcheck --seconds 5 --hitcount 150 -j DROP
iptables -A UDP_FLOOD -p udp --dport 27019 -m recent --name valveddos27019_udp --set -j RETURN

iptables -A UDP_FLOOD -p udp --dport 27020 -m recent --name valveddos27020_udp --rcheck --seconds 5 --hitcount 150 -j DROP
iptables -A UDP_FLOOD -p udp --dport 27020 -m recent --name valveddos27020_udp --set -j RETURN

iptables -A UDP_FLOOD -p udp --dport 27021 -m recent --name valveddos27021_udp --rcheck --seconds 5 --hitcount 150 -j DROP
iptables -A UDP_FLOOD -p udp --dport 27021 -m recent --name valveddos27021_udp --set -j RETURN

iptables -A UDP_FLOOD -p udp --dport 27021 -m recent --name valveddos27021_udp --rcheck --seconds 5 --hitcount 150 -j DROP
iptables -A UDP_FLOOD -p udp --dport 27021 -m recent --name valveddos27021_udp --set -j RETURN

iptables -A UDP_FLOOD -p udp --dport 27022 -m recent --name valveddos27022_udp --rcheck --seconds 5 --hitcount 150 -j DROP
iptables -A UDP_FLOOD -p udp --dport 27022 -m recent --name valveddos27022_udp --set -j RETURN

iptables -A UDP_FLOOD -p udp --dport 27023 -m recent --name valveddos27023_udp --rcheck --seconds 5 --hitcount 150 -j DROP
iptables -A UDP_FLOOD -p udp --dport 27023 -m recent --name valveddos27023_udp --set -j RETURN

iptables -A UDP_FLOOD -p udp --dport 27024 -m recent --name valveddos27024_udp --rcheck --seconds 5 --hitcount 150 -j DROP
iptables -A UDP_FLOOD -p udp --dport 27024 -m recent --name valveddos27024_udp --set -j RETURN

iptables -A UDP_FLOOD -p udp --dport 27025 -m recent --name valveddos27025_udp --rcheck --seconds 5 --hitcount 150 -j DROP
iptables -A UDP_FLOOD -p udp --dport 27025 -m recent --name valveddos27025_udp --set -j RETURN

iptables -A UDP_FLOOD -p udp --dport 27026 -m recent --name valveddos27026_udp --rcheck --seconds 5 --hitcount 150 -j DROP
iptables -A UDP_FLOOD -p udp --dport 27026 -m recent --name valveddos27026_udp --set -j RETURN

iptables -A UDP_FLOOD -p udp --dport 27027 -m recent --name valveddos27027_udp --rcheck --seconds 5 --hitcount 150 -j DROP
iptables -A UDP_FLOOD -p udp --dport 27027 -m recent --name valveddos27027_udp --set -j RETURN

iptables -A UDP_FLOOD -p udp --dport 27028 -m recent --name valveddos27028_udp --rcheck --seconds 5 --hitcount 150 -j DROP
iptables -A UDP_FLOOD -p udp --dport 27028 -m recent --name valveddos27028_udp --set -j RETURN

iptables -A UDP_FLOOD -p udp --dport 27029 -m recent --name valveddos27029_udp --rcheck --seconds 5 --hitcount 150 -j DROP
iptables -A UDP_FLOOD -p udp --dport 27029 -m recent --name valveddos27029_udp --set -j RETURN

iptables -A UDP_FLOOD -p udp --dport 27030 -m recent --name valveddos27030_udp --rcheck --seconds 5 --hitcount 150 -j DROP
iptables -A UDP_FLOOD -p udp --dport 27030 -m recent --name valveddos27030_udp --set -j RETURN

# General throttling (all other udp packets pass here)
iptables -A UDP_FLOOD -m limit --limit 5/second --limit-burst 250 -j RETURN

# Blocks everthing that goes through and is not accepted
iptables -A UDP_FLOOD -j DROP
