{{
    config(
        materialized='incremental',
        unique_key='part_key'
    )
}}

with source as (

    select
        part_id,
        name,
        manufacturer,
        brand,
        type,
        size_centimeters,
        container,
        retail_price_usd,
        comment,
        load_dts
    from {{ source('operations', 'part') }}

    {% if is_incremental() %}
        where load_dts > (select max(valid_from) from {{ this }})
    {% endif %}

),

transformed as (

    select
        SHA1_BINARY('part_id'||'load_dts') as part_key,
        part_id,
        name,
        manufacturer,
        brand,
        type,
        size_centimeters,
        container,
        retail_price_usd,
        comment,
        load_dts as valid_from,
        null::timestamp_ntz as valid_to,
        true as is_current
    from source

)

select * from transformed
