-- Chapter 1 Code Examples
------------------------------------------------------------

-- Listing 1-1: Creating a database named analysis

CREATE DATABASE analysis;

-- Listing 1-2: Creating a table named teachers with six columns

CREATE TABLE teachers (
    id bigserial,
    first_name varchar(25),
    last_name varchar(50),
    school varchar(50),
    hire_date date,
    salary numeric
);

-- This command will remove (drop) the table.
-- DROP TABLE teachers;

-- Listing 1-3 Inserting data into the teachers table

INSERT INTO teachers (first_name, last_name, school, hire_date, salary)
VALUES ('Janet', 'Smith', 'F.D. Roosevelt HS', '2011-10-30', 36200),
       ('Lee', 'Reynolds', 'F.D. Roosevelt HS', '1993-05-22', 65000),
       ('Samuel', 'Cole', 'Myers Middle School', '2005-08-01', 43500),
       ('Samantha', 'Bush', 'Myers Middle School', '2011-10-30', 36200),
       ('Betty', 'Diaz', 'Myers Middle School', '2005-08-30', 43500),
       ('Kathleen', 'Roush', 'F.D. Roosevelt HS', '2010-10-22', 38500);

--Try it yourself answers & questions:

-------------------------------------------------------------
-- Chapter 1: Creating Your First Database and Table
--------------------------------------------------------------

-- 1. Imagine you're building a database to catalog all the animals at your
-- local zoo. You want one table for tracking all the kinds of animals and
-- another table to track the specifics on each animal. Write CREATE TABLE
-- statements for each table that include some of the columns you need. Why did
-- you include the columns you chose?

-- Answer (yours will vary):

-- The first table will hold the animal types and their conservation status:

CREATE TABLE animal_types (
   animal_type_id bigserial CONSTRAINT animal_types_key PRIMARY KEY,
   common_name varchar(100) NOT NULL,
   scientific_name varchar(100) NOT NULL,
   conservation_status varchar(50) NOT NULL
);

-- Note that I have added keywords on some columns that define constraints
-- such as a PRIMARY KEY. You will learn about these in Chapters 6 and 7.

-- The second table will hold data on individual animals. Note that the
-- column animal_type_id references the column of the same name in the
-- table animal types. This is a foreign key, which you will learn about in
-- Chapter 7.

CREATE TABLE menagerie (
   menagerie_id bigserial CONSTRAINT menagerie_key PRIMARY KEY,
   animal_type_id bigint REFERENCES animal_types (animal_type_id),
   date_acquired date NOT NULL,
   gender varchar(1),
   acquired_from varchar(100),
   name varchar(100),
   notes text
);

-- 2. Now create INSERT statements to load sample data into the tables.
-- How can you view the data via the pgAdmin tool?

-- Answer (again, yours will vary):

INSERT INTO animal_types (common_name, scientific_name, conservation_status)
VALUES ('Bengal Tiger', 'Panthera tigris tigris', 'Endangered'),
       ('Arctic Wolf', 'Canis lupus arctos', 'Least Concern');
-- data source: https://www.worldwildlife.org/species/directory?direction=desc&sort=extinction_status

INSERT INTO menagerie (animal_type_id, date_acquired, gender, acquired_from, name, notes)
VALUES
(1, '1996/3/12', 'F', 'Dhaka Zoo', 'Ariel', 'Healthy coat at last exam.'),
(2, '2000/9/20', 'F', 'National Zoo', 'Freddy', 'Strong appetite.');

-- To view data via pgAdmin, in the object browser, right-click Tables and
-- select Refresh. Then right-click the table name and select
-- View/Edit Data > All Rows

-- 2b. Create an additional INSERT statement for one of your tables. On purpose,
-- leave out one of the required commas separating the entries in the VALUES
-- clause of the query. What is the error message? Does it help you find the
-- error in the code?

-- Answer: In this case, the error message points to the missing comma.

INSERT INTO animal_types (common_name, scientific_name, conservation_status)
VALUES ('Javan Rhino', 'Rhinoceros sondaicus' 'Critically Endangered');
