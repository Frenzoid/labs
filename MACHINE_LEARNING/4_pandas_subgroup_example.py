import pandas as pd

df = pd.read_csv('https://sololearn.com/uploads/files/titanic.csv')

# We only grab the columns that we want.
small_df = df[['Age', 'Sex', 'Survived']]
print(small_df.head())
