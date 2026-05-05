#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' #No Color

echo "--- JÄRJESTELMÄN TILANNEKATSAUS ---"
echo ""

# 1. Systemctl
echo -n "Caddy: "
if systemctl is-active --quiet caddy; then
    echo -e "${GREEN}KÄYNNISSÄ${NC}"
else
    echo -e "${RED}EI KÄYNNISSÄ${NC}"
fi

echo -n "UFW: "
if sudo ufw status | grep -q "Status: active"; then
    echo -e "${GREEN}AKTIIVINEN${NC}"
else
    echo -e "${RED}POIS PÄÄLTÄ${NC}"
fi

echo ""

#Työkalujen versionumerot
echo -n "Ansible: "
if ansible --version &> /dev/null; then
    VERSION=$(ansible --version | head -n 1 | awk '{print $3}')
    echo -e "${GREEN}ASENNETTU ($VERSION)${NC}"
else
    echo -e "${RED}EI ASENNETTU${NC}"
fi

echo -n "Git: "
if git --version &> /dev/null; then
    VERSION=$(git --version | awk '{print $3}')
    echo -e "${GREEN}ASENNETTU ($VERSION)${NC}"
else
    echo -e "${RED}EI ASENNETTU${NC}"
fi

echo ""
echo "---------------------------"
