set :application, "cincinnati.rb"
set :deploy_to, "/apps/#{application}"

# Primary domain name of your application. Used as a default for all server roles.
set :domain, "cincinnatirb.org"

# Login user for ssh.
set :user, "deploy"
set :use_sudo, false

# URL of your source repository.
set :repository, "git://github.com/cincinnatirb/cincinnati.rb.git"
set :deploy_via, :remote_cache
set :scm, :git
set :branch, "master"
set :git_enable_submodules, true

# Rails environment. Used by application setup tasks and migrate tasks.
set :rails_env, "production"

# Automatically symlink these directories from curent/public to shared/public.
set :app_symlinks, %w{}

# =============================================================================
# ROLES
# =============================================================================
# You can define any number of roles, each of which contains any number of
# machines. Roles might include such things as :web, or :app, or :db, defining
# what the purpose of each machine is. You can also specify options that can
# be used to single out a specific subset of boxes in a particular role, like
# :primary => true.

# Modify these values to execute tasks on a different server.
role :web, "av1.anotherventure.com"
role :app, "av1.anotherventure.com"
role :db,  "av1.anotherventure.com", :primary => true

# =============================================================================
# APACHE OPTIONS
# =============================================================================
set :apache_conf, "/etc/apache2/sites-available/#{application}"
set :apache_ctl, "/etc/init.d/apache2"
# set :apache_proxy_port, 9000
# set :apache_proxy_servers, 1
# set :apache_server_name, "etch"
# set :apache_server_aliases, %w{alias1 alias2}
# set :apache_default_vhost, true # force use of apache_default_vhost_config
# set :apache_default_vhost_conf, "/etc/httpd/conf/default.conf"
# set :apache_proxy_address, "127.0.0.1"
# set :apache_ssl_enabled, false
# set :apache_ssl_ip, "127.0.0.1"
# set :apache_ssl_forward_all, false

# =============================================================================
# SSH OPTIONS
# =============================================================================
ssh_options[:keys] = [File.expand_path("~/.ssh/id_dsa.pub"), File.expand_path("~/.ssh/id_rsa.pub")]
ssh_options[:forward_agent] = true
# ssh_options[:port] = 22

# =============================================================================
# CAPISTRANO OPTIONS
# =============================================================================
# default_run_options[:pty] = true
set :keep_releases, 7

after 'deploy:setup', 'apache:configure_vhost'
after 'apache:configure_vhost', 'apache:enable_site'
after 'deploy:cold', 'apache:reload'
after 'deploy:symlink', 'deploy:symlink_public'

namespace :apache do
  desc "Configure Passenger Vhost"
  task :configure_vhost do
    vhost_config =<<-EOF
    <VirtualHost *>

      ServerName  #{domain}
      ServerAlias www.#{domain}

      RailsEnv production

      DocumentRoot #{deploy_to}/current/public

      <Directory "#{deploy_to}/current/public">
        Options FollowSymLinks
        AllowOverride None
        Order allow,deny
        Allow from all
      </Directory>

      RewriteEngine On
      RewriteCond %{DOCUMENT_ROOT}/system/maintenance.html -f
      RewriteCond %{SCRIPT_FILENAME} !maintenance.html
      RewriteRule ^.*$ /system/maintenance.html [L]

    </VirtualHost>
EOF
    put vhost_config, "src/vhost_config"
    sudo "mv src/vhost_config /etc/apache2/sites-available/#{application}"
  end
  
  desc 'Enable site in apache'
  task :enable_site do
    sudo "a2ensite #{application}"
    sudo "sudo a2enmod rewrite"
  end
  
  desc 'Reload apache'
  task :reload do
    sudo "/etc/init.d/apache2 reload"
  end
end

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "Symlinks the :app_symlinks directories from current/public to shared/public"
  task :symlink_public do
     if app_symlinks && app_symlinks.size > 0
       app_symlinks.each do |link|
         run "ln -nfs #{shared_path}/public/#{link} #{current_path}/public/#{link}"
       end
     end
  end
end
