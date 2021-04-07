FROM openjdk:14-alpine
COPY build/libs/golf-outing-*-all.jar golf-outing.jar
EXPOSE 8080
CMD ["java", "-Dcom.sun.management.jmxremote", "-Xmx128m", "-jar", "golf-outing.jar"]