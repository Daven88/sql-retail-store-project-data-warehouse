import pandas as pd
import pyodbc
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import nltk

# %% Connect to SQL Server and retrieve data
conn = pyodbc.connect(
    'Driver={SQL Server};'
    'server=localhost\\SQLEXPRESS;'
    'database=DataWarehouse_Project_Retail;'
    'trusted_connection=yes;'
)

query = """
SELECT 
    product_key,
    product_name,
    description,
    total_rating
FROM gold.report_products
"""
# %% Load data into a DataFrame
df = pd.read_sql(query, conn)
conn.close()


## Quick EDA
ax = df['total_rating'].value_counts().sort_index().plot(kind='bar', title='Count of Reviews',
                                                    figsize=(10,5))
ax.set_xlabel('Total Rating')
plt.show()

# %% Sentiment Analysis using VADER
from nltk.sentiment import SentimentIntensityAnalyzer
from tqdm import tqdm

sia = SentimentIntensityAnalyzer()

# %% Run the polarity score on the entire dataset
res = {}
for i, row in tqdm(df.iterrows(), total=len(df)):
    description = row['description']
    key = row.name
    res[key] = sia.polarity_scores(description)

# %% Convert results to DataFrame
vaders = pd.DataFrame(res).T
print(vaders.head())
# %%
vaders = vaders.reset_index().rename(columns={'index': 'id'})
print(vaders.head())
# %%
vaders = vaders.merge(df,left_index=True, right_index=True,how='left')
print(vaders.head())
# %%
sns.barplot(data=vaders, x='total_rating', y='compound')
ax.set_title('Average Compound Sentiment Score by Total Rating')
plt.show()
# %%
fig, axs = plt.subplots(1,3, figsize=(12, 3))
sns.boxplot(data=vaders, x='total_rating', y='pos', ax=axs[0])
sns.boxplot(data=vaders, x='total_rating', y='neu', ax=axs[1])
sns.boxplot(data=vaders, x='total_rating', y='neg', ax=axs[2])
axs[0].set_title('Positive Sentiment by Total Rating')
axs[1].set_title('Neutral Sentiment by Total Rating')   
axs[2].set_title('Negative Sentiment by Total Rating')
plt.show()
# %%
vaders.to_csv('sentiment_data.csv', index=False)
