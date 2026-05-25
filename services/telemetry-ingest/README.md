# Service: telemetry-ingest

## Overview
High-performance telemetry ingestion service. Receives MAVLink data from drones, parses, validates, and publishes to Kafka.

### Technology Stack
- **Language**: Go
- **Database**: TimescaleDB (time-series telemetry hypertable)
- **Message Queue**: Kafka producer

### Key Features
- Concurrent UDP socket listeners (one per drone channel)
- MAVLink protocol parser
- Real-time Kafka publishing
- Channel heartbeat monitoring
- Link quality assessment

### API Endpoints
- `POST /api/v1/telemetry/register` - Register drone channel
- `GET /api/v1/telemetry/channels` - List active channels

### Kafka Topics (Producer)
- `drone.telemetry.{drone_id}` - Raw telemetry messages
- `drone.raw.{drone_id}` - Unprocessed MAVLink frames

### Environment Variables
- `TELEMETRY_PORT=3001`
- `TIMESCALEDB_HOST=timescaledb`
- `KAFKA_BROKERS=kafka:9092`

### Local Development
```bash
cd services/telemetry-ingest
docker-compose up -d
```

### Testing
```bash
bash scripts/run.sh              # Run service
go test ./...                    # Unit tests
bash tests/integration/test.sh   # Integration tests
```

### Deployment
```bash
kubectl apply -f infra/k8s/
```

### Performance Targets
- **Throughput**: 100k messages/sec (100 drones × 10 Hz)
- **Latency**: <5ms ingestion to Kafka
- **Availability**: 99.9%
