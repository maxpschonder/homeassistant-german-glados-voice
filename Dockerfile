FROM python:3.11

WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip && \
  pip install --no-cache-dir gunicorn && \
  pip install --no-cache-dir -r requirements.txt

# install ffmpeg
RUN apt-get update && apt-get install -y ffmpeg

# copy the app
WORKDIR /app
COPY app.py .

# use nobody user
USER nobody

ENV NUMBA_CACHE_DIR="/tmp/numba_cache"
ENV TEMP_PATH="/tmp/tts"

# expose the port
EXPOSE 59125

# run the app
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:59125", "app:app", "--access-logfile", "-", "--error-logfile", "-"]
