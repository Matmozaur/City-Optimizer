CREATE TABLE IF NOT EXISTS "language" (
  language_id SERIAL PRIMARY KEY,
  language_name VARCHAR(100) NOT NULL,
  CONSTRAINT un_language_name UNIQUE(language_name)
);

CREATE TABLE IF NOT EXISTS organization (
  organization_id SERIAL PRIMARY KEY,
  organization_name VARCHAR(100) NOT NULL,
  CONSTRAINT un_organization_name UNIQUE(organization_name)
);

CREATE TABLE IF NOT EXISTS country (
  country_id SERIAL PRIMARY KEY,
  country_name VARCHAR(100) NOT NULL,
  country_code VARCHAR(10) NOT NULL,
  population INT,
  language_id INT,
  crime_rate DECIMAL(8,2),
  CONSTRAINT un_country_name UNIQUE(country_name),
  CONSTRAINT un_country_code UNIQUE(country_code),
  CONSTRAINT fk_language FOREIGN KEY(language_id) REFERENCES "language"(language_id)
);

CREATE TABLE IF NOT EXISTS province (
  province_id SERIAL PRIMARY KEY,
  province_name VARCHAR(100) NOT NULL,  
  country_id INT NOT NULL,
  CONSTRAINT un_province_name_country_id UNIQUE(province_name, country_id),
  CONSTRAINT fk_country FOREIGN KEY(country_id) REFERENCES country(country_id)
);

CREATE TABLE IF NOT EXISTS country_organization (
  country_organization_id SERIAL PRIMARY KEY,
  country_id INT NOT NULL,
  organization_id INT NOT NULL,
  CONSTRAINT un_country_organization UNIQUE (country_id, organization_id),
  CONSTRAINT fk_country FOREIGN KEY(country_id) REFERENCES country(country_id),
  CONSTRAINT fk_organization FOREIGN KEY(organization_id) REFERENCES organization(organization_id)
);

CREATE TABLE IF NOT EXISTS city (
  city_id SERIAL PRIMARY KEY,
  city_name VARCHAR(100) NOT NULL,
  country_id INT NOT NULL,
  province_id INT,
  population INT,
  "area" DECIMAL (10,2),
  crime_rate DECIMAL(8,2),
  CONSTRAINT fk_city FOREIGN KEY(city_id) REFERENCES city(city_id),
  CONSTRAINT fk_province FOREIGN KEY(province_id) REFERENCES province(province_id)
);
