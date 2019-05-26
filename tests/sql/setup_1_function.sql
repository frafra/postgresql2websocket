CREATE OR REPLACE FUNCTION table_update_notify() RETURNS trigger AS $$
DECLARE
  rec RECORD;
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    rec = NEW;
  ELSE
    rec = OLD;
  END IF;
  -- postgresql2websocket is the default channel name
  PERFORM pg_notify('postgresql2websocket', json_build_object('table', TG_TABLE_NAME, 'type', TG_OP, 'row', row_to_json(rec))::text);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
