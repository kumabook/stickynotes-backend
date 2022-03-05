FROM ruby:2.5.3
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

COPY . /myapp/
RUN RAILS_ENV=production bundle exec rake assets:precompile
CMD ["/bin/sh", "-c", "grep web: Procfile | cut -d : -f2 | sh"]
