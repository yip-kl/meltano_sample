export MSYS_NO_PATHCONV=1

# Run without container
# meltano run tap-ga4 target-bigquery
# meltano config tap-ga4 > config.json
# source .meltano/extractors/tap-ga4/venv/Scripts/activate
# python .meltano/extractors/tap-ga4/venv/Scripts/tap-google-analytics.exe --config config.json --discover

# Run as container
docker run --rm --env-file ./.env -v $(pwd)/key-files:/project/key-files meltano_bbm run tap-ga4 target-bigquery