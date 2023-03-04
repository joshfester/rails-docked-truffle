FROM ghcr.io/graalvm/truffleruby:debian-22.3.1

# Ensure node.js 19 is available for apt-get
RUN curl -sL https://deb.nodesource.com/setup_19.x | bash -

# Install dependencies
# Packages not included in https://github.com/rails/docked :
#   git: for 'rails new'
#   pkg-config: for sqlite gem
#   libpq: for pg
RUN apt-get update -qq && apt-get install -y libpq-dev pkg-config git build-essential libvips nodejs && npm install -g yarn

# Mount $PWD to this workdir
WORKDIR /rails

# Ensure gems are installed on a persistent volume and available as bins
VOLUME /bundle
RUN bundle config set --global path '/bundle'
ENV PATH="/bundle/truffleruby/3.0.3.22.3.1/bin:${PATH}"

# Install Rails
RUN gem install rails

# Ensure binding is always 0.0.0.0, even in development, to access server from outside container
ENV BINDING="0.0.0.0"

# Overwrite ruby image's entrypoint to provide open cli
ENTRYPOINT [""]