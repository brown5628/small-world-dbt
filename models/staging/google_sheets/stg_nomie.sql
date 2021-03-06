with

raw_data as (

    select * from {{ source('raw', 'nomie') }}

),

units as (

    select * from {{ ref('nomie_units') }}

),

cleaned as (

    select 
        {{ dbt_utils.surrogate_key(
            [
                'epoch',
                '"end"',
                'tracker',
                'note'
            ]
        ) }} as tracker_id,

        tracker as tracker_name,

        case 
            when note like '%+%' then split_part(note, '+', 2)
            else 'general'        
        end as tracker_context,

        note as tracker_note,
        value as tracker_value,

        coalesce(units.tracker_units, 'events') as tracker_units,        

        to_date("end", 'YYYY-MM-DD') as date_completed
    
    from raw_data

    left outer join units 
        on raw_data.tracker = units.tracker_name

)

select * from cleaned