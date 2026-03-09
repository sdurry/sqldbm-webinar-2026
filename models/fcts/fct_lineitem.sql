{{
    config(
        materialized='incremental',
        unique_key=['line_number', 'sales_order_id']
    )
}}

with source as (

    select
        line_number,
        sales_order_id,
        part_id,
        supplier_id,
        quantity,
        extended_price_usd,
        discount_percent,
        tax_percent,
        return_flag,
        line_status,
        ship_date,
        commit_date,
        receipt_date,
        ship_instructions,
        ship_mode,
        comment,
        load_dts
    from {{ source('operations', 'lineitem') }}

    {% if is_incremental() %}
        where load_dts > (select max(load_dts) from {{ this }})
    {% endif %}

)

select * from source
