from dotenv import load_dotenv          # lets us load secret keys from a .env file instead of hardcoding them
import os                                # used to read environment variables
import google.generativeai as genai      # Google's SDK for talking to Gemini models

load_dotenv()                            # reads the .env file and loads its variables into the environment

api_key = os.getenv("GOOGLE_API_KEY")    # fetch the Gemini API key from the environment (kept out of source code)
genai.configure(api_key=api_key)         # authenticate the SDK using that key

model_names = []                         # will hold the list of model names as we loop through them
for models in genai.list_models():       # loop through every Gemini model available to your API key
    print(models.name)                   # print each model's name so you can see what's available
    model_names.append(models.name)      # also save it to the list so we can let the user pick one

choice = input("Enter the exact model name you want to use from the list above: ")  # user types a name instead of it being hardcoded
model = genai.GenerativeModel(choice)    # load whichever model name the user entered — no hardcoded model name
chat = model.start_chat()                # start a single ongoing conversation session with the model

import gradio as gradio                  # Gradio builds the web-based chat UI

def chat_with_bot(message, history):     # this function runs every time a user sends a message
    response = chat.send_message(message)  # send the user's message to Gemini and get a reply
    return response.text                 # return just the text of the reply to display in the chat UI

gradio.ChatInterface(chat_with_bot).launch(share=True)
# builds the chat window and launches it
# share=True also creates a temporary public link — remove this for local-only testing
