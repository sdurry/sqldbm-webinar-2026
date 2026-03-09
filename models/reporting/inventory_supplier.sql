{{
    config(
        materialized='table'
    )
}}

with inventory as (

    select * from {{ ref('fct_inventory') }}

),

parts as (

    select * from {{ ref('dim_part') }}
    where is_current = true

),

suppliers as (

    select * from {{ ref('dim_supplier') }}
    where is_current = true

),

final as (

    select
        inv.part_id,
        inv.supplier_id,
        inv.available_amount,
        inv.supplier_cost_usd,

        p.name                as part_name,
        p.manufacturer        as part_manufacturer,
        p.brand               as part_brand,
        p.type                as part_type,
        p.size_centimeters    as part_size_centimeters,
        p.container           as part_container,
        p.retail_price_usd    as part_retail_price_usd,

        s.name                as supplier_name,
        s.address             as supplier_address,
        s.location_id         as supplier_location_id,
        s.phone               as supplier_phone,
        s.account_balance_usd as supplier_account_balance_usd,

        inv.load_dts
    from inventory inv
    left join parts p
        on inv.part_id = p.part_id
    left join suppliers s
        on inv.supplier_id = s.supplier_id

)

select * from final
