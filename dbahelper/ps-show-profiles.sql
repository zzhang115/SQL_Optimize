use sys;

/* 
 * Procedure: enable_profiling()
 *
 * Versions: 5.6.x
 *
 * Emulates previous behaviour of SHOW PROFILES feature which has been
 * officially deprecated from MySQL 5.7 onwards.
*/

DROP PROCEDURE IF EXISTS enable_profiling;
DELIMITER $$
 
CREATE PROCEDURE enable_profiling()
BEGIN
 UPDATE performance_schema.setup_instruments SET enabled='YES', timed='YES'
  WHERE name LIKE 'stage/sql/%';
 UPDATE performance_schema.setup_consumers SET enabled = 'YES' WHERE name IN (
  'events_stages_history_long',
  'events_statements_history_long',
  'events_stages_current'
 );
END$$
 
DELIMITER ;

/* 
 * Procedure: disable_profiling()
 *
 * Versions: 5.6.x
 *
 * Turn off performance_schema switches that were required for this feature
 * to be able to work.
*/

DROP PROCEDURE IF EXISTS disable_profiling;
DELIMITER $$
 
CREATE PROCEDURE disable_profiling()
BEGIN
 UPDATE performance_schema.setup_instruments SET enabled='NO', timed='NO'
  WHERE name LIKE 'stage/sql/%';
 UPDATE performance_schema.setup_consumers SET enabled = 'NO' WHERE name IN (
  'events_stages_history_long',
  'events_statements_history_long',
  'events_stages_current'
 );
END$$
 
DELIMITER ;


/* 
 * Procedure: show_profiles()
 *
 * Versions: 5.6.x
 *
 * Emulates previous behaviour of SHOW PROFILES feature which has been
 * officially deprecated from MySQL 5.7 onwards.
*/

DROP PROCEDURE IF EXISTS show_profiles;
DELIMITER $$
 
CREATE PROCEDURE show_profiles()
BEGIN
# @TODO: Test instruments are setup correctly.
SELECT
  event_id as Event_ID,
  sys.format_time(timer_wait) as Duration,
  sys.format_statement(sql_text) as Query
 FROM performance_schema.events_statements_history_long
 INNER JOIN performance_schema.threads ON threads.THREAD_ID=events_statements_history_long.THREAD_ID
 WHERE
  threads.PROCESSLIST_ID = connection_id()
  AND event_name='statement/sql/select'
 ORDER BY event_id;
END$$
 
DELIMITER ;

/* 
 * Procedure: show_profile_for_event_id()
 *
 * Versions: 5.6.x
 *
 * Emulates previous behaviour of SHOW PROFILES feature which has been
 * officially deprecated from MySQL 5.7 onwards.
 *
 * Parameters
 *   in_event_id:   The event_id as returned by CALL show_profiles() that you would like to inspect.
 *
 * Obvious differences:
 * - It accepts an event_id instead of a Query ID.
 * - Time is formatted using sys.
*/

DROP PROCEDURE IF EXISTS show_profile_for_event_id;
DELIMITER $$
 
CREATE PROCEDURE show_profile_for_event_id(IN in_event_id INT)
BEGIN
SELECT 
 REPLACE(event_name, 'stage/sql/', '') AS Status,
 sys.format_time(timer_wait) as Duration
 FROM 
  performance_schema.events_stages_history_long
 INNER JOIN performance_schema.threads ON threads.THREAD_ID=events_stages_history_long.THREAD_ID
 WHERE
   NESTING_EVENT_ID=in_event_id
  AND threads.PROCESSLIST_ID = connection_id()
  ORDER BY event_id;
END$$
DELIMITER ;
