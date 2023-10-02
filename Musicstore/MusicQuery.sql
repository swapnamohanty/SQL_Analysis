--1.Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
--Return your list ordered alphabetically by email starting with A 

select  email, first_name, last_name
from customer 
join invoice on customer.customer_id = invoice.customer_id 
join  invoice_line  on invoice.invoice_id = invoice_line.invoice_id 
where track_id in(
     select  track_id from track 
     join genre  on track.track_id = genre.genre_id 
     where  genre.name like 'Rock'
)
order  by email

--2.Let's invite the artists who have written the most rock music in our dataset. 
--Write a query that returns the Artist name and total track count of the top 10 rock bands 

select   artist.artist_id, artist.name, count(artist.artist_id)as number_of_songs
from track   
join album on album.album_id = CAST(track.album_id AS bigint)
join artist on artist.artist_id = album.artist_id  
join genre  on genre.genre_id = track.genre_id 
where  genre.name  like  'Rock'
group by  artist.artist_id 
order by number_of_songs desc 
limit  10

--3.Return all the track names that have a song length longer than the average song length. 
--Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.

select name, milliseconds 
from track 
where  milliseconds >(
select avg(milliseconds)as length_of_songs
from track 
)
order by milliseconds  desc 

--1.Find how much amount spent by each customer on artists? 
--Write a query to return customer name, artist name and total spent .

with best_selling_artist as(
select  artist.artist_id  as artist_id, artist.name as artist_name,
sum(CAST(invoice_line.unit_price AS numeric) * CAST(invoice_line.quantity AS numeric)) as total_sales
from invoice_line 
join track on track.track_id = invoice_line.track_id 
join album on album.album_id = cast (track.track_id  as bigint)
join artist  on artist.artist_id  = album.artist_id 
group  by 1
order  by 3 desc 
limit 1
)

select  c.customer_id,c. first_name, c.last_name, bsa. artist_name,
sum(CAST(il.unit_price AS numeric) * CAST(il.quantity AS numeric)) as total_sales
from invoice i 
join customer c  on c.customer_id = i.customer_id 
join invoice_line il on il.invoice_id = i.invoice_id 
join track t on t.track_id = il.track_id 
join album a on a.album_id = cast (t.track_id  as bigint)
join best_selling_artist bsa on bsa.artist_id = a.artist_id 
group by 1,2,3,4
order by 5 desc 

--2.We want to find out the most popular music Genre for each country. 
--We determine the most popular genre as the genre with the highest amount of purchases. 
--Write a query that returns each country along with the top Genre. 
--For countries where the maximum number of purchases is shared return all Genres  
with  popular_genre as(
select  count (il .quantity) as purchases, c.country , g.name, g.genre_id ,
row_number ()over(partition by c.country order by count(il.quantity)desc)as Rowno
from  invoice_line il
join invoice i  on i.invoice_id= il.invoice_id 
join customer c  on c.customer_id = i.customer_id 
join track t on t.track_id = il.track_id 
join genre g  on g.genre_id  = t.track_id 
group by 2, 3, 4
order  by 2 asc , 1 desc 
)
select * from  popular_genre where  Rowno<=1

--method 2
with recursive
sale_per_country(
select  count (*) as purchases_per_genre, c.country , g.name, g.genre_id ,
row_number ()over(partition by c.country order by count(il.quantity)desc)as Rowno
from  invoice_line il
join invoice i  on i.invoice_id= il.invoice_id 
join customer c  on c.customer_id = i.customer_id 
join track t on t.track_id = il.track_id 
join genre g  on g.genre_id  = t.track_id 
group by 2, 3, 4
order  by 2
)

 max_genre_country as (select  max(purchases_ per _genre) as max_genre_no, country
 from sales_per_country
 group by 2 order by 2)
 
 select  sales_per_country*.
 from sales_per_country
 join max_genre_per_country on sales_per_country.country = max_genre_country.country
 where sales_per_country. purchases_per_genre= max_genre_county.max_genre_no
 
 --3.Write a query that determines the customer that has spent the most on music for each country.
--Write a query that returns the country along with the top customer and how much they spent. 
--For countries where the top amount spent is shared, provide all customers who spent this amount .
 
 with recursive
 customer_with_country as(
 select customer.customer_id , first_name, last_name, billing_country, sum(total)as total_spent
 from invoice 
 join customer  on customer.customer_id = invoice.customer_id 
 group by 1, 2, 3, 4
 order by 2, 3 desc 
 ),
 	country_max_spending as(
 select billing_country, max(total_spent)as max_spending
 from customer_with_country
 group by billing_country
 )
 
 select  cc.billing_country,cc.total_spent, cc.first_name, cc.last_name, cc.customer_id
 from customer_with_country cc
 join country_max_spending ms on
 cc.billing_country = ms.billing_country
 where  cc. total_spent= ms. max_spending
 order  by 1
