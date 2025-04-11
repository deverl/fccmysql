import csv
from datetime import datetime

def reformat_dates(file_in, file_out, date_columns):
    with open(file_in, 'r', newline='', encoding='utf-8') as infile, \
         open(file_out, 'w', newline='', encoding='utf-8') as outfile:
        
        reader = csv.reader(infile, delimiter='|')
        writer = csv.writer(outfile, delimiter='|')
        
        for row in reader:
            for col in date_columns:
                if col < len(row) and row[col]:
                    try:
                        row[col] = datetime.strptime(row[col], '%m/%d/%Y').strftime('%Y-%m-%d')
                    except ValueError:
                        pass  # Leave as-is if not a valid date
            writer.writerow(row)

# Example: columns 7, 8, 9, 43, 44 in hd correspond to date fields (zero-indexed)
reformat_dates('HD.dat', 'HD_fixed.dat', [7, 8, 9, 43, 44])
