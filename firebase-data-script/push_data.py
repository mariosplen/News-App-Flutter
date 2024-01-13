import firebase_admin
from firebase_admin import credentials, firestore
import json

collection_name = "articles"
edited_data_path = "firebase-data-script/firestore_data.json"
key_file_path = "firebase-data-script/serviceAccountKey.json"  # To generate the file visit: https://console.firebase.google.com/project/<your-project-name>/settings/serviceaccounts/adminsdk


# Authenticate With Firebase Admin SDK
cred = credentials.Certificate(key_file_path)
firebase_admin.initialize_app(cred)

# Initialize Firestore Client
firestore_client = firestore.client()

# Read edited data from JSON file
with open(edited_data_path, "r") as file:
    edited_data = json.load(file)

print("Data is being pushed to Firestore...")

# Update Firestore with edited data
for article in edited_data:
    firestore_client.collection(collection_name).add(article)


print("Edited data has been pushed to Firestore.")
