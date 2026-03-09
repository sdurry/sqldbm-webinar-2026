{{
    config(
        materialized='incremental',
        unique_key='supplier_key'
    )
}}

with source as (

    select * from {{ ref('stg_modelco__supplier') }}

    {% if is_incremental() %}
        where load_dts > (select max(valid_from) from {{ this }})
    {% endif %}

),

transformed as (

    select
        SHA1_BINARY(supplier_id::varchar || ':' || load_dts::varchar) as supplier_key,
        supplier_id,
        name,
        address,
        location_id,
        phone,
        account_balance_usd,
        comment,
        load_dts as valid_from,
        null::timestamp_ntz as valid_to,
        true as is_current
    from source

)

select * from transformed
