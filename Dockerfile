FROM python:3.6-alpine
LABEL maintainer="Abdelhamid YOUNES"

# Set work directory
WORKDIR /opt

# Install dependencies and ensure pip is up-to-date
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir flask

# Copy the application 
COPY sources/app/app.py .
COPY sources/app/templates ./templates
COPY sources/app/static ./static
VOLUME /opt

# Expose port 8000
EXPOSE 8000

# Set environment variables
ENV ODOO_URL="https://www.odoo.com/"
ENV PGADMIN_URL="https://www.pgadmin.org/"

# Set default command to run the app
# ENTRYPOINT ["python"]
# CMD [ "app.py" ]
ENTRYPOINT ["python", "app.py"]