{{
    config(
        materialized='incremental',
        unique_key='sales_order_id'
    )
}}

with source as (

    select * from {{ ref('stg_modelco__sales_order') }}

    {% if is_incremental() %}
        where load_dts > (select max(load_dts) from {{ this }})
    {% endif %}

)

select * from source
