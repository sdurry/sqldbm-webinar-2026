with source as (

    select * from {{ source('sample_data', 'lineitem') }}

),

renamed as (

    select
        l_linenumber     as line_number,
        l_orderkey       as sales_order_id,
        l_partkey        as part_id,
        l_suppkey        as supplier_id,
        l_quantity       as quantity,
        l_extendedprice  as extended_price_usd,
        l_discount       as discount_percent,
        l_tax            as tax_percent,
        l_returnflag     as return_flag,
        l_linestatus     as line_status,
        l_shipdate       as ship_date,
        l_commitdate     as commit_date,
        l_receiptdate    as receipt_date,
        l_shipinstruct   as ship_instructions,
        l_shipmode       as ship_mode,
        l_comment        as comment,
        current_timestamp()::timestamp_ntz as load_dts
    from source

)

select * from renamed
