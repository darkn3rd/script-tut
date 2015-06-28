
# Local Directories for using
cookbook_path    ["cookbooks", "site-cookbooks"]
node_path        "nodes"
role_path        "roles"
environment_path "environments"
data_bag_path    "data_bags"
#encrypted_data_bag_secret "data_bag_key"

#knife[:berkshelf_path] = "cookbooks"

client_key               "#{current_dir}/dummy.pem"
validation_client_name   "validator"
validation_key           "#{current_dir}/dummy.pem"

chef_server_url          "http://127.0.0.1:8889"
chef-zero.enabled        true
