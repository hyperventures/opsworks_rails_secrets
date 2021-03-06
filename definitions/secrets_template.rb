# Accepts:
#   application (application name)
#   deploy (hash of deploy attributes)
#   env (hash of custom environment settings)
# 
# Notifies a "restart Rails app <name> for secrets" resource.

define :secrets_template do
  
  template "#{params[:deploy][:deploy_to]}/shared/config/secrets.yml" do
    source "secrets.yml.erb"
    owner params[:deploy][:user]
    group params[:deploy][:group]
    mode "0660"
    variables :env => params[:env]

    if node[:opsworks][:instance][:layers].include?('rails-app')
      notifies :run, resources(:execute => "restart Rails app #{params[:application]} for opsworks rails secrets")
    end

    only_if do
      File.exists?("#{params[:deploy][:deploy_to]}/shared/config")
    end
  end
end

define :shards_template do
  template "#{params[:deploy][:deploy_to]}/shared/config/shards.yml" do
    source "shards.yml.erb"
    owner params[:deploy][:user]
    group params[:deploy][:group]
    mode "0660"
    variables :env => params[:env]

    if node[:opsworks][:instance][:layers].include?('rails-app')
      notifies :run, resources(:execute => "restart Rails app #{params[:application]} for opsworks rails secrets")
    end

    only_if do
      File.exists?("#{params[:deploy][:deploy_to]}/shared/config")
    end
  end
end