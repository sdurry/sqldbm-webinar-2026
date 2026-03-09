
-- Use the `ref` function to select from other models

select a.*
from {{ ref('my_first_dbt_model') }} a
inner join (select * from {{ ref('my_second_dbt_model') }} ) b on true
inner join ( SELECT * FROM {{ source('sample_data', 'customer') }} ) c on true
--where id = 1
