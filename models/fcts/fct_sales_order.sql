{{
    config(
        materialized='incremental',
        unique_key='sales_order_id'
    )
}}

with source as (

    select
        sales_order_id,
        customer_id,
        order_status,
        total_price_usd,
        order_date,
        order_priority,
        clerk,
        ship_priority,
        comment,
        load_dts
    from {{ source('operations', 'sales_order') }}

    {% if is_incremental() %}
        where load_dts > (select max(load_dts) from {{ this }})
    {% endif %}

)

select * from source
