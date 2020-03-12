FROM ruby:2.5.1

ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
RUN \
   curl -sL https://deb.nodesource.com/setup_13.x | bash - \
&& apt-get install -y nodejs \
&& apt-get update && apt-get install -y apt-transport-https \
&& curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
&& apt-get update && apt-get install -y yarn ffmpeg \
&& rm -rf /var/lib/apt/lists/*

ENV APP_PATH=/app

RUN mkdir $APP_PATH
WORKDIR $APP_PATH

ENV BUNDLER_VERSION=2.1.4
RUN gem install bundler:2.1.4
RUN gem install foreman

COPY Gemfile "${APP_PATH}/Gemfile"
COPY Gemfile.lock "${APP_PATH}/Gemfile.lock"
COPY . $APP_PATH

RUN yarn install --check-files
RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 5000

ENV PATH="${PATH}:/app/bin"

CMD ["rails", "server", "-b", "0.0.0.0"]
