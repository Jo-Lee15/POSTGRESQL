CREATE TABLE IF NOT EXISTS public.employees
(
    emp_id bigserial NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    gender character(1) NOT NULL CHECK (gender IN ('M','F')),
    address character varying(50) NOT NULL,
    email character varying(50) NOT NULL,
    depart_id bigint NOT NULL,
    role_id bigint NOT NULL,
    salary_id bigint NOT NULL,
    overtime_id bigint NOT NULL,
    PRIMARY KEY (emp_id)
);

INSERT INTO "employees" (first_name, last_name, gender, address, email, depart_id, role_id, salary_id, overtime_id)
VALUES ('Mr', 'Krabs', 'M', 'Krusty Krab', 'mk@fakeemail.com', 1, 1, 1, 1),
       ('Patrick', 'Star', 'M', 'The Rock', 'ps@fakeemail.com', 2, 2, 2, 2),
       ('Spongebob', 'Squarepants', 'M', 'Pineapple under the sea', 'ss@fake.com', 3, 3, 3, 3),
       ('Squidward', 'Tentacles', 'M', 'The Tower', 'st@nothing.com', 4, 4, 4, 4);
       
       
SELECT * FROM employees;

CREATE TABLE IF NOT EXISTS public.department
(
    depart_id bigserial NOT NULL,
    depart_name character varying(50) NOT NULL,
    depart_city character varying NOT NULL,
    PRIMARY KEY (depart_id)
);

INSERT INTO "department" (depart_name, depart_city)
VALUES ('Krusty Krab', 'Miami'),
       ('Crazy Town', 'Texas'),
       ('Grill', 'Arizona'),
       ('Clarinet', 'California');

SELECT * FROM department;

CREATE TABLE IF NOT EXISTS public.roles
(
    role_id bigserial NOT NULL,
    roles character varying(50) NOT NULL,
    PRIMARY KEY (role_id)
);


INSERT INTO "roles" (roles)
VALUES ('Head of Krusty Krab'),
       ('Head of Crazy'),
       ('Head of Grill'),
       ('Head of Clarinet');
       
SELECT * FROM roles;
       
CREATE TABLE IF NOT EXISTS public.salaries
(
    salary_id bigserial NOT NULL,
    salary_pa numeric(10, 2) NOT NULL,
    PRIMARY KEY (salary_id)
);

INSERT INTO "salaries" (salary_pa)
VALUES ('10000000'),
       ('20000000'),
       ('30000000'),
       ('15000000');
       
SELECT * FROM salaries;

CREATE TABLE IF NOT EXISTS public.overtime_hours
(
    overtime_id bigserial NOT NULL,
    overtime_hours numeric(10, 2) NOT NULL,
    PRIMARY KEY (overtime_id)
);

INSERT INTO "overtime_hours" (overtime_hours)
VALUES ('10'),
       ('20'),
       ('30'),
       ('15');

SELECT * FROM overtime_hours;

ALTER TABLE IF EXISTS public.employees
    ADD CONSTRAINT depart_id FOREIGN KEY (depart_id)
    REFERENCES public.department (depart_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.employees
    ADD CONSTRAINT role_id FOREIGN KEY (role_id)
    REFERENCES public.roles (role_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.employees
    ADD CONSTRAINT salary_id FOREIGN KEY (salary_id)
    REFERENCES public.salaries (salary_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.employees
    ADD CONSTRAINT overtime_id FOREIGN KEY (overtime_id)
    REFERENCES public.overtime_hours (overtime_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

SELECT 
e.first_name,
e.last_name,
e.gender,
e.address,
e.email,
d.depart_name,
d.depart_city,
s.salary_pa,
r.roles,
o.overtime_hours

FROM employees AS e

LEFT JOIN department AS d
ON e.depart_id = d.depart_id

LEFT JOIN salaries AS s
ON e.salary_id = s.salary_id

LEFT JOIN roles AS r
ON e.role_id = r.role_id

LEFT JOIN overtime_hours AS o
ON e.overtime_id = o.overtime_id;