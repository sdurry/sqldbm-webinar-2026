{{
    config(
        materialized='incremental',
        unique_key=['part_id', 'supplier_id']
    )
}}

with source as (

    select * from {{ ref('stg_modelco__inventory') }}

    {% if is_incremental() %}
        where load_dts > (select max(load_dts) from {{ this }})
    {% endif %}

)

select * from source
