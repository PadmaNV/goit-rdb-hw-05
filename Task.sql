use db_lec3;

-- 1. Напишіть SQL запит, який буде відображати таблицю order_details та поле customer_id з таблиці 
-- orders відповідно для кожного поля запису з таблиці order_details.
-- Це має бути зроблено за допомогою вкладеного запиту в операторі SELECT.
SELECT 
    od.*, 
    (SELECT o.customer_id 
     FROM orders o 
     WHERE o.id = od.order_id) AS customer_id
FROM order_details od;


-- 2. Напишіть SQL запит, який буде відображати таблицю order_details. Відфільтруйте результати так,
--  щоб відповідний запис із таблиці orders виконував умову shipper_id=3.
-- Це має бути зроблено за допомогою вкладеного запиту в операторі WHERE.

SELECT
	od.*
    FROM order_details od
    WHERE od.order_id IN (
		SELECT o.id
        FROM orders o
        WHERE shipper_id = 3);
        
-- 3. Напишіть SQL запит, вкладений в операторі FROM, який буде обирати рядки з умовою
-- quantity>10 з таблиці order_details. Для отриманих даних знайдіть середнє значення
-- поля quantity — групувати слід за order_id.

SELECT
	od.order_id,
	avg(od.quantity)
FROM (SELECT * FROM order_details WHERE quantity>10) od
GROUP BY od.order_id;


-- 4. Розв’яжіть завдання 3, використовуючи оператор WITH для створення тимчасової 
-- таблиці temp. Якщо ваша версія MySQL більш рання, ніж 8.0, створіть цей запит 
-- за аналогією до того, як це зроблено в конспекті.

WITH TemporalTable AS (
    SELECT *
    FROM order_details
    WHERE quantity>10
)
SELECT 
	tt.order_id,
    AVG(tt.quantity) AS avg_quantity
FROM TemporalTable AS tt
GROUP BY tt.order_id;


-- 5. Створіть функцію з двома параметрами, яка буде ділити перший параметр
-- на другий. Обидва параметри та значення, що повертається, повинні мати тип FLOAT.
-- Використайте конструкцію DROP FUNCTION IF EXISTS. Застосуйте функцію до атрибута
-- quantity таблиці order_details . Другим параметром може бути довільне число на ваш розсуд.

DROP FUNCTION IF EXISTS div_numb;

DELIMITER //

CREATE FUNCTION div_numb(num1 FLOAT, num2 FLOAT) 
RETURNS FLOAT
DETERMINISTIC 
BEGIN
    DECLARE result FLOAT;
    IF num2 = 0 THEN
		RETURN NULL;
    ELSE
		SET result = num1 / num2;
	END IF;
    RETURN result;
END //

DELIMITER ;

-- Застосувати функцію до таблиці order_details
SELECT 
    od.order_id,
    od.quantity,
    div_numb(od.quantity, 3.1) AS divided_quantity -- Ділимо на 2.0
FROM 
    order_details od;
