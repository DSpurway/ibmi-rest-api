import pyodbc
import pandas as pd

cnx = pyodbc.connect(
        'Driver=IBM i Access ODBC Driver; '
        'System=localhost; '
        'UserID=cecuser; '
        'Password=av6sgvyx_yc+Gpv;'
        )

cursor = cnx.cursor()
# Read the CSV file
data = pd.read_csv("enhanced_health_insurance_claims.csv")

cols = ",".join([str(i) for i in data.columns.tolist()])

for i,row in data.iterrows():
    sql = "INSERT INTO CLAIMS/HEALTH (" +cols + ") VALUES ("
    cursor.execute(sql, tuple(row))
