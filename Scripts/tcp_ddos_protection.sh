#!/bin/sh
# This is any example for valve games from ports 27015-27030

# Create a custom chain only once (if it doesn't already exist)
iptables -N TCP_FLOOD 2>/dev/null

# Redirects traffic from each port to the TCP_FLOOD chain
iptables -A INPUT -p tcp --dport 27015 -j TCP_FLOOD
iptables -A INPUT -p tcp --dport 27016 -j TCP_FLOOD
iptables -A INPUT -p tcp --dport 27017 -j TCP_FLOOD
iptables -A INPUT -p tcp --dport 27018 -j TCP_FLOOD
iptables -A INPUT -p tcp --dport 27019 -j TCP_FLOOD
iptables -A INPUT -p tcp --dport 27020 -j TCP_FLOOD
iptables -A INPUT -p tcp --dport 27021 -j TCP_FLOOD
iptables -A INPUT -p tcp --dport 27022 -j TCP_FLOOD
iptables -A INPUT -p tcp --dport 27023 -j TCP_FLOOD
iptables -A INPUT -p tcp --dport 27024 -j TCP_FLOOD
iptables -A INPUT -p tcp --dport 27025 -j TCP_FLOOD
iptables -A INPUT -p tcp --dport 27026 -j TCP_FLOOD
iptables -A INPUT -p tcp --dport 27027 -j TCP_FLOOD
iptables -A INPUT -p tcp --dport 27028 -j TCP_FLOOD
iptables -A INPUT -p tcp --dport 27029 -j TCP_FLOOD
iptables -A INPUT -p tcp --dport 27030 -j TCP_FLOOD

# Filters within the TCP_FLOOD chain
iptables -A TCP_FLOOD -p tcp --dport 27015 -m recent --name valveddos27015_tcp --rcheck --seconds 5 --hitcount 15 -j DROP
iptables -A TCP_FLOOD -p tcp --dport 27015 -m recent --name valveddos27015_tcp --set -j RETURN

iptables -A TCP_FLOOD -p tcp --dport 27016 -m recent --name valveddos27016_tcp --rcheck --seconds 5 --hitcount 15 -j DROP
iptables -A TCP_FLOOD -p tcp --dport 27016 -m recent --name valveddos27016_tcp --set -j RETURN

iptables -A TCP_FLOOD -p tcp --dport 27016 -m recent --name valveddos27016_tcp --rcheck --seconds 5 --hitcount 15 -j DROP
iptables -A TCP_FLOOD -p tcp --dport 27016 -m recent --name valveddos27016_tcp --set -j RETURN

iptables -A TCP_FLOOD -p tcp --dport 27017 -m recent --name valveddos27017_tcp --rcheck --seconds 5 --hitcount 15 -j DROP
iptables -A TCP_FLOOD -p tcp --dport 27017 -m recent --name valveddos27017_tcp --set -j RETURN

iptables -A TCP_FLOOD -p tcp --dport 27018 -m recent --name valveddos27018_tcp --rcheck --seconds 5 --hitcount 15 -j DROP
iptables -A TCP_FLOOD -p tcp --dport 27018 -m recent --name valveddos27018_tcp --set -j RETURN

iptables -A TCP_FLOOD -p tcp --dport 27019 -m recent --name valveddos27019_tcp --rcheck --seconds 5 --hitcount 15 -j DROP
iptables -A TCP_FLOOD -p tcp --dport 27019 -m recent --name valveddos27019_tcp --set -j RETURN

iptables -A TCP_FLOOD -p tcp --dport 27020 -m recent --name valveddos27020_tcp --rcheck --seconds 5 --hitcount 15 -j DROP
iptables -A TCP_FLOOD -p tcp --dport 27020 -m recent --name valveddos27020_tcp --set -j RETURN

iptables -A TCP_FLOOD -p tcp --dport 27021 -m recent --name valveddos27021_tcp --rcheck --seconds 5 --hitcount 15 -j DROP
iptables -A TCP_FLOOD -p tcp --dport 27021 -m recent --name valveddos27021_tcp --set -j RETURN

iptables -A TCP_FLOOD -p tcp --dport 27021 -m recent --name valveddos27021_tcp --rcheck --seconds 5 --hitcount 15 -j DROP
iptables -A TCP_FLOOD -p tcp --dport 27021 -m recent --name valveddos27021_tcp --set -j RETURN

iptables -A TCP_FLOOD -p tcp --dport 27022 -m recent --name valveddos27022_tcp --rcheck --seconds 5 --hitcount 15 -j DROP
iptables -A TCP_FLOOD -p tcp --dport 27022 -m recent --name valveddos27022_tcp --set -j RETURN

iptables -A TCP_FLOOD -p tcp --dport 27023 -m recent --name valveddos27023_tcp --rcheck --seconds 5 --hitcount 15 -j DROP
iptables -A TCP_FLOOD -p tcp --dport 27023 -m recent --name valveddos27023_tcp --set -j RETURN

iptables -A TCP_FLOOD -p tcp --dport 27024 -m recent --name valveddos27024_tcp --rcheck --seconds 5 --hitcount 15 -j DROP
iptables -A TCP_FLOOD -p tcp --dport 27024 -m recent --name valveddos27024_tcp --set -j RETURN

iptables -A TCP_FLOOD -p tcp --dport 27025 -m recent --name valveddos27025_tcp --rcheck --seconds 5 --hitcount 15 -j DROP
iptables -A TCP_FLOOD -p tcp --dport 27025 -m recent --name valveddos27025_tcp --set -j RETURN

iptables -A TCP_FLOOD -p tcp --dport 27026 -m recent --name valveddos27026_tcp --rcheck --seconds 5 --hitcount 15 -j DROP
iptables -A TCP_FLOOD -p tcp --dport 27026 -m recent --name valveddos27026_tcp --set -j RETURN

iptables -A TCP_FLOOD -p tcp --dport 27027 -m recent --name valveddos27027_tcp --rcheck --seconds 5 --hitcount 15 -j DROP
iptables -A TCP_FLOOD -p tcp --dport 27027 -m recent --name valveddos27027_tcp --set -j RETURN

iptables -A TCP_FLOOD -p tcp --dport 27028 -m recent --name valveddos27028_tcp --rcheck --seconds 5 --hitcount 15 -j DROP
iptables -A TCP_FLOOD -p tcp --dport 27028 -m recent --name valveddos27028_tcp --set -j RETURN

iptables -A TCP_FLOOD -p tcp --dport 27029 -m recent --name valveddos27029_tcp --rcheck --seconds 5 --hitcount 15 -j DROP
iptables -A TCP_FLOOD -p tcp --dport 27029 -m recent --name valveddos27029_tcp --set -j RETURN

iptables -A TCP_FLOOD -p tcp --dport 27030 -m recent --name valveddos27030_tcp --rcheck --seconds 5 --hitcount 15 -j DROP
iptables -A TCP_FLOOD -p tcp --dport 27030 -m recent --name valveddos27030_tcp --set -j RETURN

# General throttling (all other TCP packets pass here)
iptables -A TCP_FLOOD -m limit --limit 5/second --limit-burst 30 -j RETURN

# Blocks everthing that goes through and is not accepted
iptables -A TCP_FLOOD -j DROP
