# Step 1: Use an official JDK image to build the app (use OpenJDK 17 here)
FROM openjdk:17-jdk-slim AS builder

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy the build.gradle and settings files into the container
COPY build.gradle settings.gradle gradle-wrapper.jar gradle/ /app/

# Step 4: Copy the source code into the container
COPY src /app/src

# Step 5: Run Gradle to build the application (assuming you use Gradle wrapper)
RUN ./gradlew build --no-daemon

# Step 6: Create a new stage for the final Docker image
FROM openjdk:17-jdk-slim

# Step 7: Set the working directory inside the container
WORKDIR /app

# Step 8: Copy the built jar from the builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Step 9: Expose port 8080 for the Spring Boot app
EXPOSE 8080

# Step 10: Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
