# Binh Duong Bus - Backend

---

## 🚀 How to Run This Application?

You can either run the entire application using **Docker Containers** or start the backend separately 
while managing other services (Database, Redis) on Docker Containers.

### 🐳 1. Running with Docker

To start the application using Docker, run:

```shell
docker compose up --watch
```

### 🔍 2. Health Check

Once the containers are running successfully, you should see output similar to this:

```plaintext
CONTAINER ID   IMAGE                    COMMAND                  CREATED          STATUS          PORTS                    NAMES
a4cfb875586c   backend-backend          "java -jar /app.jar"     16 minutes ago   Up 16 minutes   0.0.0.0:8080->8080/tcp   binh-duong-bus-backend
a843950a1833   postgres:17-alpine3.20   "docker-entrypoint.s…"   16 minutes ago   Up 16 minutes   0.0.0.0:5432->5432/tcp   binh-duong-bus-db
2b1e43d97f1b   redis:7-alpine3.20       "docker-entrypoint.s…"   16 minutes ago   Up 16 minutes   0.0.0.0:6379->6379/tcp   binh-duong-bus-redis
```

To verify that the backend is running, visit:

➡️ **[http://localhost:8080/healthcheck](http://localhost:8080/healthcheck)**

### 📌 3. Shutting Down Containers

To shut down and clean resources:

```shell
docker compose down
```

or clean all the resources volumes:

```shell
docker compose down -v
```