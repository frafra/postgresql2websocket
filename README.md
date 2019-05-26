# postgresql2websocket

[![CircleCI](https://img.shields.io/circleci/build/github/frafra/postgres2websocket.svg)](https://circleci.com/gh/frafra/postgres2websocket)

## How does it work?

Execute `postgresql2websocket.py` and connect to `ws://localhost:8080/channel` where `channel` is the channel name of the selected database (see [PostgreSQL documentation - NOTIFY](https://www.postgresql.org/docs/current/static/sql-notify.html)).

## How to configure it?

Copy `postgresql2websocket.conf.example` as `postgresql2websocket.conf` and change the values according to your needs.

## What technologies are you using?

* [PostgreSQL](https://www.postgresql.org/)
* [Python](https://www.python.org/) (3.5 or greater)
* [aiohttp](http://aiohttp.readthedocs.io/) + [asyncpg](https://github.com/MagicStack/asyncpg)

## What can I do with it?

You can create a trigger on a table in order to get notifications over a websocket in real time. For example, this function send a notification using the `postgresql2websocket` channel containing the action that has been performed and a JSON representation of the row.
```
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
```

Then you can trigger this function when something happens on `mytable`:
```
CREATE TRIGGER mytable_notify_update AFTER UPDATE ON mytable FOR EACH ROW EXECUTE PROCEDURE table_update_notify();
CREATE TRIGGER mytable_notify_insert AFTER INSERT ON mytable FOR EACH ROW EXECUTE PROCEDURE table_update_notify();
CREATE TRIGGER mytable_notify_delete AFTER DELETE ON mytable FOR EACH ROW EXECUTE PROCEDURE table_update_notify();
```

## How to use it?

Execute `postgresql2websocket.py` and open `console.html`.

## Limitations

> The "payload" string to be communicated along with the notification. This must be specified as a simple string literal. In the default configuration it must be shorter than 8000 bytes. (If binary data or large amounts of information need to be communicated, it's best to put it in a database table and send the key of the record.)

Source: https://www.postgresql.org/docs/current/static/sql-notify.html
