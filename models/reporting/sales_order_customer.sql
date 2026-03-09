{{
    config(
        materialized='table'
    )
}}

with orders as (

    select * from {{ ref('fct_sales_order') }}

),

customers as (

    select * from {{ ref('dim_customer') }}
    where is_current = true

),

final as (

    select
        o.sales_order_id,
        o.customer_id,
        o.order_status,
        o.total_price_usd,
        o.order_date,
        o.order_priority,
        o.clerk,
        o.ship_priority,

        c.name                as customer_name,
        c.address             as customer_address,
        c.location_id         as customer_location_id,
        c.phone               as customer_phone,
        c.account_balance_usd as customer_account_balance_usd,
        c.market_segment      as customer_market_segment,

        o.load_dts
    from orders o
    left join customers c
        on o.customer_id = c.customer_id

)

select * from final
