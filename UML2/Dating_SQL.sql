--My Contacts

CREATE TABLE IF NOT EXISTS public.my_contacts
(
    "contact_id" bigserial NOT NULL,
    last_name character varying(50) NOT NULL,
    first_name character varying(50) NOT NULL,
    phone numeric(15) NOT NULL,
    email character varying(50) NOT NULL,
    gender character(1) NOT NULL,
    birthday character varying(10) NOT NULL,
    prof_id bigint NOT NULL,
    zip_code bigint NOT NULL,
    status_id bigint NOT NULL,
    PRIMARY KEY ("contact_id")
);


INSERT INTO my_contacts (last_name, first_name, phone, email, gender, birthday, prof_id, zip_code, status_id)
VALUES ('Bandicoot', 'Crash', '1010101010', 'mf@nothing.com', 'M', '1920-10-10', 1, 1111, 1),
       ('Quinn', 'Harley', '1889390003', 'pc@nothing.com', 'F', '1930-12-12', 2, 2222, 2),
       ('Cricket', 'Jiminy', '1789564738', 'mg@nothing.com', 'M', '1940-11-11', 3, 3333, 3),
       ('Belle', 'Tinker', '5649929762', 'ms@nothing.com', 'F', '1950-01-01', 4, 4444, 4),
       ('Pan', 'Peter', '9873736535', 'jl@nothing.com', 'M', '1960-02-02', 5, 5555, 5);
       
SELECT * FROM my_contacts;

--Profession

CREATE TABLE IF NOT EXISTS public.profession
(
    prof_id bigserial NOT NULL,
    profession character varying(20) NOT NULL,
    CONSTRAINT prof_id UNIQUE (prof_id)
);


INSERT INTO profession (profession)
VALUES ('Actor'),
       ('Artist'),
       ('Doctor'),
       ('Lawyer'),
       ('Astronaut');
       
SELECT * FROM profession;

--Zip Code

CREATE TABLE IF NOT EXISTS public.zip_code
(
    zip_code bigint NOT NULL CHECK (zip_code < 9999 AND zip_code >999),
    city1 character varying(50) NOT NULL,
    province character varying(50),
    PRIMARY KEY (zip_code)
);

INSERT INTO zip_code (zip_code, city1, province)
VALUES (5432, 'Port Elizabeth', 'Eastern Cape'),
       (1910, 'Cradock', 'Eastern Cape'),
       (7890, 'Johannesburg', 'Gauteng'),
       (4325, 'Pretoria', 'Gauteng'),
       (1876, 'Durban', 'KwaZulu-Natal'),
       (5555, 'Pietermaritzburg', 'KwaZulu-Natal'),
       (4444, 'Welkom', 'Freestate'),
       (3333, 'Sasolburg', 'Freestate'),
       (2222, 'Hoedspruit', 'Limpopo'),
       (1111, 'Polokwane', 'Limpopo');
       
SELECT * FROM zip_code;

--Status


CREATE TABLE IF NOT EXISTS public.status
(
    status_id bigserial NOT NULL,
    status character varying(20) NOT NULL,
    PRIMARY KEY (status_id)
);

INSERT INTO status (status)
VALUES ('Single'),
       ('Married'),
       ('Divorced'),
       ('Its Complicated'),
       ('Widowed');
       
SELECT * FROM status; 

--Contact Interest

CREATE TABLE IF NOT EXISTS public.contact_interest
(
    contact_id bigint NOT NULL,
    interest_id bigint NOT NULL
);

INSERT INTO contact_interest (contact_id, interest_id)
VALUES (1,1),
       (1,2),
       (2,1),
       (2,2),
       (3,1),
       (3,2),
       (4,1),
       (4,2),
       (5,1),
       (5,2);
       

SELECT * FROM contact_interest;

--Contact Seeking

CREATE TABLE IF NOT EXISTS public.contact_seeking
(
    contact_id bigint NOT NULL,
    seeking_id bigint NOT NULL
);

INSERT INTO contact_seeking (contact_id, seeking_id)
VALUES (1,1),
       (2,1),
       (3,1),
       (4,1),
       (5,1);
       

SELECT * FROM contact_seeking;

--Interests

CREATE TABLE IF NOT EXISTS public.interests
(
    interest_id bigserial NOT NULL,
    interests character varying(200) NOT NULL,
    PRIMARY KEY (interest_id)
);

INSERT INTO interests (interests)
VALUES ('Baseball'),
       ('Tennis'),
       ('Eating'),
       ('Sleeping'),
       ('Shopping'),
       ('Travelling'),
       ('Fishing'),
       ('Poker'),
       ('PS5'),
       ('Paintball');
       
SELECT * FROM interests; 

--Seeking

CREATE TABLE IF NOT EXISTS public.seeking
(
    "seeking_id" bigserial NOT NULL,
    seeking character varying(200) NOT NULL,
    PRIMARY KEY ("seeking_id")
);

INSERT INTO seeking (seeking)
VALUES ('Money'),
       ('Friends'),
       ('Marriage'),
       ('Ben 10'),
       ('Sugar Mama');
       
SELECT * FROM seeking;

--Constraints

ALTER TABLE IF EXISTS public.my_contacts
    ADD CONSTRAINT prof_id FOREIGN KEY (prof_id)
    REFERENCES public.profession (prof_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.my_contacts
    ADD CONSTRAINT zip_code FOREIGN KEY (zip_code)
    REFERENCES public.zip_code (zip_code) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.my_contacts
    ADD CONSTRAINT status_id FOREIGN KEY (status_id)
    REFERENCES public.status (status_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.contact_interest
    ADD CONSTRAINT interest_id FOREIGN KEY (interest_id)
    REFERENCES public.interests (interest_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.contact_interest
    ADD CONSTRAINT contact_id FOREIGN KEY (contact_id)
    REFERENCES public.my_contacts ("contact_id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.contact_interest
    ADD FOREIGN KEY (contact_id)
    REFERENCES public.my_contacts ("contact_id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.contact_seeking
    ADD CONSTRAINT seeking_id FOREIGN KEY (seeking_id)
    REFERENCES public.seeking ("seeking_id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.contact_seeking
    ADD CONSTRAINT contact_id FOREIGN KEY (contact_id)
    REFERENCES public.my_contacts ("contact_id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

--INNER JOIN--

SELECT 
mc.last_name,
mc.first_name,
mc.phone,
mc.email,
mc.gender,
mc.birthday,
prof.profession,
z.city1,
z.province,
s.status

FROM my_contacts AS mc

INNER JOIN profession AS prof
ON mc.prof_id = prof.prof_id

INNER JOIN zip_code AS z
ON mc.zip_code = z.zip_code

INNER JOIN status AS s
ON mc.status_id = s.status_id;

--INTERESTS INNER JOIN--

SELECT *
FROM my_contacts AS mc

INNER JOIN contact_interest
ON mc.contact_id = contact_interest.contact_id

INNER JOIN interests
ON contact_interest.interest_id = interests.interest_id;

--SEEKING INNER JOIN

SELECT *
FROM my_contacts AS mc

INNER JOIN contact_seeking
ON mc.contact_id = contact_seeking.contact_id

INNER JOIN seeking
ON contact_seeking.seeking_id = seeking.seeking_id;
