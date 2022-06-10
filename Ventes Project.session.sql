select table_name,
    column_name,
    data_type,
    character_maximum_length,
    column_default,
    is_nullable
from INFORMATION_SCHEMA.COLUMNS
where table_name in ('msuserdt')
order by table_name,
    ordinal_position;
-- select column_name,
--     data_type,
--     character_maximum_length,
--     column_default,
--     is_nullable
-- from INFORMATION_SCHEMA.COLUMNS
-- where table_name = 'stbpcustomer';
select *
from INFORMATION_SCHEMA.TABLES
where TABLE_SCHEMA = 'public';
-- select *
-- from mscustomer;
-- INSERT INTO mscustomer
-- VALUES (
--         default,
--         null,
--         'Magnum P.I.',
--         '081211113333',
--         'Jl. Bahagia Raya, Kel. Gebang Raya, Kec. Periuk, Kota Tangerang',
--         18,
--         36,
--         3671,
--         367108,
--         null,
--         '34435',
--         -6.180482,
--         106.589175,
--         null,
--         1,
--         now(),
--         1,
--         now(),
--         true
--     );
select *
from msuserdt
where userdtbpid = (
        select userdtbpid
        from msuserdt
        where userid = 18
    );
select *
from msuserdt
where userid = 8;
TRUNCATE trprospectdt RESTART IDENTITY;
TRUNCATE msproduct RESTART IDENTITY;
TRUNCATE trprospectproduct RESTART IDENTITY;
SELECT *
FROM vtschedule
WHERE '[2022-06-01, 2022-06-30]'::daterange @> [schestartdate, scheenddate]::daterange;
SELECT schenm,
    generate_series (
        schestartdate::date,
        scheenddate::date,
        '1 day'::interval
    )::date as date
from vtschedule
where schestartdate is not null
    and scheenddate is not null;
-- 
-- function to get date between 2 dates
-- 
-- drop function if exists get_schedule_from_dates(
--     start_date1 date,
--     end_date1 date,
--     start_date2 date,
--     end_date2 date
-- );
-- drop function if exists get_dates(start_date date, end_date date);
-- CREATE OR REPLACE FUNCTION get_schedule_from_dates(
--         start_date1 DATE,
--         end_date1 DATE,
--         start_date2 DATE,
--         end_date2 DATE
--     ) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
-- DECLARE result BOOLEAN := false;
-- DECLARE date1 DATE;
-- DECLARE date2 DATE;
-- DECLARE dates1 TIMESTAMP [] := get_dates (start_date1, end_date1);
-- DECLARE dates2 TIMESTAMP [] := get_dates (start_date2, end_date2);
-- BEGIN FOREACH date1 IN ARRAY dates1 LOOP FOREACH date2 IN ARRAY dates2 LOOP result := result
-- OR to_char(date1, 'YYYY-MM-DD') = to_char(date2, 'YYYY-MM-DD');
-- IF result THEN EXIT;
-- END IF;
-- END LOOP;
-- END LOOP;
-- RETURN result;
-- END;
-- $$;
-- -- create function to get date between 2 dates
-- --
-- CREATE OR REPLACE FUNCTION get_dates(
--         start_date1 date,
--         end_date1 date
--     ) RETURNS TIMESTAMP [] LANGUAGE plpgsql AS $$ BEGIN RETURN array(
--         SELECT generate_series (
--                 start_date1::DATE,
--                 end_date1::DATE,
--                 '1 day'::INTERVAL
--             )::TIMESTAMP
--     );
-- END;
-- $$;
SELECT *
FROM vtschedule
WHERE get_schedule_from_dates(
        schestartdate,
        scheenddate,
        '2022-02-22',
        '2022-03-04'
    ) = true;
-- select get_schedule_from_dates(
--         '2022-01-05',
--         '2022-01-08',
--         '2022-01-01',
--         '2022-12-30'
--     ) AS b;
select *
from trprospect;
TRUNCATE trprospect RESTART IDENTITY;
TRUNCATE trprospectproduct RESTART IDENTITY;
TRUNCATE msproduct RESTART IDENTITY;
select *
from msuserdt;
-- INSERT INTO msuserdt
-- VALUES (
--         default,
--         8,
--         2,
--         2,
--         null,
--         null,
--         null,
--         1,
--         now(),
--         1,
--         now(),
--         true
--     );