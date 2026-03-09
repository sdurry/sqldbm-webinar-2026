with 

source as (

    select * from {{ source('operations', 'sales_order') }}

),

renamed as (

    select
        sales_order_id,
        customer_id,
        order_status,
        total_price_usd,
        order_date,
        order_priority,
        clerk,
        ship_priority,
        comment

    from source

)

select * from renamed