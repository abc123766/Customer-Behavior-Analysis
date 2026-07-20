import pandas as pd

df = pd.read_csv('customer_shopping_behavior.csv')

# Make column names fully lowercase
df.columns = df.columns.str.lower()
# Replace spaces with underscores in column names
df.columns = df.columns.str.replace(' ', '_')

# Change purchase amount column name
df = df.rename(columns={'purchase_amount_(usd)':'purchase_amount'})

# Check summary statistics of all the columns (including categorical columns)
df.describe(include='all')

# Check for missing values
df.isnull().sum()
# output: only the review ratings have null values

# Replace with median (within each category) because median ignores extremes and is robust to outliers
df['review_rating'] = df.groupby('category')['review_rating'].transform(lambda x: x.fillna(x.median()))

# Create new column age_group, labelling by age
age_labels = ['Young Adult', 'Adult', 'Middle-aged', 'Senior']
df['age_group'] = pd.qcut(df['age'], q=4, labels=age_labels)

# Create new column transforming frequency into numbers (text -> int) by using dictionary
freq_map = {'Weekly': 7, 'Bi-Weekly': 14, 'Fortnightly': 14, 'Monthly': 30, 'Quarterly': 90, 'Every 3 Months': 90,
            'Annually': 365}
df['freq_days'] = df['frequency_of_purchases'].map(freq_map)

# Connect to MySQL

