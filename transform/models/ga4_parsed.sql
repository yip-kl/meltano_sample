SELECT
    PARSE_DATE("%Y%m%d",JSON_VALUE(data, '$.date')) AS date,
    JSON_VALUE(data, '$.activeUsers') AS activeUsers
FROM {{ source('raw_ga4', 'users_per_day')}}