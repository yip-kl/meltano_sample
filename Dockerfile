# registry.gitlab.com/meltano/meltano:latest is also available in GitLab Registry
ARG MELTANO_IMAGE=meltano/meltano:latest
FROM $MELTANO_IMAGE

WORKDIR /project

# Install any additional requirements
COPY ./requirements.txt .
RUN pip install -r requirements.txt

# Copy over Meltano project directory
COPY . .
RUN meltano install

# Don't allow changes to containerized project files
ENV MELTANO_PROJECT_READONLY 1

ENTRYPOINT ["meltano"]

# In case need to inspect the container filesystem
# ENTRYPOINT ["bash"]

