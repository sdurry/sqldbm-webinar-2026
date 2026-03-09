with source as (

    select * from {{ source('sample_data', 'sales_order') }}

),

renamed as (

    select
        o_orderkey       as sales_order_id,
        o_custkey        as customer_id,
        o_orderstatus    as order_status,
        o_totalprice     as total_price_usd,
        o_orderdate      as order_date,
        o_orderpriority  as order_priority,
        o_clerk          as clerk,
        o_shippriority   as ship_priority,
        o_comment        as comment,
        current_timestamp()::timestamp_ntz as load_dts
    from source

)

select * from renamed
