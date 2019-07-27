web: bundle exec rails server -p $PORT
worker: QUEUE=* bundle exec env rake resque:schedule_then_work