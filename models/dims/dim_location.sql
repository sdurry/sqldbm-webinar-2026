{{
    config(
        materialized='incremental',
        unique_key='location_key'
    )
}}

with source as (

    select * from {{ ref('stg_modelco__location') }}

    {% if is_incremental() %}
        where load_dts > (select max(valid_from) from {{ this }})
    {% endif %}

),

transformed as (

    select
        SHA1_BINARY(location_id::varchar || ':' || load_dts::varchar) as location_key,
        location_id,
        name,
        region_id,
        comment,
        load_dts as valid_from,
        null::timestamp_ntz as valid_to,
        true as is_current
    from source

)

select * from transformed
