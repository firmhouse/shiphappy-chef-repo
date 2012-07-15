if node.shiphappy_env == "development"
  default['phantomjs'] = {
    'version' => '1.6.0-linux-i686-dynamic'
  }
else
  default['phantomjs'] = {
    'version' => '1.6.0-linux-x86_64-dynamic'
  }
end