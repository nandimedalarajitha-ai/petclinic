FROM docker.io/library/eclipse-temurin:17-jdk-jammy
RUN groupadd -r petclinic && useradd -r -g petclinic -d /opt/petclinic petclinic
RUN mkdir -p /opt/petclinic/config && \
    chown -R petclinic:petclinic /opt/petclinic && \
    chmod -R 755 /opt/petclinic
WORKDIR /opt/petclinic
COPY --chown=petclinic:petclinic target/*.jar app.jar
COPY --chown=petclinic:petclinic application.properties /opt/petclinic/config/application.properties
EXPOSE 8080
USER petclinic
ENTRYPOINT ["sh", "-c", "java -jar app.jar --spring.config.location=classpath:/,file:/opt/petclinic/config/application.properties"]
