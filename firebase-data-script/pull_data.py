import firebase_admin

from firebase_admin import credentials
from firebase_admin import firestore

import json

collection_name = "articles"
export_path = "firebase-data-script/firestore_data.json"
key_file_path = "firebase-data-script/serviceAccountKey.json"  # To generate the file visit: https://console.firebase.google.com/project/<your-project-name>/settings/serviceaccounts/adminsdk

# Authenticate With Firebase Admin SDK
cred = credentials.Certificate(key_file_path)
firebase_admin.initialize_app(cred)

# Initialize Firestore Client
firestore_client = firestore.client()

# Retrieve Data From Firestore
documents = firestore_client.collection(collection_name).stream()

# Prepare Data For JSON export
data = {}
for doc in documents:
    data[doc.id] = doc.to_dict()

# Write Data To A JSON File
with open(key_file_path, "w") as file:
    json.dump(data, file, indent=4)

print(f"Data has been exported to {key_file_path}")
