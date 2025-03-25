Step by step on how to reproduce a Debezium Server bug

## Set up
To execute the steps described below, you need to have Docker installed

## Reproducing the bug

To reproduce the bug, first initiate the database by running:
```shell
docker compose up -d postgres
```

And then, to have more producers created on Debezium Server, create the outbox table and insert some messages with different `aggregatetype`:
```shell
docker exec postgres psql postgresql://postgres:secret@localhost/test_db -f ./create-and-populate-outbox-table.sql
```

Then, initiate the Pulsar:
```shell
docker compose up -d pulsar
```

To be able to simulate a delay on Pulsar side, install the Traffic Control tools on Pulsar's container:
```shell
docker exec pulsar apt-get update
docker exec pulsar apt-get install iproute2 -y
```

Now, start the Debezium Server container, following it logs:
```shell
docker compose up debezium
```

After connecting to database and Pulsar successfully, wait for the logs of successful messages sent to Pulsar, like:
```json

{
  "timestamp": "2025-03-25T12:45:25.727922862Z",
  "sequence": 2521,
  "loggerClassName": "org.slf4j.impl.Slf4jLogger",
  "loggerName": "org.apache.pulsar.client.impl.ProducerStatsRecorderImpl",
  "level": "INFO",
  "message": "[public/default/outbox.event.topic_1] [standalone-0-5] Pending messages: 0 --- Publish throughput: 0.02 msg/s --- 0.00 Mbit/s --- Latency: med: 30.000 ms - 95pct: 30.000 ms - 99pct: 30.000 ms - 99.9pct: 30.000 ms - max: 30.000 ms --- BatchSize: med: 1.000 - 95pct: 1.000 - 99pct: 1.000 - 99.9pct: 1.000 - max: 1.000 --- MsgSize: med: 69.000 bytes - 95pct: 69.000 bytes - 99pct: 69.000 bytes - 99.9pct: 69.000 bytes - max: 69.000 bytes --- Ack received rate: 0.02 ack/s --- Failed messages: 0 --- Pending messages: 0",
  "threadName": "pulsar-timer-5-1",
  "threadId": 45,
  "mdc": {},
  "ndc": "",
  "hostName": "c6a215748d1e",
  "processName": "/usr/lib/jvm/java-21-openjdk-21.0.6.0.7-1.el8.x86_64/bin/java",
  "processId": 1,
}
{
  "timestamp": "2025-03-25T12:45:25.835076624Z",
  "sequence": 2526,
  "loggerClassName": "org.slf4j.impl.Slf4jLogger",
  "loggerName": "org.apache.pulsar.client.impl.ProducerStatsRecorderImpl",
  "level": "INFO",
  "message": "[public/default/outbox.event.topic_2] [standalone-0-6] Pending messages: 0 --- Publish throughput: 0.02 msg/s --- 0.00 Mbit/s --- Latency: med: 9.000 ms - 95pct: 9.000 ms - 99pct: 9.000 ms - 99.9pct: 9.000 ms - max: 9.000 ms --- BatchSize: med: 1.000 - 95pct: 1.000 - 99pct: 1.000 - 99.9pct: 1.000 - max: 1.000 --- MsgSize: med: 69.000 bytes - 95pct: 69.000 bytes - 99pct: 69.000 bytes - 99.9pct: 69.000 bytes - max: 69.000 bytes --- Ack received rate: 0.02 ack/s --- Failed messages: 0 --- Pending messages: 0",
  "threadName": "pulsar-timer-5-1",
  "threadId": 45,
  "mdc": {},
  "ndc": "",
  "hostName": "c6a215748d1e",
  "processName": "/usr/lib/jvm/java-21-openjdk-21.0.6.0.7-1.el8.x86_64/bin/java",
  "processId": 1,
}
{
  "timestamp": "2025-03-25T12:45:25.902575306Z",
  "sequence": 2527,
  "loggerClassName": "org.slf4j.impl.Slf4jLogger",
  "loggerName": "org.apache.pulsar.client.impl.ProducerStatsRecorderImpl",
  "level": "INFO",
  "message": "[public/default/outbox.event.topic_3] [standalone-0-7] Pending messages: 0 --- Publish throughput: 0.02 msg/s --- 0.00 Mbit/s --- Latency: med: 8.000 ms - 95pct: 8.000 ms - 99pct: 8.000 ms - 99.9pct: 8.000 ms - max: 8.000 ms --- BatchSize: med: 1.000 - 95pct: 1.000 - 99pct: 1.000 - 99.9pct: 1.000 - max: 1.000 --- MsgSize: med: 69.000 bytes - 95pct: 69.000 bytes - 99pct: 69.000 bytes - 99.9pct: 69.000 bytes - max: 69.000 bytes --- Ack received rate: 0.02 ack/s --- Failed messages: 0 --- Pending messages: 0",
  "threadName": "pulsar-timer-5-1",
  "threadId": 45,
  "mdc": {},
  "ndc": "",
  "hostName": "c6a215748d1e",
  "processName": "/usr/lib/jvm/java-21-openjdk-21.0.6.0.7-1.el8.x86_64/bin/java",
  "processId": 1,
}
{
  "timestamp": "2025-03-25T12:45:25.965063579Z",
  "sequence": 2528,
  "loggerClassName": "org.slf4j.impl.Slf4jLogger",
  "loggerName": "org.apache.pulsar.client.impl.ProducerStatsRecorderImpl",
  "level": "INFO",
  "message": "[public/default/__debezium-heartbeat.test] [standalone-0-8] Pending messages: 0 --- Publish throughput: 0.10 msg/s --- 0.00 Mbit/s --- Latency: med: 4.000 ms - 95pct: 4.000 ms - 99pct: 4.000 ms - 99.9pct: 4.000 ms - max: 4.000 ms --- BatchSize: med: 1.000 - 95pct: 1.000 - 99pct: 1.000 - 99.9pct: 1.000 - max: 1.000 --- MsgSize: med: 200.000 bytes - 95pct: 200.000 bytes - 99pct: 200.000 bytes - 99.9pct: 200.000 bytes - max: 200.000 bytes --- Ack received rate: 0.10 ack/s --- Failed messages: 0 --- Pending messages: 0",
  "threadName": "pulsar-timer-5-1",
  "threadId": 45,
  "mdc": {},
  "ndc": "",
  "hostName": "c6a215748d1e",
  "processName": "/usr/lib/jvm/java-21-openjdk-21.0.6.0.7-1.el8.x86_64/bin/java",
  "processId": 1,
}
```

