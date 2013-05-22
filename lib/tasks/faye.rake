namespace "faye" do
  desc "Start the Faye server"
  task :start do
    require 'faye'

    if ENV['verbose']
      Faye::Logging.log_level = :info
      Faye.logger = lambda { |m| puts m }
    end

    bayeux = Faye::RackAdapter.new :mount => '/faye', :timeout => 25

    port = ENV['port'] || 9292
    if ENV['key'] and ENV['cert']
      bayeux.listen port, :key => ENV['key'], :cert => ENV['cert']
    else
      bayeux.listen port
    end
  end
end
