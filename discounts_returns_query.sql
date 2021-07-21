USE portfolio_project

-- Explore sales_by product

SELECT *
FROM sales_by_product

-- Find the products with the biggest difference in gross and net sells
SELECT [Product Type], SUM([Gross Sales]) - SUM([Total Net Sales]) AS Diff_Gross_Net_Sales
FROM sales_by_product
GROUP BY [Product Type]
HAVING SUM([Gross Sales]) - SUM([Total Net Sales]) > 500
ORDER BY Diff_Gross_Net_Sales DESC


-- Find out if discounts or returns cause more deficits for each product type

-- Basket
SELECT SUM([Discounts]) AS Baskets_Discounts, SUM([Returns]) AS Baskets_Returns, SUM([Gross Sales]) - SUM([Total Net Sales]) AS Diff_Gross_Net_Sales
FROM sales_by_product
WHERE [Product Type] = 'Basket'

SELECT ABS(SUM([Discounts])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Baskets_Discount_Percent, ABS(SUM([Returns])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Baskets_Return_Percent
FROM sales_by_product
WHERE [Product Type] = 'Basket'

-- Art & Sculpture
SELECT SUM([Discounts]) AS Art_Discounts, SUM([Returns]) AS Art_Returns, SUM([Gross Sales]) - SUM([Total Net Sales]) AS Diff_Gross_Net_Sales
FROM sales_by_product
WHERE [Product Type] = 'Art & Sculpture'

SELECT ABS(SUM([Discounts])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Art_Discount_Percent, ABS(SUM([Returns])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Art_Return_Percent
FROM sales_by_product
WHERE [Product Type] = 'Art & Sculpture'

-- Jewelry
SELECT SUM([Discounts]) AS Jewelry_Discounts, SUM([Returns]) AS Jewelry_Returns, SUM([Gross Sales]) - SUM([Total Net Sales]) AS Diff_Gross_Net_Sales
FROM sales_by_product
WHERE [Product Type] = 'Jewelry'

SELECT ABS(SUM([Discounts])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Jewelry_Discount_Percent, ABS(SUM([Returns])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Jewelry_Return_Percent
FROM sales_by_product
WHERE [Product Type] = 'Jewelry'

-- Home Decor
SELECT SUM([Discounts]) AS Home_Discounts, SUM([Returns]) AS Home_Returns, SUM([Gross Sales]) - SUM([Total Net Sales]) AS Diff_Gross_Net_Sales
FROM sales_by_product
WHERE [Product Type] = 'Home Decor'

SELECT ABS(SUM([Discounts])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Home_Discount_Percent, ABS(SUM([Returns])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Home_Return_Percent
FROM sales_by_product
WHERE [Product Type] = 'Home Decor'

-- Christmas
SELECT SUM([Discounts]) AS Christmas_Discounts, SUM([Returns]) AS Christmas_Returns, SUM([Gross Sales]) - SUM([Total Net Sales]) AS Diff_Gross_Net_Sales
FROM sales_by_product
WHERE [Product Type] = 'Christmas'

SELECT ABS(SUM([Discounts])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Christmas_Discount_Percent, ABS(SUM([Returns])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Christmas_Return_Percent
FROM sales_by_product
WHERE [Product Type] = 'Christmas'

-- Kitchen
SELECT SUM([Discounts]) AS Kitchen_Discounts, SUM([Returns]) AS Kitchen_Returns, SUM([Gross Sales]) - SUM([Total Net Sales]) AS Diff_Gross_Net_Sales
FROM sales_by_product
WHERE [Product Type] = 'Kitchen'

SELECT ABS(SUM([Discounts])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Kitchen_Discount_Percent, ABS(SUM([Returns])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Kitchen_Return_Percent
FROM sales_by_product
WHERE [Product Type] = 'Kitchen'


-- Combine all to compare easily
SELECT ABS(SUM([Discounts])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Baskets_Discount_Percent, ABS(SUM([Returns])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Baskets_Return_Percent, 
SUM([Discounts]) AS Baskets_Discounts, SUM([Returns]) AS Baskets_Returns, SUM([Gross Sales]) - SUM([Total Net Sales]) AS Diff_Gross_Net_Sales
FROM sales_by_product
WHERE [Product Type] = 'Basket'

SELECT ABS(SUM([Discounts])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Art_Discount_Percent, ABS(SUM([Returns])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Art_Return_Percent, 
SUM([Discounts]) AS Art_Discounts, SUM([Returns]) AS Art_Returns, SUM([Gross Sales]) - SUM([Total Net Sales]) AS Diff_Gross_Net_Sales
FROM sales_by_product
WHERE [Product Type] = 'Art & Sculpture'

SELECT ABS(SUM([Discounts])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Jewelry_Discount_Percent, ABS(SUM([Returns])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Jewelry_Return_Percent, 
SUM([Discounts]) AS Jewelry_Discounts, SUM([Returns]) AS Jewelry_Returns, SUM([Gross Sales]) - SUM([Total Net Sales]) AS Diff_Gross_Net_Sales
FROM sales_by_product
WHERE [Product Type] = 'Jewelry'

SELECT ABS(SUM([Discounts])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Home_Discount_Percent, ABS(SUM([Returns])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Home_Return_Percent, 
SUM([Discounts]) AS Home_Discounts, SUM([Returns]) AS Home_Returns, SUM([Gross Sales]) - SUM([Total Net Sales]) AS Diff_Gross_Net_Sales
FROM sales_by_product
WHERE [Product Type] = 'Home Decor'

SELECT ABS(SUM([Discounts])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Christmas_Discount_Percent, ABS(SUM([Returns])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Christmas_Return_Percent, 
SUM([Discounts]) AS Christmas_Discounts, SUM([Returns]) AS Christmas_Returns, SUM([Gross Sales]) - SUM([Total Net Sales]) AS Diff_Gross_Net_Sales
FROM sales_by_product
WHERE [Product Type] = 'Christmas'

SELECT ABS(SUM([Discounts])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Kitchen_Discount_Percent, ABS(SUM([Returns])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Kitchen_Return_Percent, 
SUM([Discounts]) AS Kitchen_Discounts, SUM([Returns]) AS Kitchen_Returns, SUM([Gross Sales]) - SUM([Total Net Sales]) AS Diff_Gross_Net_Sales
FROM sales_by_product
WHERE [Product Type] = 'Kitchen'

-- Combined
SELECT [Product Type], ABS(SUM([Discounts])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Discount_Percent, ABS(SUM([Returns])/(SUM([Gross Sales]) - SUM([Total Net Sales]))*100) AS Return_Percent, 
SUM([Discounts]) AS Discounts, SUM([Returns]) AS Returns, SUM([Gross Sales]) - SUM([Total Net Sales]) AS Diff_Gross_Net_Sales
FROM sales_by_product
GROUP BY [Product Type]
Having SUM([Gross Sales]) - SUM([Total Net Sales]) > 500
ORDER BY Diff_Gross_Net_Sales DESC

/*
Notes:
- Baskets and Art & Sculpture products are split pretty evenly between discounts and returns causing lost revunue; Note that these are the products with the highest revenue overall
- Jewelry discounts account for 65% of lost revenue
- Home Decor discounts account for 70% of lost revenue
- Christmas returns is the only category with a much higher return rate, at 65%
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Explore sales_by_year

SELECT *
FROM sales_by_year


-- Find percent of discounts compared to percent of returns per year, order by percentage of returns
SELECT Year, ABS(SUM([Discounts])/(SUM([Gross Sales]) - SUM([Net Sales]))*100) AS Discount_Percent, ABS(SUM([Returns])/(SUM([Gross Sales]) - SUM([Net Sales]))*100) AS Return_Percent, 
SUM(Discounts) AS Discounts, Sum(Returns) AS Returns, SUM([Gross Sales]) - SUM([Net Sales]) AS Diff_Gross_Net_Sales
FROM sales_by_year
GROUP BY Year
ORDER BY Return_Percent DESC

-- Find percent of discounts compared to percent of returns per month, order by percentage of returns
SELECT Month, ABS(SUM([Discounts])/(SUM([Gross Sales]) - SUM([Net Sales]))*100) AS Discount_Percent, ABS(SUM([Returns])/(SUM([Gross Sales]) - SUM([Net Sales]))*100) AS Return_Percent, 
SUM(Discounts) AS Discounts, Sum(Returns) AS Returns, SUM([Gross Sales]) - SUM([Net Sales]) AS Diff_Gross_Net_Sales
FROM sales_by_year
GROUP BY Month
ORDER BY Return_Percent DESC

-- Find percent of discounts to percent of returns by month and year, order by percentage of returns
SELECT Year, Month, ABS(SUM([Discounts])/(SUM([Gross Sales]) - SUM([Net Sales]))*100) AS Discount_Percent, ABS(SUM([Returns])/(SUM([Gross Sales]) - SUM([Net Sales]))*100) AS Return_Percent, 
SUM(Discounts) AS Discounts, Sum(Returns) AS Returns, SUM([Gross Sales]) - SUM([Net Sales]) AS Diff_Gross_Net_Sales
FROM sales_by_year
GROUP BY YEAR, MONTH
ORDER BY Return_Percent DESC

-- Export tables and compare with Alteryx workflow