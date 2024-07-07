#This is the main script for the hackathon project
#print("Hello MediHacks!")

import pandas as pd
from dotenv import load_dotenv
import os

load_dotenv()
api_key = os.getenv('API_KEY')

def main():

    primekg = pd.read_csv('disease_features.csv', low_memory = False)
    print(primekg.head(50))

if __name__ == "__main__":
    main()