import pandas as pd
import os
import shutil

# Path to the root folder containing all audio files
root_folder = r"audio path here"

# Path to the Excel file
excel_file = r"csv file path here"

# Read the CSV file
df = pd.read_csv(excel_file)

# Iterate through each row in the DataFrame
for index, row in df.iterrows():
    # Extract file name, class label, and dataset type
    file_name = row[0]
    class_label = row[1]
    dataset_type = row[2]
    
    # Construct source and destination paths
    src_path = os.path.join(root_folder, file_name)
    dest_folder = os.path.join(root_folder, dataset_type)
    dest_class_folder = os.path.join(dest_folder, class_label)
    dest_path = os.path.join(dest_class_folder, file_name)
    
    # Create destination folders if they don't exist
    if not os.path.exists(dest_folder):
        os.makedirs(dest_folder)
    if not os.path.exists(dest_class_folder):
        os.makedirs(dest_class_folder)
    
    # Move file to destination folder
    shutil.move(src_path, dest_path)
