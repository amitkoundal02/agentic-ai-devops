from dotenv import load_dotenv          # Load environment variables from the .env file
import os                               # Read environment variables
import google.generativeai as genai     # Google Gemini SDK
import gradio as gradio                 # Build a web-based chatbot interface

load_dotenv()                           # Load variables from the .env file

api_key = os.getenv("GOOGLE_API_KEY")   # Retrieve the Gemini API key
genai.configure(api_key=api_key)        # Authenticate with the Gemini API

# Display all available Gemini models
for model in genai.list_models():
    print(model.name)

# Replace ******** with one of the model names displayed above
model = genai.GenerativeModel("models/********")

# Start a chat session so conversation history is maintained
chat = model.start_chat()

def chat_with_bot(message, history):
    # Send the user's message to Gemini
    response = chat.send_message(message)

    # Return Gemini's response to the Gradio interface
    return response.text

gradio.ChatInterface(
    fn=chat_with_bot,
    title="Gemini Gradio Chatbot",
    description="A simple AI chatbot built using Google Gemini API and Gradio."
).launch(share=True)

# share=True creates a temporary public URL.
# Remove share=True if you only want to run the chatbot locally.