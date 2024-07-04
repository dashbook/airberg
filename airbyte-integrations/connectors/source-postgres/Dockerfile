FROM gradle:7.6.4-jdk17 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle --no-daemon :airbyte-integrations:connectors:source-postgres:assemble
RUN tar -xvf /home/gradle/src/airbyte-integrations/connectors/source-postgres/build/distributions/source-postgres*.tar --strip-components=1 

FROM amazoncorretto:17

RUN mkdir /airbyte

COPY --from=build /home/gradle/src/lib /airbyte/lib
COPY --from=build /home/gradle/src/bin /airbyte/bin

ENTRYPOINT ["/airbyte/bin/source-postgres"]


