CREATE TABLE public.album
(
    album_id int8 PRIMARY KEY,
    title character varying,
    artist_id int8
);


CREATE TABLE public.album2
(
    album_id int8 PRIMARY KEY,
    title character varying,
    artist_id int8
);

CREATE TABLE public.artist
(
    artist_id int8 primary key,
     name character varying
   
);

CREATE TABLE customer(
customer_id VARCHAR(30) PRIMARY KEY,
first_name CHAR(50),
last_name CHAR(50),
company VARCHAR(50),
address VARCHAR(50),
city VARCHAR(50),
state VARCHAR(50),
country VARCHAR(50),
postal_code varchar(30),
phone varchar(20),
fax varchar(20),
email VARCHAR(100),
support_rep_id VARCHAR(100));

CREATE TABLE employee(
employee_id VARCHAR(50) PRIMARY KEY,
last_name CHAR(50),
first_name CHAR(50),
title VARCHAR(50),
reports_to VARCHAR(30),
levels VARCHAR(10),
birthdate Timestamp,
hire_date Timestamp,
address VARCHAR(120),
city VARCHAR(50),
state VARCHAR(50),
country VARCHAR(30),
postal_code VARCHAR(30),
phone VARCHAR(30),
fax VARCHAR(30),
email VARCHAR(50));



CREATE TABLE genre(
genre_id VARCHAR(50) PRIMARY KEY,
name VARCHAR(30));

CREATE TABLE media_type(
media_type_id VARCHAR(50) PRIMARY KEY,
name VARCHAR(30));

CREATE TABLE playlist_track(
playlist_id VARCHAR(50) ,
track_id VARCHAR(50) );

CREATE TABLE playlist(
playlist_id VARCHAR(50) PRIMARY KEY,
name  VARCHAR(30));

CREATE TABLE track(
track_id VARCHAR(250) PRIMARY KEY,
name VARCHAR(250),
album_id VARCHAR(30),
media_type_id VARCHAR(250),
genre_id VARCHAR(250),
composer VARCHAR(250),
milliseconds int,
bytes INT8,
unit_price INT);

CREATE TABLE invoice_line(
invoice_line_id VARCHAR(50) PRIMARY KEY,
invoice_id VARCHAR(30),
track_id VARCHAR(30),
unit_price VARCHAR(30),
quantity VARCHAR(30));

CREATE TABLE invoice(
invoice_id VARCHAR(30) PRIMARY KEY,
customer_id VARCHAR(30),
invoice_date TIMESTAMP,
billing_address VARCHAR(120),
billing_city VARCHAR(30),
billing_state VARCHAR(30),
billing_country VARCHAR(30),
billing_postal VARCHAR(30),
total FLOAT8);





--1.Who is the senior most employee based on job title? 

select * from employee e 
order by levels desc 
limit 1

--2.Which countries have the most Invoices? 

select count(*) as c, billing_country  from invoice i 
group by billing_country 
order by c desc 

--3.What are top 3 values of total invoice? 

select  total  from invoice i 
order by total  desc 
limit 3

--4.Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
--Write a query that returns one city that has the highest sum of invoice totals. 
--Return both the city name & sum of all invoice totals 

select  sum(total) as total_invoice, billing_city
from invoice i 
group by billing_city 
order  by  total_invoice desc 

--5.Who is the best customer? 
--The customer who has spent the most money will be declared the best customer. 
--Write a query that returns the person who has spent the most money 

select  c.customer_id , c.first_name , c.last_name ,sum(i.total) as total  
from  customer c 
join invoice i 
on c.customer_id = i.customer_id 
group by c.customer_id 
order  by  total desc 
limit 1

 