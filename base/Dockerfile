FROM ubuntu:14.04
MAINTAINER Hiroki Kumamoto <kumabook@live.jp>
RUN apt-get -qq update
RUN apt-get install -qqy haskell-platform
RUN cabal update
RUN cabal install cabal-install
ENV PATH $HOME/.cabal/bin:$PATH
