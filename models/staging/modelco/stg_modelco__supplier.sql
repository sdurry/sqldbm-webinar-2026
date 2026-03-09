with source as (

    select * from {{ source('sample_data', 'supplier') }}

),

renamed as (

    select
        s_suppkey        as supplier_id,
        s_name           as name,
        s_address        as address,
        s_nationkey      as location_id,
        s_phone          as phone,
        s_acctbal        as account_balance_usd,
        s_comment        as comment,
        current_timestamp()::timestamp_ntz as load_dts
    from source

)

select * from renamed
