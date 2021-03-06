with

raw_data as (

    select * from {{ source('raw_google_sheets_financial_data', 'fund_conversions') }}

),

cleaned as (

    select 
        {{ dbt_utils.surrogate_key(
            [
                'asset_name',
                'asset_category',
                'date_pulled',
                'asset_class'
            ]
        ) }} as fund_conversions_id,

        asset_category,
        asset_class,
        asset_name,

        percent,
        to_date(date_pulled, 'YYYY-MM-DD') as date_pulled

    from raw_data 

)

select * from cleaned