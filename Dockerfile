FROM rails:onbuild 

ENV PG_USER postgres

####################################################################
### I want to delete the app (which by default is added to the   ### 
### /usr/src/app directory and then later replace it with a      ### 
### read/write volume. So I don't have to build the app each     ###
### time it is updated. Ideally, I wouldn't even need to restart ###
### the server container...                                      ###
####################################################################
RUN cd /usr/src && \
    rm -rf /usr/src/app && \ 
    mkdir app && \ 
    cd app

####################################################################
### Apparently you can't do this with dockerfiles because it is  ### 
### against their nature as being portable (able to use on any   ###
### machine)                                                     ###
###                                                              ###
### VOLUME [/home/john/projects/docker/rails/jhi2:/usr/src/app]  ###
####################################################################

####################################################################
