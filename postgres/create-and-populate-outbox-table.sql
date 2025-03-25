CREATE TABLE IF NOT EXISTS outbox (
  id UUID PRIMARY KEY,
  aggregatetype VARCHAR(255) NOT null,
  aggregateid VARCHAR(255) NOT NULL,
  payload BYTEA NOT NULL,
  created_at timestamptz NOT NULL DEFAULT NOW()  
);

INSERT INTO outbox (id,aggregatetype,aggregateid,payload,created_at) VALUES
  ('6bdeb220-9162-4b19-9bad-d6e399224c53'::uuid,'topic_1','aggid',decode('54657374652031', 'hex'),now()),
  ('fc684c0d-ea9e-4b0a-b1b9-78cdba29ac65'::uuid,'topic_2','aggid',decode('54657374652032', 'hex'),now()),
  ('21b13cb2-48ab-4503-a88c-a6f5bc33ffca'::uuid,'topic_3','aggid',decode('54657374652033', 'hex'),now());