FROM python:slim

WORKDIR /code

# 
COPY ./requirements.txt /code/requirements.txt

# 
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

# 
COPY ./app /code/app

ENV PYTHONPATH /code/app

ENV DB_USER user
ENV DB_PASSWORD password
ENV DB_HOST postgres
ENV DB_PORT 5432
ENV DB_NAME postgres


# 
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]

EXPOSE 8080
