require 'yaml'

class User
  admin_yml = File.join(RAILS_ROOT, 'config', 'admin.yml')
  
  Admin = YAML.load_file(admin_yml)
  
  def self.authenticate username, password
    username == Admin['user'] && password == Admin['password']
  end
end
