#!/usr/bin/env python3

import datetime
import pymongo
from pymongo import MongoClient

client = MongoClient('localhost', 27017)

db = client.test_database
collection = db['posts']

post = {"author": "Mike", "text": "My first blog post!", "tags": ["mongodb", "python", "pymongo"], "date": datetime.datetime.utcnow()}

post_id = collection.insert_one(post).inserted_id
print(db.list_collection_names())
