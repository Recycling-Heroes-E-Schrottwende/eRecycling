from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.get("/user/{user_id}")
async def read_item(user_id: int):
    return {"user_id": user_id}
