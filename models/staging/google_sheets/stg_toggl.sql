with

raw_data as (

    select * from {{ source('raw', 'toggl') }}

),

cleaned as (

    select
        {{ dbt_utils.surrogate_key(
            [
                '"Start date"',
                '"Start time"',
                '"End date"',
                '"End time"'
            ]
        ) }} as tracker_id,

        "Client" as client_name,
        "Project" as project_name,
        "Description" as task_description,
        to_date("Start date", 'YYYY-MM-DD') as date_started,
        "Start time" :: time as time_started,
        to_date("End date", 'YYYY-MM-DD') as date_ended,
        "End time" :: time  as time_ended,
        left("Duration",2) :: int * 3600 + substring("Duration",4,2) :: int * 60 + substring("Duration",7,2) :: int as duration_seconds,
        "Tags" as context_tags
    
    from raw_data

)

select * from cleaned