import pandas as pd

# Read the CSV file
data = pd.read_csv("enhanced_health_insurance_claims.csv")

# Get the column names
columns = data.columns.values

# Get how column details might map to Db2 Table
SQL_details_string = ""
for column in columns:
        if data[column].dtype == 'object':
                column_name = (column)
                column_size = (data[column].map(len).max())
                SQL_details_string += "\"" + column_name + "\" FOR COLUMN " + column_name + " VARCHAR (" + str(column_size) + ") NOT NULL,\n"
        elif data[column].dtype == 'int64':
                SQL_details_string += "\"" + column_name + "\" FOR COLUMN " + column_name + " INT NOT NULL,\n"
        elif data[column].dtype == 'float64':
                SQL_details_string += "\"" + column_name + "\" FOR COLUMN " + column_name + " FLOAT NOT NULL,\n"
print(SQL_details_string)
