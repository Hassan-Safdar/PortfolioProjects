SELECT sum(t.sales_amount) FROM sales.transactions t JOIN sales.date d ON
 t.order_date = d.date 
WHERE d.year = 2020 AND t.market_code = "Mark001";