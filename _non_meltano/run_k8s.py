from airflow import DAG
from airflow.providers.cncf.kubernetes.operators.pod import KubernetesPodOperator
from airflow.models import Variable
from airflow.providers.cncf.kubernetes.secret import Secret
from datetime import datetime
import pendulum

# Push to GCS gsutil cp _non_meltano/run_k8s.py gs://us-central1-example-environ-906e5dcc-bucket/dags

local_tz = pendulum.timezone('Asia/Hong_Kong')

default_args = {
    'retries': 0,
    'catchup': False,
    'start_date': datetime(2024, 3, 17, 10, 0, tzinfo=local_tz),
    # 'email': [Variable.get("recipient_address")],
    # 'email_on_failure': True,
}

env_vars = {
    'PROJECT_ROOT': '/project',
    'KEY_FILE_FOLDER': 'key-files',
    'GCP_KEYFILE':'adroit-hall-301111-417090a2983b.json',
    'SA_SECRET_NAME': 'gcp-service-account'    
}

gcp_service_account_volume = Secret(
    deploy_type="volume",
    deploy_target=f"{env_vars['PROJECT_ROOT']}/{env_vars['KEY_FILE_FOLDER']}",  # Path to mount secret as volume
    secret=env_vars["SA_SECRET_NAME"],  # Name of Kubernetes Secret
    key=env_vars["GCP_KEYFILE"],  # Key of a secret stored in Secret object
)

args = ["run",
        "tap-ga4",
        "target-bigquery"
        ]

# args = [
#         "echo pwd",
#         "ls"
#         ]

with DAG('scheduled_query', description='',
        schedule_interval='0 22 * * *',
        default_args=default_args) as dag:

    kubernetes_min_pod = KubernetesPodOperator(
        # The ID specified for the task.
        task_id="pod-ex-minimum",
        # Name of task you want to run, used to generate Pod ID.
        name="pod-ex-minimum",
        # Entrypoint of the container, if not specified the Docker container's
        # entrypoint is used. The cmds parameter is templated.
        # cmds=["bash", "-c"],
        arguments=args,
        # The namespace to run within Kubernetes. In Composer 2 environments
        # after December 2022, the default namespace is
        # `composer-user-workloads`.
        namespace="composer-user-workloads",
        # Docker image specified. Defaults to hub.docker.com, but any fully
        # qualified URLs will point to a custom repository. Supports private
        # gcr.io images if the Composer Environment is under the same
        # project-id as the gcr.io images and the service account that Composer
        # uses has permission to access the Google Container Registry
        # (the default service account has permission)
        image="us-central1-docker.pkg.dev/adroit-hall-301111/meltano-repo/meltano_bbm:latest",
        # Specifies path to kubernetes config. If no config is specified will
        # default to '~/.kube/config'. The config_file is templated.
        config_file="/home/airflow/composer_kube_config",
        # Identifier of connection that should be used
        kubernetes_conn_id="kubernetes_default",
        startup_timeout_seconds=120,
        # All environment variables referenced in the meltano.yml file must be included here
        env_vars=env_vars,
        secrets=[gcp_service_account_volume]
    )

    kubernetes_min_pod

    # Comment out secrets, can detect meltano, but can't find the secret
    # Enable secrets, can't detect meltano
    # Try define the deploy_target = full path to the secret, it would be considered as a folder
    # airflow.kubernetes.secret -> airflow.providers.cncf.kubernetes.secret (Airflow2)