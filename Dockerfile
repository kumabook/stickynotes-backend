FROM kumabook/haskell
MAINTAINER Hiroki Kumamoto <kumabook@live.jp>

ADD stickynotes-backend.cabal stickynotes-backend.cabal
ADD Setup.hs Setup.hs
ADD src src
ADD static static
ADD test test

EXPOSE 3000
RUN ["cabal", "sandbox", "init"]
RUN ["cabal", "install", "--only-dependencies"]
RUN ["cabal", "build"]
