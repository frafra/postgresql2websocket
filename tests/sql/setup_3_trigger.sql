BEGIN;

DROP TRIGGER IF EXISTS mytable_notify_update ON mytable;
DROP TRIGGER IF EXISTS mytable_notify_insert ON mytable;
DROP TRIGGER IF EXISTS mytable_notify_delete ON mytable;

CREATE TRIGGER mytable_notify_update AFTER UPDATE ON mytable FOR EACH ROW EXECUTE PROCEDURE table_update_notify();
CREATE TRIGGER mytable_notify_insert AFTER INSERT ON mytable FOR EACH ROW EXECUTE PROCEDURE table_update_notify();
CREATE TRIGGER mytable_notify_delete AFTER DELETE ON mytable FOR EACH ROW EXECUTE PROCEDURE table_update_notify();

END;
