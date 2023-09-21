SELECT * FROM sales.transactions limit 5;
select count(*) from sales.transactions;
select count(*) from sales.customers;
SELECT * FROM sales.transactions where market_code = "Mark001";
SELECT * FROM sales.transactions where currency = "USD";
SELECT transactions.*, date.* FROM transactions INNER JOIN date ON transactions.order_date=date.date where date.year=2020;
SELECT SUM(transactions.sales_amount) FROM transactions INNER JOIN date ON transactions.order_date=date.date where date.year=2020 ;
SELECT SUM(transactions.sales_amount) FROM transactions INNER JOIN date ON transactions.order_date=date.date where date.year=2020 and transactions.market_code="Mark001";
SELECT distinct product_code FROM transactions where market_code='Mark001';