FROM ubuntu
MAINTAINER Makoto Kitamura

WORKDIR /root
ENV HOME /root

RUN apt-get update -y
RUN apt-get upgrade -y

# install essential software
RUN apt-get install -y \
        build-essential \
        curl \
        git-core \
        libcurl4-openssl-dev \
        libffi-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        libxml2-dev \
        libxslt1-dev \
        libyaml-dev \
        python-software-properties \
        sqlite3 \
        sudo \
        vim \
        wget \
        zlib1g-dev

# postgresql
ENV PATH "/usr/lib/postgresql/9.5/bin:$PATH"
RUN sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
RUN wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
RUN apt-get install -y postgresql-common
RUN apt-get install -y postgresql-9.5 libpq-dev

# rbenv
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
ENV PATH "$HOME/.rbenv/bin:$PATH"
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc

# ruby-build
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
ENV PATH "$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

# install ruby
RUN rbenv install 2.2.5
RUN rbenv global 2.2.5
RUN $HOME/.rbenv/shims/gem install bundler
RUN rbenv rehash

# rails
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get install -y nodejs
RUN $HOME/.rbenv/shims/gem install rails -v 4.2.6
RUN rbenv rehash

# heroku toolbelt
RUN wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# copy initialize script file
ADD init.sh /usr/local/bin/init.sh
RUN chmod u+x /usr/local/bin/init.sh

CMD ["/usr/local/bin/init.sh"]