On another terminal, insert a delay on Pulsar's container:
```shell
docker exec pulsar tc qdisc add dev eth0 root netem delay 35s
```

Wait for the timeout error on Debezium Server and for the stop engine log:
```json
{
  "timestamp": "2025-03-25T12:46:07.130940373Z",
  "sequence": 2929,
  "loggerClassName": "org.slf4j.impl.Slf4jLogger",
  "loggerName": "io.debezium.server.DebeziumServer",
  "level": "INFO",
  "message": "Received request to stop the engine",
  "threadName": "main",
  "threadId": 1,
  "mdc": {},
  "ndc": "",
  "hostName": "c6a215748d1e",
  "processName": "/usr/lib/jvm/java-21-openjdk-21.0.6.0.7-1.el8.x86_64/bin/java",
  "processId": 1
}
```

Then, remove the delay from the Pulsar container:
```shell
docker exec pulsar tc qdisc del dev eth0 root
```

Usually on the first time will not get the bug, if so, remove the Debezium container:
```shell
docker compose down -v debezium
```
And then try again starting from `docker compose up debezium`

You will see that the Debezium Server creates new producers:
```json
{
  "timestamp": "2025-03-25T12:46:25.838205253Z",
  "sequence": 2946,
  "loggerClassName": "org.slf4j.impl.Slf4jLogger",
  "loggerName": "org.apache.pulsar.client.impl.ConnectionHandler",
  "level": "INFO",
  "message": "[public/default/__debezium-heartbeat.test] [standalone-0-8] Reconnecting after timeout",
  "threadName": "pulsar-timer-5-1",
  "threadId": 45,
  "mdc": {},
  "ndc": "",
  "hostName": "c6a215748d1e",
  "processName": "/usr/lib/jvm/java-21-openjdk-21.0.6.0.7-1.el8.x86_64/bin/java",
  "processId": 1
}
{
  "timestamp": "2025-03-25T12:46:25.842430438Z",
  "sequence": 2947,
  "loggerClassName": "org.slf4j.impl.Slf4jLogger",
  "loggerName": "org.apache.pulsar.client.impl.ConnectionHandler",
  "level": "INFO",
  "message": "[public/default/outbox.event.topic_3] [standalone-0-7] Reconnecting after timeout",
  "threadName": "pulsar-timer-5-1",
  "threadId": 45,
  "mdc": {},
  "ndc": "",
  "hostName": "c6a215748d1e",
  "processName": "/usr/lib/jvm/java-21-openjdk-21.0.6.0.7-1.el8.x86_64/bin/java",
  "processId": 1
}
{
  "timestamp": "2025-03-25T12:46:25.84960404Z",
  "sequence": 2955,
  "loggerClassName": "org.slf4j.impl.Slf4jLogger",
  "loggerName": "org.apache.pulsar.client.impl.ConnectionPool",
  "level": "INFO",
  "message": "[[id: 0x02cf6799, L:/10.219.1.4:42966 - R:pulsar/10.219.1.2:6650]] Connected to server",
  "threadName": "pulsar-client-io-1-1",
  "threadId": 44,
  "mdc": {},
  "ndc": "",
  "hostName": "c6a215748d1e",
  "processName": "/usr/lib/jvm/java-21-openjdk-21.0.6.0.7-1.el8.x86_64/bin/java",
  "processId": 1
}
{
  "timestamp": "2025-03-25T12:46:25.850204884Z",
  "sequence": 2957,
  "loggerClassName": "org.slf4j.impl.Slf4jLogger",
  "loggerName": "org.apache.pulsar.client.impl.ClientCnx",
  "level": "INFO",
  "message": "[id: 0x02cf6799, L:/10.219.1.4:42966 - R:pulsar/10.219.1.2:6650] Connected through proxy to target broker at localhost:6650",
  "threadName": "pulsar-client-io-1-1",
  "threadId": 44,
  "mdc": {},
  "ndc": "",
  "hostName": "c6a215748d1e",
  "processName": "/usr/lib/jvm/java-21-openjdk-21.0.6.0.7-1.el8.x86_64/bin/java",
  "processId": 1
}
{
  "timestamp": "2025-03-25T12:46:25.852611263Z",
  "sequence": 2963,
  "loggerClassName": "org.slf4j.impl.Slf4jLogger",
  "loggerName": "org.apache.pulsar.client.impl.ProducerImpl",
  "level": "INFO",
  "message": "[public/default/outbox.event.topic_3] [standalone-0-7] Creating producer on cnx [id: 0x02cf6799, L:/10.219.1.4:42966 - R:pulsar/10.219.1.2:6650]",
  "threadName": "pulsar-client-io-1-1",
  "threadId": 44,
  "mdc": {},
  "ndc": "",
  "hostName": "c6a215748d1e",
  "processName": "/usr/lib/jvm/java-21-openjdk-21.0.6.0.7-1.el8.x86_64/bin/java",
  "processId": 1
}
{
  "timestamp": "2025-03-25T12:46:25.853346412Z",
  "sequence": 2964,
  "loggerClassName": "org.slf4j.impl.Slf4jLogger",
  "loggerName": "org.apache.pulsar.client.impl.ProducerImpl",
  "level": "INFO",
  "message": "[public/default/__debezium-heartbeat.test] [standalone-0-8] Creating producer on cnx [id: 0x02cf6799, L:/10.219.1.4:42966 - R:pulsar/10.219.1.2:6650]",
  "threadName": "pulsar-client-io-1-1",
  "threadId": 44,
  "mdc": {},
  "ndc": "",
  "hostName": "c6a215748d1e",
  "processName": "/usr/lib/jvm/java-21-openjdk-21.0.6.0.7-1.el8.x86_64/bin/java",
  "processId": 1
}
{
  "timestamp": "2025-03-25T12:46:25.862107086Z",
  "sequence": 2967,
  "loggerClassName": "org.slf4j.impl.Slf4jLogger",
  "loggerName": "org.apache.pulsar.client.impl.ProducerImpl",
  "level": "INFO",
  "message": "[public/default/outbox.event.topic_3] [standalone-0-7] Created producer on cnx [id: 0x02cf6799, L:/10.219.1.4:42966 - R:pulsar/10.219.1.2:6650]",
  "threadName": "pulsar-client-io-1-1",
  "threadId": 44,
  "mdc": {},
  "ndc": "",
  "hostName": "c6a215748d1e",
  "processName": "/usr/lib/jvm/java-21-openjdk-21.0.6.0.7-1.el8.x86_64/bin/java",
  "processId": 1
}
{
  "timestamp": "2025-03-25T12:46:25.862557422Z",
  "sequence": 2970,
  "loggerClassName": "org.slf4j.impl.Slf4jLogger",
  "loggerName": "org.apache.pulsar.client.impl.ProducerImpl",
  "level": "INFO",
  "message": "[public/default/__debezium-heartbeat.test] [standalone-0-8] Created producer on cnx [id: 0x02cf6799, L:/10.219.1.4:42966 - R:pulsar/10.219.1.2:6650]",
  "threadName": "pulsar-client-io-1-1",
  "threadId": 44,
  "mdc": {},
  "ndc": "",
  "hostName": "c6a215748d1e",
  "processName": "/usr/lib/jvm/java-21-openjdk-21.0.6.0.7-1.el8.x86_64/bin/java",
  "processId": 1
}
```

