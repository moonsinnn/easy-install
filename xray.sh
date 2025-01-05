echo
echo -n 'Setup Service.....'
# NON TLS MODE
cat >/usr/local/etc/xray/vmesswsnontls.json <<END
{
  "log": {
    "loglevel": "info",
    "error": "/var/log/xray/error.log",
    "access": "/var/log/xray/access.log"
  },
  "stats": {},
  "api": {
    "tag": "api",
    "services": [
      "StatsService"
    ]
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserUplink": true,
        "statsUserDownlink": true
      },
      "1": {
        "handshake": 3,
        "connIdle": 60,
        "downlinkOnly": 0,
        "uplinkOnly": 0,
        "statsUserUplink": true,
        "statsUserDownlink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink": true,
      "statsOutboundDownlink": true
    }
  },
  "inbounds": [
    {
      "tag": "vmesswsnontls",
      "port": "80, 8080, 2086, 8880, 2052, 2082, 2095",
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "email": "admin@fuby.moe",
            "id": "b2422495-d0b1-47fd-a38f-e60c83527229",
            "level": 0,
            "alterId": 0
          },
          {
            "email": "admin@fubi.moe",
            "id": "019d5ce7-0bd3-4ba9-a032-ca71610443aa",
            "level": 0,
            "alterId": 0
#membervmesswsnontls
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/worryfree"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "listen": "127.0.0.1",
      "port": 10081,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    }
  ],
  "outbounds": [
    {
      "tag": "direct",
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "socks",
      "settings": {
        "servers": [
          {
            "address": "127.0.0.1",
            "port": 40000
          }
        ]
      },
      "tag": "socks5-warp"
    }
  ],
  "routing": {
    "domainStrategy": "IPOnDemand",
    "rules": [
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "127.0.0.0/8",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "type": "field",
        "protocol": [
          "bittorrent"
        ],
        "outboundTag": "blocked"
      }
    ]
  }
}
END
# TLS MODE VMESS
cat >/usr/local/etc/xray/vmesswstls.json <<END
{
  "log": {
    "loglevel": "info",
    "error": "/var/log/xray/error.log",
    "access": "/var/log/xray/access.log"
  },
  "stats": {},
  "api": {
    "tag": "api",
    "services": [
      "StatsService"
    ]
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserUplink": true,
        "statsUserDownlink": true
      },
      "1": {
        "handshake": 3,
        "connIdle": 60,
        "downlinkOnly": 0,
        "uplinkOnly": 0,
        "statsUserUplink": true,
        "statsUserDownlink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink": true,
      "statsOutboundDownlink": true
    }
  },
  "inbounds": [
    {
      "tag": "vmesswstls",
      "port": 2001,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "email": "admin@fuby.moe",
            "id": "b2422495-d0b1-47fd-a38f-e60c83527229",
            "level": 0,
            "alterId": 0
          },
          {
            "email": "admin@fubi.moe",
            "id": "019d5ce7-0bd3-4ba9-a032-ca71610443aa",
            "level": 0,
            "alterId": 0
#membervmesswstls
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/netzvmess"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "listen": "127.0.0.1",
      "port": 10082,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    }
  ],
  "outbounds": [
    {
      "tag": "direct",
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "socks",
      "settings": {
        "servers": [
          {
            "address": "127.0.0.1",
            "port": 40000
          }
        ]
      },
      "tag": "socks5-warp"
    }
  ],
  "routing": {
    "domainStrategy": "IPOnDemand",
    "rules": [
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "127.0.0.0/8",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "type": "field",
        "protocol": [
          "bittorrent"
        ],
        "outboundTag": "blocked"
      }
    ]
  }
}
END
cat >/usr/local/etc/xray/vmessgrpc.json <<END
{
  "log": {
    "loglevel": "info",
    "error": "/var/log/xray/error.log",
    "access": "/var/log/xray/access.log"
  },
  "stats": {},
  "api": {
    "tag": "api",
    "services": [
      "StatsService"
    ]
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserUplink": true,
        "statsUserDownlink": true
      },
      "1": {
        "handshake": 3,
        "connIdle": 60,
        "downlinkOnly": 0,
        "uplinkOnly": 0,
        "statsUserUplink": true,
        "statsUserDownlink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink": true,
      "statsOutboundDownlink": true
    }
  },
  "inbounds": [
    {
      "tag": "vmessgrpc",
      "port": 2004,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "email": "admin@fuby.moe",
            "id": "b2422495-d0b1-47fd-a38f-e60c83527229",
            "level": 0
          },
          {
            "email": "admin@fubi.moe",
            "id": "019d5ce7-0bd3-4ba9-a032-ca71610443aa",
            "level": 0
#membervmessgrpc
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "grpc",
        "security": "none",
        "grpcSettings": {
          "serviceName": "netzvmessgrpc"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "listen": "127.0.0.1",
      "port": 10083,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    }
  ],
  "outbounds": [
    {
      "tag": "direct",
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "socks",
      "settings": {
        "servers": [
          {
            "address": "127.0.0.1",
            "port": 40000
          }
        ]
      },
      "tag": "socks5-warp"
    }
  ],
  "routing": {
    "domainStrategy": "IPOnDemand",
    "rules": [
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "127.0.0.0/8",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "type": "field",
        "protocol": [
          "bittorrent"
        ],
        "outboundTag": "blocked"
      }
    ]
  }
}
END
# TLS MNODE VLESS
cat >/usr/local/etc/xray/vlesswstls.json <<END
{
  "log": {
    "loglevel": "info",
    "error": "/var/log/xray/error.log",
    "access": "/var/log/xray/access2.log"
  },
  "stats": {},
  "api": {
    "tag": "api",
    "services": [
      "StatsService"
    ]
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserUplink": true,
        "statsUserDownlink": true
      },
      "1": {
        "handshake": 3,
        "connIdle": 60,
        "downlinkOnly": 0,
        "uplinkOnly": 0,
        "statsUserUplink": true,
        "statsUserDownlink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink": true,
      "statsOutboundDownlink": true
    }
  },
  "inbounds": [
    {
      "tag": "vlesswstls",
      "port": 2002,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "email": "admin@fuby.moe",
            "id": "b2422495-d0b1-47fd-a38f-e60c83527229",
            "level": 0,
            "alterId": 0
          },
          {
            "email": "admin@fubi.moe",
            "id": "019d5ce7-0bd3-4ba9-a032-ca71610443aa",
            "level": 0,
            "alterId": 0
#membervlesswstls
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/netzvless"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "listen": "127.0.0.1",
      "port": 10084,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    }
  ],
  "outbounds": [
    {
      "tag": "direct",
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "socks",
      "settings": {
        "servers": [
          {
            "address": "127.0.0.1",
            "port": 40000
          }
        ]
      },
      "tag": "socks5-warp"
    }
  ],
  "routing": {
    "domainStrategy": "IPOnDemand",
    "rules": [
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "127.0.0.0/8",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "type": "field",
        "protocol": [
          "bittorrent"
        ],
        "outboundTag": "blocked"
      }
    ]
  }
}
END
cat >/usr/local/etc/xray/vlessgrpc.json <<END
{
  "log": {
    "loglevel": "info",
    "error": "/var/log/xray/error.log",
    "access": "/var/log/xray/access2.log"
  },
  "stats": {},
  "api": {
    "tag": "api",
    "services": [
      "StatsService"
    ]
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserUplink": true,
        "statsUserDownlink": true
      },
      "1": {
        "handshake": 3,
        "connIdle": 60,
        "downlinkOnly": 0,
        "uplinkOnly": 0,
        "statsUserUplink": true,
        "statsUserDownlink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink": true,
      "statsOutboundDownlink": true
    }
  },
  "inbounds": [
    {
      "tag": "vlessgrpc",
      "port": 2005,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "email": "admin@fuby.moe",
            "id": "b2422495-d0b1-47fd-a38f-e60c83527229",
            "level": 0
          },
          {
            "email": "admin@fubi.moe",
            "id": "019d5ce7-0bd3-4ba9-a032-ca71610443aa",
            "level": 0
#membervlessgrpc
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "grpc",
        "security": "none",
        "grpcSettings": {
          "serviceName": "netzvlessgrpc"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "listen": "127.0.0.1",
      "port": 10085,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    }
  ],
  "outbounds": [
    {
      "tag": "direct",
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "socks",
      "settings": {
        "servers": [
          {
            "address": "127.0.0.1",
            "port": 40000
          }
        ]
      },
      "tag": "socks5-warp"
    }
  ],
  "routing": {
    "domainStrategy": "IPOnDemand",
    "rules": [
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "127.0.0.0/8",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "type": "field",
        "protocol": [
          "bittorrent"
        ],
        "outboundTag": "blocked"
      }
    ]
  }
}
END
# TLS MODE TROJAN
cat >/usr/local/etc/xray/trojanwstls.json <<END
{
  "log": {
    "access": "/var/log/xray/access3.log",
    "error": "/var/log/xray/error3.log",
    "loglevel": "info"
  },
  "stats": {},
  "api": {
    "tag": "api",
    "services": [
      "StatsService"
    ]
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserUplink": true,
        "statsUserDownlink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink": true,
      "statsOutboundDownlink": true
    }
  },
  "dns": {
    "servers": [
      "localhost"
    ],
    "queryStrategy": "UseIPv4"
  },
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {
        "type": "field",
        "ip": [
          "1.1.1.1",
          "1.0.0.1"
        ],
        "outboundTag": "IPv4-out"
      },
      {
        "type": "field",
        "domain": [
          "geosite:rule-ads",
          "geosite:rule-malicious"
        ],
        "outboundTag": "block"
      },
      {
        "type": "field",
        "ip": [
          "geoip:cn"
        ],
        "outboundTag": "block"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      }
    ]
  },
  "inbounds": [
    {
      "tag": "TROJANWS",
      "port": 2003,
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "password": "admin@fuby.moe",
            "email": "admin@fuby.moe"
          },
          {
            "password": "admin@fubi.moe",
            "email": "admin@fubi.moe"
#membertrojanwstls
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/netztrojan"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "listen": "127.0.0.1",
      "port": 10086,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIPv4"
      },
      "tag": "IPv4-out"
    },
    {
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIPv6"
      },
      "tag": "IPv6-out"
    },
    {
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      },
      "tag": "block"
    }
  ]
}
END
cat >/usr/local/etc/xray/trojanwscf.json <<END
{
  "log": {
    "access": "/var/log/xray/access3.log",
    "error": "/var/log/xray/error3.log",
    "loglevel": "info"
  },
  "stats": {},
  "api": {
    "tag": "api",
    "services": [
      "StatsService"
    ]
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserUplink": true,
        "statsUserDownlink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink": true,
      "statsOutboundDownlink": true
    }
  },
  "dns": {
    "servers": [
      "localhost"
    ],
    "queryStrategy": "UseIPv4"
  },
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {
        "type": "field",
        "domain": [
          "geosite:rule-playstore",
          "geosite:youtube",
          "geosite:google"
        ],
        "outboundTag": "cloudflarewarp"
      },
      {
        "type": "field",
        "ip": [
          "geoip:google"
        ],
        "outboundTag": "cloudflarewarp"
      },
      {
        "type": "field",
        "ip": [
          "1.1.1.1",
          "1.0.0.1"
        ],
        "outboundTag": "IPv4-out"
      },
      {
        "type": "field",
        "domain": [
          "geosite:rule-ads",
          "geosite:rule-malicious"
        ],
        "outboundTag": "block"
      },
      {
        "type": "field",
        "ip": [
          "geoip:cn"
        ],
        "outboundTag": "block"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      }
    ]
  },
  "inbounds": [
    {
      "tag": "TROJANCF",
      "port": 2009,
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "password": "admin@fuby.moe",
            "email": "admin@fuby.moe"
          },
          {
            "password": "admin@fubi.moe",
            "email": "admin@fubi.moe"
#membertrojanwscf
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/netztrojancf"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "listen": "127.0.0.1",
      "port": 10090,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIPv4"
      },
      "tag": "IPv4-out"
    },
    {
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIPv6"
      },
      "tag": "IPv6-out"
    },
    {
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      },
      "tag": "block"
    },
    {
      "protocol": "socks",
      "settings": {
        "servers": [
          {
            "address": "127.0.0.1",
            "port": 40000
          }
        ]
      },
      "tag": "cloudflarewarp"
    }
  ]
}
END
cat >/usr/local/etc/xray/trojangrpc.json <<END
{
  "log": {
    "access": "/var/log/xray/access3.log",
    "error": "/var/log/xray/error3.log",
    "loglevel": "info"
  },
  "stats": {},
  "api": {
    "tag": "api",
    "services": [
      "StatsService"
    ]
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserUplink": true,
        "statsUserDownlink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink": true,
      "statsOutboundDownlink": true
    }
  },
  "dns": {
    "servers": [
      "localhost"
    ],
    "queryStrategy": "UseIPv4"
  },
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {
        "type": "field",
        "ip": [
          "1.1.1.1",
          "1.0.0.1"
        ],
        "outboundTag": "IPv4-out"
      },
      {
        "type": "field",
        "domain": [
          "geosite:rule-ads",
          "geosite:rule-malicious"
        ],
        "outboundTag": "block"
      },
      {
        "type": "field",
        "ip": [
          "geoip:cn"
        ],
        "outboundTag": "block"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      }
    ]
  },
  "inbounds": [
    {
      "tag": "TROJANGRPC",
      "port": 2006,
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "password": "admin@fuby.moe",
            "email": "admin@fuby.moe"
          },
          {
            "password": "admin@fubi.moe",
            "email": "admin@fubi.moe"
#membertrojangrpc
          }
        ]
      },
      "streamSettings": {
        "network": "grpc",
        "security": "none",
        "grpcSettings": {
          "serviceName": "netztrojangrpc"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "listen": "127.0.0.1",
      "port": 10087,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIPv4"
      },
      "tag": "IPv4-out"
    },
    {
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIPv6"
      },
      "tag": "IPv6-out"
    },
    {
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      },
      "tag": "block"
    }
  ]
}
END
