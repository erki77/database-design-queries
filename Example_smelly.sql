CREATE TABLE Person_state_type (
person_state_type_code INTEGER PRIMARY KEY, 
name VARCHAR(50),
CONSTRAINT chk_person_state_type_name CHECK(trim(name)<>''),
CONSTRAINT chk_code CHECK(person_state_type_code>0));

CREATE TABLE Public_person_data (id INTEGER GENERATED ALWAYS AS IDENTITY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
persons_state_type_code SMALLINT NOT NULL,
registration_time TIMESTAMP WITH TIME ZONE NOT NULL,
CONSTRAINT pk_person PRIMARY KEY (id),
CONSTRAINT "FK_person person_state_type" FOREIGN KEY (persons_state_type_code)
REFERENCES Person_state_type (person_state_type_code) ON DELETE CASCADE,
CONSTRAINT chk_person_data_last_name CHECK(trim(last_name) IS NOT NULL),
CONSTRAINT chk_person_data_last_name2 CHECK(last_name !~'[[:digit:]]'),
CONSTRAINT chk_code CHECK(persons_state_type_code>0));

CREATE TABLE Comment (person_id INTEGER NOT NULL,
comment_text TEXT NOT NULL,
comment_registration_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
check_date TIMESTAMP,
active BOOLEAN,
comment_id SERIAL PRIMARY KEY,
CONSTRAINT comment_check CHECK(comment_text!~'^[[:space:]]*$' AND check_date>=CURRENT_TIMESTAMP));