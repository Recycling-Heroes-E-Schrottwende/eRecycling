import requests

class Test:
  def __init__(self):
    self.db = "localhost"

  def get():
    res = requests.get(self.db, header={"key"})
