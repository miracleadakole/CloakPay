from fastapi import FastAPI

app = FastAPI(title="CloakPay Backend")

@app.get("/health")
def health():
    return {"status": "ok"}
