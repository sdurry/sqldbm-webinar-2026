with source as (

    select * from {{ source('sample_data', 'inventory') }}

),

renamed as (

    select
        ps_partkey       as part_id,
        ps_suppkey       as supplier_id,
        ps_availqty      as available_amount,
        ps_supplycost    as supplier_cost_usd,
        ps_comment       as comment,
        current_timestamp()::timestamp_ntz as load_dts
    from source

)

select * from renamed
