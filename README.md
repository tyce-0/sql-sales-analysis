# 📊 SQL Sales Analysis Project

## 📌 Project Overview

This project analyzes historical sales data to identify trends, patterns, and business insights using SQL.

The goal is to simulate real-world data analysis tasks such as tracking performance over time and supporting decision-making.

---

## 🛠️ Tools Used

* SQL (Data Querying & Analysis)

---

## 📊 Key Business Questions

* How did sales perform over time?
* Is there growth between different years?
* What trends can be observed in order volume?

---

## 🧠 SQL Techniques Applied

* Aggregate functions (`COUNT`)
* Conditional aggregation (`CASE WHEN`)
* Date functions (`YEAR`)
* Data grouping and filtering

---

## 📂 Project Files

* ` insert_data.sql & sales_querirs.sql` → Contains all queries used

---

## 🔍 Sample Query

```sql
SELECT 
    COUNT(CASE WHEN YEAR(order_date) = 1996 THEN 1 END) AS orders_1996,
    COUNT(CASE WHEN YEAR(order_date) = 1997 THEN 1 END) AS orders_1997
FROM orders;
```

---

## 📈 Key Insights

* 📌 **Year-over-Year Growth**
  There was a noticeable increase in the number of orders from 1996 to 1997, indicating business growth.

* 📌 **Trend Identification**
  The upward trend suggests improving customer demand or expansion in operations.

* 📌 **Data-Driven Thinking**
  Using SQL aggregation made it easy to compare performance across time periods.

---

## 💡 Conclusion

This project demonstrates how SQL can be used to extract meaningful insights from raw data and support business decisions.

---

