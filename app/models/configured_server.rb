class ConfiguredServer

  def list
    servers = []
    YAML.load_file(Rails.root.join('config/gitserver_config.yml')).each_key {|k| servers << add_server(k) }
    servers.compact!
  end

  def add_server(server)
    if GITSERVER_FILE[server][Rails.env]["base_ws_url"] != "YOUR_BASE_WS_URL_HERE"
      server
    end
  end

end