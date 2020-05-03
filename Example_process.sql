/*Some names have gratuitous context. Table name Public_person_data starts with the schema name. Column names comment_registration_time and comment_text of table Comment start with the table name. Moreover, the style of using table names in column names is not consistent across tables.*/
ALTER TABLE public.Public_person_data RENAME TO Person_data;

ALTER TABLE public.Comment RENAME COLUMN comment_registration_time TO registration_time;


/*Table names Comment and Public_person_data are too generic. In case of the former, it is unclear what is the subject of comments (are these about persons?) and in case of the latter, the word data is a noise because all tables contain data.*/
ALTER TABLE public.Person_data RENAME TO Person;
ALTER TABLE public.Comment RENAME TO Person_feedback;


--Changes in the names of dependent objects 
ALTER TABLE public.Person RENAME CONSTRAINT chk_person_data_last_name TO chk_person_last_name;
ALTER TABLE public.Person RENAME CONSTRAINT chk_person_data_last_name2 TO chk_person_last_name2;

ALTER TABLE public.Person_feedback RENAME CONSTRAINT comment_pkey TO Person_feedback_pkey;
ALTER TABLE public.Person_feedback RENAME CONSTRAINT comment_check TO person_feedback_check;

ALTER TABLE public.Person_feedback RENAME COLUMN comment_id TO person_feedback_id;
ALTER SEQUENCE public.comment_comment_id_seq RENAME TO person_feedback_person_feedback_id;


/*Column name id is too generic. SQL antipattern ID Required warns against using the name. Moreover, another surrogate key column – comment_id – uses a different naming style. Thus, there is a naming inconsistency.*/
ALTER TABLE public.Person RENAME COLUMN id TO person_id;


/*If a cultural tradition is to present surname before given name, then the column names first_name and last_name will cause confusion.*/
ALTER TABLE public.Person RENAME COLUMN first_name TO given_name;
ALTER TABLE public.Person RENAME COLUMN last_name TO surname;

--Changes in the names of dependent objects
ALTER TABLE public.Person RENAME CONSTRAINT chk_person_last_name TO chk_person_surname;
ALTER TABLE public.Person RENAME CONSTRAINT chk_person_last_name2 TO chk_person_surname2;


/*Column name person_id does not reveal the role of persons in terms of comments.*/
ALTER TABLE public.Person_feedback RENAME COLUMN person_id TO author;


/*Column active contains Boolean data but does not follow a naming convention to have prefix is_ or has_.*/
ALTER TABLE public.Person_feedback RENAME COLUMN active TO is_active;


/*The one letter difference of the primary/foreign key column names (person_state_type_code vs. persons_state_type_code) makes writing join queries more difficult and error prone and prevents the use of USING syntax in the join.*/
ALTER TABLE public.Person RENAME COLUMN persons_state_type_code TO  person_state_type_code;


/*Constraint name chk_code is too generic and does not sufficiently explain the meaning and/or context of the constraint.*/
ALTER TABLE public.Person_state_type RENAME CONSTRAINT chk_code TO chk_person_state_type_person_state_type_code;
ALTER TABLE public.Person RENAME CONSTRAINT chk_code TO chk_person_person_state_type_code;


/*Two tables have a directly attached check constraint with the same name (chk_code).*/
--It has already been solved with the step of making the constraint names less generic.


/*Names of some table constraints (for instance, chk_code) do not contain the name of the table. It contributes towards having duplicate constraint names in a schema.*/
--It has already been solved with the previous steps.


/*Constrain name "FK_person person_state_type" is a delimited identifier. Thus, it is case sensitive, complicating schema maintenance and evolvement. Other identifiers are case insensitive regular identifiers. Hence, there is also a naming inconsistency.*/
ALTER TABLE public.Person RENAME CONSTRAINT "FK_person person_state_type" TO FK_person_person_state_type;


/*Constraint name chk_person_data_last_name2 contains a sequence number instead of explaining more precisely the meaning of the constraint.*/
ALTER TABLE public.Person RENAME CONSTRAINT chk_person_surname2 TO chk_person_surname_no_digits;


/*Most of the constraint names are user-defined whereas the primary key constraints of tables Comment and Person_state_type would have system-generated names.*/
ALTER TABLE public.Person_state_type RENAME CONSTRAINT person_state_type_pkey TO pk_person_state_type;
ALTER TABLE public.Person_feedback RENAME CONSTRAINT person_feedback_pkey TO pk_person_feedback;


/*The primary key column comment_id is not the first in table Comment.*/
/*Although SQL pays attention to the order of columns it does not offer a special syntax for changing the column order.
Thus, the best option is to copy data. Drop table. Recreate table. Load data back to the table.
One can do it within one transaction block to ensure that all the changes will be made or none of the changes will be made.*/

