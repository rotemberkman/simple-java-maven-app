FROM maven:3.9.5-eclipse-temurin-17 AS builder

COPY src /app/src

COPY pom.xml /app

WORKDIR /app

RUN mvn dependency:go-offline --batch-mode

RUN mvn package



FROM eclipse-temurin:17-jre-alpine AS runtime

ARG PATCHNUM

COPY --from=builder /app/target/my-app-1.0.jar /app/my-app-1.0.${PATCHNUM}.jar

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

ENTRYPOINT ["java", "-jar", "/app/my-app-1.0.${PATCHNUM}.jar"]
