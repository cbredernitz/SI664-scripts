-- Combine UN Statistics Division (UNSD) standard region, sub-regions, intermediate
-- regions and countries or areas codes (M49) with UNESCO World Heritage List.
-- Source: https://unstats.un.org/unsd/methodology/m49/overview/
-- Source: https://whc.unesco.org/en/list/

--
-- Create database
--

-- CREATE DATABASE IF NOT EXISTS unesco_heritage_sites;
-- USE unesco_heritage_sites;

--
-- Drop tables
-- turn off FK checks temporarily to eliminate drop order issues
--

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS noise_level, category, attire, business_category, city, state, user, review, business, tmp_business, tmp_review;
SET FOREIGN_KEY_CHECKS=1;

-- SET FOREIGN_KEY_CHECKS=0;
-- DROP TABLE IF EXISTS review;
-- SET FOREIGN_KEY_CHECKS=1;

--
-- Noise Level
--

CREATE TABLE IF NOT EXISTS noise_level
  (
    noise_level_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    noise VARCHAR(45) NOT NULL UNIQUE,
    PRIMARY KEY (noise_level_id)
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

INSERT IGNORE INTO noise_level (noise) VALUES
  ('Average'), ('Loud'), ('Quiet'), ('Very Loud');

-- --
-- -- Attire
-- --

CREATE TABLE IF NOT EXISTS attire
  (
    attire_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    attire VARCHAR(45) NOT NULL UNIQUE,
    PRIMARY KEY (attire_id)
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

INSERT IGNORE INTO attire (attire) VALUES
  ('Casual'),
  ('Dressy'),
  ('Formal');


-- --
-- -- Category
-- --

CREATE TABLE IF NOT EXISTS category
  (
    category_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    category VARCHAR(45) NOT NULL UNIQUE,
    PRIMARY KEY (category_id)
   )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

-- Insert dev_status options
LOAD DATA LOCAL INFILE './output/business_categories.csv'
INTO TABLE category
  CHARACTER SET utf8mb4
  FIELDS TERMINATED BY '\t'
  -- FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  -- LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (category);

-- --
-- -- State
-- --

CREATE TABLE IF NOT EXISTS state
  (
    state_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    state_abbrev VARCHAR(45) NOT NULL UNIQUE,
    PRIMARY KEY (state_id)
   )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

-- Insert dev_status options
LOAD DATA LOCAL INFILE './output/states.csv'
INTO TABLE state
  CHARACTER SET utf8mb4
  FIELDS TERMINATED BY '\t'
  -- FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  -- LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (state_abbrev);

--
-- City
--
 
CREATE TABLE IF NOT EXISTS city
  (
    city_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    city_name VARCHAR(45) NOT NULL UNIQUE,
    PRIMARY KEY (city_id)
   )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

-- Insert dev_status options
LOAD DATA LOCAL INFILE './output/cities.csv'
INTO TABLE city
  CHARACTER SET utf8mb4
  FIELDS TERMINATED BY '\t'
  -- FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  -- LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (city_name);


--
-- Business Temporary
--

CREATE TABLE IF NOT EXISTS tmp_business
  (
    business_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    business_name VARCHAR(100) NOT NULL,
    yelp_business_id VARCHAR(45),
    address VARCHAR(100),
    city_name VARCHAR(45),
    state_name VARCHAR(45),
    neighborhood VARCHAR(100),
    postal_code VARCHAR(15),
    latitude DECIMAL,
    longitude DECIMAL,
    business_stars DECIMAL,
    business_review_count INTEGER,
    is_open TINYINT,
    attire_name VARCHAR(45),
    noise_name VARCHAR(45),
    categories VARCHAR(45),
    PRIMARY KEY (business_id)
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

-- LOAD DATA LOCAL INFILE '/Users/Chris/Documents/SI_664/week4/SI664-scripts/scripts/input/csv/yelp_full_businesses.csv'
LOAD DATA LOCAL INFILE '/Users/Chris/Documents/SI_664/week4/SI664-scripts/scripts/input/csv/SMALL_yelp_full_businesses.csv'
INTO TABLE tmp_business
  CHARACTER SET utf8mb4
  FIELDS TERMINATED BY ','
  -- FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  -- LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (yelp_business_id, business_name, neighborhood, address, city_name, state_name, postal_code, latitude, longitude, business_stars, business_review_count, is_open, categories, attire_name, noise_name);


--
-- Businesses
--

CREATE TABLE IF NOT EXISTS business
  (
    business_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    business_name VARCHAR(100) NOT NULL,
    yelp_business_id VARCHAR(45),
    noise_level_id INTEGER,
    attire_id INTEGER,
    city_id INTEGER,
    state_id INTEGER,
    address VARCHAR(100),
    neighborhood VARCHAR(100),
    postal_code VARCHAR(15),
    latitude DECIMAL,
    longitude DECIMAL,
    business_stars DECIMAL,
    business_review_count INTEGER,
    is_open TINYINT,
    PRIMARY KEY (business_id),
    FOREIGN KEY (city_id) REFERENCES city(city_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (state_id) REFERENCES state(state_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (noise_level_id) REFERENCES noise_level(noise_level_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (attire_id) REFERENCES attire(attire_id)
    ON DELETE CASCADE ON UPDATE CASCADE
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

INSERT IGNORE INTO business (
    business_name,
    yelp_business_id,
    address,
    neighborhood,
    city_id,
    state_id,
    attire_id,
    noise_level_id,
    postal_code,
    latitude,
    longitude,
    business_stars,
    business_review_count,
    is_open
)
SELECT bs.business_name, bs.yelp_business_id, bs.address, bs.neighborhood, cit.city_id, st.state_id, noi.noise_level_id,
       atr.attire_id, bs.postal_code, bs.latitude, bs.longitude, bs.business_stars, bs.business_review_count, bs.is_open
  FROM tmp_business bs
       LEFT JOIN city cit
              ON TRIM(bs.city_name) = TRIM(cit.city_name)
       LEFT JOIN state st
              ON TRIM(bs.state_name) = TRIM(st.state_abbrev)
       LEFT JOIN attire atr
              ON TRIM(bs.attire_name) = TRIM(atr.attire)
       LEFT JOIN noise_level noi
              ON TRIM(bs.noise_name) = TRIM(noi.noise)
ORDER BY bs.business_name;


--
-- business_category                                            (NEEDS FOREIGN KEY MAPPING) M2M
--


-- CREATE TABLE IF NOT EXISTS business_category
--   (
--     category_id INTEGER,
--     business_id INTEGER,
--     FOREIGN KEY (category_id) REFERENCES category(category_id)
--     ON DELETE CASCADE ON UPDATE CASCADE,
--     FOREIGN KEY (business_id) REFERENCES business(business_id)
--     ON DELETE CASCADE ON UPDATE CASCADE
--    )
-- ENGINE=InnoDB
-- CHARACTER SET utf8mb4
-- COLLATE utf8mb4_0900_ai_ci;


--
-- Users
--

CREATE TABLE IF NOT EXISTS user
  (
    user_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    user_name VARCHAR(45) NOT NULL,
    review_count INT NOT NULL,
    yelper_since DATE,
    elite VARCHAR(10),
    average_stars DECIMAL,
    yelp_user_id VARCHAR(45),
    PRIMARY KEY (user_id)
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

-- LOAD DATA LOCAL INFILE '/Users/Chris/Documents/SI_664/week4/SI664-scripts/scripts/input/csv/yelp_user.csv'
LOAD DATA LOCAL INFILE '/Users/Chris/Documents/SI_664/week4/SI664-scripts/scripts/input/csv/SMALL_yelp_user.csv'
INTO TABLE user
  CHARACTER SET utf8mb4
  FIELDS TERMINATED BY ','
  -- FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
--   LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (yelp_user_id, user_name, review_count, yelper_since, @dummy, @dummy, @dummy, @dummy, @dummy, elite, average_stars, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy);


-- --
-- -- Temporary Review
-- --

CREATE TABLE IF NOT EXISTS tmp_review
  (
    review_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    yelp_review_id VARCHAR(45),
    yelp_user_id VARCHAR(45),
    yelp_business_id VARCHAR(45),
    stars DECIMAL,
    date_created DATE,
    review_text TEXT,
    PRIMARY KEY (review_id)
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

-- LOAD DATA LOCAL INFILE '/Users/Chris/Documents/SI_664/week4/SI664-scripts/scripts/input/csv/yelp_review.csv'
LOAD DATA LOCAL INFILE '/Users/Chris/Documents/SI_664/week4/SI664-scripts/scripts/input/csv/SMALL_yelp_review.csv'
INTO TABLE tmp_review
  CHARACTER SET utf8mb4
  FIELDS TERMINATED BY ','
  -- FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
--   LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (yelp_review_id, yelp_user_id, yelp_business_id, stars, date_created, review_text, @dummy, @dummy, @dummy);

--
-- Review                                               NEEDS TO BE CHANGED - M2M
--

CREATE TABLE IF NOT EXISTS review
  (
    review_id INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    user_id INTEGER,
    business_id INTEGER,
    yelp_review_id VARCHAR(45),
    stars DECIMAL,
    date_created DATE,
    review_text TEXT,
    PRIMARY KEY (review_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (business_id) REFERENCES business(business_id)
    ON DELETE CASCADE ON UPDATE CASCADE
  )
ENGINE=InnoDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

INSERT IGNORE INTO review (
    user_id,
    business_id,
    yelp_review_id,
    stars,
    date_created,
    review_text
)
SELECT trv.yelp_review_id, trv.stars, trv.date_created, trv.review_text, bs.business_id, usr.user_id
  FROM tmp_review trv
       INNER JOIN business bs
              ON TRIM(trv.yelp_business_id) = TRIM(bs.yelp_business_id)
       INNER JOIN user usr
              ON TRIM(trv.yelp_user_id) = TRIM(usr.yelp_user_id);






















