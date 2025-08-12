from src.prompt_engineering.chainer import run_chain

def step_upper(s: str) -> str:
    return s.upper()

def step_exclaim(s: str) -> str:
    return s + "!!!"

def main():
    result = run_chain([step_upper, step_exclaim], "hello")
    print(result)

if __name__ == "__main__":
    main()
