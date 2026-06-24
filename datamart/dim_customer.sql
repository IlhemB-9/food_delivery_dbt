select
    customer_hk,
    customer_name,
    email,
    phone_number,
    governorate,
    district,
    customer_segment,
    is_active

from ranked
where rn = 1