CREATE TABLE public.Person_feedback_copy AS SELECT * FROM public.Person_feedback;
DROP TABLE public.Person_feedback;
CREATE TABLE public.Person_feedback (
person_feedback_id SERIAL NOT NULL,
author INTEGER NOT NULL,
comment_text TEXT NOT NULL,
registration_time TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
check_date TIMESTAMP WITHOUT TIME ZONE,
is_active BOOLEAN,    
CONSTRAINT pk_person_feedback PRIMARY KEY (person_feedback_id),
CONSTRAINT person_feedback_check CHECK (((comment_text !~ '^[[:space:]]*$') AND (check_date >= CURRENT_TIMESTAMP)))
);
INSERT INTO public.Person_feedback (author, comment_text, registration_time, check_date, is_active)
SELECT author, comment_text, registration_time, check_date, is_active
FROM public.Person_feedback;
DROP TABLE public.Person_feedback_copy;


/*Table Comment does not have the foreign key constraint to enforce the relationship between tables Comment and Public_person_data.*/
ALTER TABLE public.Person_feedback ADD CONSTRAINT fk_person_feedback_person FOREIGN KEY(author) REFERENCES public.Person(person_id);


/*Textual non-foreign key column first_name does not have a check constraint to prevent the empty string or strings that consist of only whitespace characters.*/
ALTER TABLE public.Person ADD CONSTRAINT chk_person_given_name CHECK(given_name!~'^[[:space:]]*$');


/*Columns with a timestamp type (check_date, registration_time, comment_registration_time) do not have a check constraint to prevent illogical values that are far back in time (for instance, 1200-12-22) or in the distant future (for instance, 4000-12-22). Such values belong to the type but are inappropriate to use in case of the domain.*/
ALTER TABLE public.Person ADD CONSTRAINT chk_person_registration_time CHECK(registration_time>='2019-01-01' AND registration_time<'2201-01-01');
ALTER TABLE public.Person_feedback ADD CONSTRAINT chk_person_feedback_registration_time CHECK(registration_time>='2019-01-01' AND registration_time<'2201-01-01');
ALTER TABLE public.Person_feedback ADD CONSTRAINT chk_person_feedback_check_date CHECK(check_date>='2019-01-01' AND check_date<'2201-01-01');


/*In table Comment there is no check constraint that connects columns check_date and comment_registration_time. In practice, temporal columns in a table correspond to events and quite often, there is a particular order of events in the domain.*/
ALTER TABLE public.Person_feedback ADD CONSTRAINT chk_person_feedback_check_date_registration_time CHECK(check_date>=registration_time);

--Existing set of constraints can be simplified.
ALTER TABLE public.Person_feedback DROP CONSTRAINT chk_person_feedback_registration_time;
ALTER TABLE public.Person_feedback DROP CONSTRAINT chk_person_feedback_check_date;

ALTER TABLE public.Person_feedback ADD CONSTRAINT chk_person_feedback_registration_time CHECK(registration_time>='2019-01-01');
ALTER TABLE public.Person_feedback ADD CONSTRAINT chk_person_feedback_check_date CHECK(check_date<'2201-01-01');

/*The check ensuring that last names cannot contain numerical digits is too restrictive.*/
ALTER TABLE public.Person DROP CONSTRAINT chk_person_surname_no_digits;


/*The check constraint of table Comment has multiple tasks (responsibilities).*/
ALTER TABLE public.Person_feedback DROP CONSTRAINT person_feedback_check;

ALTER TABLE public.Person_feedback ADD CONSTRAINT chk_person_feedback_comment_text CHECK(comment_text!~'^[[:space:]]*$');
ALTER TABLE public.Person_feedback ADD CONSTRAINT chk_person_feedback_check_date_bigger_current CHECK(check_date>=CURRENT_TIMESTAMP);


/*Duplication of parent table check constraint on the foreign key column (column persons_state_type_code of table Public_person_data).*/
ALTER TABLE public.Person DROP CONSTRAINT chk_person_person_state_type_code;


/*Check constraint (check_date >= CURRENT_TIMESTAMP) invokes non-deterministic function in a manner that data that conforms to the constraint at the registration time does not necessarily conform to it later.*/
ALTER TABLE public.Person_feedback DROP CONSTRAINT chk_person_feedback_check_date_bigger_current;


/*Check constraint (trim(last_name) IS NOT NULL) implements incorrectly the rule that last name cannot be the empty string or a string that consists of only spaces. PostgreSQL does not automatically replace the empty string with NULL.*/
ALTER TABLE public.Person DROP CONSTRAINT chk_person_surname;

--Regression testing reveals a need to add the constraint.
ALTER TABLE public.Person ADD CONSTRAINT chk_person_surname CHECK(surname!~'^[[:space:]]*$');

/*In case of columns name and last_name the intent is to prevent strings that consist of only spaces not strings that consist of only whitespace like in case of column comment_text. The inconsistency could be intentional or a mistake.*/
ALTER TABLE public.Person_state_type DROP CONSTRAINT chk_person_state_type_name;

--Regression testing reveals a need to add the constraint.
ALTER TABLE public.Person_state_type ADD CONSTRAINT chk_person_state_type_name CHECK(name!~'^[[:space:]]*$');


