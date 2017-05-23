DECLARE

  l_sql VARCHAR2(32767);

BEGIN

  l_sql := 'INSERT INTO t SELECT ';

  FOR i IN 1..25

  LOOP

    l_sql := l_sql || '0,';

  END LOOP;

  l_sql := l_sql || 'NULL FROM dual CONNECT BY level <= 10000';

  EXECUTE IMMEDIATE l_sql;

  COMMIT;

END;

/
