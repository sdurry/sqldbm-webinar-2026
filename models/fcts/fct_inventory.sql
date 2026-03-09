{{
    config(
        materialized='incremental',
        unique_key=['part_id', 'supplier_id']
    )
}}

with source as (

    select
        part_id,
        supplier_id,
        available_amount,
        supplier_cost_usd,
        comment,
        load_dts
    from {{ source('operations', 'inventory') }}

    {% if is_incremental() %}
        where load_dts > (select max(load_dts) from {{ this }})
    {% endif %}

)

select * from source
