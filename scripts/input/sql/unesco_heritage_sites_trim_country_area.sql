-- WARNING: before running this script confirm that the foreign key names in the ALTER TABLE
-- statement are correct before executing this script.
--
-- Run the following SQL SELECT statement against the information_schema database to ascertain the
-- foreign key constraint names for country_area.region_id, country_area.sub_region_id, and
-- country_area.intermediate_region_id. Then adjust the names accordingly in the DROP FOREIGN KEY
-- statements below. Foreign key constraints MUST be dropped before the associated column is
-- dropped.

-- /*
-- mysql> SELECT table_name, column_name, constraint_name,
--     ->        referenced_table_name, referenced_column_name
--     ->  FROM information_schema.key_column_usage
--     -> WHERE table_name = 'country_area';
-- +--------------+------------------------+-----------------------------+-----------------------+------------------------+
-- | table_name   | column_name            | constraint_name             | referenced_table_name | referenced_column_name |
-- +--------------+------------------------+-----------------------------+-----------------------+------------------------+
-- | country_area | country_area_id        | PRIMARY                     | NULL                  | NULL                   |
-- | country_area | country_area_id        | country_area_id             | NULL                  | NULL                   |
-- | country_area | country_area_name      | country_area_name           | NULL                  | NULL                   |
-- | country_area | region_id              | country_area_ibfk_1         | region                | region_id              |
-- | country_area | sub_region_id          | country_area_ibfk_2         | sub_region            | sub_region_id          |
-- | country_area | intermediate_region_id | country_area_ibfk_3         | intermediate_region   | intermediate_region_id |
-- | country_area | dev_status_id          | country_area_ibfk_4         | dev_status            | dev_status_id          |
-- | country_area | location_id            | country_area_fk_location_id | location              | location_id            |
-- +--------------+------------------------+-----------------------------+-----------------------+------------------------+
-- 8 rows in set, 2 warnings (0.00 sec)
-- */

-- Drop country_area region-related foreign keys and columns
ALTER TABLE country_area
       DROP FOREIGN KEY country_area_ibfk_1,
       DROP COLUMN region_id;
ALTER TABLE country_area
       DROP FOREIGN KEY country_area_ibfk_2,
       DROP COLUMN sub_region_id;
ALTER TABLE country_area
       DROP FOREIGN KEY country_area_ibfk_3,
       DROP COLUMN intermediate_region_id;
