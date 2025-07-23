from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Flutter'dan gelen istekleri kabul etmesi için
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

class Feedback(BaseModel):
    yorum: str

@app.post("/feedback")
async def feedback_gonder(feedback: Feedback):
    with open("feedbacks.txt", "a", encoding="utf-8") as dosya:
        dosya.write(feedback.yorum + "\n---\n")
    return {"durum": "alındı"}

from fastapi.responses import JSONResponse

@app.get("/feedbacks")
async def tum_feedbackler():
    try:
        with open("feedbacks.txt", "r", encoding="utf-8") as dosya:
            icerik = dosya.read()
        yorumlar = icerik.strip().split("\n---\n")
        # Boş satırları temizle
        yorumlar = [y for y in yorumlar if y.strip() != ""]
        return JSONResponse(content={"yorumlar": yorumlar})
    except FileNotFoundError:
        return JSONResponse(content={"yorumlar": []})

