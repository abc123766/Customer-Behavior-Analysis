# Customer Shopping Behavior Analysis

## Overview

This project analyzes customer shopping behavior using Python, MySQL, and Power BI. The goal was to clean and transform raw customer data, perform exploratory data analysis (EDA), uncover business insights through SQL queries, and build an interactive dashboard.

---

# Dataset

**Dataset:** `customer_shopping_behavior.csv`

The dataset contains customer purchase information, including:

- Customer demographics
- Purchase history
- Product categories
- Purchase amounts
- Ratings
- Discounts
- Shipping preferences
- Subscription status

---

# Tools

- **Python (Pandas)** — Data cleaning, EDA, and feature engineering
- **MySQL** — Data analysis and business queries
- **Power BI** — Interactive dashboard and data visualization

---

# Project Workflow

## 1. Data Cleaning & Preparation

Performed data preparation using Python:

- Standardized column names
- Renamed columns for easier analysis
- Checked summary statistics and missing values
- Filled missing review ratings using category-level median values

Example:

```python
df['review_rating'] = (
    df.groupby('category')['review_rating']
    .transform(lambda x: x.fillna(x.median()))
)
```

---

## 2. Feature Engineering

Created new features to support analysis:

- Customer age groups:
  - Young Adult
  - Adult
  - Middle-aged
  - Senior

- Converted purchase frequency into numerical day intervals for customer behavior analysis.

---

## 3. SQL Analysis (MySQL)

Used SQL to answer key business questions:

- Revenue by gender, age group, and category
- Customer segmentation (New, Returning, Loyal)
- Top-performing products
- Product ratings analysis
- Discount and subscription behavior
- Shipping preferences
- Pareto analysis to identify high-revenue locations

Customer segmentation was created using a reusable SQL view based on previous purchases.

---

# Power BI Dashboard

Built an interactive dashboard to present key findings.
<img width="1073" height="604" alt="Customer Behaviour Dashboard" src="https://github.com/user-attachments/assets/f63cfeb9-b467-4c7b-9332-b4ed4f58abae" />

Dashboard includes:

### KPIs
- Total Customers
- Total Revenue
- Average Purchase Amount
- Average Review Rating
- Subscription Rate

### Visualizations
- Revenue by category
- Customer segments by revenue
- Revenue by age group
- Top 5 products by average review rating
- Demographic analysis
- Subscription insights
- Shipping preferences

The Power BI dashboard (`.pbix`) is included in this repository.

---

# Results & Insights

Key insights from the analysis:

- Identified customer segments based on purchasing behavior.
- Compared spending patterns between new, returning, and loyal customers.
- Found the highest revenue-generating categories and locations.
- Analyzed discount usage and subscription trends.
- Evaluated product performance through sales and ratings.

---

# How to Run

### 1. Clone Repository

```bash
git clone https://github.com/abc123766/customer-behavior-analysis.git
cd customer-behavior-analysis
```

### 2. Install Dependencies

```bash
pip install pandas
```

### 3. Run Python Analysis

Open PyCharm and run the analysis workflow.

### 4. Run SQL Queries

Import the dataset into MySQL and execute the SQL scripts.

### 5. Open Dashboard

Open the Power BI `.pbix` file to explore the dashboard.

---

# Project Structure

```
Customer-Shopping-Behavior-Analysis/
│
├── data/
│   └── customer_shopping_behavior.csv
│
├── python/
│   └── customer_behavior_cleaning.py
│
├── sql/
│   └── customer_behavior_sql_queries.sql
│
├── powerbi/
│   └── customer_behavior_dashboard.pbix
│
└── README.md
```

---

# Skills Demonstrated

- Python (Pandas)
- Data Cleaning
- Exploratory Data Analysis
- Feature Engineering
- SQL (MySQL)
- Window Functions
- Data Visualization
- Power BI Dashboard Development
- Business Analytics
