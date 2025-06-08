# Stage 1: build the JAR with JDK 21
FROM maven:3.9.4-eclipse-temurin-21 AS build
WORKDIR /app

# copy wrapper, POM, and wrapper config
COPY mvnw pom.xml .mvn/ ./
COPY .mvn .mvn/

# copy source & build
COPY src ./src
RUN chmod +x mvnw \
  && ./mvnw -B package -DskipTests

# Stage 2: runtime
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
