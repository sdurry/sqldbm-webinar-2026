with source as (

    select * from {{ source('sample_data', 'part') }}

),

renamed as (

    select
        p_partkey        as part_id,
        p_name           as name,
        p_mfgr           as manufacturer,
        p_brand          as brand,
        p_type           as type,
        p_size           as size_centimeters,
        p_container      as container,
        p_retailprice    as retail_price_usd,
        p_comment        as comment,
        current_timestamp()::timestamp_ntz as load_dts
    from source

)

select * from renamed
