import os
import google.generativeai as genai

genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

model = genai.GenerativeModel("gemini-1.5-flash")

def read_project():
    code = ""
    for root, _, files in os.walk("."):
        for f in files:
            if f.endswith(".dart"):
                path = os.path.join(root, f)
                with open(path, "r", encoding="utf-8") as file:
                    code += f"\n\nFILE: {path}\n"
                    code += file.read()
    return code

def generate_docs(code):
    prompt = f"""
You are an AI Documentation Agent.

Analyze this Flutter project and generate documentation:

- Explain each file
- Explain architecture
- Explain providers and flows

CODE:
{code}
"""

    response = model.generate_content(prompt)
    return response.text

if __name__ == "__main__":
    code = read_project()
    docs = generate_docs(code)

    with open("DOCUMENTATION.md", "w", encoding="utf-8") as f:
        f.write(docs)

    print("Docs generated")
