FROM dashbook/airbyte-java-source-builder:latest AS build
RUN gradle --no-daemon :airbyte-integrations:connectors:source-postgres:assemble
RUN tar -xvf /home/gradle/src/airbyte-integrations/connectors/source-postgres/build/distributions/source-postgres*.tar --strip-components=1 

FROM amazoncorretto:17

RUN mkdir /airbyte

COPY --from=build /home/gradle/src/lib /airbyte/lib
COPY --from=build /home/gradle/src/bin /airbyte/bin

ENTRYPOINT ["/airbyte/bin/source-postgres"]


