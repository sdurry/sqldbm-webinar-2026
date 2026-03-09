with source as (

    select * from {{ source('sample_data', 'location') }}

),

renamed as (

    select
        n_nationkey      as location_id,
        n_name           as name,
        n_regionkey      as region_id,
        n_comment        as comment,
        current_timestamp()::timestamp_ntz as load_dts
    from source

)

select * from renamed
