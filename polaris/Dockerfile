FROM maven:3.6.3-jdk-8

COPY polaris_cli-linux64/bin /polaris/cli/

RUN ln -sf /polaris/cli/polaris /usr/bin/polaris
RUN ln -sf /polaris/cli/polaris-submit /usr/bin/polaris-submit
RUN ln -sf /polaris/cli/polaris-wait /usr/bin/polaris-wait

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]