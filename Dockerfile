# Stage 1: build the JAR
FROM maven:3.9.4-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml mvnw .mvn/ ./
COPY src ./src
RUN chmod +x mvnw \
  && ./mvnw -B package -DskipTests

# Stage 2: run the JAR
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
