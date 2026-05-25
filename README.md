# ADSMS — Autonomous Drone Swarm Management System

A **TRUE MICROSERVICE ARCHITECTURE** platform for managing autonomous drone swarms at scale.

## Architecture Overview

- **15 Backend Services** — each with own database, Docker, infrastructure
- **Drone Embedded Layer** — Python + ROS2 on Jetson Orin companion computers
- **GCS Frontend** — React + TypeScript ground control station
- **Domain Modules** — Agriculture, Logistics, Military, Inspection
- **Event-Driven** — Kafka-based async communication
- **Fully Observable** — Prometheus, Grafana, Loki, Tempo

## Services

### Core Backend (15 Services)

| # | Service | Language | Database | Purpose |
|---|---------|----------|----------|---------|
| 01 | telemetry-ingest | Go | TimescaleDB | Raw drone telemetry ingestion |
| 02 | state-manager | Go | Redis | Live drone state cache |
| 03 | mission-service | Go | PostgreSQL | Mission planning & assignment |
| 04 | command-dispatch | Go | Redis | Command routing & ACK tracking |
| 05 | swarm-intelligence | Python | Redis + PostgreSQL | Formation control & task allocation |
| 06 | collision-avoidance | Go | Redis | Trajectory prediction & safety |
| 07 | video-service | Go | Redis + MinIO | Stream ingestion & transcoding |
| 08 | geofence-service | Go | PostGIS | Airspace boundary enforcement |
| 09 | alert-service | Go | PostgreSQL | Threshold monitoring & dispatch |
| 10 | safety-manager | Go | PostgreSQL | Emergency response & state machine |
| 11 | analytics-service | Python | TimescaleDB | Flight metrics & reporting |
| 12 | drone-registry | Go | PostgreSQL | Drone inventory & capabilities |
| 13 | auth-service | Go | PostgreSQL | JWT, RBAC, API keys, PKI |
| 14 | integration-service | Go | PostgreSQL | NOTAM sync, ERP, webhooks |
| 15 | notification-service | Go | PostgreSQL | Email, SMS, push alerts |

## Quick Start

### Local Development (All Services)

```bash
docker-compose up -d
docker-compose logs -f
```

### Individual Service

```bash
cd services/mission-service
docker-compose up -d
```

## Documentation

- [System Requirements Specification](docs/SRS.md)
- [Architecture Deep Dive](docs/ARCHITECTURE.md)
- [Kafka Topics Map](docs/KAFKA_TOPICS.md)

## Microservice Principles

✅ **Each service has:**
- Own source code (`src/`)
- Own database
- Own Dockerfile
- Own docker-compose.yml
- Own tests
- Own infra config

✅ **Communication:**
- Async via Kafka for events
- Sync REST for operations
- gRPC for high-throughput

## Technology Stack

- **Go, Python, Node.js** — Backend
- **PostgreSQL, TimescaleDB, Redis** — Data
- **Kafka** — Event streaming
- **Kubernetes, Istio** — Orchestration
- **React + TypeScript** — GCS Frontend
