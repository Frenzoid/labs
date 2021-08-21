
import pandas as pd
df = pd.read_csv('https://sololearn.com/uploads/files/titanic.csv')

# This creates a new column "male" with the right side return value, for each element in the df array.
df['male'] = df['Sex'] == 'male'
print(df.head())
