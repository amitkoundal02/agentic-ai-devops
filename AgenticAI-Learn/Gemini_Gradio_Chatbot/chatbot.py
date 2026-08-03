import os

import gradio as gr
from dotenv import load_dotenv

load_dotenv()


def respond(message, history):
    return "Gemini integration will be connected here."


with gr.Blocks(title="Gemini Gradio Chatbot") as demo:
    gr.Markdown("# Gemini + Gradio Chatbot")
    chatbot = gr.Chatbot()
    msg = gr.Textbox(label="Your message")
    clear = gr.Button("Clear")

    def submit(message, history):
        reply = respond(message, history)
        return history + [[message, reply]], ""

    msg.submit(submit, [msg, chatbot], [chatbot, msg])
    clear.click(lambda: None, None, chatbot)


if __name__ == "__main__":
    demo.launch()
