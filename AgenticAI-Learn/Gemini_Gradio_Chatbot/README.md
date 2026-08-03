# 🤖 Gemini + Gradio Chatbot

A simple AI chatbot built using **Python**, **Google Gemini API**, and **Gradio**. This project demonstrates how to integrate Google's Gemini Large Language Model (LLM) with a web-based chat interface using Gradio.

---

## 📌 Project Overview

This chatbot allows users to interact with Google's Gemini model through a simple web interface. It accepts user input, sends it to the Gemini API, and displays the AI-generated response in real time.

This project is part of my Agentic AI learning journey and focuses on understanding:

- Google Gemini API Integration
- Prompt-based AI interactions
- Gradio Chat Interface
- Secure API key management using `.env`
- Python function-based chatbot development

---

## 🚀 Features

- Interactive AI chatbot
- Google Gemini API integration
- Web-based chat interface using Gradio
- Secure API key management using environment variables
- Displays available Gemini models
- Simple and beginner-friendly Python code

---

## 🛠️ Technologies Used

- Python 3.x
- Google Gemini API
- Gradio
- python-dotenv

---

## 📂 Project Structure

```
Gemini_Gradio_Chatbot/
│
├── chatbot.py          # Main chatbot application
├── requirements.txt    # Required Python packages
├── README.md           # Project documentation
├── .env.example        # Sample environment variables
└── screenshot.png      # Chatbot screenshot
```

---

## ⚙️ Installation

### Step 1 : Clone the Repository

```bash
git clone https://github.com/<your-github-username>/<repository-name>.git
```

---

### Step 2 : Navigate to the Project Folder

```bash
cd Gemini_Gradio_Chatbot
```

---

### Step 3 : Install Dependencies

```bash
pip install -r requirements.txt
```

---

### Step 4 : Configure API Key

Create a `.env` file in the project directory and add your Gemini API Key.

```
GOOGLE_API_KEY=YOUR_API_KEY_HERE
```

> **Note:** Never upload your actual `.env` file to GitHub.

---

### Step 5 : Run the Application

```bash
python chatbot.py
```

Gradio will launch a local web server.

Open the URL shown in your terminal (usually http://127.0.0.1:7860) in your browser.

---

## 📷 Screenshot

Below is the chatbot interface.

> Replace the image below with your own screenshot after running the application.

```
screenshot.png
```

---

## 📖 How It Works

1. User enters a prompt in the Gradio chat interface.
2. Python receives the user input.
3. The message is sent to the Google Gemini API.
4. Gemini generates a response.
5. The response is displayed back to the user through Gradio.

```
User
   │
   ▼
Gradio Interface
   │
   ▼
Python Function
   │
   ▼
Google Gemini API
   │
   ▼
AI Response
   │
   ▼
Gradio Interface
```

---

## 📦 Required Python Packages

```
google-generativeai
gradio
python-dotenv
```

Or simply install using:

```bash
pip install -r requirements.txt
```

---

## 💡 Learning Outcomes

Through this project, I learned:

- How to use the Google Gemini API
- How API authentication works
- How to manage API keys securely
- How to build a chatbot using Gradio
- How Python functions connect the UI with AI models
- Basic prompt-response workflow using Large Language Models (LLMs)

---

## 🔮 Future Improvements

Some enhancements planned for future versions include:

- Conversation history management
- Multiple AI model support (Gemini, OpenAI, Claude)
- DevOps-focused chatbot prompts
- Terraform and Ansible code generation
- AWS integration
- CI/CD automation
- Better UI customization

---

## 👨‍💻 Author

**Amit Koundal**

DevOps | Cloud | AI | Agentic AI Learner

GitHub: https://github.com/<your-github-username>

LinkedIn: https://linkedin.com/in/<your-linkedin-profile>

---

## ⭐ If you found this project helpful, consider giving it a Star!
