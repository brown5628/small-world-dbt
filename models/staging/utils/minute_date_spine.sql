{{ config(materialized='table') }}


{{ dbt_utils.date_spine(
    datepart="minute",
    start_date="to_date('01/01/2019', 'mm/dd/yyyy')",
    end_date="current_date"
   )
}}