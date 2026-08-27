test -x /usr/bin/cf-agent && exit 0

# Official CFEngine community apt repository (https://cfengine.com/cfengine-linux-distros/)
# - a single flat "stable" suite, not one per distro codename.
curl -fsSL https://cfengine-package-repos.s3.amazonaws.com/pub/gpg.key | gpg --batch --yes --dearmor -o /usr/share/keyrings/cfengine-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/cfengine-archive-keyring.gpg] https://cfengine-package-repos.s3.amazonaws.com/pub/apt/packages stable main" > /etc/apt/sources.list.d/cfengine-community.list
apt-get update
apt-get install -y cfengine-community
