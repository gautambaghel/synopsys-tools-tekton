FROM maven:3.6.3-jdk-8

COPY polaris_cli-linux64/bin /workspace/polaris/cli/

RUN ln -sf /workspace/polaris/cli/polaris /usr/bin/polaris
RUN ln -sf /workspace/polaris/cli/polaris-submit /usr/bin/polaris-submit
RUN ln -sf /workspace/polaris/cli/polaris-wait /usr/bin/polaris-wait

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]