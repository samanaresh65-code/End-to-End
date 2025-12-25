# STAGE 1: BUILD

FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy pom.xml first (for dependency caching)
COPY pom.xml .

# Download dependencies (cached if pom.xml unchanged)
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# -----------------------------------------------------------------------------
# STAGE 2: RUN
# -----------------------------------------------------------------------------

FROM eclipse-temurin:17-jre 

# Add labels for documentation
LABEL maintainer="samanareshreddy"
LABEL version="1.0"
LABEL description="Spring PetClinic Application"

# Create non-root user for security
RUN groupadd spring && useradd -g spring spring
USER spring:spring

WORKDIR /app

# Copy the built JAR file
COPY --from=builder /app/target/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD wget -qO- http://localhost:8080/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

