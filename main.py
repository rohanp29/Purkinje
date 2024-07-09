#This is the main script for the hackathon project
#print("Hello MediHacks!")

import pandas as pd
from dotenv import load_dotenv
import os
from openai import OpenAI

load_dotenv()
api_key = os.getenv('API_KEY')

def main():
    primekg = pd.read_csv('disease_features.csv', low_memory = False)
    atx = primekg[primekg['mondo_name']=='ataxia telangiectasia']
    course_content= generate_course_content(atx)
    print(course_content)


def generate_course_content(topic):
    name = topic.iloc[0]['mondo_name']
    definition = topic.iloc[0]['mondo_definition']
    description = topic.iloc[0]['umls_description']
    prevalence = topic.iloc[0]['orphanet_prevalence']
    epidemiology = topic.iloc[0]['orphanet_epidemiology']
    clinical = topic.iloc[0]['orphanet_clinical_description']
    treatment = topic.iloc[0]['orphanet_management_and_treatment']
    prmpt = (f'''Create an educational module for doctors about {name}, using the following information, 
            Description: {description} 
            Prevalence: {prevalence} 
            Epidemiology: {epidemiology} 
            Clinical: {clinical} 
            Treatment: {treatment}. 
            Do not use any content from any other sources. Only use the information in this prompt''')
    
    client = OpenAI(
        # This is the default and can be omitted
        api_key=api_key,
        )

    chat_completion = client.chat.completions.create(
        messages=[
            {
                'role': 'user',
                'content': prmpt,
            }
        ],
        model='gpt-3.5-turbo',
        )
    response_content = chat_completion.choices[0].message.content
    return response_content

def read_text(name):
    with open(name, 'r') as file:
        text = file.read()
    return text

def generate_quiz(content):
    prmpt = f'Generate a 10 question multiple choice question on the following course content. {content}'
    client = OpenAI(
        # This is the default and can be omitted
        api_key=api_key,
        )

    chat_completion = client.chat.completions.create(
        messages=[
            {
                'role': 'user',
                "content": prmpt,
            }
        ],
        model='gpt-3.5-turbo',
        )
    response_content = chat_completion.choices[0].message.content
    return response_content

if __name__ == '__main__':
    #main()
    pass


