require 'resque/tasks'
require 'resque/scheduler/tasks'

namespace :resque do

  task :schedule_then_work do
    if Process.respond_to? :fork
      if Process.fork
        sh "rake environment resque:work"
      else
        sh "rake resque:scheduler"
        Process.wait
      end
    else # windows
      pid = Process.spawn "rake environment resque:work"
      Rake::Task["resque:scheduler"].invoke
      Process.wait pid
    end
  end

  task :setup do
    require 'resque'

    ENV['QUEUE'] = '*'
    Resque.redis = 'localhost:6379' unless Rails.env == 'production'
  end
  task :setup => :environment

  task :setup_scheduler do
    require 'resque-scheduler'
    Resque.schedule = YAML.load_file(Rails.root.join('config/job_schedules.yml'))
  end
  task :scheduler => :setup_scheduler

end

Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