But before that, if you look on the previous logs, the Postgres connector was closed:
```json
{
  "timestamp": "2025-03-25T12:46:07.096650565Z",
  "sequence": 2902,
  "loggerClassName": "org.slf4j.impl.Slf4jLogger",
  "loggerName": "io.debezium.jdbc.JdbcConnection",
  "level": "INFO",
  "message": "Connection gracefully closed",
  "threadName": "pool-14-thread-1",
  "threadId": 73,
  "mdc": {
    "dbz.taskId": "0",
    "dbz.databaseName": "test_db",
    "dbz.connectorName": "test",
    "dbz.connectorType": "Postgres",
    "dbz.connectorContext": "streaming"
  },
  "ndc": "",
  "hostName": "c6a215748d1e",
  "processName": "/usr/lib/jvm/java-21-openjdk-21.0.6.0.7-1.el8.x86_64/bin/java",
  "processId": 1
}
{
  "timestamp": "2025-03-25T12:46:07.097887454Z",
  "sequence": 2904,
  "loggerClassName": "org.slf4j.impl.Slf4jLogger",
  "loggerName": "io.debezium.jdbc.JdbcConnection",
  "level": "INFO",
  "message": "Connection gracefully closed",
  "threadName": "pool-15-thread-1",
  "threadId": 74,
  "mdc": {
    "dbz.taskId": "0",
    "dbz.databaseName": "test_db",
    "dbz.connectorName": "test",
    "dbz.connectorType": "Postgres",
    "dbz.connectorContext": "streaming"
  },
  "ndc": "",
  "hostName": "c6a215748d1e",
  "processName": "/usr/lib/jvm/java-21-openjdk-21.0.6.0.7-1.el8.x86_64/bin/java",
  "processId": 1
}
```
Then, because of new Pulsar producers the container keeps up, but the connection to Postgres was closed, so new events will not be consumed until a restart of the container.