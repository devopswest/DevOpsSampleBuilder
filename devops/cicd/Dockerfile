FROM pwcusadc/cicd

RUN echo "Overriding Files....."
COPY ./devops/cicd /var/devops/cicd

RUN \
   chmod -R +x /var/devops/cicd/*.sh && \
   chmod -R +x /var/devops/cicd/scripts/*.sh
