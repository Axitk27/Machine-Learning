-- SELECT model,screen_size FROM mobilephone.smartphones WHERE brand_name = 'samsung'
-- ORDER BY screen_size DESC LIMIT 5

-- SELECT brand_name,model,num_front_cameras + num_rear_cameras AS total_cameras FROM mobilephone.smartphones
-- ORDER BY total_cameras DESC

-- SELECT model,ROUND(SQRT(resolution_width*resolution_width + resolution_height*resolution_width)/screen_size) AS ppi FROM mobilephone.smartphones
-- ORDER BY ppi DESC

-- SELECT model,battery_capacity FROM mobilephone.smartphones
-- ORDER BY battery_capacity ASC LIMIT 1,1

-- SELECT model,rating FROM mobilephone.smartphones WHERE brand_name = 'apple'
-- ORDER BY rating ASC LIMIT 1

-- SELECT model,price FROM mobilephone.smartphones 
-- ORDER BY brand_name ASC, price ASC

-- SELECT brand_name,COUNT(DISTINCT(model)) AS no_of_phone,AVG(price) AS 'average_price' FROM mobilephone.smartphones
-- GROUP BY brand_name 
-- ORDER BY no_of_phone DESC LIMIT 10

-- SELECT brand_name,processor_brand,
-- COUNT(*) AS 'no_of_phone',
-- AVG(primary_camera_rear) AS 'primary_camera_resolution' 
-- FROM mobilephone.smartphones 
-- GROUP BY brand_name,processor_brand

-- SELECT brand_name,AVG(screen_size) AS 'average_screen_size' FROM mobilephone.smartphones
-- GROUP BY brand_name
-- ORDER BY average_screen_size ASC LIMIT 1

-- SELECT brand_name,COUNT(*) AS 'count' 
-- FROM mobilephone.smartphones
-- WHERE has_nfc = 'TRUE' AND has_ir_blaster = 'TRUE'
-- ORDER BY count smartphonessmartphones

-- SELECT brand_name,
-- AVG(ram_capacity) AS 'average_ram',
-- AVG(refresh_rate) AS 'refresh_rate',
-- COUNT(*) AS 'count'
-- FROM mobilephone.smartphones
-- WHERE refresh_rate > 90 AND fast_charging_available = 1
-- GROUP BY brand_name
-- HAVING count > 10 
-- ORDER BY average_ram DESC LIMIT 3

-- SELECT batter,SUM(batsman_run) AS 'run' 
-- FROM lecture.ipl
-- GROUP BY batter 
-- ORDER BY run DESC LIMIT 5

-- SELECT batter, COUNT(*) AS 'num_six' FROM lecture.ipl
-- WHERE batsman_run = 6
-- GROUP BY batter
-- ORDER BY num_six DESC LIMIT 1,1

-- SELECT bowler, SUM(batsman_run) AS 'run'
-- FROM lecture.ipl
-- WHERE batter = 'V Kohli'
-- GROUP BY bowler
-- ORDER BY run DESC

-- SELECT batter,
-- SUM(batsman_run), AS 'run_per_match',
-- COUNT()
-- -- count(*) AS 'century' This will not work - You r having a result table then you need to use that table to generate other result
-- FROM lecture.ipl
-- GROUP BY batter, ID
-- HAVING run_per_match >= 100
-- ORDER BY run_per_match DESC 

-- SELECT batter,
-- COUNT(*) AS 'count_ball',
-- SUM(batsman_run) AS 'run',
-- round(100*run/count_ball,2) AS 'strike_rate'   
-- FROM lecture.ipl
-- GROUP BY batter
-- HAVING count_ball > 1000
-- ORDER BY strike_rate DESC LIMIT 5 