CREATE TABLE IF NOT EXISTS public.my_contacts
(
    "contact-id" bigserial NOT NULL,
    last_name character varying(50) NOT NULL,
    first_name character varying(50) NOT NULL,
    phone numeric(15) NOT NULL,
    email character varying(50) NOT NULL,
    gender character(1) NOT NULL,
    birthday character varying(10) NOT NULL,
    prof_id bigint NOT NULL,
    zip_code bigint NOT NULL,
    status_id bigint NOT NULL,
    PRIMARY KEY ("contact-id")
);


INSERT INTO my_contacts (last_name, first_name, phone, email, gender, birthday, prof_id, zip_code, status_id)
VALUES ('Bandicoot', 'Crash', '1010101010', 'mf@nothing.com', 'M', '1920-10-10', 1, 1, 1),
       ('Quinn', 'Harley', '1889390003', 'pc@nothing.com', 'F', '1930-12-12', 2, 2, 2),
       ('Cricket', 'Jiminy', '1789564738', 'mg@nothing.com', 'M', '1940-11-11', 3, 3, 3),
       ('Belle', 'Tinker', '5649929762', 'ms@nothing.com', 'F', '1950-01-01', 4, 4, 4),
       ('Pan', 'Peter', '9873736535', 'jl@nothing.com', 'M', '1960-02-02', 5, 5, 5);
       
SELECT * FROM my_contacts;


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


CREATE TABLE IF NOT EXISTS public.zip_code
(
    zip_code numeric (4),
    city1 character varying(50) NOT NULL,
    city2 character varying(50) NOT NULL,
    province character varying(50),
    PRIMARY KEY (zip_code)
);

INSERT INTO zip_code (zip_code, city1, city2, province)
VALUES (5432, 'Port Elizabeth', 'Cradock', 'Eastern Cape'),
       (1910, 'Welkom', 'Sasolburg', 'Freestate'),
       (7890, 'Johannesburg', 'Pretoria', 'Gauteng'),
       (4325, 'Durban', 'Newcastle', 'KwaZulu-Natal'),
       (1876, 'Polokwane', 'Hoedspruit', 'Limpopo');
       
SELECT * FROM zip_code;

CREATE TABLE IF NOT EXISTS public.status
(
    status_id bigserial NOT NULL,
    status character varying(20) NOT NULL,
    PRIMARY KEY (status_id)
);

INSERT INTO status (status)
VALUES ('Single'),
       ('Single'),
       ('Single'),
       ('Single'),
       ('Single');
       
SELECT * FROM status; 

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

CREATE TABLE IF NOT EXISTS public.interests
(
    interest_id bigserial NOT NULL,
    interest character varying(200) NOT NULL,
    PRIMARY KEY (interest_id)
);

INSERT INTO interests (interest)
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



CREATE TABLE IF NOT EXISTS public.seeking
(
    "seeking-id" bigserial NOT NULL,
    seeking character varying(200) NOT NULL,
    PRIMARY KEY ("seeking-id")
);

INSERT INTO seeking (seeking)
VALUES ('Money'),
       ('Friends'),
       ('Marriage'),
       ('Ben 10'),
       ('Sugar Mama');
       
SELECT * FROM seeking;

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
    REFERENCES public.my_contacts ("contact-id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.contact_interest
    ADD FOREIGN KEY (contact_id)
    REFERENCES public.my_contacts ("contact-id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.contact_seeking
    ADD CONSTRAINT seeking_id FOREIGN KEY (seeking_id)
    REFERENCES public.seeking ("seeking-id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.contact_seeking
    ADD CONSTRAINT contact_id FOREIGN KEY (contact_id)
    REFERENCES public.my_contacts ("contact-id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;