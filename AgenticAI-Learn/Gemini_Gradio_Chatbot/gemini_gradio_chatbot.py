import os

import google.generativeai as genai
import gradio as gr
from dotenv import load_dotenv

load_dotenv()


def main() -> None:
    api_key = os.getenv("GOOGLE_API_KEY") or os.getenv("GEMINI_API_KEY")
    if not api_key:
        raise RuntimeError(
            "Missing API key. Set GOOGLE_API_KEY (or GEMINI_API_KEY) in your .env file."
        )

    genai.configure(api_key=api_key)

    available_models = [
        m.name
        for m in genai.list_models()
        if "generateContent" in m.supported_generation_methods
    ]

    if not available_models:
        raise RuntimeError("No chat-capable Gemini models were found for this account.")

    print("Available models:")
    for i, name in enumerate(available_models, start=1):
        print(f"{i}. {name}")

    choice = int(input("Enter the number of the model you want to use: ")) - 1
    selected_model = available_models[choice]

    print(f"Using model: {selected_model}")

    model = genai.GenerativeModel(selected_model)
    chat = model.start_chat()

    def chat_with_bot(message, history):
        response = chat.send_message(message)
        return response.text

    gr.ChatInterface(chat_with_bot, title="Gemini Gradio Chatbot").launch(share=True)


if __name__ == "__main__":
    main()
