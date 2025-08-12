from src.llm.gpt_client import GPTClient

def main():
    client = GPTClient()
    resp = client.complete("Hello world")
    print(resp.text)

if __name__ == "__main__":
    main()