/*Column comment_registration_time has a default value but the column is optional, raising the question as to whether the column should have NOT NULL constraint.*/
ALTER TABLE public.Person_feedback ALTER COLUMN registration_time SET NOT NULL;


/*Column active of Comment is optional. It leads to the use of three-valued logic.*/
ALTER TABLE public.Person_feedback ALTER COLUMN is_active SET NOT NULL;


/*In table Person_state_type all the non-primary key columns are optional raising the question as to whether the columns should have NOT NULL constraint.*/
ALTER TABLE public.Person_state_type ALTER COLUMN name SET NOT NULL;


/*Columns for registering personal names (first_name, last_name) do not take into account the possibility of long names (longer than 50 characters) and the existence of mononymous persons, i.e., persons who have a single name.*/
ALTER TABLE public.Person ALTER COLUMN given_name TYPE VARCHAR(1000);
ALTER TABLE public.Person ALTER COLUMN surname TYPE VARCHAR(1000);

ALTER TABLE public.Person ALTER COLUMN surname DROP NOT NULL;


/*Column persons_state_type_code of table Person_data does not have a default value. The value should be the code of the first state that a person gets according to the state machine model of entity type Person.*/
ALTER TABLE public.Person ALTER COLUMN person_state_type_code SET DEFAULT 1;


/*Boolean column active of table Comment does not have a default value.*/
ALTER TABLE public.Person_feedback ALTER COLUMN is_active SET DEFAULT TRUE;


/*In table Comment the column for registration time has a default value whereas in table Public_person_data it does not (lack of a default value; inconsistency).*/
ALTER TABLE public.Person ALTER COLUMN registration_time SET DEFAULT CURRENT_TIMESTAMP(0);


/*The default value and type of column comment_registration_time are inconsistent. It leads to the question as to whether the registration of time zone is needed or not.*/
ALTER TABLE public.Person_feedback ALTER COLUMN registration_time SET DEFAULT LOCALTIMESTAMP(0);


/*Tables Public_person_data and Comment use an internal and an external se-quence generator, respectively, to generate surrogate key values (inconsistency).*/
ALTER TABLE public.Person ALTER COLUMN person_id DROP IDENTITY;
CREATE SEQUENCE public.person_person_id_seq OWNED BY Person.person_id;
ALTER TABLE public.Person ALTER COLUMN person_id SET DEFAULT nextval('person_person_id_seq');


/*In one table, column person_state_type_code has type SMALLINT and in another type INTEGER (inconsistency). Thus, certain state codes that one could register in table Person_state_type cannot be used in table Public_person_data.*/
ALTER TABLE public.Person_state_type ALTER COLUMN person_state_type_code TYPE SMALLINT;


/*In table Public_person_data registration time value must contain time zone whereas in table Comment it cannot (inconsistency).*/
ALTER TABLE public.Person ALTER COLUMN registration_time TYPE TIMESTAMP;

--The constraint has to be recreated as well because the old constraint version assumes that the column type is TIMESTAMP WITH TIME ZONE.
ALTER TABLE public.Person DROP CONSTRAINT chk_person_registration_time;
ALTER TABLE public.Person ADD CONSTRAINT chk_person_registration_time CHECK(registration_time>='2019-01-01' AND registration_time<'2201-01-01');
--The default value has to be changed accordingly.
ALTER TABLE public.Person ALTER COLUMN registration_time SET DEFAULT LOCALTIMESTAMP(0);


/*Column name check_date is not consistent with the datatype, leading to the question as to what should be the precision of data (date or timestamp) in this column.*/
ALTER TABLE public.Person_feedback RENAME COLUMN check_date TO check_time;


--Changes in the names of dependent objects
ALTER TABLE public.Person_feedback RENAME CONSTRAINT chk_person_feedback_check_date TO chk_person_feedback_check_time;
ALTER TABLE public.Person_feedback RENAME CONSTRAINT chk_person_feedback_check_date_registration_time TO chk_person_feedback_check_registration_time;


/*Comments have a simplistic state machine (active/inactive). The task to register the current state is implemented differently in case of different tables (inconsistency).*/
--Does not need a change.


/*The foreign key constraint that refers to Person_state_type does not have ON UPDATE CASCADE compensating action although the classifier codes could change over time. Moreover, having ON DELETE CASCADE there is reckless.*/
ALTER TABLE Person DROP CONSTRAINT fk_person_person_state_type;
ALTER TABLE Person ADD CONSTRAINT fk_person_person_state_type FOREIGN KEY (person_state_type_code) REFERENCES Person_state_type (person_state_type_code) ON UPDATE CASCADE;


/*The default FILLFACTOR parameter value of base tables has not been changed.*/
ALTER TABLE public.Person_state_type SET (FILLFACTOR=90);
ALTER TABLE public.Person SET (FILLFACTOR=90);
ALTER TABLE public.Person_feedback SET (FILLFACTOR=90);


/*Foreign key columns are not indexed.*/
CREATE INDEX idx_person_persons_state_type_code ON Person (person_state_type_code);
CREATE INDEX idx_person_feedback_author ON Person_feedback (author);