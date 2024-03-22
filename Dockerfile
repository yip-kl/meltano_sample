# registry.gitlab.com/meltano/meltano:latest is also available in GitLab Registry
ARG MELTANO_IMAGE=meltano/meltano:latest
FROM $MELTANO_IMAGE

ARG PROJECT_ROOT
WORKDIR ${PROJECT_ROOT}

# Install any additional requirements
COPY ./requirements.txt .
RUN pip install -r requirements.txt

# Copy over Meltano project directory
COPY . .
RUN meltano install

# Don't allow changes to containerized project files
ENV MELTANO_PROJECT_READONLY 1

ENTRYPOINT ["meltano"]
