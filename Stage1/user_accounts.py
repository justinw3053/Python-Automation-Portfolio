import csv
import subprocess

with open("users.csv", "r") as csv_file:
    csv_reader = csv.reader(csv_file)
    next(csv_reader) #This skips the first line (the header row)
    for row in csv_reader:
        # Each 'row' will be a list of the values on that line
        # For example, the first row would be ['username', 'full_name', 'email']
        username = row[0]
        subprocess.run(["sudo", "adduser", username])
