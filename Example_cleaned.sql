/*The statements depict the design, which original is in the file Example_smelly.sql, where all the problems have been fixed.*/

CREATE TABLE Person_state_type (
person_state_type_code SMALLINT NOT NULL, 
name VARCHAR(50) NOT NULL,
CONSTRAINT pk_person_state_type PRIMARY KEY(person_state_type_code),
CONSTRAINT ak_person_state_type_name UNIQUE (name),
CONSTRAINT chk_person_state_type_name CHECK(name!~'^[[:space:]]*$'),
CONSTRAINT chk_person_state_type_person_state_type_code CHECK(person_state_type_code>0));

CREATE TABLE Person (person_id SERIAL NOT NULL,
given_name VARCHAR(1000) NOT NULL,
surname VARCHAR(1000),
person_state_type_code SMALLINT NOT NULL DEFAULT 1,
registration_time TIMESTAMP NOT NULL DEFAULT LOCALTIMESTAMP(0),
CONSTRAINT pk_person PRIMARY KEY (person_id),
CONSTRAINT fk_person_person_state_type FOREIGN KEY (person_state_type_code) 
REFERENCES Person_state_type (person_state_type_code) ON UPDATE CASCADE,
CONSTRAINT chk_person_given_name CHECK(given_name!~'^[[:space:]]*$'),
CONSTRAINT chk_person_surname CHECK(surname!~'^[[:space:]]*$'),
CONSTRAINT chk_person_registration_time CHECK(registration_time>='2019-01-01' AND registration_time<'2201-01-01'));

CREATE TABLE Person_feedback (person_feedback_id SERIAL NOT NULL,
author INTEGER NOT NULL,
comment_text TEXT NOT NULL,
registration_time TIMESTAMP NOT NULL DEFAULT LOCALTIMESTAMP(0),
check_time TIMESTAMP,
is_active BOOLEAN NOT NULL DEFAULT TRUE,
CONSTRAINT pk_person_feedback PRIMARY KEY (person_feedback_id),
CONSTRAINT fk_person_feedback_person FOREIGN KEY(author) REFERENCES Person(person_id),
CONSTRAINT chk_person_feedback_comment_text CHECK(comment_text!~'^[[:space:]]*$'),
CONSTRAINT chk_person_feedback_check_registration_time CHECK(check_time>=registration_time),
CONSTRAINT chk_person_feedback_registration_time CHECK(registration_time>='2019-01-01'),
CONSTRAINT chk_person_feedback_check_time CHECK(check_time<'2201-01-01'));