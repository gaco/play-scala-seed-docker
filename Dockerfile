###########################
# Play Framework Dockerfile
# -------------------------
# Description: An example Play Framework application through Seed Template: https://github.com/playframework/play-scala-seed.g8
#  It doesn't use activator, as the  official support for the same will be discontinued by the end of 2017.
#  This image requires only scala and sbt installed, which are provided by the inherited image: hseeberger/scala-sbt.
# Git Repository: https://github.com/gaco/play-scala-seed-docker/
###########################

# Base image
FROM hseeberger/scala-sbt

LABEL maintainer.name="Gabriel Côrtes"
LABEL maintainer.email="gaco1001@gmail.com"

# Environment variables
## Exposed Port
ENV PLAY_PORT=9000
## Play Directory
ENV PLAY_USER=play
ENV PLAY_HOME=/home/${PLAY_USER}

# Creates a new user to use play.
RUN useradd --create-home --password ${PLAY_USER} --shell /bin/bash ${PLAY_USER}

# Switch back to root user to starts seed template in play directory
USER root
WORKDIR ${PLAY_HOME}

# Starts seed template with default parameters
RUN yes "" | sbt new playframework/play-scala-seed.g8
WORKDIR ${PLAY_HOME}/play-scala-seed

HEALTHCHECK CMD curl --fail http://localhost:${PLAY_PORT}/ || exit 1

# Expose Play port and launch the application
EXPOSE ${PLAY_PORT}
CMD ["sbt", "run"]
