{{
    config
    (
        materialized = 'table',
        pre_hook = 'use warehouse compute_wh;',
        transient = false,
        post_hook = 'create or replace table qwt_analytics_dev.staging_dev.stg_products_test clone qwt_analytics_dev.staging_dev.stg_products; ')
}}

select * 
from
{{source('qwt_raw','raw_products')}}