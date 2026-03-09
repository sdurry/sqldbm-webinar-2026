{{
    config(
        materialized='incremental',
        unique_key='customer_key'
    )
}}

with source as (

    select * from {{ ref('stg_modelco__customer') }}

    {% if is_incremental() %}
        where load_dts > (select max(valid_from) from {{ this }})
    {% endif %}

),

transformed as (

    select
        SHA1_BINARY(customer_id::varchar || ':' || load_dts::varchar) as customer_key,
        customer_id,
        name,
        address,
        location_id,
        phone,
        account_balance_usd,
        market_segment,
        comment,
        load_dts as valid_from,
        null::timestamp_ntz as valid_to,
        true as is_current
    from source

)

select * from transformed
