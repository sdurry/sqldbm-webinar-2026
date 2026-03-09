{{
    config(
        materialized='incremental',
        unique_key='supplier_key'
    )
}}

with source as (

    select
        supplier_id,
        name,
        address,
        location_id,
        phone,
        account_balance_usd,
        comment,
        load_dts
    from {{ source('operations', 'supplier') }}

    {% if is_incremental() %}
        where load_dts > (select max(valid_from) from {{ this }})
    {% endif %}

),

transformed as (

    select
       SHA1_BINARY('supplier_id'||'load_dts') as supplier_key,
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
