

```bash
wget -qO- https://cfengine.com/pub/gpg.key | apt-key add -
echo "deb http://cfengine.com/pub/apt/packages stable main" > /etc/apt/sources.list.d/cfengine-community.list
apt-get update
apt-get install cfengine-community
```

https://cfengine.com/product/community/cfengine-linux-distros/
