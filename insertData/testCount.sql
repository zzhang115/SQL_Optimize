use insertDataMillion;
DECLARE

  l_sql VARCHAR2(32767);

BEGIN

  l_sql := 'CREATE TABLE t (';

  FOR i IN 1..25 

  LOOP

    l_sql := l_sql || 'n' || i || ' NUMBER,';

  END LOOP;

  l_sql := l_sql || 'pad VARCHAR2(1000)) PCTFREE 10';

  EXECUTE IMMEDIATE l_sql;

END;
/
