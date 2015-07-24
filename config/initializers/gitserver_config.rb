GITSERVER_FILE = YAML.load_file(Rails.root.join('config/gitserver_config.yml'))
GITLAB_WS_URL = YAML.load_file(Rails.root.join('config/gitserver_config.yml'))["gitlab"][Rails.env]["base_ws_url"]
GITLAB_TOKEN = YAML.load_file(Rails.root.join('config/gitserver_config.yml'))["gitlab"][Rails.env]["private_token"]

GIT_SERVERS = ConfiguredServer.new.list
