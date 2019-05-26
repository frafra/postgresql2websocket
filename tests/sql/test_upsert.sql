INSERT INTO mytable VALUES (1, 'Hello world')
ON CONFLICT (uid) DO UPDATE SET uid = mytable.uid + 1;
