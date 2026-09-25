# =============================================================================
# TapFood - container image
#
# Two stages: build the WAR with Maven, then run it on Tomcat. The build tools
# stay in the first stage, so the published image contains only Tomcat, a JDK
# and the application.
# =============================================================================

# -----------------------------------------------------------------------------
# Stage 1: build
# -----------------------------------------------------------------------------
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /build

# Copy the POM on its own first and pre-fetch dependencies. Docker caches this
# layer, so editing Java or JSP files does not re-download Maven Central.
COPY pom.xml ./
RUN mvn -B -q dependency:go-offline

# Then the sources, which change on nearly every commit.
COPY src ./src
RUN mvn -B clean package

# -----------------------------------------------------------------------------
# Stage 2: runtime
#
# Tomcat 10.1 implements Jakarta Servlet 6.0, which is what this application
# targets. Tomcat 9 would fail because it still uses the javax.* namespace, and
# Tomcat 11 moves to Servlet 6.1, so the major version is pinned deliberately.
# -----------------------------------------------------------------------------
FROM tomcat:10.1-jdk21-temurin

# Drop Tomcat's bundled webapps: the default landing page, docs, examples and
# the manager applications. None are used, and the manager apps are needless
# attack surface on a public host.
RUN rm -rf /usr/local/tomcat/webapps/*

# Deploying as ROOT.war serves the application at / instead of /tapfood.
COPY --from=build /build/target/tapfood.war /usr/local/tomcat/webapps/ROOT.war

# Render assigns a port through the PORT variable, but server.xml hardcodes
# 8080. Make the HTTP connector read a system property so the port can be set
# at startup; the default below keeps local `docker run` working unchanged.
RUN sed -i 's/port="8080"/port="${port.http}"/' /usr/local/tomcat/conf/server.xml

# Default for local runs. Render overrides PORT at deploy time.
ENV PORT=8080

# Container clock in IST, matching connectionTimeZone in DB_URL, so timestamps
# rendered by the JVM agree with the ones stored by the database.
ENV TZ=Asia/Kolkata

EXPOSE 8080

# MaxRAMPercentage is set for the 512 MB free instance: 50% leaves roughly
# 256 MB of heap and keeps enough headroom for metaspace, code cache and
# thread stacks. Without it the JVM would default to 25% (about 128 MB).
CMD ["sh", "-c", "export CATALINA_OPTS=\"-Dport.http=${PORT} -XX:MaxRAMPercentage=50.0 -Duser.timezone=Asia/Kolkata ${CATALINA_OPTS}\"; exec catalina.sh run"]
