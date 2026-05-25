# Kafka Topics Reference

## Topic Naming Convention

```
{domain}.{resource}.{modifier}

Examples:
- drone.telemetry.{drone_id}
- drone.state.changed.{drone_id}
- mission.uploaded.{mission_id}
- cmd.acked.{drone_id}
```

## Topics

### Telemetry & State

#### `drone.telemetry.{id}`
- **Producers**: telemetry-ingest
- **Consumers**: state-manager, analytics-service, alert-service, collision-avoidance
- **Retention**: 7 days
- **Partitions**: 10 per 100 drones
- **Schema**: MAVLink telemetry message
```json
{
  "timestamp": "2026-01-01T12:00:00Z",
  "drone_id": "drone-001",
  "gps": {"lat": 37.7749, "lon": -122.4194, "alt": 100},
  "velocity": {"x": 10.5, "y": 2.3, "z": -0.1},
  "attitude": {"roll": 5.2, "pitch": 3.1, "yaw": 45.6},
  "battery": {"voltage": 11.4, "current": 25.3, "remaining": 65}
}
```

#### `drone.state.changed.{id}`
- **Producers**: state-manager
- **Consumers**: mission-service, collision-avoidance, geofence-service, swarm-intelligence, safety-manager
- **Retention**: 3 days
- **Partitions**: 5 per 100 drones
- **Schema**: Drone state snapshot
```json
{
  "drone_id": "drone-001",
  "timestamp": "2026-01-01T12:00:00Z",
  "state": "flying",
  "position": {"lat": 37.7749, "lon": -122.4194, "alt": 100},
  "velocity_ms": 15.2,
  "battery_percent": 65,
  "link_quality": 95,
  "armed": true
}
```

### Missions

#### `mission.uploaded.{id}`
- **Producers**: mission-service
- **Consumers**: command-dispatch, analytics-service
- **Retention**: 30 days
- **Partitions**: 1 (low volume)
- **Schema**: Complete mission definition
```json
{
  "mission_id": "mission-12345",
  "uploaded_at": "2026-01-01T12:00:00Z",
  "operator_id": "user-789",
  "drone_ids": ["drone-001", "drone-002"],
  "segments": [
    {
      "segment_id": "seg-1",
      "waypoints": [
        {"lat": 37.7749, "lon": -122.4194, "alt": 100, "delay_s": 0}
      ]
    }
  ],
  "formation": "line",
  "speed_ms": 10
}
```

#### `mission.event.{id}`
- **Producers**: mission-service
- **Consumers**: analytics-service, frontend
- **Retention**: 30 days
- **Partitions**: 1

### Commands

#### `cmd.outbound.{id}`
- **Producers**: command-dispatch
- **Consumers**: Drone firmware (via mesh)
- **Retention**: 7 days
- **Partitions**: 10 per 100 drones (high throughput)
- **Schema**: MAVLink command
```json
{
  "command_id": "cmd-uuid-001",
  "drone_id": "drone-001",
  "timestamp": "2026-01-01T12:00:01Z",
  "sequence": 1,
  "command": "SET_POSITION_TARGET_GLOBAL_INT",
  "params": {
    "lat": 377749000,
    "lon": -1224194000,
    "alt": 100
  }
}
```

#### `cmd.acked.{id}`
- **Producers**: command-dispatch (on ACK from drone)
- **Consumers**: mission-service, safety-manager, frontend
- **Retention**: 3 days
- **Partitions**: 5 per 100 drones

#### `cmd.failed.{id}`
- **Producers**: command-dispatch
- **Consumers**: alert-service, safety-manager, frontend
- **Retention**: 7 days
- **Partitions**: 5 per 100 drones

### Swarm & Formation

#### `swarm.formation.update`
- **Producers**: swarm-intelligence
- **Consumers**: mission-service, drones, frontend
- **Retention**: 1 day
- **Partitions**: 3
- **Schema**: Formation state
```json
{
  "timestamp": "2026-01-01T12:00:00Z",
  "swarm_id": "swarm-001",
  "formation_type": "line|V|triangle|grid",
  "slots": [
    {
      "slot_id": "slot-1",
      "drone_id": "drone-001",
      "relative_position": {"x": 0, "y": 0, "z": 0},
      "target_position": {"lat": 37.7749, "lon": -122.4194, "alt": 100}
    }
  ]
}
```

#### `swarm.task.alloc`
- **Producers**: swarm-intelligence
- **Consumers**: mission-service, frontend
- **Retention**: 30 days
- **Partitions**: 1

### Safety & Alerts

#### `collision.alert.{id}`
- **Producers**: collision-avoidance
- **Consumers**: safety-manager, alert-service, frontend
- **Retention**: 7 days
- **Partitions**: 10 per 100 drones
- **Schema**: Collision prediction
```json
{
  "alert_id": "alert-uuid-001",
  "drone_id": "drone-001",
  "timestamp": "2026-01-01T12:00:00Z",
  "threat_drone_id": "drone-002",
  "time_to_collision_s": 15,
  "severity": "warning|critical"
}
```

#### `geofence.violation.{id}`
- **Producers**: geofence-service
- **Consumers**: alert-service, safety-manager, frontend
- **Retention**: 30 days
- **Partitions**: 3

#### `alert.created.{id}`
- **Producers**: alert-service
- **Consumers**: notification-service, safety-manager, analytics-service, frontend
- **Retention**: 90 days
- **Partitions**: 3
- **Schema**: General alert
```json
{
  "alert_id": "alert-uuid-001",
  "timestamp": "2026-01-01T12:00:00Z",
  "drone_id": "drone-001",
  "severity": "info|warning|critical",
  "alert_type": "battery_low|gps_lost|link_quality",
  "message": "Battery level critically low (15%)"
}
```

#### `safety.event.{id}`
- **Producers**: safety-manager
- **Consumers**: analytics-service, frontend
- **Retention**: 90 days
- **Partitions**: 1

### Integrations

#### `notam.update`
- **Producers**: integration-service
- **Consumers**: mission-service, geofence-service, frontend
- **Retention**: 30 days
- **Partitions**: 1

#### `mission.trigger.{id}`
- **Producers**: integration-service
- **Consumers**: mission-service
- **Retention**: 30 days
- **Partitions**: 1

## Consumer Groups

```
adsms.telemetry-ingest
adsms.state-manager
adsms.mission-service
adsms.command-dispatch
adsms.swarm-intelligence
adsms.collision-avoidance
adsms.geofence-service
adsms.alert-service
adsms.safety-manager
adsms.analytics-service
adsms.notification-service
adsms.integration-service
```

---

For deployment details, see the main [Architecture documentation](ARCHITECTURE.md)
