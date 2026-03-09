with source as (

    select * from {{ source('sample_data', 'customer') }}

),

renamed as (

    select
        c_custkey        as customer_id,
        c_name           as name,
        c_address        as address,
        c_nationkey      as location_id,
        c_phone          as phone,
        c_acctbal        as account_balance_usd,
        c_mktsegment     as market_segment,
        c_comment        as comment,
        current_timestamp()::timestamp_ntz as load_dts
    from source

)

select * from renamed
