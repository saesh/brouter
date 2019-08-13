FROM maven:3-jdk-8 as build
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY . .
RUN mvn clean install -pl brouter-server -am

FROM openjdk:8-jdk-alpine
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=build /usr/src/app/brouter-server/target/brouter-server-1.5.5-jar-with-dependencies.jar app.jar
VOLUME /root/customprofiles
VOLUME /root/profiles
VOLUME /root/segments
EXPOSE 17777
CMD java -Xmx128M -Xms128M -Xmn8M -DmaxRunningTime=300 -cp app.jar btools.server.RouteServer segments profiles customprofiles 17777 1
